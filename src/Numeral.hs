module Numeral where

import Data.List.Split ( splitOn )
import Data.Char(digitToInt)

toChurchNumeral :: [Char] -> [Char]
toChurchNumeral s 
    | '*' `elem` s = multToChurchNumeral s    
    | '+' `elem` s = sumToChurchNumeral s
    | otherwise = intToChurchNumeral (toInt s)

newToChurchNumeral :: [Char] -> [Char] -> [Char]
newToChurchNumeral s acc
    | s == "" = acc
    | head s == '+' =
        let newAcc = acc ++ "(\\wyx.y(wyx))"
        in newToChurchNumeral (tail s) newAcc
    | head s == '*' =
        let newAcc = "(\\xyz.x(yz))(" ++ acc ++ ")"
        in newToChurchNumeral (tail s) newAcc
    | otherwise =
        let number = intToChurchNumeral (digitToInt (head s))
            newAcc = acc ++ number
        in newToChurchNumeral (tail s) newAcc

toInt :: [Char] -> Int
toInt s = read s :: Int

intToChurchNumeral :: Int -> [Char]
intToChurchNumeral n = "(\\sz." ++ intToChurchNumeralHelper n ++ ")"

intToChurchNumeralHelper :: Int -> String
intToChurchNumeralHelper 0 = "z"
intToChurchNumeralHelper n = "s(" ++ intToChurchNumeralHelper (n-1) ++ ")"
