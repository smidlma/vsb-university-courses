{-# HLINT ignore "Use foldr" #-}
{-# OPTIONS_GHC -Wno-incomplete-patterns #-}
{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}

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