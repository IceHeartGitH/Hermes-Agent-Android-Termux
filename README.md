# Hermes Agent Android Termux

Install Hermes Agent on Android using Termux.

After installation, start Hermes with:

```sh
hermes
```

## Compatibility

This installer is intended for modern Android devices running the F-Droid version of Termux.

It is not guaranteed to work on every device. Older Android versions, especially versions below Android 15, may fail because Hermes Agent and its dependencies require a compatible Python/runtime environment.

## Requirements

- Android device
- Termux from F-Droid
- Internet connection
- Enough storage for Python, Node.js, Rust/build tools, and Hermes Agent

Install Termux from F-Droid:

```text
https://f-droid.org/packages/com.termux/
```

Do not use the outdated Google Play build of Termux.

## Install

Copy the full command into Termux:

```sh
pkg update -y && pkg install -y git && cd ~ && if [ -d Hermes-Agent-Android-Termux/.git ]; then cd Hermes-Agent-Android-Termux && git pull --ff-only; else git clone https://github.com/IceHeartGitH/Hermes-Agent-Android-Termux.git && cd Hermes-Agent-Android-Termux; fi && bash install.sh --force
```

## Start Hermes

```sh
hermes
```

## Verify

```sh
hermes --version
hermes doctor
bash verify.sh
```

## Configure model/provider

If setup did not complete during installation, run:

```sh
hermes setup
```

## Update Hermes

After a successful installation, update Hermes Agent with:

```sh
hermes update
```

## Android shared storage

To allow Termux access to Android shared storage, run:

```sh
termux-setup-storage
```

Approve the Android permission prompt when it appears.

## Uninstall

This removes the Hermes runtime/data directory created by this installer.

```sh
bash scripts/uninstall-hermes-android-termux.sh --yes
```


## Troubleshooting

If installation fails:

1. Make sure Termux is installed from F-Droid.
2. Run `pkg update -y && pkg upgrade -y` and try again.
3. Check the Android version. Older Android versions may not support the Python runtime required by Hermes Agent.
4. Run `bash verify.sh` and include the output when opening an issue.

## What the installer does

- checks that it is running in Termux;
- installs required Termux packages;
- ensures a Hermes-compatible Python version;
- downloads and runs the official Hermes Agent installer from `https://hermes-agent.nousresearch.com/install.sh`;
- creates the `hermes` command;
- runs basic verification.

## What this repository does not include

- credentials or tokens;
- auth files;
- sessions, logs, or state databases;
- device-specific notes;
- unrelated project workflows.
