/*
	=================================
	engine.pl
	=================================
	Ce fichier contient les différents prédicats
	qui permettent de manipuler le plateau,
	contient la partie IA :
		- génération de mouvements possibles
		- recherche de solutions optimales
	-------------------------------
*/


/*
	--------------------------------------------------------------
	----------------------- PREDICATS ----------------------------
	-------------------- ? TEMPORAIRES ? -------------------------
*/
getRowFromBoard(1, [X|_], X) :- !.
getRowFromBoard(R,[_|Q], Res) :- R2 is R-1, getRowFromBoard(R2, Q, Res).

getCellFromRow(1, [X|_], X) :- !.
getCellFromRow(R, [_|Q], Res) :- R2 is R-1, getCellFromRow(R2, Q, Res).

getCell(X, Y, Plateau, Res) :- 
	getRowFromBoard(X, Plateau, RowRes),
	getCellFromRow(Y, RowRes, Res).

testCell(X,Y, Res) :- baseBoard(1, Plat), getCell(X,Y, Plat, Res).

/*
	--------------------------------------------------------------
	--------------------------------------------------------------
*/

/* 
	nextTo(C, PosX, PosY)
	------------------------------
	Unifie PosX et PosY avec des coordonnées
	voisines de celles de la position
	de couple C
*/
nextTo((X,Y), PosX, PosY) :-
	X is PosX-1,Y is PosY, X>0, Y>0;
	X is PosX,Y is PosY-1, X>0, Y>0;
	X is PosX+1,Y is PosY, X>0, Y>0;
	X is PosX,Y is PosY+1, X>0, Y>0.

/* 
	getNeighbours(C, Moves)
	------------------------------
	Unifie Moves avec les différentes positions voisines
	atteignables par la position de coordonnnées C
*/
getNeighbours((X,Y), Moves) :- setof(C, nextTo(C,X,Y), Moves).

/* 
	getNeighboursOfList(ListeDeCouples, MovesTotaux)
	------------------------------
	Unifie MovesTotaux avec l'ensemble des positions atteignables
	depuis les positions contenues dans ListeDeCouples
*/
getNeighboursOfList([],[]).
getNeighboursOfList([CoupleTete|QueueCouples], MovesTotaux) :-
	getNeighbours(CoupleTete, MovesCouple),
	getNeighboursOfList(QueueCouples, MovesQueues),
	concat(MovesCouple, MovesQueues, MovesTotaux).

/* 
	generateMoves(N, Couple, Res)
	------------------------------
	Unifie Res avec la liste des positions atteignables
	depuis la position de coordonnées Couple,
	en réalisant exactement N mouvements.
*/
generateMoves(1, C, Res) :- getNeighbours(C, Res), !.
generateMoves(K, C, Res) :-
	K2 is K-1,
	generateMoves(K2, C, MovesOne),
	getNeighboursOfList(MovesOne, MovesTwo),
	retire_doublons(MovesTwo, SubRes),
	retire_element(C, SubRes, Res), !.