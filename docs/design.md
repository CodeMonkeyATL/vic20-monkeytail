# template design notes

How `src/template.bas` works. Once the source is tightened it has no comments (they cost too much memory on an unexpanded VIC-20), so this file is where the explanations live. Update it whenever the code changes.

## The game

Rules, modes and scoring, as the program implements them.

## Screen layout

The screen is 22×23 characters; screen RAM starts at 7680 and color RAM at 38400. Map which rows and columns hold what.

## Data model

Arrays and what each element holds. Document the bit layout of any packed value.

## Routines

| Lines | Routine |
|---|---|
| 100 | init |

## Variables

| Name | Meaning |
|---|---|
| `a$` | last key from `get` |

## Sound

Each sound's register and values, for tuning by ear.

## Memory

Free memory measured with `?fre(0)` after quitting, with the date and what changed.

| Date | Free | After |
|---|---|---|
