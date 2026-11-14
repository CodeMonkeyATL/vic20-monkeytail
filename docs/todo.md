# MonkeyTail todo

Known issues and ideas. Nothing here is scheduled; the user picks what's worth doing.

## To decide before the game loop

- **Controls:** WASD (as MonkeySwap) or the cursor keys, or both.
- **Speed:** how many moves per second, and whether it speeds up as the tail grows.
- **Growth:** how many cells a banana adds.
- **Score:** bananas eaten, tail length, or points that rise with speed. It's what the leaderboard will show.
- **Where bananas go:** a random empty cell inside the walls, found with `peek`.

## Later

- The title line, framed in bricks (design.md, "Title").
- The launcher handoff and leaderboard fields, as in 2up11 and MonkeySwap.
- Sounds: an eat sound and a crash sound (`meta/docs/routines.md` and MonkeySwap's `src/soundlib.bas` first).
- Variants, if memory allows: walls that wrap around, or a faster speed.
