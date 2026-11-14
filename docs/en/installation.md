# Installation, step by step

About five minutes.

## You need

- A Linux terminal (usually the lab **virtual machine**).
- `g++` and `make` (`sudo apt install g++ make`).
- `git` **or** `curl`.
- Optional, for `estilo`: `clang-format` and `cpplint` (the installer offers them).

## Step 1. Get the tools

Option A (recommended):

```bash
git clone https://github.com/Broslunas/ib-tools.git
cd ib-tools
./install.sh
```

Option B (no clone):

```bash
curl -fsSL https://raw.githubusercontent.com/Broslunas/ib-tools/main/install.sh | bash
```

Read [install.sh](../../install.sh) first if you like: it copies six scripts to `~/.local/bin` and adds that folder to your `PATH`.

## Step 2. Answer the installer

It will:

1. Copy `genmake`, `nuevo`, `run`, `estilo`, `ib-config` and `ib-update` to `~/.local/bin`, and enable Tab completion.
2. Ask for your profile: language, name, email (required), university, school, degree, subject and academic year (proposed from today's date). Saved in `~/.config/ib-tools/config`.
3. Add `~/.local/bin` to your `PATH` in `~/.bashrc` if needed.
4. Offer to install `clang-format` and `cpplint` (needs sudo; the password isn't shown while typing).

## Step 3. Open a new terminal

Or run `source ~/.bashrc`.

## Step 4. Check

```bash
which genmake nuevo run estilo ib-config ib-update
nuevo test -y && ls test
```

You should see a `Makefile` and `test_main.cc`.

## Update

```bash
ib-update
```

Your profile is kept. `genmake` also reminds you, at most once a week, when a new version exists.

## Change your profile

```bash
ib-config          # asks again; Enter keeps each value
ib-config --show   # just show it
```

## Uninstall

From the repository folder: `./install.sh --desinstalar`. Your profile stays in `~/.config/ib-tools` (delete it by hand if you want).
