
-- f muss monoton wachsend sein.
-- Es wird nach der größten Zahl x aus [lowerBound, upperBound] gesucht, sodass f x <= y
invert :: (Integer -> Integer) -> Integer -> Integer -> Integer-> Integer
invert f lowerBound upperBound y
    | lowerBound > upperBound = error "Interval is empty"
    | lowerBound == upperBound = if f lowerBound <= y then lowerBound else error "Interval too small"
    | f mid <= y = invert f mid upperBound y
    | f mid > y = invert f lowerBound (mid-1) y
        -- Annahme lowerBound < mid <= upperBound wenn lowerBound != upperBound 
        where mid = (1 + lowerBound + upperBound) `div` 2

root x = invert (^2) 1 x x


insert :: [Int] -> Int -> [Int]
insert (x:xs) e 
    | e < x = e:x:xs
    | otherwise = x:insert xs e

insertSort :: [Int] -> [Int]
insertSort = foldl insert []
