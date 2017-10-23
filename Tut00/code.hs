module Test where

-- module -> "module" module_identifier "where" declarations
-- declarations -> (declaration ";"?)*


{-
                   | left hand side (lhs) |   |                   right hand side (rhs)              |
                   ------------------------   --------------------------------------------------------
    declaration -> (function_lhs | pattern)   (expression | guarded_expressions) ("where" declarations)?
--}

{-
    function_lhs -> var pattern+
             | pattern varop pattern 
             | (function_lhs) pattern+
-}

blubb arg1 arg2 = 42
x +++ y = 42

{-
    pattern -> var ("@" pattern)?
             | literal
             | _
             | "(" pattern ")"
             | "(" pattern ("," pattern)+ ")"
             | "[" pattern ("," pattern)* "]"
-}

bla arg1@alias = 42
bla 4 = 42
bla _ = 42
bla (4) = 42

baz1 (a, b) = 42
baz2 [a] = 42


{-
    guarded_expressions -> (guards = expression)+

    guards -> "|" guard ("," guard)*

    guard -> expression
           | pat "<-" expression
           | "let" declarations
-}

foo | 10 == 9 = 10
bar myarg | x <- myarg, let localFunc arg = arg, localFunc x == 10 = 42
          | otherwise = 41

{-
    expression -> literal
                | var
                | "(" expression ")"

                | expression expression
                | expression varop expression
                | "-" expression

                | "(" expression ("," expression)+ ")"
                | "[" expression ("," expression)* "]"
                | "[" expression "|" qualifier ("," qualifier)* "]"
                
                | "\" pattern+ "->" expression

                | "let" declarations "in" expression
                | "if" expression ";"? "then" expression ";"? "else" expression
                | "case" expression "of" "{" alternatives "}"
-}

max3_1 x y z = if tmp > x then tmp else x
    where tmp = if y > z then y else z

max3_1' x y z =
    let tmp= if y > z then y else z
    in if tmp > x then tmp else x

max3_2 x y z
    | x >= y && x >= z = x
    | y >= z && y >= x = y
    | otherwise = z
max3_3 x y z = max (max x y) z


sum1 a b | a /= b = a + (sum1 (a+1) b)
        | otherwise = a

{-

    ifIsZero :: Int -> a -> a -> a
    ifIsZero 0 a b = a
    ifIsZero x a b = b

    sum :: Int -> Int -> Int
    sum a b = ifIsZero (b - a) a (a + (sum (a + 1) b))
-}

sum2 = sum2Acc 0
    where
        sum2Acc acc a b | a /= b = acc
                    | otherwise = sum2Acc (acc + a) (a+1) b