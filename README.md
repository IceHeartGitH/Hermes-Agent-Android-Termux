# Hermes Agent Android Termux

Инсталация на Hermes Agent на Android чрез Termux.

Този repo е за прост public install flow. След инсталация използваш само:

```sh
hermes
```

## Важно за съвместимостта

Не е 100% гарантирано, че ще тръгне на всеки телефон.

Най-рискови са по-стари Android версии, особено под Android 15, защото Hermes Agent изисква съвместим Python/runtime environment.

Потвърден reference: модерен Samsung S26 Ultra + Termux от F-Droid.

## Изисквания

- Android телефон
- Termux от F-Droid, не старата Google Play версия
- Интернет връзка
- Свободно място за Python, Node, Rust/build tools и Hermes Agent

Termux от F-Droid:

```text
https://f-droid.org/packages/com.termux/
```

## Инсталация

Копирай цялата команда в Termux:

```sh
pkg update -y && pkg install -y git && cd ~ && if [ -d Hermes-Agent-Android-Termux/.git ]; then cd Hermes-Agent-Android-Termux && git pull --ff-only; else git clone https://github.com/IceHeartGitH/Hermes-Agent-Android-Termux.git && cd Hermes-Agent-Android-Termux; fi && bash install.sh --force
```

## Стартиране

```sh
hermes
```

## Проверка

```sh
hermes --version
hermes doctor
bash verify.sh
```

## Setup на модел/provider

Ако installer-ът не е завършил interactive setup, пусни:

```sh
hermes setup
```

## Update

След успешна инсталация Hermes core се обновява с official updater:

```sh
hermes update
```

## Android storage

Ако искаш Hermes да работи с shared storage:

```sh
termux-setup-storage
```

После разреши Android permission popup-а.

## Uninstall

Внимание: това трие локалния Hermes runtime/data от тази инсталация.

```sh
bash scripts/uninstall-hermes-android-termux.sh --yes
```

## Какво прави installer-ът

- проверява, че си в Termux;
- инсталира нужните Termux packages;
- осигурява Python версия, съвместима с Hermes Agent;
- използва official Hermes installer;
- създава командата `hermes`;
- прави базова проверка.

## Какво НЕ съдържа този repo

- tokens или credentials;
- auth files;
- sessions/logs/state database;
- private repo flow;
- global install mode;
- Obsidian/private project memory.
