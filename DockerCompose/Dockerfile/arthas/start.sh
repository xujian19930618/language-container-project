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

#exec java -jar /opt/arthas/arthas-boot.jar --target-ip 0.0.0.0 $PID