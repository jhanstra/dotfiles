#!/usr/bin/env python3
"""Run a command with a deadline while preserving interactive terminal access."""

import os
import shlex
import signal
import subprocess
import sys
import termios


def seconds(duration: str) -> int:
    units = {"s": 1, "m": 60, "h": 60 * 60}
    if duration[-1] in units:
        return int(duration[:-1]) * units[duration[-1]]
    return int(duration)


timeout = seconds(sys.argv[1])
command = sys.argv[2:]
interactive = sys.stdin.isatty()
terminal_fd = sys.stdin.fileno() if interactive else None
terminal_settings = termios.tcgetattr(terminal_fd) if terminal_fd is not None else None
process = subprocess.Popen(command, start_new_session=not interactive)


def stop_process_tree() -> None:
    try:
        if interactive:
            process.terminate()
        else:
            os.killpg(process.pid, signal.SIGTERM)
    except ProcessLookupError:
        return
    try:
        process.wait(timeout=10)
    except subprocess.TimeoutExpired:
        if interactive:
            process.kill()
        else:
            os.killpg(process.pid, signal.SIGKILL)
        process.wait()


try:
    raise SystemExit(process.wait(timeout=timeout))
except subprocess.TimeoutExpired:
    print(f"Timed out after {timeout}s: {shlex.join(command)}", file=sys.stderr)
    stop_process_tree()
    raise SystemExit(124)
except KeyboardInterrupt:
    stop_process_tree()
    raise SystemExit(130)
finally:
    if terminal_fd is not None and terminal_settings is not None:
        try:
            termios.tcsetattr(terminal_fd, termios.TCSADRAIN, terminal_settings)
        except termios.error:
            pass
