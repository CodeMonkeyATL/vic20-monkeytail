# MonkeyTail todo

Known issues and ideas. Nothing here is scheduled; the user picks what's worth doing.

## Next

- **The game loop, in small reviewed steps.** Controls, speed, growth, score and banana placement were decided 2026-11-15 (design.md, "Play"). Done: the board, the moving head, the tail following by the codes on the screen (steps 1-3), bananas and growth (step 4), the score (step 5), the speed rising (step 6), sounds and mute (step 7), the launcher handoff (step 8). Next: the launcher's mock list and the service seed need game 3.
- **Modes with a harder start (the user, 2026-11-17):** the speed's start (400), step (8), interval (every 3 bananas) and floor (150) could be parameters that a mode sets, along with the inner walls.

## Progression ideas (2026-11-15)

- **Inner walls as the game goes on:** posts 3 or 5 cells tall at about x=5 and x=17, centered vertically, added as difficulty rises. Other snake games add obstacles or mazes by level. Works alongside the rising speed; bananas already avoid them (random empty cell). To decide: when a level changes (every N bananas?), and whether the tail resets.

- **The death walk's length (the user, 2026-11-16):** at a score of 26 (about 80 cells, about 5 seconds) it wasn't tedious; it's a rewarding replay of the path traveled, so longer may be fine too. Revisit with the crash sound: if it drags late in the game, a delay that shrinks with the length.
- **Bonus pieces (the user, 2026-11-16, "maybe getting ahead of myself"):** e.g. a cherry that appears now and then and shortens the tail, or is worth more. To decide: what it does, how long it stays, its glyph. Shortening fits the screen model: step the tail end several times in one move.


## Later

- The title line, framed in bricks (design.md, "Title").
- Sounds: an eat sound and a crash sound (`meta/docs/routines.md` and MonkeySwap's `src/soundlib.bas` first).
- Variants, if memory allows: walls that wrap around, or a faster speed.
