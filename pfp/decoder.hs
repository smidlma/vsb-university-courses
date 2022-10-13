-- DU 4 homework 1 FPR
type Result = [String]

pp :: Result -> IO ()
pp x = putStr (concat (map (++ "\n") x))

-- replace' str voc = map str
-- replace' c voc
--   | isReplacable c voc = 'a'
--   | otherwise = c

-- isReplacable c voc = filter (\(key, value) -> key == c) voc

findInVoc c voc = map (\(key, value) -> head value) (filter (\(key, value) -> key == c) voc)

replace' _ _ [] = []
replace' c val (x : xs)
  | c == x = val ++ replace' c val xs
  | otherwise = x : replace' c val xs

mapValues xs voc = [(findInVoc x voc) | x <- xs]

test' xs = [x | x <- xs, x == 'A']

-- replace' xs voc =
-- replace' c voc = c

-- splitCode str = [[x] | x <- str]

-- decode hash vocabulary = [isReplacable x vocabulary | x <- hash]

-- decode :: String -> [(Char, String)] -> String
-- decode "HAHA" [('E',"AB"),('F',"CD"),('G',"EF"),('H',"GG")]
-- HAHA
-- GGAHA
-- EFGAHA
-- ABFGAHA
-- ABCDGAHA
-- "ABCDABCDAABCDABCDA"
-- 1. check first char against vocabulary
-- 2. if find letter from voc take start of code insert
