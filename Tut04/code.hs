
data Exp t = Var t | Int Integer | Sum (Exp t) (Exp t)
    | Less (Exp t) (Exp t) | And (Exp t) (Exp t) | Not (Exp t) | If (Exp t) (Exp t) (Exp t)

type Env t = t -> Integer

eval :: Env t -> Exp t -> Integer
eval env (Var t) = env t
eval env (Int i) = i
eval env (Sum expr1 expr2) = eval env expr1 + eval env expr2

eval env (Less expr1 expr2) = boolToNum $ eval env expr1 < eval env expr2
-- und so weiter

boolToNum False = 0
boolToNum True = 1

instance Show t => Show (Exp t) where
    show (Var t) = show t
    show (Int i) = show i
    show (Sum expr1 expr2) = show expr1 ++ "+" ++ show expr2


data Tree a = Leaf | Node (Tree a) a (Tree a) deriving (Show)

deleteMin :: Tree a -> (a, Tree a)
deleteMin Leaf = error "Empty Tree"
deleteMin (Node Leaf val right) = (val, right)
deleteMin (Node left val right) = (minLeft, Node leftWithoutMin val right)
    where (minLeft, leftWithoutMin) = deleteMin left

merge :: Tree a -> Tree a -> Tree a
merge left Leaf = left
merge left right = Node left minRight right'
    where (minRight, right') = deleteMin right

merge' :: Tree a -> Tree a -> Tree a
merge' Leaf right = right
merge' (Node leftChild value Leaf) right = Node leftChild value right
merge' (Node leftChild value rightChild) right = Node leftChild value (merge' rightChild right)

partition :: (a -> Bool) -> Tree a -> (Tree a, Tree a)
partition p (Node left val right) =
    if p val
        then (Node lTrue val rTrue, merge lFalse rFalse)
        else (merge lTrue rTrue, Node lFalse val lTrue)
    where
          (lTrue, lFalse) = partition p left
          (rTrue, rFalse) = partition p right

allTrees :: Int -> t -> [Tree t]
allTrees 0 value = [ Leaf ]
allTrees nodeCount value = [ Node left value right |
    n <- [0..nodeCount - 1], left <- allTrees n value, right <- allTrees (nodeCount - 1 - n) value ]

-- trees_4_13 = [ tree | tree <- allTrees 13 0, height tree = 4 ]

-- S (Maybe r) (Map Char (State r))
data State r = S { value :: Maybe r, transitions :: Map Char (State r) }
type Map k v = [(k,v)]

accepts :: String -> State r -> Maybe r
accepts "" (S val transitions) = val
accepts (c:cs) (S _ transitions) = bind (lookup c transitions) (accepts cs)
    where 
        bind :: Maybe (State r) -> (State r -> Maybe r) -> Maybe r
        bind Nothing f = Nothing
        bind (Just x) f = f x


data NumberSystem = Zero | Bin | Dec | Oct
{- to be completed
    automata :: State NumberSystem
    automata = s where
        s = S Nothing ( [(d, s10) | d <- ['1'..'9' ]] ++ [('0',s0)] )
        s0 = 
        s8 =
        s2 =
        s10 =
-}




-- Monaden


-- Kann nicht wirklich was laden, aber hier egal
tryLoadSomeData :: Maybe [String]
tryLoadSomeData = Just ["1"]

tryGetHead :: [a] -> Maybe a
tryGetHead [] = Nothing
tryGetHead (x:xs) = Just x

tryParseInt :: String -> Maybe Int
tryParseInt str = Just 1


program =
            case tryLoadSomeData of
                Nothing -> Nothing
                Just dat ->
                    case tryGetHead dat of
                        Nothing -> Nothing
                        Just val ->
                            case tryParseInt val of
                                Nothing -> Nothing
                                Just val -> Just val

program' =
            tryLoadSomeData >>= \dat ->
            tryGetHead dat >>= \head ->
            tryParseInt head


program'' = do 
            dat <- tryLoadSomeData
            head <- tryGetHead dat
            tryParseInt head

type FileSystem = [(String, String)]
data FileSystemT result = FileSystemT (FileSystem -> (result, FileSystem))

unwrapFST :: FileSystem -> FileSystemT result -> result
unwrapFST fs (FileSystemT f) = fst $ f fs


staticResultT :: result -> FileSystemT result
staticResultT result = FileSystemT $ \d -> (result, d)

loadFile :: String -> FileSystemT (Maybe String)
loadFile key = FileSystemT loadFile'
    where
        loadFile' [] = (Nothing, [])
        loadFile' ((k,v):hs)
            | key == k = (Just v, (k,v):hs)
            | otherwise = (result, (k,v):updatedDict)
                where (result, updatedDict) = loadFile' hs

updateFile :: String -> String -> FileSystemT {- Old Value: -} (Maybe String)
updateFile key val = FileSystemT updateFile'
    where
        updateFile' [] = (Nothing, [(key, val)])
        updateFile' ((k,v):hs)
            | key == k = (Just v, (k,val):hs)
            | otherwise = (result, (k,v):updatedDict)
                where (result, updatedDict) = updateFile' hs


program3 =
        unwrapFST [] $
            updateFile "file1" "foo" >>= \_ ->
            updateFile "file1" "bar" >>= \_ ->
            loadFile "file1" >>= \result ->
            case result of
                Nothing -> staticResultT $ error "something bad happened"
                Just content -> staticResultT content

instance Functor FileSystemT where
    fmap f (FileSystemT f2) = FileSystemT $ \s -> let (a, s') = f2 s in (f a, s')


instance Applicative FileSystemT where
  pure = staticResultT
  (<*>) f1 f2 = FileSystemT f
        where
            FileSystemT f1' = f1
            FileSystemT f2' = f2
            unwrap (FileSystemT x) = x
            f s = (abResult aResult, s'')
                where
                    (aResult, s') = f2' s
                    (abResult, s'') = f1' s'

instance Monad FileSystemT where
    (>>=) (FileSystemT t1) aToT2 = FileSystemT $ \fs -> 
        let 
            (aResult, stateAfterA) = t1 fs
            FileSystemT t2 = aToT2 aResult
        in 
            t2 stateAfterA

    return = staticResultT


program4 =
        unwrapFST [] $
            do  updateFile "file1" "foo"
                updateFile "file1" "bar"
                result <- loadFile "file1"
                case result of
                    Nothing -> return $ error "something bad happened"
                    Just content -> return content



main = putStrLn "Hello, what is your name?" >>= \x ->
       getLine >>= \name ->
       putStrLn ("Hello " ++ name ++ "!") >>= \x ->
       main

