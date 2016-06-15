% ------------------------------------------------------------------
%	@developer : Tanguy LUCCI, UTC Student
%	@developer : Alexandre-Guillaume GILBERT, UTC Student
% ------------------------------------------------------------------


/*
	=================================
	internaltools.pl
	=================================
	Ce fichier contient les différents prédicats
	qui sont utilisées de manière utilitaire au projet.
	Ils sont internes au projet et sa structure de données
	utiles pour de simples actions
	(sélection de cellule, etc...)
	-------------------------------
*/

%   ==================================================================
%	Prédicats dépendants du projet
%	==================================================================

/* 
	cell(X,Y, Brd, Res)
	------------------------------
	Unifie Res avec le tuple présent dans le plateau
	aux coordonnées (X,Y)
*/
cell(X, Y, Brd, Res) :- 
	rowFromBrd(X, Brd, RowRes),
	cellFromRow(Y, RowRes, Res).
rowFromBrd(1, [X|_], X) :- !.
rowFromBrd(R,[_|Q], Res) :- R2 is R-1, rowFromBrd(R2, Q, Res).
cellFromRow(1, [X|_], X) :- !.
cellFromRow(R, [_|Q], Res) :- R2 is R-1, cellFromRow(R2, Q, Res).

/* 
	positionKalista(Brd,PlayerSide, Position)
	------------------------------
	Unifie Position avec la position du Kalista
	côté PlayerSide grâce au Brd.
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
	typeFromSide(PieceType, PlayerSide)
	------------------------------
	Unifie PlayerSide avec le camp de la pièce
	selon son intitulé de type
*/
typeFromSide(ko, ocre).
typeFromSide(so, ocre).
typeFromSide(kr, rouge).
typeFromSide(sr, rouge).

/* 
	pieceType(PlayerSide, PieceCategory, PieceType)
	------------------------------
	Unifie PieceType pour avec l'intitulé de la pièce
	en prenant en compte son camp (PlayerSide),
	et sa catégorie (PieceCategory)
*/
pieceType(ocre, kalista, ko).
pieceType(ocre, sbire, so).
pieceType(rouge, kalista, kr).
pieceType(rouge, sbire, sr).

/* 
	enemyColor(X,Y)
	------------------------------
	Unifie X et Y avec les deux couleurs
	antagonistes.
*/
enemyColor(rouge, ocre).
enemyColor(ocre, rouge).

/*
	pieceFromColor(Piece, Color)
	------------------------------
	Unifie Color avec la couleur de Piece
*/
pieceFromColor((_,kr), rouge).
pieceFromColor((_,sr), rouge).
pieceFromColor((_,ko), ocre).
pieceFromColor((_,so), ocre).
/*
	pieceOfPower2AndColor(Piece, Color)
	------------------------------
	Unifie Color avec la couleur de Piece 
	si celle-ci est sur une case de puissance 2
*/
pieceOfPower2AndColor((2,kr), rouge).
pieceOfPower2AndColor((2,sr), rouge).
pieceOfPower2AndColor((2,ko), ocre).
pieceOfPower2AndColor((2,so), ocre).

/*
	validPositioning(Brd, PlayerSide, C)
	------------------------------
	Prédicat qui vérifie qu'une entrée de position de départ
	est valide.
	Non valide si la place est déja prise ou si la position
	ne correspond pas avec les deux rangs autorisées
	à chaque camp
*/

% --------- Cas du côté ROUGE
validPositioning(Brd, rouge, (X, Y), CellPower) :-
	X >= 5, X =< 6, Y >= 1, Y =< 6,
	cell(X, Y, Brd, (CellPower,empty)), !.
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
validPositioning(Brd, ocre, (X, Y), CellPower) :-
	X >= 1, X =< 2, Y >= 1, Y =< 6,
	cell(X, Y, Brd, (CellPower,empty)), !.
% Cas où la cellule n'est pas vide
validPositioning(_, ocre, (X, Y),_) :-
	X >= 1, X =< 2, Y >= 1, Y =< 6,
	nl, multipleWSep(2, 60),
	nl, write("La cellule est deja prise !"), nl, !, fail.
% Cas où les coordonnées ne sont pas valides.
validPositioning(_, ocre,_,_) :-
	nl, multipleWSep(2, 60),
	nl, writeln("Coordonnees invalides, elles doivent etre comprises entre (1,1) et (2,6)"), fail.