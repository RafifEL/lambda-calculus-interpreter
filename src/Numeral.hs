module Numeral where

import Data.Char(digitToInt)

toChurchNumeral :: [Char] -> [Char]
toChurchNumeral = (flip helperToChurchNumeral) ""

helperToChurchNumeral :: [Char] -> [Char] -> [Char]
helperToChurchNumeral s acc
    | s == "" = acc
    | head s == '+' =
        let newAcc = acc ++ "(\\wyx.y(wyx))"
        in helperToChurchNumeral (tail s) newAcc
    | head s == '*' =
        let newAcc = "(\\xyz.x(yz))(" ++ acc ++ ")"
        in helperToChurchNumeral (tail s) newAcc
    | otherwise =
        let number = intToChurchNumeral (digitToInt (head s))
            newAcc = acc ++ number
        in helperToChurchNumeral (tail s) newAcc

intToChurchNumeral :: Int -> [Char]
intToChurchNumeral n = "(\\sz." ++ intToChurchNumeralHelper n ++ ")"

intToChurchNumeralHelper :: Int -> String
intToChurchNumeralHelper 0 = "z"
intToChurchNumeralHelper n = "s(" ++ intToChurchNumeralHelper (n-1) ++ ")"
