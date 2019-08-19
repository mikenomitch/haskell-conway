module Main where
-- import Lib
import Data.Char

-- RULES
-- Any live cell with fewer than two live neighbours dies, as if by underpopulation
-- Any live cell with two or three live neighbours lives on to the next generation
-- Any live cell with more than three live neighbours dies, as if by overpopulation
-- Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction

-- TYPES
type Coordinate = [Int]
type Coordinates = [Coordinate]

type Point = Char
type Row = [Point]
type Board = [Row]

-- CONSTANTS
blankPoint = '-'
blankRow = take 5 (repeat blankPoint)
initialBoard = take 5 (repeat blankRow)
initialLife = [[0,0],[1,1],[2,2],[3,3],[4,4]]

-- HELPERS
second :: Coordinate -> Int
second list = list!!1

replaceNth :: Int -> a -> [a] -> [a]
replaceNth _ _ [] = []
replaceNth idx val (hd:tail)
  | idx == 0 = val:tail
  | otherwise = hd:replaceNth (idx-1) val tail

-- MAIN LOGIC
setValueAtCoordinate :: Board -> Coordinate -> Point -> Board
setValueAtCoordinate board coordinate value = do
  let rowIdx = head coordinate
  let colIdx = second coordinate
  let row = board!!rowIdx
  let newRow = replaceNth colIdx value (board!!rowIdx)
  replaceNth rowIdx newRow board

hasLife :: Board -> Coordinate -> Bool
hasLife board coordinate = do
  valueAtCoordinate board coordinate == 'X'

valueAtCoordinate :: Board -> Coordinate -> Point
valueAtCoordinate board coordinate = do
  let rowIdx = head coordinate
  let colIdx = second coordinate
  board!!rowIdx!!colIdx

setRowLife :: Board -> Coordinate -> Board
setRowLife board coordinate = do
  setValueAtCoordinate board coordinate 'X'

setBoardLife :: Board -> Coordinates -> Board
setBoardLife board coords = do
  foldl setRowLife board coords

neighborCount :: Board -> Coordinate -> Int
neighborCount board coordinate = do
  let rowIdx = head coordinate
  let colIdx = second coordinate
  let neighborCoordinates = [[rowIdx - 1, colIdx],[rowIdx + 1, colIdx],[rowIdx, colIdx - 1],[rowIdx, colIdx + 1]]
  length (filter (hasLife board) neighborCoordinates)

getNextBoard :: Board -> Board
getNextBoard currentBoard = do
  -- iterate over rows
  -- get neighBorBound
  -- map getNextRow currentBoard
  initialBoard

iterateLife :: Board -> Board -> IO()
iterateLife lastBoard currentBoard = do
  print currentBoard

  if (lastBoard == currentBoard) then
    print "=== DONE ==="
  else
    iterateLife currentBoard (getNextBoard currentBoard)

main = do
  let withLife = (setBoardLife initialBoard initialLife)
  iterateLife initialBoard withLife

