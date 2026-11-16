# MonkeyTail design notes

How `src/monkeytail.bas` works. Once the source is tightened it has no comments (they cost too much memory on an unexpanded VIC-20), so this file is where the explanations live. Update it whenever the code changes.

## Decisions so far

What was decided before the code exists (2026-11-13; the idea started in `meta/ideas.md`, under "Offline runner", where snake came up as the joke version). The glyphs were settled with the test `meta/src/tailtest.bas`, which stays in the private `meta` repo. Sections below take over each part as it gets built.

### The game

A snake game: the monkey moves on its own, the player steers, each banana makes the tail longer. **Hitting a wall or the tail ends the game** (no wrap-around; wrapping could be a variant later).

### Play

Decided 2026-11-15:

- **Controls:** WASD, as in MonkeySwap.
- **Speed:** fixed. The monkey moves at one rate all game, set by a delay in the main loop and tuned by playing.
- **Growth:** each banana adds **3 cells**: the tail end stays put for the next 3 moves.
- **Score:** bananas eaten. That's what the leaderboard shows.
- **Bananas:** placed in a random cell inside the walls, picked again with `peek` until it's empty.

### The tail lives on the screen

The tail's cells are never stored in an array. Each body cell's **character code says which way the tail leaves that cell**, so the tail end can follow the body by reading the screen:

- Directions: up 0, right 1, down 2, left 3. A step is `o%(d)`: -22, 1, 22, -1 (the screen is 22 columns wide).
- **Body codes are `48+in*4+out`** (48-63): `in` is the direction the head was moving when it entered the cell, `out` the direction it left in. So `peek(cell)and3` is the way out, whatever the picture.
- **When the head moves** from cell A in direction `d` (it entered A moving `e`), A gets `48+e*4+d` and the new cell gets the head.
- **When the tail moves:** read `j=peek(tail)and3`, blank the cell, step `o%(j)`, and redraw the new end cell as a tail tip with the same way out. A banana skips this for one move (or more), which is how the tail grows.
- So the game keeps only two screen positions (head and tail) and the current direction, against about 1K for an array of positions.

### Glyphs

A custom character set, chosen 2026-11-13 by eye in `tailtest.bas`:

| Codes | Glyph |
|---|---|
| 32 | blank (must be defined: `{clr}` fills the screen with it) |
| 40 | the head: a monkey face |
| 41 | a banana |
| 42 | a brick (the walls) |
| 48, 53, 58, 63 | straight pieces (`in=out`): a double chevron pointing the way it moves |
| the other 8 of 48-63 | corners: **a copy of the straight piece going out** (two-half and elbow corners were tried and dropped as too jagged or backwards-looking) |
| 50, 55, 56, 61 | **tail tips**, in the codes of the impossible U-turns (`in` opposite `out`): a small chevron with a dash. Their `and3` is still the way out (56 up, 61 right, 50 down, 55 left), so the tail reads a tip like any other cell |

The straight piece and the tail tip are each drawn once, for "out right", and turned into the other three directions by the program at start. Head, banana and brick are first drafts.

**Memory and text:** with `poke36869,255` the VIC reads codes 0-63 from RAM at 7168 and codes 128-255 as the normal ROM glyphs (`meta/src/chartest.bas`). Our codes 32-63 sit at 7424-7679, so the top of BASIC drops to 7424 (`poke51,0:poke52,29:poke55,0:poke56,29:clr`), costing 256 bytes. **All text has to be printed reversed** (`{reverse on}`), which puts it in codes 128-255, where it shows as normal letters.

### Title

The user's idea (2026-11-13) for the top line, possibly framed in bricks on all sides:

```
{wht}CODE{yel}MONKEY{wht}ATL {yel}TAIL
```

18 characters, so it fits with a brick at each end (20 of 22 columns). Printed reversed, as all text.

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
