#!/bin/zsh
set -eu
TASK_PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
TASK_GODOT_BIN="${GODOT_BIN:-/Users/abinashbasak/Downloads/Godot_mono.app/Contents/MacOS/Godot}"
exec "$TASK_GODOT_BIN" --headless --path "$TASK_PROJECT_DIR" --script res://tests/smoke_test.gd
