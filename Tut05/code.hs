
data LambdaTerm t = Var t | App (LambdaTerm t) (LambdaTerm t) | Abs t (LambdaTerm t)

isRedex (App (Abs varName expr1) expr2) = True
isRedex _ = False
