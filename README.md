# Haskell's Game of Life

This is an implementation of Conway's Game of Life in Haskell.

See `./app/Main.hs` for the logic

## The Rules

- Any live cell with fewer than two live neighbours dies, as if by underpopulation
- Any live cell with two or three live neighbours lives on to the next generation
- Any live cell with more than three live neighbours dies, as if by overpopulation
- Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction
