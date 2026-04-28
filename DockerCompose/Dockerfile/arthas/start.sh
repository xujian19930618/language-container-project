#!/bin/sh

echo "[arthas] waiting JVM..."

while true; do
  PID=$(jps | grep -v Jps | awk '{print $1}' | head -n 1)

  if [ ! -z "$PID" ]; then
    echo "[arthas] found JVM PID: $PID"
    break
  fi

  sleep 2
done

# 使用本地离线启动（不联网）
/opt/arthas/arthas-boot.sh $PID