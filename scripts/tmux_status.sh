#!/bin/bash

CACHE_DIR="/tmp/tmux_status_cache"
STATS_FILE="$CACHE_DIR/stats"

mkdir -p "$CACHE_DIR"

if [ ! -f "$CACHE_DIR/net_rx" ]; then
    INTERFACE=$(ip route | grep default | head -1 | awk '{print $5}')
    if [ -z "$INTERFACE" ]; then
        INTERFACE="eth0"
    fi

    RX_BYTES=$(cat /sys/class/net/$INTERFACE/statistics/rx_bytes 2>/dev/null || echo 0)
    TX_BYTES=$(cat /sys/class/net/$INTERFACE/statistics/tx_bytes 2>/dev/null || echo 0)
    echo "$RX_BYTES" > "$CACHE_DIR/net_rx"
    echo "$TX_BYTES" > "$CACHE_DIR/net_tx"
    echo "$(date +%s)" > "$CACHE_DIR/net_time"
fi

get_network_speed() {
    INTERFACE=$(ip route | grep default | head -1 | awk '{print $5}')
    if [ -z "$INTERFACE" ]; then
        INTERFACE="eth0"
    fi

    if [ ! -f "/sys/class/net/$INTERFACE/statistics/rx_bytes" ]; then
        echo "↓0KB/s ↑0KB/s"
        return
    fi

    CURRENT_RX=$(cat /sys/class/net/$INTERFACE/statistics/rx_bytes 2>/dev/null || echo 0)
    CURRENT_TX=$(cat /sys/class/net/$INTERFACE/statistics/tx_bytes 2>/dev/null || echo 0)
    CURRENT_TIME=$(date +%s)

    LAST_RX=$(cat "$CACHE_DIR/net_rx" 2>/dev/null || echo 0)
    LAST_TX=$(cat "$CACHE_DIR/net_tx" 2>/dev/null || echo 0)
    LAST_TIME=$(cat "$CACHE_DIR/net_time" 2>/dev/null || echo $CURRENT_TIME)

    TIME_DIFF=$((CURRENT_TIME - LAST_TIME))
    if [ $TIME_DIFF -eq 0 ]; then
        TIME_DIFF=1
    fi

    RX_SPEED=$(( (CURRENT_RX - LAST_RX) / TIME_DIFF ))
    TX_SPEED=$(( (CURRENT_TX - LAST_TX) / TIME_DIFF ))

    if [ $RX_SPEED -lt 0 ]; then RX_SPEED=0; fi
    if [ $TX_SPEED -lt 0 ]; then TX_SPEED=0; fi

    RX_KB=$((RX_SPEED / 1024))
    TX_KB=$((TX_SPEED / 1024))

    echo "$CURRENT_RX" > "$CACHE_DIR/net_rx"
    echo "$CURRENT_TX" > "$CACHE_DIR/net_tx"
    echo "$CURRENT_TIME" > "$CACHE_DIR/net_time"

    printf "↓%dKB/s ↑%dKB/s" $RX_KB $TX_KB
}

get_memory_usage() {
    if [ -f /proc/meminfo ]; then
        TOTAL=$(grep MemTotal /proc/meminfo | awk '{print $2}')
        AVAILABLE=$(grep MemAvailable /proc/meminfo | awk '{print $2}')
        if [ -z "$AVAILABLE" ]; then
            FREE=$(grep MemFree /proc/meminfo | awk '{print $2}')
            BUFFERS=$(grep Buffers /proc/meminfo | awk '{print $2}')
            CACHED=$(grep "^Cached" /proc/meminfo | awk '{print $2}')
            AVAILABLE=$((FREE + BUFFERS + CACHED))
        fi
        USED=$((TOTAL - AVAILABLE))
        USAGE=$((USED * 100 / TOTAL))
        echo "${USAGE}%"
    else
        echo "N/A"
    fi
}

get_cpu_usage() {
    if [ -f /proc/stat ]; then
        CPU_LINE=$(head -1 /proc/stat)
        CPU_VALUES=$(echo $CPU_LINE | sed 's/^cpu //')

        IDLE=$(echo $CPU_VALUES | awk '{print $4}')
        TOTAL=0
        for value in $CPU_VALUES; do
            TOTAL=$((TOTAL + value))
        done

        if [ -f "$CACHE_DIR/cpu_idle" ] && [ -f "$CACHE_DIR/cpu_total" ]; then
            LAST_IDLE=$(cat "$CACHE_DIR/cpu_idle")
            LAST_TOTAL=$(cat "$CACHE_DIR/cpu_total")

            IDLE_DIFF=$((IDLE - LAST_IDLE))
            TOTAL_DIFF=$((TOTAL - LAST_TOTAL))

            if [ $TOTAL_DIFF -gt 0 ]; then
                CPU_USAGE=$((100 - (IDLE_DIFF * 100 / TOTAL_DIFF)))
                if [ $CPU_USAGE -lt 0 ]; then CPU_USAGE=0; fi
                if [ $CPU_USAGE -gt 100 ]; then CPU_USAGE=100; fi
            else
                CPU_USAGE=0
            fi
        else
            CPU_USAGE=0
        fi

        echo "$IDLE" > "$CACHE_DIR/cpu_idle"
        echo "$TOTAL" > "$CACHE_DIR/cpu_total"

        echo "${CPU_USAGE}%"
    else
        echo "N/A"
    fi
}

case "$1" in
    "network")
        get_network_speed
        ;;
    "memory")
        get_memory_usage
        ;;
    "cpu")
        get_cpu_usage
        ;;
    *)
        echo "Usage: $0 {network|memory|cpu}"
        exit 1
        ;;
esac
