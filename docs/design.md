# MonkeyTail design notes

How `src/monkeytail.bas` works. Once the source is tightened it has no comments (they cost too much memory on an unexpanded VIC-20), so this file is where the explanations live. Update it whenever the code changes.

## Decisions so far

What was decided before the code exists (2026-11-13; the idea started in `meta/ideas.md`, under "Offline runner", where snake came up as the joke version). The glyphs were settled with the test `meta/src/tailtest.bas`, which stays in the private `meta` repo. Sections below take over each part as it gets built.

### The game

A snake game: the monkey moves on its own, the player steers, each banana makes the tail longer. **Hitting a wall or the tail ends the game** (no wrap-around; wrapping could be a variant later).

### Play

Decided 2026-11-15:

- **Controls:** WASD, as in MonkeySwap.
- **Speed:** rises as the game gets harder (corrected 2026-11-16; "fixed" was a misreading). It's set by a delay in the main loop, starting at 400 (approved by play 2026-11-15), 12 less every 3 bananas, down to 150 (2026-11-17, for now).
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

A custom character set, chosen by eye in `tailtest.bas` (2026-11-13; the body redrawn as a closed tube 2026-11-15, the user's drawings):

| Codes | Glyph |
|---|---|
| 32 | blank (must be defined: `{clr}` fills the screen with it) |
| 40 | the head: a monkey face |
| 41 | a banana |
| 42 | a brick (the walls) |
| 48, 53, 58, 63 | straight pieces (`in=out`): a double chevron pointing the way it moves, **with solid edges on both sides**, so the body reads as a tube |
| the other 8 of 48-63 | **corners: their own glyph**, a diamond: the outer side is a 45° bevel that carries the incoming chevron on, splitting into the outgoing chevron, whose legs meet the outgoing piece's edges; one pixel closes the inner side. (Copying the straight piece going out worked for the edgeless pieces, but with edges it left a wall across the bend. A wider bevel was tried and dropped: the diamond is the regular shape.) |
| 50, 55, 56, 61 | **tail tips**, in the codes of the impossible U-turns (`in` opposite `out`): the body's edges step in to a rounded point. Their `and3` is still the way out (56 up, 61 right, 50 down, 55 left), so the tail reads a tip like any other cell |

Drawn "out right" (the corner: in right, out down), 8 rows each:

```
straight   corner     tail tip
########   #.......   ........
.#...#..   .#......   ......##
..#...#.   ..#.....   ....###.
...#...#   ...#....   ...#...#
...#...#   ...##...   ...#...#
..#...#.   ..#..#..   ....###.
.#...#..   .#....#.   ......##
########   #......#   ........
```

These drawings are the source; the program stores all 16 tail pieces ready-made as bytes (lines 1010-1040). Each drawing is turned into the other directions; the corner drawn is the clockwise turn, turning it gives the other three clockwise corners, and the four counterclockwise ones are the same drawing flipped across its diagonal (swap row and column) before turning. Turning them in BASIC at start took 35 seconds (2026-11-15), so a throwaway script did it once instead: for each `#` at row `r`, column `n`, flip (`x=r`, `y=n`) if counterclockwise, else `x=n`, `y=r`; then turn `k` times (`t=x`, `x=7-y`, `y=t`), with `k=(out-1)and3` for straights and tips, `k=(out-2+flip)and3` for corners; set bit `128>>x` of byte `y`. **When a drawing changes, regenerate the bytes the same way** (`meta/src/tailtest.bas` does it in BASIC, slowly). Head, banana and brick are first drafts.

The 8 corners are only 4 pictures (up-to-right looks like left-to-down, and so on: the diamond looks the same from both ends of the bend). Their codes stay distinct, since the code carries the direction; a tightening pass could copy the bytes of the duplicates instead of storing them (about 140 bytes).

**Memory and text:** with `poke36869,255` the VIC reads codes 0-63 from RAM at 7168 and codes 128-255 as the normal ROM glyphs (`meta/src/chartest.bas`). Our codes 32-63 sit at 7424-7679, so the top of BASIC drops to 7424 (`poke51,0:poke52,29:poke55,0:poke56,29:clr`), costing 256 bytes. **All text has to be printed reversed** (`{reverse on}`), which puts it in codes 128-255, where it shows as normal letters.

### Title

Row 1, framed in bricks, columns 1-20 exactly: `CODE` banana `MONKEY` banana `ATL` banana `TAIL` (the user's, 2026-11-16). `CODE` and `ATL` cyan, `MONKEY` and `TAIL` green like the body, yellow bananas between: the words are reversed text like the rest, and each banana is printed with `{reverse off}` as `)` (our code 41).

**Inverted tiles were tried and dropped (2026-11-16):** black letters on solid colored tiles, made by copying the ROM letters inverted into codes 1-26 (7176-7383). Those codes lie below the top of BASIC (7424), so BASIC's strings, built downward from the top (every `get a$`, the time's `str$`), overwrote them during play: `Y` broke first, then `T`. Protecting them would have cost 256 bytes. **Only codes 32-63 are safe for our characters.** A restart also printed the title with reverse still on (reverse mode lasts until a carriage return, and the help and time lines end with `;`); each print of the title now sets reverse on or off itself. See "Screen layout".

## The game

Rules, modes and scoring, as the program implements them.

## Screen layout

The screen is 22×23 characters; screen RAM starts at 7680 (`s`) and color RAM at 38400 (`c`). The user's layout (2026-11-15), black screen and border:

| Rows | Content |
|---|---|
| 0 | bricks |
| 1 | brick, title (columns 1-20), brick |
| 2 | bricks |
| 3-17 | the play area: columns 1-20 (20×15), bricks at columns 0 and 21 (and on every row from 1 to 21) |
| 18 | bricks |
| 19 | `SCORE 0` from column 1, on its own: `SCORE` cyan, the score white |
| 20 | `WASD=MOVE` from column 1, `RR=RESTART` at columns 11-20 |
| 21 | `M=MUTE` at columns 4-9 (`printtab(4)`), `QQ=QUIT` at columns 11-17; printed with `;` |
| 22 | bricks |

The keys are cyan and the rest white. Two columns of help, each lined up on its `=`: `WASD=MOVE` over `M=MUTE` (column 5), `RR=RESTART` over `QQ=QUIT` (column 13), always shown. `GAME OVER` (columns 12-20 of the score line) appears only at game over (the user's layout, 2026-11-15, reworked 2026-11-16).

Rows 19-21 are framed in bricks at columns 0 and 21, like the title (2026-11-15), so the screen is one brick frame with three panels. Bricks are code 42 in red (2), each cell's color poked before its brick so none shows white first. They're poked, never printed, so row 22's last cell can't scroll the screen. The text is reached with `poke214,18:print` (`meta/docs/routines.md`, "Cursor to a row, cheaply") and starts with `{right}`, which steps over the brick at column 0.

## Data model

No arrays besides the step table `o%(0-3)` (-22, 1, 22, -1 for up, right, down, left). The tail lives on the screen (see "The tail lives on the screen").

## Routines

| Lines | Routine |
|---|---|
| 100-130 | init: top of BASIC to 7424 (first, since its `clr` wipes variables), addresses, steps, empty the keyboard buffer |
| 200-210 | character set: reads `code, 8 bytes` groups until -1 and pokes them at 7168+code×8 |
| 300-370 | board: colors and RAM character set on, bricks, title, score and help |
| 400-470 | play: the monkey starts at row 10, columns 8-10 (tip, body, head) moving right; each move waits (410), reads at most one key, moves the tail end (460-462), steps the head, and ends the game on any cell that isn't blank |
| 480-492 | game over: the time played into `z`, `GAME OVER` on the score line (row 19, column 12), the crash sound (481); the monkey turns red one cell at a time from the head to the tail end, with the up+down sound (482-487); then `TIME m:ss` over `WASD=MOVE` (row 20), and falls into 500 |
| 500-520 | wait for a key pressed twice: `rr` goes back to 300 (board and a new monkey; the character set is still loaded), `qq` falls into 520; other keys are ignored. 520 puts the ROM character set and top of BASIC back and ends. During play, `qq` jumps straight to 520 and `rr` to 300 (435); the redraw takes about a second |
| 600-610 | banana: a random cell of the play area (row 3-17, column 1-20: `67+int(rnd(1)*15)*22+int(rnd(1)*20)`), picked again until it's blank, then a yellow banana; no reachability check (an open board, and the tail always moves) |
| 700-730 | eat: 3 more cells to grow, score +1, a new banana, the score printed after `SCORE`, the ding-ding (702, fade at 720); every 3rd banana a shorter delay |
| 800-850 | **test start** (`tt`, hidden: not in the help): draws a 109-cell monkey snaking across rows 3-8 (the length at about 35 bananas), head at row 8 moving left; with score 35 and its delay (268), set at 407-408 when `f` is 1. For testing the death walk and late-game speed without 4.5 minutes of play. Kept for now (the user, 2026-11-17); remove before release |
| 1000-1050 | character data: blank, head, banana, brick, the 16 tail pieces |

## Variables

| Name | Meaning |
|---|---|
| `s` | screen RAM, 7680 |
| `c` | color RAM, 38400 |
| `o%()` | step for each direction |
| `i` | loop temporary |
| `k`, `t` | character code and byte while loading the character set |
| `p` | the head's screen offset (row×22 + column) |
| `n` | the cell the head moves into |
| `d` | the direction the head moves: 0 up, 1 right, 2 down, 3 left |
| `e` | the direction the head was moving when it entered its cell (the `in` of the body code it leaves behind) |
| `q` | the tail end's screen offset |
| `t` | also the way out of a tail cell, `peek and 3`; the next cell's code; the cell being turned red at game over |
| `g` | moves left to grow: the tail end stays put while it's above 0 |
| `b` | the banana's screen offset |
| `v` | the score: bananas eaten |
| `w` | the delay between moves (the speed): 400 down to 150 |
| `h` | the volume: 7, or 0 when muted with `m` |
| `x`, `y` | the death walk's falling and rising pitch |
| `f` | 1 when `tt` asked for the test start |
| `r`, `u` | test start: row and column of the cell being drawn |
| `z` | `ti` at the start of a game; at game over, the jiffies played |
| `j` | the direction a key asks for |
| `k` | the key's code, `asc(a$)and127` (Shift ignored); also a character code while loading |
| `l` | the previous key, for `qq` and `rr` |
| `a$` | last key from `get` |

### Play loop details

- **Keys:** `j=-(k=68)-2*(k=83)-3*(k=65)` turns `d`, `s`, `a` into 1, 2, 3 and anything else into 0; a 0 counts as up only when the key was `w` (87). A key pressed between moves waits in the keyboard buffer, so quick turns queue up instead of being lost.
- **No reversing:** `ifj<>((d+2)and3)thend=j`; `(d+2)and3` is the opposite direction. It matters once the tail exists.
- **The tail follows (step 3, 2026-11-16):** each move first steps the tail end: `t=peek(s+q)and3` is its way out, the cell is blanked, `q` steps by `o%(t)`, and the new end cell is redrawn as a tip with the same way out: `48+((t+2)and3)*4+t`, the U-turn code (`in` opposite `out`). Then the head steps; the cell it leaves gets `48+e*4+d` in yellow (7), and `e=d`. The crash check comes first, so a crash leaves the whole monkey on screen; the one non-blank cell that's safe is the tail end (`n=q`), which moves out of the way in the same move, as in other snake games. (Moving the tail first made the monkey shrink by a cell at game over.)
- **Bananas and growth (step 4, 2026-11-16):** the next cell is read once into `t`. A banana (41) adds 3 to `g`, places the next banana and skips the crash check. (3 felt a little aggressive at first, but the user lasted a long time with it, 2026-11-16.) While `g>0`, each move takes 1 from it and leaves the tail end where it is, so a banana makes the monkey 3 cells longer over 3 moves. The tail end is only a safe cell when it's about to move (`g=0`). `rnd(-ti)` at start seeds the random numbers from the clock, so each game's bananas differ.
- **Score (2026-11-16):** `v`, bananas eaten, printed by the eat routine (700) with `printtab(6)` on row 19: BASIC prints a positive number with a leading space, which lands on the space after `SCORE` (column 6), so the digits start at column 7, where the board's `0` is. The board prints `SCORE 0` itself, so a restart shows 0 again; the score stays on screen at game over.
- **Time played (2026-11-16):** `z=ti` at the start; at the crash `z=ti-z` is the jiffies (1/60 s) played, before the death walk, so the walk doesn't count. After the walk, `TIME m:ss` replaces `WASD=MOVE` (no longer needed); the seconds are `right$(str$(100+sec),2)`, a cheap leading zero. It isn't shown during play (the user's choice). A restart redraws the help. It'll be a leaderboard field later.
- **Colors:** the head and bananas yellow, the body green (5) (2026-11-16: the body was yellow, then the head white).
- **Turning red at game over (482-487):** the codes are read backwards. The cell behind the head is `p-o%(e)`; from any body cell, `int(peek/4)and3` is its `in` direction, so the cell before it is `t-o%(in)`. Each cell's color goes to red (2) after a short delay (`fori=1to20`), until the tail end `q`. The delay was 60 until a score of 35 made the walk "excruciatingly long" (the user, 2026-11-17).
- **Crash:** a single `peek` of the next cell: anything but blank (32) ends the game, which covers the walls now and the tail later. A banana is checked first (see above).
- **Speed:** a delay loop, `fori=1tow:next` (410). `w` starts at 400, about 2-3 moves a second; every 3rd banana takes 12 off it (705: `v-int(v/3)*3=0` means "`v` divides by 3"), down to a floor of 150, reached at 63 bananas (step 6, 2026-11-17; 8 per 3 was hardly felt by a score of 35: each move also spends about as long running its BASIC as in the delay, so a 22% shorter delay made moves only about 12% faster). Start, step, interval and floor are the user's "for now" values, and could be set by harder modes. 150 was "much too fast to start out" (the user, 2026-11-15: more like the speed after eating a lot).

## Sound

Each sound's register and values, for tuning by ear. Picked by the user on `meta/src/soundlib.bas` (2026-11-17; letters there in brackets). The volume `h` is 7 of 15 (the user: "like 50% to start"); `m` toggles it between 7 and 0, which mutes every sound without changing any timing. While muted, the `UTE` of `M=MUTE` is red (740: color RAM 38869-38871, row 21 columns 7-9, `1-(h=0)` gives white 1 or red 2), as in MonkeySwap; the board calls it too, so a restart keeps it.

| Sound | Lines | What it does |
|---|---|---|
| eat (`f`, RingSort's lock ding-ding) | 702, 720 | high voice (36876) at 230, the volume faded from `h` to 0, then 240 held a moment and faded again. The fade takes 16 steps whatever `h` is (`step-h/15`), so its length doesn't depend on the volume; it's skipped when muted (a step of 0 would never end) |
| crash (`l`, 2up11's game over) | 481 | the low voice (36874) falls from 200 to 140 by 0.5, before the death walk |
| death walk (`x`, up+down) | 482-487 | one step per cell of the walk: the low and high voices (36874, 36876) fall 4 from 226, wrapping at 196 back up an octave (30), while the middle voice (36875) rises 4 from 196, wrapping at 226. With the voices an octave apart, both directions go on forever (a Shepard-like effect), and the sound lasts exactly as long as the walk. Tried first: a plain Shepard fall, faster and slower, detuned, wobbling, with noise; and a tritone alternation (kept in soundlib as a future alert) |

## Memory

Free memory measured with `?fre(0)` after quitting, with the date and what changed.

| Date | Free | After |
|---|---|---|
| 2026-11-15 | 2409 (about 2100 in play) | character set and board (PRG 1176). The value after quitting includes the 256 bytes the character set gives back. |
| 2026-11-15 | about 1800 in play (estimated from the PRG, 1488) | the help framed in bricks, layout B, the moving head |
