# MonkeyTail todo

Known issues and ideas. Nothing here is scheduled; the user picks what's worth doing.

## Next

- **The game loop, in small reviewed steps.** Controls, speed, growth, score and banana placement were decided 2026-11-15 (design.md, "Play"). Done: the board, the moving head, the tail following by the codes on the screen (steps 1-3), bananas and growth (step 4). Next: the score.
- **Speed rising as the game gets harder** (decided; the user, 2026-11-16). Starts at line 410's delay of 400. To decide: what triggers a speed-up (each banana, every N bananas, a level) and the fastest delay.

## Progression ideas (2026-11-15)

- **Inner walls as the game goes on:** posts 3 or 5 cells tall at about x=5 and x=17, centered vertically, added as difficulty rises. Other snake games add obstacles or mazes by level. Works alongside the rising speed; bananas already avoid them (random empty cell). To decide: when a level changes (every N bananas?), and whether the tail resets.

- **A faster death walk late in the game (the user, 2026-11-16):** at a 25-cell tail it takes a couple of seconds and looks good; it should never take more than about 5. Revisit with the crash sound: e.g. a delay that shrinks with the length.
- **Bonus pieces (the user, 2026-11-16, "maybe getting ahead of myself"):** e.g. a cherry that appears now and then and shortens the tail, or is worth more. To decide: what it does, how long it stays, its glyph. Shortening fits the screen model: step the tail end several times in one move.

## Later

- The title line, framed in bricks (design.md, "Title").
- The launcher handoff and leaderboard fields, as in 2up11 and MonkeySwap.
- Sounds: an eat sound and a crash sound (`meta/docs/routines.md` and MonkeySwap's `src/soundlib.bas` first).
- Variants, if memory allows: walls that wrap around, or a faster speed.
