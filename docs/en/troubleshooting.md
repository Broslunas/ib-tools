# Troubleshooting

**`command not found`** — open a new terminal or run `source ~/.bashrc`; check `ls ~/.local/bin`; check `echo $PATH` contains `~/.local/bin`, otherwise:

```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc && source ~/.bashrc
```

**`Error: your details (name and email) are missing`** — run `ib-config` in a normal terminal.

**`estilo` can't find cpplint/clang-format** — `sudo apt install clang-format pipx && pipx install cpplint`, then reopen the terminal.

**`error: externally-managed-environment`** — use `pipx`, not `pip`.

**`multiple definition of 'main'`** — two `.cc` files with `main()` in one folder. Use one folder per exercise.

**genmake says a file exists and leaves it** — by design. Delete it yourself to start over.

**Default functions missing from `main`** — the main file already existed; add the calls to `PrintProgramPurpose` and `CheckCorrectParameters` yourself.

**`./install.sh: Permission denied`** — `bash install.sh` or `chmod +x install.sh`.

**`undefined reference to ...`** — the function is declared but not defined in a `.cc` in that folder, or its signature differs from the prototype.

**Tab does nothing** — open a new terminal; check `~/.bashrc` has a line sourcing `~/.local/share/ib-tools/completion.bash`.

**`ib-update` fails** — needs `curl` and internet; with a clone use `git pull && ./install.sh --actualizar`.

Still stuck? Open an [issue](https://github.com/Broslunas/ib-tools/issues) with the command and the full message.
