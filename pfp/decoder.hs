-- DU 4 homework 1 FPR
findEncoded :: Char -> [(Char, String)] -> [String]
findEncoded c voc = map (\(key, value) -> value) (filter (\(key, value) -> key == c) voc)

repl :: Char -> [(Char, String)] -> [Char]
repl c voc =
  let tmp = findEncoded c voc
   in if null tmp then [c] else head tmp

fromEncode :: [Char] -> [(Char, String)] -> [[Char]]
fromEncode str voc = map (\x -> repl x voc) str

-- decode "HAHA" [('E',"AB"),('F',"CD"),('G',"EF"),('H',"GG")]
decode :: String -> [(Char, String)] -> String
decode str voc =
  let tmp = foldl (++) [] (fromEncode str voc)
   in if tmp == str then tmp else decode tmp voc
