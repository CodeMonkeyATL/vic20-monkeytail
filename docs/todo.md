# MonkeyTail todo

Known issues and ideas. Nothing here is scheduled; the user picks what's worth doing.

## Next

- **The game loop, in small reviewed steps.** Controls, speed, growth, score and banana placement were decided 2026-11-15 (design.md, "Play"). Done: the board, the moving head (steps 1-2). Next: the tail follows, by the codes on the screen (step 3), then bananas and growth, then the score.
- **Tune the speed by play** (line 410's delay).

## Progression ideas (2026-11-15)

- **Inner walls as the game goes on:** posts 3 or 5 cells tall at about x=5 and x=17, centered vertically, added as difficulty rises. Other snake games add obstacles or mazes by level. Fits the fixed speed (harder by board, not speed); bananas already avoid them (random empty cell). To decide: when a level changes (every N bananas?), and whether the tail resets.
- **Speed rising with the tail:** the user described the first speed tried as "like after you've eaten a lot and are nearing super speed", which suggests a speed-up after all; the decision so far is a fixed speed.

## Later

- The title line, framed in bricks (design.md, "Title").
- The launcher handoff and leaderboard fields, as in 2up11 and MonkeySwap.
- Sounds: an eat sound and a crash sound (`meta/docs/routines.md` and MonkeySwap's `src/soundlib.bas` first).
- Variants, if memory allows: walls that wrap around, or a faster speed.
