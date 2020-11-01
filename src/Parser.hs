module Parser (parseExpr) where

import Syntax
import Text.ParserCombinators.Parsec

import Numeral

type LambdaParser = GenParser Char () LExpr

-- toChurchNumeral :: Int -> [Char]
-- toChurchNumeral n = "(\\sz." ++ toChurchNumeralHelper n ++ ")"

-- toChurchNumeralHelper :: Int -> String
-- toChurchNumeralHelper 0 = "z"
-- toChurchNumeralHelper n = "s(" ++ toChurchNumeralHelper (n-1) ++ ")"

varName :: GenParser Char () Name
varName = letter

arguments :: GenParser Char () [Name]
arguments = many1 varName

variable :: LambdaParser
variable = do
              variable <- varName
              return (Var variable)

abstraction :: LambdaParser
abstraction = do
                 char '\\' <|> char 'λ'
                 args <- arguments
                 char '.'
                 body <- lambdaExpr
                 return $ foldr Abs body args

brackets :: LambdaParser
brackets = between (char '(') (char ')') lambdaExpr

lambdaTerm :: LambdaParser
lambdaTerm =    brackets
            <|> abstraction
            <|> variable

lambdaExpr :: LambdaParser
lambdaExpr  = do
                  terms <- many1 lambdaTerm
                  return $ foldl1 App terms

parseExpr :: String -> Either ParseError LExpr
parseExpr s = 
    if head s `elem` ['0'..'9']
        then let operation = newToChurchNumeral s ""
             in parse lambdaExpr "" operation
    else parse lambdaExpr "" s
