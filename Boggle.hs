module Boggle (boggle) where
-- sanna balouchi
import Data.List (isPrefixOf)
import qualified Data.Map as Map
type Board = [[Char]]
type Visited = [[Bool]]

{--
    Fill in the boggle function below. Use as many helpers as you want.
    Test your code by running 'cabal test' from the tester_hs_simple directory.
--}

boggle :: Board -> [String] -> [(String, [(Int, Int)])]
boggle board words =
  let n = length board
      visitedWords = replicate n (replicate n False) -- creates nxn list of visited letters on board
      found = Map.empty -- creates the empty map for words found
  in Map.toList $ solve board words n visitedWords found -- collects all found words

-- takes in the board, list of valid words, size of board, visited list, words found and returns filled map of found words
solve :: Board -> [String] -> Int -> Visited -> Map.Map String [(Int, Int)] -> Map.Map String [(Int, Int)]
solve board words size visited found =
  foldl (\acc1 i ->
           foldl (\acc2 j ->
                    let newVisted = updateVisited i j visited --updates visited
                        current = [board !! i !! j] --grabs letter off board
                    in (dfssearch current i j words acc2 board [(i,j)] newVisted) --continues to dfssearch all possible paths starting with letter
                 ) acc1 [0..size-1]
        ) found [0..size-1]

--conducts dfs for all paths possible
dfssearch :: String -> Int -> Int -> [String] -> Map.Map String [(Int, Int)] -> Board -> [(Int, Int)] -> Visited -> Map.Map String [(Int, Int)]
dfssearch current x y words found board position visited =
  let neighbours = [[1, 0], [0, 1], [-1, 0], [0, -1], [1, 1], [-1, -1], [1, -1], [-1, 1]] -- up, down, left, right, corners
      validWord = filter (isPrefixOf current) words -- returns true if the current word can form a word
      newVisited = updateVisited x y visited    -- updates the visited
      wordsFound = if current `elem` words --if it is a valid word
                   then Map.insert current position found -- then add to map
                   else found -- otherwise remain unchanged
  in if length current > (length board * length board) || null validWord
  then wordsFound --if cannot form a word, or out of bounds, exit dfs
  else --else continue with dfs
    foldl (\wordsacc [dx, dy] ->
        let addx = x + dx --new positions for x,y
            addy = y + dy
        --makes sure it is on the board and not out of bounds + not already visited
        in if addx >= 0 && addx < length board && addy >= 0 && addy < length board && not (newVisited !! addx !! addy) 
           then let newPosition = position ++ [(addx, addy)] --new position list updated to include current new position
                in dfssearch (current ++ [board !! addx !! addy]) addx addy validWord wordsacc board newPosition newVisited -- continues dfs
           else wordsacc --returns found words to move to next dfs
            ) wordsFound neighbours 
  
-- sets the position given to true so we do not visit again
updateVisited :: Int -> Int -> Visited -> Visited
updateVisited i j visited = map (\(idx, row) -> 
    if idx == i 
    then take j row ++ [True] ++ drop (j + 1) row
    else row) 
    (zip [0..] visited)