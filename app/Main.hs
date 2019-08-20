module Main where

-- TYPES

type Coordinate = (Int, Int)
type Coordinates = [Coordinate]

type Cell = Char
type Row = [Cell]
type Board = [Row]
type CellWithNeighborCount = (Cell, Int)

-- CONSTANTS

deadCell = '-'
liveCell = 'O'

-- GENERAL HELPERS

replaceNth :: Int -> a -> [a] -> [a]
replaceNth _ _ [] = []
replaceNth idx val (hd:tail)
  | idx == 0 = val:tail
  | otherwise = hd:replaceNth (idx-1) val tail

-- PRINTING HELPERS

printDivider :: IO()
printDivider = putStrLn "==========="

printEnd :: IO()
printEnd = putStrLn "STABLE LIFE"

printRows :: Board -> IO()
printRows (row:[]) = do
  putStrLn row
  printDivider
printRows (row:rest) = do
  putStrLn row
  printRows rest

printBoard :: Board -> IO()
printBoard board = do
  printRows board

-- DOMAIN HELPERS

colBound :: Board -> Int
colBound board = (length (board!!0)) - 1

rowBound :: Board -> Int
rowBound board = (length board) - 1

invalidIdx :: Int -> Int -> Bool
invalidIdx bound val = val > bound || val < 0

invalidRowIdx :: Board -> Int -> Bool
invalidRowIdx board val = invalidIdx (rowBound board) val

invalidColIdx :: Board -> Int -> Bool
invalidColIdx board val = invalidIdx (colBound board) val

invalidCoordinate :: Board -> Coordinate -> Bool
invalidCoordinate board (rowIdx, colIdx) = do
  invalidRowIdx board rowIdx || invalidColIdx board colIdx

-- SETUP

-- CHANGE HERE TO SEE DIFFERENT EVOLUTION
makeSeeds :: Int -> Coordinates
makeSeeds size = do
  [ (x,y) |
    x <- [0..(size -1)],
    y <- [0..(size - 1)],
    (mod (x + y) 3) == 0 || x == y || x == (size - y) ]

setValueAtCoordinate :: Board -> Coordinate -> Cell -> Board
setValueAtCoordinate board (rowIdx, colIdx) value = do
  let row = board!!rowIdx
  let newRow = replaceNth colIdx value row
  replaceNth rowIdx newRow board

setRowLife :: Board -> Coordinate -> Board
setRowLife board coordinate = do
  setValueAtCoordinate board coordinate liveCell

setBoardLife :: Board -> Coordinates -> Board
setBoardLife board coords = do
  foldl setRowLife board coords

boardOfSize :: Int -> Board
boardOfSize size = do
  let blankRow = take size (repeat deadCell)
  take size (repeat blankRow)

-- LIFE CYCLES

valueAtCoordinate :: Board -> Coordinate -> Cell
valueAtCoordinate board (rowIdx, colIdx) = do
  (board!!rowIdx)!!colIdx

hasLife :: Board -> Coordinate -> Bool
hasLife board coordinate = do
  if invalidCoordinate board coordinate then
    False
  else
    valueAtCoordinate board coordinate == liveCell

neighborCount :: Board -> Coordinate -> Int
neighborCount board (rowIdx, colIdx) = do
  let neighborCoordinates = [ (rowIdx - 1, colIdx),
                              (rowIdx + 1, colIdx),
                              (rowIdx, colIdx - 1),
                              (rowIdx, colIdx + 1) ]
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
  [ getNextValue board (rowIdx, colIdx) |
    colIdx <- [0..(colBound board)] ]

getNextBoard :: Board -> Board
getNextBoard board = do
  [ getNextRow board rowIdx |
    rowIdx <- [0..(rowBound board)] ]

iterateLife :: Board -> Board -> IO()
iterateLife lastBoard currentBoard = do
  printBoard currentBoard

  if (lastBoard == currentBoard) then
    printEnd
  else
    iterateLife currentBoard (getNextBoard currentBoard)

main = do
  putStrLn "How large should the board be?"
  boardSize <- getLine

  let blankBoard = boardOfSize (read boardSize)
  let seedLife = makeSeeds (read boardSize)
  let initialBoard = setBoardLife blankBoard seedLife

  printDivider
  iterateLife blankBoard initialBoard
