import Data.List (sortBy, find)

type Field = [[Value]]
type Value = Int

mys :: Field
mys = 
   [[1, 0, 5, 0, 0, 0, 3, 7, 0],
    [0, 0, 0, 0, 0, 0, 2, 0, 0],
    [0, 9, 7, 3, 0, 0, 0, 1, 0],
    [0, 0, 0, 0, 5, 3, 1, 0, 2],
    [3, 0, 0, 8, 0, 1, 0, 0, 4],
    [2, 0, 1, 4, 7, 0, 0, 0, 0],
    [0, 7, 0, 0, 0, 8, 6, 4, 0],
    [0, 0, 8, 0, 0, 0, 0, 0, 0],
    [0, 1, 2, 0, 0, 0, 8, 0, 7]]

printF' f = putStr $ printF f

printF :: Field -> String
printF f = concatMap printRow f
    where printRow row = concatMap (\v -> show v ++ " ") row ++ "\n" 

setValueAt :: Field -> Int -> Int -> Value -> Field
setValueAt f x y newValue = replaceNth y (replaceNth x newValue (f !! y)) f 
    where
        replaceNth n newVal (x:xs)
            | n == 0 = newVal:xs
            | otherwise = x:replaceNth (n-1) newVal xs

getPossibleValuesAt :: Field -> Int -> Int -> [Value]
getPossibleValuesAt f x y
    | (f !! y) !! x /= 0 = []
    | otherwise = filter (not . (flip elem) blockedValuesAt) [1..9]
    where 
        blockedValuesAt = blockedByRow ++ blockedByColumn ++ blockedByBlock
        blockedByRow = filter (/=0)  (f !! y) 
        blockedByColumn = filter (/=0) [(f !! idx) !! x | idx <- [0..8]]
        blockedByBlock = filter (/=0) [(f !! (m3 y + dy)) !! (m3 x + dx) | dy <- [0..2], dx <- [0..2]]
        m3 n = (n `div` 3) * 3 

moves f = sortBy countOfPossibleValuesAsc $ filter moveHasPossibleValues allMoves
    where
        allMoves = [(x, y, getPossibleValuesAt f x y) | x <- [0..8], y <- [0..8]]
        moveHasPossibleValues (_, _, p)  = length p > 0
        countOfPossibleValuesAsc (_, _, p1) (_, _, p2) = compare (length p1) (length p2)

-- gibt [] zurück, wenn f unlösbar ist
solve :: Field -> Field
solve f
    | all (\row -> all (/=0) row) f = f
    | null possibleMoves = []
    | otherwise = head $ [ solution | 
                newValue <- possibleValues, 
                let solution = solve $ setValueAt f x y newValue, 
                not $ null solution ] ++ [[]]
    where 
        possibleMoves = moves f
        (x, y, possibleValues) = head possibleMoves
