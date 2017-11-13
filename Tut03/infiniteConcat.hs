
infConcat :: [[a]] -> [a]
infConcat = concatHeads 1
    where
        {-
            Concatenizes the first n heads from the given lists
            to the first n+1 heads from the updated lists (where the first n heads have been removed) and so on. 
        -}
        concatHeads n lists 
            | null lists = []
            | otherwise = heads ++ concatHeads (n+1) lists'
            where (heads, lists') = popNHeads n lists

        {-
            Removes heads from the first n given lists. The first item of the result tuple contains the removed heads, the second the updated lists.
            Example:
            popNHeads 3 [[1..], [1..], [1..], [1..]] ++ error "not evaluated" returns  
                ( [1, 1, 1],  [[2..], [2..], [2..], [1..]] ++ error "not evaluated".] )
        -}
        popNHeads :: Integer -> [[a]] -> ([a], [[a]])
        popNHeads 0 (lists) = ([], lists)
        popNHeads n ((h:list):lists) = (h:heads, list:lists')
            where (heads, lists') = popNHeads (n-1) lists
        popNHeads n ([]:lists) = popNHeads (n-1) lists
        popNHeads n [] = ([], [])

_N :: [Integer]
_N = [1..]

_N0 :: [Integer]
_N0 = 0:_N 

_Z :: [Integer]
_Z = infConcat [ [ x * y | y <- _N0] | x <- [1, -1] ]

tuplesOver base1 base2 = infConcat [ [(x, y) | y <- base2] | x <- base1 ]
q = [ toRational x / toRational y | (x, y) <- tuplesOver _Z _N ]

finitListsOfLengthOver :: [a] -> Integer -> [[a]]
finitListsOfLengthOver base 0 = [[]]
finitListsOfLengthOver base n = infConcat [ [ x:list | list <- finitListsOfLengthOver base (n-1) ] | x <- base ]

allListsOver base = infConcat [ finitListsOfLengthOver base length | length <- [0..] ]
allNatNumberLists = allListsOver _N

hamming = infConcat [ infConcat [ [ 2^i * 3^j * 5^k | k <- [0..] ] | j <- [0..] ] | i <- [0..] ]
