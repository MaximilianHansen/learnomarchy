# learnomarchy ✈

**Learn to fly [Omarchy](https://omarchy.org).**

A keybind trainer disguised as an arcade game. It runs *in your real window
manager* — it spawns real windows, gives you missions, and times you to the
tenth of a second over Hyprland's IPC. Muscle memory only forms on real keys
with real consequences, so there's no simulation and no sandbox. Just you,
a timer, and your operating system.

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/MaximilianHansen/learnomarchy/main/install.sh | bash
```

Then run `learnomarchy`, find **Learnomarchy** in your app launcher, or take
the offered `SUPER + ALT + L` bind. That's it.

Prefer to read before you run? `git clone` this repo and run `./install.sh`.
It's forty lines.

## What you get

- **9 levels, 3 ranks** — CADET → PILOT → ACE. Score 3★ to unlock the next level.
- **5★ = par time.** CADET pars are day-two achievable. ACE 5★ is psychopath-level
  operating system control: ghost-shipping windows to workspaces you never visit,
  window squadrons, scratchpad slingshots.
- **Coins, streaks, star fanfares.** Intentionally addicting. Restart in under a second.
- **You actually learn.** A bind is shown once — after that you fly from memory
  (stall a few seconds and the keys fade back in). Every run tracks your recall
  rate; ⚡ 100% RECALL is the real trophy.
- **Share cards.** Press `s` on any result: a themed card lands in your clipboard
  and X's compose window opens. Ctrl+V, post, dare your followers.

## Playing

Each mission tells you what to do and shows the keys. The HUD pins itself to
a corner of every workspace, so it's with you wherever you fly. `q` aborts a
run, `r` restarts one instantly.

```
learnomarchy              # the hangar (level select)
learnomarchy --level 7    # jump straight to a level
learnomarchy --reset      # wipe progress, back to CADET
learnomarchy --update     # pull the latest version
learnomarchy --uninstall  # remove everything it installed
```

Progress lives in `~/.local/state/learnomarchy/save`.

## Why it looks perfect on your setup

It doesn't ship a theme. The whole game is drawn with the 16 ANSI colors of
your terminal, so it wears whatever Omarchy theme you do — and so does your
share card.

## Requirements

Omarchy 4. Nothing else — it's one bash script using what Omarchy already
ships: `hyprctl`, `jq`, `xdg-terminal-exec`, `pw-play`, `grim`, `wl-copy`.
No daemon, no build step, no config. Read the whole thing in ten minutes:
[`learnomarchy`](learnomarchy).

It also runs on stock Hyprland as long as your terminal windows carry a
`terminal` tag and the default Omarchy binds are in place, but that's not the
target and not tested.

## Contributing

Bugs and ideas → [issues](https://github.com/MaximilianHansen/learnomarchy/issues).
New levels are just a function of `do_task` lines; see `level_1` for the
shape. Keep the script dependency-free, keep it in the 16 colors, and run
`shellcheck learnomarchy install.sh` before you open a PR (CI does too).

Sounds are generated, not recorded: `sounds/generate` is a stdlib-only Python
synth. Edit the notes, run it, commit the wavs.

## License

[MIT](LICENSE).
