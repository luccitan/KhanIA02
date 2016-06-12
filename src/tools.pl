/*
	=================================
	tools.pl
	=================================
	Ce fichier contient les différents prédicats
	qui sont utilisées de manière utilitaire au projet.
	Ils peuvent être indépendants du projet ou alors
	utiles pour de simples actions
	(sélection de cellule, etc...)
	-------------------------------
*/

%   ==================================================================
%	Prédicats dépendants du projet
%	==================================================================

/* 
	positionKalista(Board,PlayerSide, Position)
	------------------------------
	Unifie Position avec la position du Kalista
	côté PlayerSide grâce au Board.
	Renvoie faux si la Kalista est morte
*/
positionKalista([X|_], PlayerSide, Position) :-
	subPositionKalista(X, PlayerSide, Position), !.
positionKalista([_|Q], PlayerSide, (PosX, PosY)) :-
	positionKalista(Q, PlayerSide, (PosX2, PosY)), PosX is PosX2 + 1.

% sous-prédicat pour le prédicat "positionKalista"
subPositionKalista([(_,ko)|_], ocre, (1,1)) :- !.
subPositionKalista([(_,kr)|_], rouge, (1,1)) :- !.
subPositionKalista([_|Q], PlayerSide, (PosX, PosY)) :-
	subPositionKalista(Q, PlayerSide, (PosX, PosY2)), PosY is PosY2 + 1.

/* 
	cell(X,Y, Board, Res)
	------------------------------
	Unifie Res avec le tuple présent dans le plateau
	aux coordonnées (X,Y)
*/
cell(X, Y, Board, Res) :- 
	rowFromBoard(X, Board, RowRes),
	cellFromRow(Y, RowRes, Res).
rowFromBoard(1, [X|_], X) :- !.
rowFromBoard(R,[_|Q], Res) :- R2 is R-1, rowFromBoard(R2, Q, Res).

cellFromRow(1, [X|_], X) :- !.
cellFromRow(R, [_|Q], Res) :- R2 is R-1, cellFromRow(R2, Q, Res).

typeFromSide(ko, ocre).
typeFromSide(so, ocre).
typeFromSide(kr, rouge).
typeFromSide(sr, rouge).

getPieceType(ocre, kalista, ko).
getPieceType(ocre, sbire, so).
getPieceType(rouge, kalista, kr).
getPieceType(rouge, sbire, sr).

/* 
	print(List)
	------------------------------
	Affiche la liste des tuples présents dans
	dans List
*/
print([]) :- !.
print([X|Q]) :-
	write("("),
	write(X),
	write(") "),
	print(Q).

/* 
	enemyColor(X,Y)
	------------------------------
	Unifie X et Y avec les deux couleurs
	antagonistes.
*/
enemyColor(rouge, ocre).
enemyColor(ocre, rouge).

%   ==================================================================
%	Prédicats indépendants du projet
%	==================================================================


/*
	element(X, L)
	------------------------------
	Prédicat qui retourne VRAI si :
	un élément X (argument 1) est présent dans la liste L (argument 2)
*/
element(X, [X|_]).
element(X, [_|Q]) :- element(X,Q).

/*
	concat(Liste1, Liste2, ListeResultat)
	------------------------------
	Prédicat qui unifie ListeResultat
	avec la concaténation des listes Liste1 et Liste2
*/
concat([], L, L) :- !.
concat(L, [], L) :- !.
concat([T|Q], L2, [T|Res]) :- concat(Q, L2, Res).


/*
	retire_element(X, L1, L2)
	------------------------------
	Prédicat qui déplace dans L2 la première occurence de l'élément X dans L
*/
retire_element(_, [], []) :- !.
retire_element(X, [X|Q], Q) :- !.
retire_element(X, [T|Q], [T|Res]) :- retire_element(X, Q, Res).

/*
	retire_elements(X, L1, L2)
	------------------------------
	Prédicat qui déplace dans L2 TOUTES les occurences de l'élément X dans L
*/
retire_elements(_, [], []) :- !.
retire_elements(X, [X|Q], Res) :- retire_elements(X, Q, Res), !.
retire_elements(X, [T|Q], [T|Res]) :- retire_elements(X,Q,Res).

/*
	retire_doublons(L, Res)
	------------------------------
	Prédicat qui insère dans Res la liste L retirée de tous ses doublons
	Res devient donc un 'ensemble'
*/
retire_doublons([], []) :- !.
retire_doublons([T|Q], [T|R]) :- retire_elements(T, Q, Res), retire_doublons(Res, R).

/*
	difference(L1, L2, Res)
	------------------------------
	Prédicat qui retire les éléments de L1 présents dans L2
	et met le résultat filtré dans Res
*/
difference([],_,[]) :- !.
difference([T|Q], L2, [T|Res]) :- \+element(T, L2), difference(Q, L2, Res), !.
difference([_|Q], L2, Res) :- difference(Q, L2, Res), !.

/*
	validPositioning(Board, PlayerSide, C)
	------------------------------
	Prédicat qui vérifie
*/
% --------- Cas du côté ROUGE
validPositioning(Board, rouge, (X, Y), CellPower) :-
	X >= 5, X =< 6, Y >= 1, Y =< 6,
	cell(X, Y, Board, (CellPower,empty)), !.
% Cas où la cellule n'est pas vide
validPositioning(_, rouge, (X,Y),_) :-
	X >= 5, X =< 6, Y >= 1, Y =< 6,
	nl, multipleWSep(2, 60),
	writeln("La cellule est deja prise !"), !, fail.
% Cas où les coordonnées ne sont pas valides.
validPositioning(_, rouge,_,_) :-
	nl, multipleWSep(2, 60),
	nl, writeln("Coordonnees invalides, elles doivent etre comprises entre (5,1) et (6,6)"), fail.
% --------- Cas du côté OCRE
validPositioning(Board, ocre, (X, Y), CellPower) :-
	X >= 1, X =< 2, Y >= 1, Y =< 6,
	cell(X, Y, Board, (CellPower,empty)), !.
% Cas où la cellule n'est pas vide
validPositioning(_, ocre, (X, Y),_) :-
	X >= 1, X =< 2, Y >= 1, Y =< 6,
	nl, multipleWSep(2, 60),
	nl, write("La cellule est deja prise !"), nl, !, fail.
% Cas où les coordonnées ne sont pas valides.
validPositioning(_, ocre,_,_) :-
	nl, multipleWSep(2, 60),
	nl, writeln("Coordonnees invalides, elles doivent etre comprises entre (1,1) et (2,6)"), fail.


/*
	longueur(L, Res)
	------------------------------
	Prédicat qui unifie Res
	avec la longueur de la liste L
*/
longueur([], 0).
longueur([_|Q], Res) :- longueur(Q, SubRes), Res is SubRes + 1.
