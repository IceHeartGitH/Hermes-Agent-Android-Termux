#!/usr/bin/env python3
"""Small non-root Android system inspector for Termux using adb wireless debugging."""
from __future__ import annotations
import argparse
import re
import shlex
import subprocess
import sys
from collections import Counter


def run(cmd: list[str], timeout: int = 30) -> tuple[int, str]:
    try:
        p = subprocess.run(cmd, text=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, timeout=timeout)
        return p.returncode, p.stdout.strip()
    except subprocess.TimeoutExpired as e:
        out = (e.stdout or '') if isinstance(e.stdout, str) else ''
        return 124, (out + '\n[TIMEOUT]').strip()
    except FileNotFoundError:
        return 127, f'command not found: {cmd[0]}'


def adb(args: list[str], timeout: int = 30) -> tuple[int, str]:
    return run(['adb', *args], timeout=timeout)


def print_section(title: str, body: str) -> None:
    print(f'=== {title} ===')
    print(body.strip() if body.strip() else '(empty)')
    print()


def devices() -> list[str]:
    code, out = adb(['devices'], timeout=20)
    devs=[]
    for line in out.splitlines():
        if '\tdevice' in line:
            devs.append(line.split('\t',1)[0].strip())
    return devs


def require_device() -> str:
    devs=devices()
    if not devs:
        print('NO_ADB_DEVICE')
        print('Enable Android Wireless debugging, run pair/connect, then retry.')
        sys.exit(2)
    return devs[0]


def cmd_status(args):
    sections=[]
    for title, cmd in [
        ('adb version', ['version']),
        ('adb devices', ['devices','-l']),
    ]:
        code,out=adb(cmd, timeout=20)
        sections.append((title,out))
    for title,out in sections: print_section(title,out)


def cmd_pair(args):
    target = args.target
    code,out = adb(['pair', target, args.code], timeout=30)
    print(out)
    sys.exit(code)


def cmd_connect(args):
    code,out = adb(['connect', args.target], timeout=30)
    print(out)
    code2,out2 = adb(['devices','-l'], timeout=20)
    print(out2)
    sys.exit(code if code else code2)


def shell(cmd: str, timeout: int=40) -> str:
    code,out = adb(['shell', cmd], timeout=timeout)
    return out


def cmd_apps(args):
    require_device()
    ps = shell('ps -A', timeout=40)
    package_names=[]
    app_lines=[]
    for line in ps.splitlines():
        if re.search(r'\bu\d+_a\d+\b|\bu\d+_i\d+\b', line):
            app_lines.append(line)
            # last column often process/package name
            toks=line.split()
            if toks:
                name=toks[-1]
                if re.match(r'[A-Za-z0-9_]+(\.[A-Za-z0-9_]+)+', name):
                    package_names.append(name)
    uids=set()
    for line in app_lines:
        m=re.search(r'\b(u\d+_[ai]\d+)\b', line)
        if m: uids.add(m.group(1))
    print(f'app_process_lines={len(app_lines)}')
    print(f'unique_app_uids={len(uids)}')
    print(f'package_like_names={len(set(package_names))}')
    print()
    for name in sorted(set(package_names))[:args.limit]:
        print(name)
    if len(set(package_names)) > args.limit:
        print(f'... +{len(set(package_names))-args.limit} more')


def cmd_summary(args):
    require_device()
    print_section('devices', adb(['devices','-l'], timeout=20)[1])
    print_section('battery', shell('dumpsys battery | sed -n "1,40p"', timeout=30))
    print_section('memory', shell('dumpsys meminfo | sed -n "1,45p"', timeout=40))
    apps_out = subprocess.run([sys.executable, __file__, 'apps', '--limit', str(args.limit)], text=True, stdout=subprocess.PIPE).stdout
    print_section('apps', apps_out)


def cmd_top(args):
    require_device()
    print(shell('top -b -n 1 -o PID,USER,%%CPU,RES,ARGS -m %d 2>/dev/null || top -b -n 1 -m %d' % (args.limit,args.limit), timeout=40))


def main():
    ap=argparse.ArgumentParser(description='ADB-based Android inspector for Termux/Hermes')
    sub=ap.add_subparsers(dest='cmd', required=True)
    sub.add_parser('status')
    p=sub.add_parser('pair'); p.add_argument('target', help='host:pairing_port, e.g. 127.0.0.1:37123'); p.add_argument('code', help='pairing code from Android')
    p=sub.add_parser('connect'); p.add_argument('target', help='host:debug_port, e.g. 127.0.0.1:42123')
    p=sub.add_parser('apps'); p.add_argument('--limit', type=int, default=80)
    p=sub.add_parser('summary'); p.add_argument('--limit', type=int, default=80)
    p=sub.add_parser('top'); p.add_argument('--limit', type=int, default=30)
    args=ap.parse_args()
    {'status':cmd_status,'pair':cmd_pair,'connect':cmd_connect,'apps':cmd_apps,'summary':cmd_summary,'top':cmd_top}[args.cmd](args)

if __name__ == '__main__':
    main()
