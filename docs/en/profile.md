# ib-config and ib-update

## ib-config

```bash
ib-config          # asks each field; Enter keeps the value in brackets
ib-config --show   # show the saved profile
ib-config --path   # where it is stored
```

Fields: language (`es`/`en`: language of messages and of the text `genmake` writes), name and email (required, used in `@author`), university, school and degree (first header lines), subject and academic year (last line; the year is proposed from the date). Stored in `~/.config/ib-tools/config`. Only affects files you create afterwards.

## ib-update

```bash
ib-update
```

Downloads the latest version and reinstalls the commands, keeping your profile. Requires `curl`. `genmake` checks at most once a week and prints one line when a new version exists; silent without internet.
