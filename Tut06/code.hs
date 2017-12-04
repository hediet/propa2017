
import Data.Map.Strict (Map, elems, insert)

type VarName = String

data Term =
    Const { constValue :: String } {- 0, 1, true, false -} |
    Var { varName :: VarName } {- x, y, z -} |
    App { appFunc :: Term, appArg :: Term } {- func arg -} |
    Abs { boundVarName :: VarName, absTerm :: Term } {- λ boundVarName . absTerm -} |
    Let { letBoundVarName :: VarName, letAbsTerm :: Term, letBody :: Term }

type TypeVarName = String

data Type =
    ConstType String {- Int, Bool -} |
    TypeVar TypeVarName {- α, β -} |
    FuncType { argType :: Type, funcType :: Type } {- type1 -> type2 -} |
    TypeScheme { boundTypeVarName :: TypeVarName, generalizedType :: Type } 
        {- ∀ boundTypeVarName: generalizedType -}


data TypeSystem = TypeSystem { tsTypeOfFreeVars :: Map VarName Type }

tsFreeTypeVars :: TypeSystem -> [TypeVarName]
tsFreeTypeVars (TypeSystem tsFreeVars) = concatMap (\v -> freeTypeVars v) (elems tsFreeVars)

tsWith :: VarName -> Type -> TypeSystem -> TypeSystem
tsWith varName t (TypeSystem map) = TypeSystem (insert varName t map) 

tBool = ConstType "bool"
tInt = ConstType "int"


typeOfConst :: String -> Type
typeOfConst "true" = tBool
typeOfConst "false" = tBool
typeOfConst "0" = tInt
typeOfConst "1" = tInt
{- ... -}


freeVars :: Term -> [VarName]
freeVars (Var varName) = [varName]
freeVars (App func arg) = freeVars func ++ freeVars arg
freeVars (Abs varName term) = filter (/= varName) $ freeVars term
freeVars (Const _) = []

freeTypeVars :: Type -> [TypeVarName]
freeTypeVars (TypeVar varName) = [varName]
freeTypeVars (FuncType argType funcType) = freeTypeVars argType ++ freeTypeVars funcType
freeTypeVars (TypeScheme varName gtype) = filter (/= varName) $ freeTypeVars gtype
freeTypeVars (ConstType _) = []

{- insertType (α) (bool) (α->int->α) = (bool->int->bool) -}
insertType :: TypeVarName -> Type -> Type -> Type
insertType = error "not implemented"

{- ta((α->int->α->β), { x: β }) = ∀α:(α->int->α->β)  -}
ta :: TypeSystem -> Type -> Type
ta gamma mtype = foldl (\t varName -> TypeScheme varName t) mtype varsToBind
    where 
        fv_gamma = tsFreeTypeVars gamma
        fv_mtype = freeTypeVars mtype
        varsToBind = filter (\x -> not (x `elem` fv_gamma)) fv_mtype

-- a `isTypeInstantiationOf` b <=> b ≽ a
-- Allquantoren in b werden durch konkrete Werte aufgelöst, sodass a entsteht.
-- Wenn dies geht, gebe true zurück, ansonsten false.
isTypeInstantiationOf :: Type -> Type -> bool
isTypeInstantiationOf = error "not implemented"


{-

CONST: {}
=========>
Γ ⊢ (Const val): typeOfConst val


VAR: { Γ(x) = σ,     τ `isTypeInstantiationOf` σ }
=========>
Γ ⊢ (Var x): τ


APP: { Γ ⊢ func: (FuncType τ2 τ),     Γ ⊢ arg: τ2 } 
=========>
Γ ⊢ (App func arg): τ


ABS: { (tsWith x τ1) Γ ⊢ term: τ2,    not (containsTypeScheme τ1) }
=========>
Γ ⊢ (Abs x term): (FuncType τ1 τ2)


LET: { Γ ⊢ t1: τ1,    (tsWith x (ta Γ τ1)) Γ ⊢ t2: τ2 }
=========>
Γ ⊢ (Let x t1 t2): τ2

-}


