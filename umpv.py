#!/usr/bin/env python3

"""
This script emulates "unique application" functionality. When starting playback with this script, it will try to reuse an already running instance of mpv (but only if that was started with umpv). Other mpv instances (not started by umpv) are ignored, and the script doesn't know about them.

This only takes filenames as arguments. Custom options can't be used; the script interprets them as filenames. If mpv is already running, the files passed to umpv are appended to mpv's internal playlist. If a file does not exist or is otherwise not playable, mpv will skip the playlist entry when attempting to play it (from the GUI perspective, it's silently ignored).

If mpv isn't running yet, this script will start mpv and let it control the current terminal. It will not write output to stdout/stderr, because this will typically just fill ~/.xsession-errors with garbage.

mpv will terminate if there are no more files to play, and running the umpv script after that will start a new mpv instance.

Note: you can supply custom mpv path and options with the MPV environment variable. The environment variable will be split on whitespace, and the first item is used as path to mpv binary and the rest is passed as options _if_ the script starts mpv. If mpv is not started by the script (i.e. mpv is already running), this will be ignored.
"""

import os
import shlex
import socket
import string
import subprocess
import sys
from collections.abc import Iterable
from configparser import ConfigParser
from typing import BinaryIO


def read_conf():
    conf = ConfigParser()
    try :
        conf.read(filenames="umpv.conf", encoding="utf-8")
        param1 = conf["DEFAULT"].get("Socket_Path", r"\\.\pipe\umpv")
        param2 = conf["DEFAULT"].get("Loadfile_Flag", "replace")
    except :
        param1 = r"\\.\pipe\umpv"
        param2 = "replace"
    return param1, param2

Socket_Path, Loadfile_Flag = read_conf()

def is_url(filename: str) -> bool:
    parts = filename.split("://", 1)
    if len(parts) < 2:
        return False
    # protocol prefix has no special characters => it's an URL
    allowed_symbols = string.ascii_letters + string.digits + "_"
    prefix = parts[0]
    return all(c in allowed_symbols for c in prefix)

def send_files_to_mpv(conn: socket.socket | BinaryIO, files: Iterable[str]) -> None:
    try:
        send = conn.send if isinstance(conn, socket.socket) else conn.write
        for f in files:
            f = f.replace("\\", "\\\\").replace('"', '\\"').replace("\n", "\\n")
            send(f'raw loadfile "{f}" "{Loadfile_Flag}"\n'.encode())
    except Exception:
        print("mpv is terminating or the connection was lost.", file=sys.stderr)
        sys.exit(1)

def start_mpv(files: Iterable[str], Socket_Path: str) -> None:
    mpv = "mpv.exe"
    mpv_command = shlex.split(os.getenv("MPV", mpv))
    mpv_command.extend([
        f"--input-ipc-server={Socket_Path}",
        "--",
    ])
    mpv_command.extend(files)
    subprocess.Popen(mpv_command, start_new_session=True)

def main() -> None:
    files = (os.path.abspath(f) if not is_url(f) else f for f in sys.argv[1:])

    try:
        with open(Socket_Path, "r+b", buffering=0) as pipe:
            send_files_to_mpv(pipe, files)
    except (FileNotFoundError, ConnectionRefusedError):
        start_mpv(files, Socket_Path)

if __name__ == "__main__":
    main()
