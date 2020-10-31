module Numeral where

import Data.List.Split ( splitOn )

toChurchNumeral :: [Char] -> [Char]
toChurchNumeral s 
    | '*' `elem` s = multToChurchNumeral s    
    | '+' `elem` s = sumToChurchNumeral s
    | otherwise = intToChurchNumeral (toInt s)

sumToChurchNumeral :: [Char] -> [Char]
sumToChurchNumeral s = 
    let data_split = map toInt $ splitOn "+" s
    in intToChurchNumeral (data_split !! 0) ++ "(\\wyx.y(wyx))" ++ intToChurchNumeral (data_split !! 1)

multToChurchNumeral :: [Char] -> [Char]
multToChurchNumeral s = 
    let data_split = map toInt $ splitOn "*" s
    in "(\\xyz.x(yz))" ++ intToChurchNumeral (data_split !! 0) ++ intToChurchNumeral (data_split !! 1)

toInt :: [Char] -> Int
toInt s = read s :: Int

intToChurchNumeral :: Int -> [Char]
intToChurchNumeral n = "(\\sz." ++ intToChurchNumeralHelper n ++ ")"

intToChurchNumeralHelper :: Int -> String
intToChurchNumeralHelper 0 = "z"
intToChurchNumeralHelper n = "s(" ++ intToChurchNumeralHelper (n-1) ++ ")"
