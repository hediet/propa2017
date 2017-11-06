import Data.List (sortBy)

type Polynom = [Double]

-- Aufgabe 2.1
add :: Polynom -> Polynom -> Polynom
add p1 [] = p1
add [] p2 = p2
add (x:p1) (y:p2) = (x+y) : add p1 p2

-- Aufgabe 2.2
eval :: Polynom -> Double -> Double
eval p x = foldr (\a -> (a+) . (x*)) 0 p

-- Aufgabe 2.3
deriv :: Polynom -> Polynom
deriv p = zipWith (*) [1..] $ tail p

-- Aufgabe 3.1
-- Sind in list mindestens n Elemente größer gleich n?
atLeastElements :: [Int] -> Int -> Bool
atLeastElements list n = length (filter (>= n) list) >= n

-- Aufgabe 3.2
-- Berechnet hIndex die größte Zahl n für (list, atLeastElements)?
hIndexCorrect :: ([Int] -> Int) -> [Int] -> Bool
hIndexCorrect hIndex list = atLeastElements list h && not (atLeastElements list $ h + 1)
    where h = hIndex list

-- Aufgabe 3.3
-- Finde die größte Zahl n, sodass mindestens n Elemente in l größer als n sind.
hIndex :: [Int] -> Int
hIndex l = length $ takeWhile (uncurry (<=)) $ zip [1..] $ sortBy (flip compare) l 


-- Zusatzaufgabe 1.1
-- splitWhen even [1,2,3] => ([1], [2, 3])
splitWhen :: (a -> Bool) -> [a] -> ([a],[a])
splitWhen f xs = (take n xs, drop n xs)
    where
        -- Anzahl der ersten Elemente, die f nicht erfüllen
        n = length $ takeWhile (not . f) xs

-- Zusatzaufgabe 1.2
-- group [1,1,2,2,1,1,3] => [[1, 1], [2, 2], [1, 1], [3]]
group :: Eq a => [a] -> [[a]]
group list = reverse $ groupReversed [] list
    where
        groupReversed :: Eq a => [[a]] -> [a] -> [[a]]
        groupReversed acc [] = acc
        groupReversed []           (x:xs) = groupReversed [[x]] xs
        groupReversed ((h:hs):acc) (x:xs) 
            | x == h    = groupReversed (  (x:h:hs):acc) xs
            | otherwise = groupReversed ([x]:(h:hs):acc) xs


-- Zusatzaufgabe 1.3
-- encode [1, 1, 2, 2, 2] => [(1, 2), (2, 3)]
encode :: Eq a => [a] -> [(a,Int)]
encode xs = zip (map head grouped) (map length grouped)
    where grouped = group xs

-- Zusatzaufgabe 1.4
decode :: [(a,Int)] -> [a]
decode xs = foldl (\l (x,y) -> l ++ (replicate y x)) [] xs
