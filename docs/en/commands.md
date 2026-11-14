# genmake, run and estilo

## genmake: create an exercise

```bash
mkdir square && cd square
genmake            # or: genmake square
```

Questions, one at a time (Enter = value in brackets; `[y/N]` means the capital letter is the default):

1. Exercise name (also the executable's name; defaults to the folder name).
2. Main program file name (default `<name>_main`).
3. Create a functions file? If yes: its name (default `<name>`), and whether to add the default functions `PrintProgramPurpose` and `CheckCorrectParameters`.
4. If you add them: how many arguments the program expects (`kCorrectNumber`, not counting the program name), the name of each one (used in the usage message), and a one-line description.
5. A summary; nothing is written until you confirm.

It creates `Makefile`, `<name>_main.cc` and, optionally, `<name>.cc` + `<name>.h` (one header only). Existing `.cc`/`.h` files are **never** touched; the `Makefile` is rewritten. `genmake -y` accepts every default without asking.

File headers use your profile (university, school, degree, subject + year, `@author`); empty fields are skipped. If `~/.vim/skeleton.cc` exists it is used as the base for the main file (`FILENAME` and `DATE` get replaced; it needs a literal `int main() {` line for the default functions to be inserted).

The Makefile compiles **all** `.cc` files with `g++ -Wall -Wextra -std=c++17`, so keep one `main()` per folder. `make clean` removes `.o` files, the executable and Vim swap files (`.*.swp`).

## run: build and run

```bash
run            # or: run 7 3 hello   (arguments are passed on)
```

Reads `PROGRAMA` from the Makefile, runs `make clean`, shows style warnings (`estilo -q`, never blocks), runs `make` (stops on errors) and runs the program between two dashed lines, showing the exit code.

## estilo: check and fix style

```bash
estilo               # all .cc and .h in the folder
estilo square.cc     # one file
estilo -f            # fix formatting with clang-format, then check
```

Runs cpplint (Google style) and the compiler with `-Wall -Wextra`. Each warning shows the file, line, reason and the offending source line. Exit code is `0` with no warnings, `1` otherwise. With `-f`, an existing `.clang-format` replaces the Google style. Copyright, include-path and header-guard-path checks are disabled as noise in labs.

More screenshots: [Spanish docs](../genmake.md).
