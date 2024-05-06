{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Use camelCase" #-}
{-# HLINT ignore "Use elem" #-}
{-# HLINT ignore "Use uncurry" #-}
{-# HLINT ignore "Use !!" #-}
{-# OPTIONS_GHC -Wno-overlapping-patterns #-}
module Lab5 (third_last, every_other, is_cyclops, domino_cycle, tukeys_ninther) where
import Data.Bits (FiniteBits(countTrailingZeros))

{--
    Add your functions for lab 5 below. Function and type signatures are 
    provided below, along with dummy return values.
    Add your code below each signature, but to not modify the types.
       
    Test your code by running 'cabal test' from the lab5 directory.
--}


third_last :: [a] -> a
third_last [x,_,_] = x
third_last (_:y:z:xt) = third_last (y:z:xt)


every_other :: [a] -> [a]
every_other [] = []
every_other [x] = [x]
every_other (a:_:xt) = a:every_other xt


is_cyclops :: Int -> Bool
is_cyclops n
    | length strNum == 1 && head strNum == '0' = True
    | length strNum < 3 || even (length strNum) = False -- if number is less than 3 or is even
    | length (filter (=='0') strNum) > 1 || not (any (=='0') strNum) = False -- if no 0's are present or too many 0's
    | otherwise = True
    where
        strNum = show n

domino_cycle :: [(Int, Int)] -> Bool
domino_cycle tiles =
    if length tiles == 1 then
        fst (head tiles) == snd (head tiles)
    else
        let (first, sec) = head tiles
            starting = fst (head tiles)
            ending = snd (last tiles)
        in if length tiles > 2 then
            starting == ending && snd (head tiles) == fst (head (drop 1 tiles)) && domino_cycle2 (drop 1 tiles)
           else starting == ending && snd (head tiles) == fst (head (drop 1 tiles))

domino_cycle2 :: [(Int, Int)] -> Bool
domino_cycle2 tiles =
    if length tiles > 2 then
        fst (head tiles) == snd (head (drop 1 tiles)) && domino_cycle2 (drop 1 tiles)
        else snd (head tiles) == fst (head (drop 1 tiles))

tukeys_ninther :: (Ord a, Num a) => [a] -> a
tukeys_ninther (_:b:_:xt) = b
tukeys_ninther (_:b:_) = b
tukeys_ninther [a] = a