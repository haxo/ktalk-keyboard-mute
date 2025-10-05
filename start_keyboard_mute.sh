#!/bin/bash

# Запуск KeyboardMute в фоне без окна терминала
cd "$(dirname "$0")"
nohup ./KeyboardMute > /dev/null 2>&1 &
echo "KeyboardMute запущен в фоне. PID: $!"

