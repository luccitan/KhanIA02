/*

	- Structure de la liste de pions d'un joueur :
			redPiecesList --> [(X1, Y1, s), (X2, Y2, s), (X3, Y3, k), (X4, Y4, s)]
			ocrePiecesList --> [(X1, Y1, k), (X2, Y2, s), (X3, Y3, s)]
*/

/*
	=== /!\ Code pas forcément pertinent /!\ ===
	Permet d'obtenir un tuple précis du plateau
	grâce aux coordonnées en arguments
	===
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
	=== 
		Prédicats permettant d'obtenir les différentes positions atteignables
		selon la puissance du movement
	===
*/
nextTo((X,Y), PosX, PosY) :-
	X is PosX-1,Y is PosY, X>0, Y>0;
	X is PosX,Y is PosY-1, X>0, Y>0;
	X is PosX+1,Y is PosY, X>0, Y>0;
	X is PosX,Y is PosY+1, X>0, Y>0.

getNeighbours((X,Y), Moves) :- setof(C, nextTo(C,X,Y), Moves).
getNeighboursOfList([],[]).
getNeighboursOfList([CoupleTete|QueueCouples], MovesTotaux) :-
	getNeighbours(CoupleTete, MovesCouple),
	getNeighboursOfList(QueueCouples, MovesQueues),
	concat(MovesCouple, MovesQueues, MovesTotaux).

generateMoves(1, C, Res) :- getNeighbours(C, Res), !.
generateMoves(K, C, Res) :-
	K2 is K-1,
	generateMoves(K2, C, MovesOne),
	getNeighboursOfList(MovesOne, MovesTwo),
	retire_doublons(MovesTwo, SubRes),
	retire_element(C, SubRes, Res), !.