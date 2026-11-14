# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

MonkeyTail, a snake game for an **unexpanded VIC-20**, written in Commodore BASIC V2 (petcat text format). The README has the rules and controls; `docs/design.md` explains how the program works. `docs/todo.md` lists known issues and ideas.

## Build and run

- **Build + run (what the IDE Build does):** `powershell -NoProfile -ExecutionPolicy Bypass -File buildtools/build-and-run.ps1 -BasFile src/<name>.bas`
  - Strips the `rem`s into a temporary copy (`buildtools/strip-rems.ps1`), runs `petcat.exe -w2 -l 1001 -o prgs/<name>` on it, then autostarts the PRG in xvic. If xvic is already running, it's sent over the remote monitor (127.0.0.1:6510); otherwise xvic is started with `-memory none -keymap 0 -remotemonitor`.
  - **Machine-aware:** the file name picks the machine, with the same suffixes as CI: `<name>-c64.bas` builds for the C64 (`-l 0801`, 80-character lines, x64sc with its monitor on port 6511, so it can run beside xvic); anything else is a VIC-20 program. The table is `buildtools/machine.ps1`; `screenshot.ps1` and `keys.ps1` take `-Machine c64`.
  - **Shared folders (opt-in, next to the repos):** `prgs-latest` collects every VIC-20 build and is xvic's drive 8, `sd-c64` the same for the C64, and `net-mock` becomes drive 9 on every emulator the tools start (the mock network between a VIC-20 and a C64).
  - `petcat.exe` and `xvic.exe` must be on PATH (VICE 3.10 GTK3). Copies of petcat/c1541 are also in `tools/`.
  - The local build is byte-identical to the CI build. Don't commit locally built PRGs; CI builds them.
- **See the screen:** `powershell -NoProfile -ExecutionPolicy Bypass -File buildtools/screenshot.ps1` saves a PNG to `screenshots/temp/` (gitignored). The `/screenshot` skill wraps this (a user-level skill; its master copy is in the `meta` repo, `claude/user/skills/`). Pass `-OutFile` only as an absolute path.
- **Press keys:** `powershell -NoProfile -ExecutionPolicy Bypass -File buildtools/keys.ps1 -Keys "<keys>"` types into the running program through the monitor's `keybuf` command. Example: after quitting, `-Keys "\x93?fre(0)\n"` prints free memory on a clean screen.
- **Remote monitor and autostart:** the rules for driving xvic safely (never send `x`, one command per connection, autostart replaying the last `keybuf` string, escape syntax) are in `meta/claude/xvic.md`, loaded through the workspace CLAUDE.md. The stray `z` that `build-and-run.ps1` leaves for autostart is discarded by `poke198,0` at start.
- **Lint:** `buildtools/check-basic.ps1 -BasFile <file>` checks a source file against the guidelines: missing `goto`/`gosub`/`then` targets, lines over 88 characters as listed (80 for a C64 program), spaces outside strings and `rem`s, line numbers that are unnumbered, duplicated or out of order, and keywords formed across a name and the next word. For that last check it tokenizes each line the way petcat does, then flags keywords where none belongs: a statement keyword inside a statement (`fori=stop`), a function without `(` (`tand7`), `to`/`step` outside `for`, `then` without `if`. It also flags `?` outside a string, which petcat stores as a plain character instead of print. `build-and-run.ps1` runs it before petcat; it only prints warnings and never stops the build. The game's source should stay at 0 warnings.
- There are no automated tests. Verify changes by building and looking at the emulator screen.
- **IDE tasks:** the user works in Visual Studio (Open Folder). VS reads only `.vs/tasks.vs.json`, which is gitignored; `buildtools/tasks.vs.json` is the committed copy (and `buildtools/tasks.json` is the VS Code equivalent). Keep the copies in sync. Every VS Build prints a harmless "The system cannot find the file specified." that comes from VS itself, not the script.
- **`rem`s are stripped at build (2026-11-08):** `strip-rems.ps1` drops rem-only lines and cuts `:rem…` off line ends, with the lint's tokenizer (`basic-tokens.ps1`, shared), so a `rem` in a string survives. The PRG has no comments; the source keeps them. A routine's `rem` goes at the end of its first code line, since a jump to a rem-only line would fail in the build; the lint warns about it.
- **CI:** `.github/workflows/build-prg.yml` strips the `rem`s the same way (with `pwsh`) and runs petcat on changed `.bas` files when a PR is merged (or a `v*` tag is pushed) and commits the PRGs to `prgs/`. When a PR deletes or renames a `.bas` file, it also removes that file's old PRG. A filename suffix picks the petcat flags (`-vic20-8k.bas`, `-c64.bas`, …); plain names get `-w2 -l 1001`, the same as the local build.

## Source files (`src/`)

- `monkeytail.bas`: the game.

The glyph test that settled the tail's look is `meta/src/tailtest.bas`, in the private `meta` repo. **Keep it there:** this repo may go public, and the test shouldn't. Port what the game needs from it; don't copy the file here.

## Docs

- `docs/design.md`: how the program works, including the variable table and routine map. Keep it in sync with code changes.
- `docs/todo.md`: known issues and ideas; the user decides what gets done. Cross-repo plans are in `meta/ideas.md`.
- The general VIC-20 reference (petcat tokens, colors, glyphs, registers, keyboard buffer) is the user's cheatsheet in the `meta` repo, `meta/docs/cheatsheet.md`; general facts learned here go there, game specifics in `design.md`.

## Program architecture

No game code yet; `docs/design.md`, "Decisions so far", holds what's decided. Describe the flow, data model, screen layout and routine blocks here once they exist. Free memory: not measured yet (measure with `?fre(0)` after quitting).

- **Built in small reviewed steps,** as MonkeySwap was: one routine or idea per step, with the BASIC choices explained, stopping for the user's review before the next. The user wants to be involved, not handed finished code.
- **The custom character set takes the top 256 bytes** (top of BASIC at 7424), so program and variables share about 3.3K, not 3.5K.

- Subroutines live at fixed line-number blocks; keep new routines in their own blocks.

## Coding guidelines

Follow the BASIC coding rules in the private `meta` repo (`meta/docs/basic-guidelines.md`). The workspace CLAUDE.md one folder up imports them, along with the xvic and petcat notes (`meta/claude/xvic.md`).
