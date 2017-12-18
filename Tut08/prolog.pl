del1([],_,[]).
del1([X|T1],X,L2) :- !, del1(T1,X,L2).
del1([Y|T1],X,[Y|T2]) :- del1(T1,X,T2).

del2([],_,[]).
del2([X|T1],X,L2) :- del2(T1,X,L2).
del2([Y|T1],X,[Y|T2]) :- del2(T1,X,T2), not(X=Y).

del3([X|L],X,L).
del3([Y|T1],X,[Y|T2]) :- del3(T1,X,T2).

/*
1) deli([1, 2, 1], X, L)

a) deli(L, 2, [1, 3]).
b) deli([1, 2, 3], X, [1, 3]).
c) deli([1, 2, 3, 2], X, [1, 3]).
d) deli([1, 2, 3, 2], X, [1, 2, 3]).
e) deli([1|L], 1, X).
*/





fv(T, []) :- integer(T).
fv(T, [T]) :- atom(T).
fv(app(T,U), F) :- fv(T, F1), fv(U, F2), append(F1, F2, F).
fv(abs(X,T), F) :- fv(T, F1), del2(F1, X, F).
