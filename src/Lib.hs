module Lib (
  sayHi
  ) where

-- TYPES
type Coord = [Int]

type Point = String
type Row = [Point]
type Board = [Row]

-- CONSTANTS
blankPoint = "_"
blankRow = take 5 (repeat blankPoint)
initialBoard = take 5 (repeat blankRow)

-- MAIN
sayHi :: IO()
sayHi = do
  putStrLn "hey"