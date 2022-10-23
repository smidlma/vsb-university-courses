data Suit = Hearts | Clubs | Diamonds | Spades deriving (Eq, Show)

data Rank = Numeric Int | Jack | Queen | King | Ace deriving (Eq, Show)

data Card = Card Rank Suit deriving (Eq, Show)

type Hand = [Card]

data Category
  = RoyalFlush
  | StraightFlush
  | Four
  | FullHouse
  | Flush
  | Straight
  | Three
  | TwoPair
  | Pair
  | HighCard
  deriving (Eq, Show) --

cardOrder = [Ace, Numeric 2, Numeric 3, Numeric 4, Numeric 5, Numeric 6, Numeric 7, Numeric 8, Numeric 9, Numeric 10, Jack, Queen, King]

getSuit :: Card -> Suit
getSuit (Card _ s) = s

getRank :: Card -> Rank
getRank (Card r _) = r

sameRankCountInHand :: Hand -> Rank -> Int
sameRankCountInHand h r = length (filter (\item -> getRank item == r) h)

isSameRankCountInHand :: Hand -> Int -> Bool
isSameRankCountInHand h c = any (\item -> sameRankCountInHand h (getRank item) == c) h

getRankCount :: Hand -> Rank -> Int
getRankCount h r = length (filter (\item -> getRank item == r) h)

getTuplets :: Hand -> Int -> [Card]
getTuplets h n = filter (\item -> getRankCount h (getRank item) == n) h

allSuitsSame :: Hand -> Bool
allSuitsSame x = all (\item -> getSuit item == getSuit (head x)) x

isRankInHand :: Hand -> Rank -> Bool
isRankInHand x y = any (\item -> getRank item == y) x

getRanks :: Hand -> [Rank]
getRanks = map (\item -> getRank (item))

getOrderedRanks :: Hand -> [Rank]
getOrderedRanks h = filter (\item -> item `elem` getRanks h) cardOrder

isStraight :: Hand -> Bool
isStraight h = (drop 0 . take 5 $ cardOrder) == getOrderedRanks h || (drop 1 . take 6 $ cardOrder) == getOrderedRanks h || (drop 2 . take 7 $ cardOrder) == getOrderedRanks h || (drop 3 . take 8 $ cardOrder) == getOrderedRanks h || (drop 4 . take 9 $ cardOrder) == getOrderedRanks h || (drop 5 . take 10 $ cardOrder) == getOrderedRanks h || (drop 6 . take 11 $ cardOrder) == getOrderedRanks h || (drop 7 . take 12 $ cardOrder) == getOrderedRanks h || (drop 8 . take 13 $ cardOrder) == getOrderedRanks h

decide :: Hand -> Category
decide x
  | allSuitsSame x
      && isRankInHand x (Numeric 10)
      && isRankInHand x King
      && isRankInHand x Queen
      && isRankInHand x Jack
      && isRankInHand x Ace =
    RoyalFlush
  | allSuitsSame x && isStraight x =
    StraightFlush
  | allSuitsSame x =
    Flush
  | isStraight x =
    Straight
  | isSameRankCountInHand x 4 =
    Four
  | length (getTuplets x 2) == 2
      && length (getTuplets x 3) == 3 =
    FullHouse
  | isSameRankCountInHand x 3 = Three
  | length (getTuplets x 2) == 4 =
    TwoPair
  | isSameRankCountInHand x 2 =
    Pair
  | otherwise = HighCard

-- Prelude> decide [Card (Numeric 2) Hearts,Card (Numeric 2) Clubs,Card Ace Hearts,Card Ace Clubs,Card King Spades]
-- TwoPair
-- Prelude> decide [Card (Numeric 2) Hearts,Card (Numeric 2) Clubs,Card Ace Hearts,Card Ace Clubs,Card Ace Spades]
-- FullHouse
-- Prelude> decide [Card Ace Hearts,Card (Numeric 2) Hearts,Card (Numeric 5) Hearts,Card (Numeric 3) Hearts,Card (Numeric 4) Clubs]
-- Straight
-- Prelude> decide [Card (Numeric 2) Hearts,Card (Numeric 5) Clubs,Card Ace Hearts,Card King Clubs,Card Jack Spades]
-- HighCard
