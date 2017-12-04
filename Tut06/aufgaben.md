## Tools
* https://hediet.github.io/LambdaCalculus2/dist/
* https://srtobi.github.io/lambda/docs/

## Y Kombinator

```
Y := \f . (\x . f (x x))(\x . f (x x))

Zu zeigen: fun => X <= funF fun
    für fun = Y funF
```

## Aufgabe 1: Zeige: Theta F ⇒ F (Theta F)

```
Theta := (\x . \y . y (x x y)) (\x . \y . y (x x y))


```


## Aufgabe 2
### 1: fib

```hs
fib :: Integer -> Integer
fib 0 = 1
fib 1 = 1
fib n = fib (n - 1) + fib (n - 2)
```

```

```

## 2: foo

```hs
foo :: Integer -> Integer
foo n
    | n <= 100 = foo (foo (n + 11))
    | otherwise = n - 10
```

```

```

### 3: Typen in Haskell implementieren

