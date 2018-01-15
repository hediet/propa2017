solution(S) :-
   % Lösung ist eine Liste mit Einträgen der Form [Name, ProgrammingLanguage, Algorithm]
   S = [[_,_,_],[_,_,_],[_,_,_],[_,_,_],[_,_,_]],
   clue1(S),
   clue2(S),
   clue3(S),
   clue4(S),
   clue5(S),
   clue6(S),
   clue7(S),
   clue8(S),
   clue9(S),
   clue10(S),
   clue11(S),
   clue12(S).

% 1.) Es steht genau ein Tutor zwischen dem Tutor, der gerne GLR-Parsing betreibt, und dem, der C\# mag.
clue1(Solution) :-
	  indexOf([_,_,"GLR-Parsing"], Solution, N1),
	  indexOf([_,"C#",_], Solution, N2),
	  AbsDiff is abs(N2 - N1),
	  AbsDiff == 2.

% 2.) Der Tutor, der am liebsten in Pseudocode programmiert, steht direkt rechts von Jonas.
clue2(Solution) :-
  indexOf(["Jonas",_,_], Solution, N1),
  N2 is N1 + 1,
  indexOf([_,"Pseudocode",_], Solution, N2).

% 3.) Es steht genau ein Tutor zwischen dem Tutor, dessen Lieblingssprache Elm ist, und Henning.
clue3(Solution) :-
	  indexOf([_,"Elm",_], Solution, N1),
	  indexOf(["Henning",_,_], Solution, N2),
	  AbsDiff is abs(N2 - N1),
	  AbsDiff == 2.

% 4.) Der Tutor, der gerne Append Lists verwendet, steht direkt rechts von Tobias.
clue4(Solution) :-
    indexOf(["Tobias",_,_], Solution, N1),
    N2 is N1 + 1,
    indexOf([_,_,"Append Lists"], Solution, N2).

% 5.) Es steht genau ein Tutor zwischen Daniel und dem Tutor, der gerne Packrat-Parsing einsetzt.
clue5(Solution) :-
	  indexOf(["Daniel",_,_], Solution, N1),
	  indexOf([_,_,"Packrat-Parsing"], Solution, N2),
	  AbsDiff is abs(N2 - N1),
	  AbsDiff == 2.

% 6.) Es stehen genau zwei Tutoren zwischen dem Tutor, der gerne im TypeScript-Typsystem programmiert, und Jonas.
clue6(Solution) :-
	  indexOf([_,"TypeScript-Typsystem",_], Solution, N1),
	  indexOf(["Jonas",_,_], Solution, N2),
	  AbsDiff is abs(N2 - N1),
	  AbsDiff == 3.

% 7.) Der Tutor, der am liebsten in Pseudocode programmiert, steht rechts von Henning.
clue7(Solution) :-
    indexOf([_,"Pseudocode",_], Solution, N1),
    indexOf(["Henning",_,_], Solution, N2),
    N1 > N2.

% 8.) Der Tutor mit dem Lieblingsalgorithmus Bogosort steht direkt links von dem, der lieber den Euklidischen Algorithmus einsetzt.
clue8(Solution) :-
    indexOf([_,_,"Bogosort"], Solution, N1),
    N2 is N1 + 1,
    indexOf([_,_,"Euklidischer Algorithmus"], Solution, N2).

% 9.) Der Tutor, der gerne Packrat-Parsing verwendet, tut das natürlich im TypeScript-Typsystem.
clue9(Solution) :-
	indexOf([_,"TypeScript-Typsystem","Packrat-Parsing"], Solution, _).

% 10.) Es stehen genau zwei Tutoren zwischen Henning und Jonas.
clue10(Solution) :-
	  indexOf(["Henning",_,_], Solution, N1),
	  indexOf(["Jonas",_,_], Solution, N2),
	  AbsDiff is abs(N2 - N1),
	  AbsDiff == 3.

% 11.) Es steht genau ein Tutor zwischen Daniel und Roman.
clue11(Solution) :-
	  indexOf(["Daniel",_,_], Solution, N1),
	  indexOf(["Roman",_,_], Solution, N2),
	  AbsDiff is abs(N2 - N1),
	  AbsDiff == 2.

% 12.) Ein Tutor mag Scala.
clue12(Solution) :-
	  indexOf([_,"Scala",_], Solution, _).

indexOf(X,[X|_],0).
indexOf(X,[_|XS],N) :- indexOf(X,XS,M), N is M+1.



