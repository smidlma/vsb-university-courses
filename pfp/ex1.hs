{-# HLINT ignore "Use foldr" #-}
{-# OPTIONS_GHC -Wno-incomplete-patterns #-}
{-# HLINT ignore "Use foldr" #-}
{-# OPTIONS_GHC -Wno-incomplete-patterns #-}
{-# HLINT ignore "Use foldr" #-}
{-# OPTIONS_GHC -Wno-incomplete-patterns #-}
{-# HLINT ignore "Use foldr" #-}
{-# OPTIONS_GHC -Wno-incomplete-patterns #-}
{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}

import Data.Char (isLower, ord, toLower, toUpper)
import Distribution.Compat.Semigroup (Last' (getLast'))

plus x y = x + y

factorial 0 = 1
factorial n = n * factorial (n - 1)

fib :: Int -> Int
fib 0 = 1
fib 1 = 1
fib n = fib (n - 1) + fib (n - 2)

fib2 n = cyklus n (1, 1)
  where
    cyklus 0 (x, y) = x
    cyklus n (x, y) = cyklus (n -1) (y, x + y)

isPrime :: Int -> Bool
isPrime x
  | x > 1 = help 2
  | otherwise = False
  where
    help i
      | i == truncate (sqrt (fromIntegral x)) = True
      | x `mod` i == 0 = False
      | otherwise = help (i + 1)

secti [] = 0
secti (x : xs) = x + secti xs

-- [x] == (x:[])
getLast :: [p] -> p
getLast [x] = x
getLast (_ : xs) = getLast xs

isElement :: Eq t => t -> [t] -> Bool
isElement n [] = False
isElement n (x : xs)
  | n == x = True
  | otherwise = isElement n xs

getInit [x] = []
getInit (x : xs) = x : getInit xs

-- DU fp3 => combine
combine :: [a] -> [a] -> [a]
combine [] ys = ys
combine (x : xs) ys = x : combine xs ys

max' [x] = x
max' (x : xs)
  | x > max' xs = x
  | otherwise = max' xs

reverse' [] = []
reverse' [x] = [x]
reverse' xs = getLast xs : reverse' (getInit xs)

reverse'' xs = tmp xs []
  where
    tmp [] ys = ys
    tmp (x : xs) ys = tmp xs (x : ys)

take' 0 _ = []
take' n [] = []
take' n (x : xs) = x : take' (n -1) xs

oddList :: Int -> Int -> [Int]
oddList a b = [x | x <- [a .. b], odd x]

quicksort :: (Ord a) => [a] -> [a]
quicksort [] = []
quicksort [x] = [x]
quicksort (x : xs) =
  let left = filter (< x) xs
      right = filter (>= x) xs
   in quicksort left ++ [x] ++ quicksort right

uni [] = []
uni (x : xs) = x : uni (filter (/= x) xs)

count x xs = length (filter (== x) xs)

countThem xs = zip (uni xs) [count x xs | x <- uni xs]

type Pic = [String]

pp :: Pic -> IO ()
pp x = putStr (concat (map (++ "\n") x))

pic :: Pic
pic =
  [ "....#....",
    "...###...",
    "..#.#.#..",
    ".#..#..#.",
    "....#....",
    "....#....",
    "....#####"
  ]

flipV = map reverse

flipH = reverse

above p1 p2 = p1 ++ p2

sideBySide p1 [] = p1
sideBySide p1 p2 = zipWith (++) p1 p2

toCol xs = [[x] | x <- reverse xs]

rotateL [] = []
rotateL (x : xs) = sideBySide (toCol x) (rotateL xs)

data Expr
  = Num Int
  | Add Expr Expr
  | Sub Expr Expr
  | Mul Expr Expr
  | Div Expr Expr
  | Var Char
  deriving (Eq)

instance Show Expr where
  show = showExpr

eval :: Expr -> Int
eval (Num a) = a
eval (Add a b) = eval a + eval b
eval (Sub a b) = eval a - eval b
eval (Mul a b) = eval a * eval b
eval (Div a b) = eval a `div` eval b
eval (Var a) = ord a

showExpr :: Expr -> String
showExpr (Num a) = show a
showExpr (Var a) = [a]
showExpr (Add l r) = "(" ++ showExpr l ++ "+" ++ showExpr r ++ ")"
showExpr (Sub l r) = "(" ++ showExpr l ++ "-" ++ showExpr r ++ ")"
showExpr (Mul l r) = "(" ++ showExpr l ++ "*" ++ showExpr r ++ ")"
showExpr (Div l r) = "(" ++ showExpr l ++ "%" ++ showExpr r ++ ")"

deriv :: Expr -> Char -> Expr
deriv (Num a) x = Num 0
deriv (Var a) x
  | x == a = Num 1
  | otherwise = Num 0
deriv (Add a b) x = Add (deriv a x) (deriv b x)
deriv (Mul a b) x = Mul (deriv a x) (deriv a x)