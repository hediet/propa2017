
## Y Kombinator

```
Y = \f . (\x . f (x x))(\x . f (x x))


Zu zeigen: fun => X <= funF fun
    für fun = Y funF

Zu zeigen: (Y funF) => X <= funF (Y funF)


Y funF =
(\f . (\x . f (x x))(\x . f (x x))) funF

Zu zeigen: 
    (\f . (\x . f (x x))(\x . f (x x))) funF 
    => X <=
    funF ((\f . (\x . f (x x))(\x . f (x x))) funF)

```


## Aufgabe 1: Zeige: Theta F ⇒ F (Theta F)

```
// Theta = (\x . \y . y (x x y)) (\x . \y . y (x x y))

(\x . \y . y (x x y)) (\x . \y . y (x x y)) F;
⇒ (zu zeigen)
F ((\x . \y . y (x x y)) (\x . \y . y (x x y)) F)
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
fibF = \fib -> (\n -> 
        if (less_eq n c1) 
            (c1) 
            (add (fib (pred n)) (fib (pred (pred n))))
        )

fib = Y fibF
```

## 2: foo

```hs
foo :: Integer -> Integer
foo n
    | n <= 100 = foo (foo (n + 11))
    | otherwise = n - 10
```

```
fooF = \foo -> (\n ->
    if (less_eq n c100)
        (foo (foo (add n c11)))
        (sub n c10)
    )
foo = Y fooF
```