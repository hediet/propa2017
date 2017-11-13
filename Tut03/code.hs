import Data.List (maximumBy)
import Data.Ord (comparing)

fib :: [Integer]
fib = 0 : 1 : zipWith (+) fib (tail fib)


collatz :: Int -> [Int]
collatz = iterate a_nPlus1
    where
        a_nPlus1 a_n
            | even a_n = a_n `div` 2
            | otherwise = 3 * a_n + 1

num :: Int -> Int
num a0 = length $ takeWhile (>1) $ collatz a0

maxNum :: Int -> Int -> (Int, Int)
maxNum a b = maximumBy (comparing snd) $ map (\n -> (n, num n)) [a..b]




merge :: Ord t => [t] -> [t] -> [t]
merge [] right = right
merge left [] = left
merge (l:left) (r:right)
    | l <= r = l:merge left (r:right)
    | otherwise = r:merge (l:left) right


primes :: [Integer]
primes = [x | x <- [2..], isPrime x]
    where isPrime x = null [n | n <- [2..x-1], x `mod` n == 0]


primepowers :: Integer -> [Integer]
primepowers 1 = primes
primepowers n = map (^n) primes `merge` primepowers (n - 1)

primepowers' :: Integer -> [Integer]
primepowers' n = foldl merge [] [ [ p^i | p <- primes ] | i <- [1..n] ]
-- wobei [ p^i | p <- primes ] = map (^i) primes


hamming :: [Integer]
hamming = 1 : map (*2) hamming `merge` map (*3) hamming `merge` map (*5) hamming



{-

merge :: Ord t => [t] -> [t] -> [t]
merge [] right = right
merge left [] = left
merge (l:left) (r:right)
    | l <= r = l:merge left (r:right)
    | otherwise = r:merge (l:left) right


merge (map (*2) hamming) (map (*3) hamming)

hamming
=> 1 : merge (map (*2) hamming) (map (*3) hamming)
    map (*2) hamming => map (*2) (1 : drop 1 hamming) => 2 : map (*2) (drop 1 hamming)
    map (*3) hamming => map (*3) (1 : drop 1 hamming) => 3 : map (*3) (drop 1 hamming)
=> 1 : merge 2:(map (*2) drop 1 hamming) 3:(map (*3) drop 1 hamming)
=> 1 : 2 : merge (map (*2) drop 1 hamming) 3:(map (*3) drop 1 hamming)
=> 1 : 2 : merge 4:( map (*2) drop 2 hamming) 3:(map (*3) drop 1 hamming)
=> 1 : 2 : 3 : merge 4:(map (*2) drop 2 hamming) (map (*3) drop 1 hamming)
=> 1 : 2 : 3 : merge 4:(map (*2) drop 2 hamming) 6:(map (*3) drop 2 hamming)
=> 1 : 2 : 3 : 4 : merge (map (*2) drop 2 hamming) 6:(map (*3) drop 2 hamming)
=> 1 : 2 : 3 : 4 : merge 6:(map (*2) drop 3 hamming) 6:(map (*3) drop 2 hamming)
-}



