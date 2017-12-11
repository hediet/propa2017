

farbe(blau).
farbe(gelb).
farbe(gruen).
farbe(rot).

erzwingeUnterschFarben(X, Y) :- farbe(X), farbe(Y), X \= Y.

deutschland(VW02,VW03,VW04,VW05,VW06,VW07,VW08,VW09) :-
  erzwingeUnterschFarben(VW04, VW05), erzwingeUnterschFarben(VW04, VW03),
  erzwingeUnterschFarben(VW05, VW02), erzwingeUnterschFarben(VW05, VW06), erzwingeUnterschFarben(VW05, VW03),
  erzwingeUnterschFarben(VW02, VW06),
  erzwingeUnterschFarben(VW03, VW06), erzwingeUnterschFarben(VW03, VW09),
  erzwingeUnterschFarben(VW06, VW09), erzwingeUnterschFarben(VW06, VW07),
  erzwingeUnterschFarben(VW09, VW07), erzwingeUnterschFarben(VW09, VW08),
  erzwingeUnterschFarben(VW07, VW08).



matches(e,[]).
matches(C,[C]) :- atom(C), C \= e.
matches(u(A, B),S) :- matches(A, S); matches(B, S).
matches(c(A,B),S) :- append(S1,S2,S), matches(A,S1), matches(B,S2).
matches(*(_),[]).
matches(*(A),S) :- append(S1,S2,S), not(S1=[]), matches(A,S1), matches(*(A),S2).



% Befinden sich Wolf und Ziege unbeaufsichtigt am gleichen Ufer, so frisst der Wolf die Ziege.
% Befinden sich Ziege und Kohl unbeaufsichtigt am gleichen Ufer, so frisst die Ziege den Kohl.
% Situation: Tupel (Mann, Ziege, Wolf, Kohl) \in { links, rechts }^4
% Anfang: Alle links, Ende: Alle rechts

gegenueber(links,rechts).
gegenueber(rechts,links).

harmlos(_,X,Y) :- gegenueber(X,Y).
harmlos(Ufer,Ufer,Ufer).

% Aufgabe 1: erlaubt(situation) definieren

erlaubt((Mann,Ziege,Wolf,Kohl)) :- harmlos(Mann,Ziege,Wolf), harmlos(Mann,Ziege,Kohl).

% Aufgabe 2: Mögliche Situationsübergänge

fahrt((U, Ziege, Wolf, Kohl), "leer",  (UNeu, Ziege, Wolf, Kohl)) :- gegenueber(U,UNeu).
fahrt((U, U,     Wolf, Kohl), "Ziege", (UNeu, UNeu,  Wolf, Kohl)) :- gegenueber(U,UNeu).
fahrt((U, Ziege, U,    Kohl), "Wolf",  (UNeu, Ziege, UNeu, Kohl)) :- gegenueber(U,UNeu).
fahrt((U, Ziege, Wolf, U  ),  "Kohl",  (UNeu, Ziege, Wolf, UNeu)) :- gegenueber(U,UNeu).

% Aufgabe 3: erreichbar(Start, Besucht, Fahrten, Ziel) definieren

erreichbar(S,_,[],S).
erreichbar(S,Besucht,[Fahrt|Fahrten],Z) :-
    fahrt(S,Fahrt,ZwischenS), erlaubt(ZwischenS), not(member(ZwischenS,Besucht)),
    erreichbar(ZwischenS,[ZwischenS|Besucht],Fahrten,Z).

lösung(Fahrten) :- start(S), ziel(Z), erreichbar(S,[],Fahrten,Z).
start((links,links,links,links)).
ziel((rechts,rechts,rechts,rechts)).



/* 
Haskell: 

splits :: [t] -> [([t], [t])]
splits [1,2,3] = [ ([],[1,2,3]), ([1],[2,3]), ([1,2],[3]), ([1,2,3],[]) ]

splits l = [ (take n l, drop n l) | n <- [0..length l] ]
*/



? splits([1,2,3], Res).
Res = ([], [1,2,3]) ;
Res = ([1], [2,3]) ;
Res = ([1,2], [3]) ;
Res = ([1,2,3], []) ;
No


splits(L, ([], L)).
splits([X|L], ([X|S], E)) :- splits(L, (S, E)).

% oder:
splits(L, (Xs, Ys)) :- append(Xs, Ys, L).

% cut:

main(X, Y) :- test(X, Y).
main(100, 200).

test(X, Y) :- bin(X), !, bin(Y).
test(10, 20).

bin(0).
bin(1).