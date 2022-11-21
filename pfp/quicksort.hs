import Control.Monad
import Data.Array
import Data.Array.ST
import Data.Foldable (foldlM)

bubbleSort :: Array Int Int -> Array Int Int
bubbleSort myArray = runSTArray $ do
  stArray <- thaw myArray
  let end = (snd . bounds) myArray
  forM_ [1 .. end] $ \i -> do
    forM_ [0 .. (end - i)] $ \j -> do
      val <- readArray stArray j
      nextVal <- readArray stArray (j + 1)
      let outOfOrder = val > nextVal
      when outOfOrder $ do
        writeArray stArray j nextVal
        writeArray stArray (j + 1) val
  return stArray

quickSort :: Array Int Int -> Array Int Int
quickSort myArray = runSTArray $ do
  stArray <- thaw myArray
  let (minIndex, maxIndex) = bounds myArray
  quicksortHelper minIndex maxIndex stArray
  return stArray

quicksortHelper low high stArr = when (low < high) $ do
  pivotIndex <- partitionHelp stArr low high high
  quicksortHelper low (pivotIndex - 1) stArr
  quicksortHelper (pivotIndex + 1) high stArr

partitionHelp arr left right pivotIndex = do
  pivotValue <- readArray arr pivotIndex
  storeIndex <-
    foreachWith
      [left .. right -1]
      left
      ( \i storeIndex -> do
          val <- readArray arr i
          if val <= pivotValue
            then do
              swap arr i storeIndex
              return (storeIndex + 1)
            else do
              return storeIndex
      )
  swap arr storeIndex right
  return storeIndex

swap arr left right = do
  leftVal <- readArray arr left
  rightVal <- readArray arr right
  writeArray arr left rightVal
  writeArray arr right leftVal

foreachWith xs v f = foldlM (flip f) v xs

-- elems $ quickSort $  listArray (0,5) [8,4,9,6,7,1]
