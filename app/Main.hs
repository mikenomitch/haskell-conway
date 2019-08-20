module Main where
import Data.Char

-- TODOS
-- TODO: Random seeds with a seed number
-- TODO: Pattern match with the constant escaped
-- TODO: Various clean up

-- RULES
-- Any live cell with fewer than two live neighbours dies, as if by underpopulation
-- Any live cell with two or three live neighbours lives on to the next generation
-- Any live cell with more than three live neighbours dies, as if by overpopulation
-- Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction

-- TYPES
type Coordinate = [Int]
type Coordinates = [Coordinate]

type Cell = Char
type Row = [Cell]
type Board = [Row]
type CellWithNeighborCount = (Cell, Int)

-- CONSTANTS
deadCell = '-'
liveCell = 'O'
rowCount = 5
colCount = 5
rowBound = rowCount - 1
colBound = colCount - 1

blankRow = take rowCount (repeat deadCell)
blankBoard = take colCount (repeat blankRow)
seed = [[0,0],[1,1],[2,2],[3,3],[4,4],[1,0],[0,1],[2,3],[3,2],[4,4],[3,4]]

-- GENERAL HELPERS
second :: Coordinate -> Int
second list = list!!1

replaceNth :: Int -> a -> [a] -> [a]
replaceNth _ _ [] = []
replaceNth idx val (hd:tail)
  | idx == 0 = val:tail
  | otherwise = hd:replaceNth (idx-1) val tail

-- PRINTING HELPERS

printDivider :: IO()
printDivider = putStrLn "======"

printRows :: Board -> IO()
printRows (row:[]) = do
  putStrLn row
  putStrLn "======"
printRows (row:rest) = do
  putStrLn row
  printRows rest

printBoard :: Board -> IO()
printBoard board = do
  printRows board

-- DOMAIN HELPERS
invalidIdx :: Int -> Int -> Bool
invalidIdx bound val = val > bound || val < 0

invalidRowIdx :: Int -> Bool
invalidRowIdx val = invalidIdx rowBound val

invalidColIdx :: Int -> Bool
invalidColIdx val = invalidIdx colBound val

invalidCoordinate :: Coordinate -> Bool
invalidCoordinate coordinate = do
  let rowIdx = head coordinate
  let colIdx = second coordinate
  invalidRowIdx rowIdx || invalidColIdx colIdx

-- SETUP

setValueAtCoordinate :: Board -> Coordinate -> Cell -> Board
setValueAtCoordinate board coordinate value = do
  let rowIdx = head coordinate
  let colIdx = second coordinate
  let row = board!!rowIdx
  let newRow = replaceNth colIdx value row
  replaceNth rowIdx newRow board

setRowLife :: Board -> Coordinate -> Board
setRowLife board coordinate = do
  setValueAtCoordinate board coordinate liveCell

setBoardLife :: Board -> Coordinates -> Board
setBoardLife board coords = do
  foldl setRowLife board coords

-- LIFE CYCLES

valueAtCoordinate :: Board -> Coordinate -> Cell
valueAtCoordinate board coordinate = do
  let rowIdx = head coordinate
  let colIdx = second coordinate
  (board!!rowIdx)!!colIdx

hasLife :: Board -> Coordinate -> Bool
hasLife board coordinate = do
  if invalidCoordinate coordinate then
    False
  else
    valueAtCoordinate board coordinate == liveCell

neighborCount :: Board -> Coordinate -> Int
neighborCount board coordinate = do
  let rowIdx = head coordinate
  let colIdx = second coordinate
  let neighborCoordinates = [[rowIdx - 1, colIdx],[rowIdx + 1, colIdx],[rowIdx, colIdx - 1],[rowIdx, colIdx + 1]]
  length (filter (hasLife board) neighborCoordinates)

nextValue :: CellWithNeighborCount -> Cell
nextValue ('O', 2) = liveCell
nextValue ('O', 3) = liveCell
nextValue ('-', 3) = liveCell
nextValue _        = deadCell

getNextValue :: Board -> Coordinate -> Cell
getNextValue board coordinate = do
  let neighbors = neighborCount board coordinate
  let cell = valueAtCoordinate board coordinate
  nextValue (cell, neighbors)

getNextRow :: Board -> Int -> Row
getNextRow board rowIdx = do
  [ getNextValue board [rowIdx, colIdx] | colIdx <- [0..colBound]]

getNextBoard :: Board -> Board
getNextBoard board = do
  [ getNextRow board rowIdx | rowIdx <- [0..rowBound]]

iterateLife :: Board -> Board -> IO()
iterateLife lastBoard currentBoard = do
  printBoard currentBoard

  if (lastBoard == currentBoard) then
    print "STABLE LIFE"
  else
    iterateLife currentBoard (getNextBoard currentBoard)

main = do
  let initialBoard = setBoardLife blankBoard seed
  printDivider
  iterateLife blankBoard initialBoard
