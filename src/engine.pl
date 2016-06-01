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
rowFromBoard(1, [X|_], X) :- !.
rowFromBoard(R,[_|Q], Res) :- R2 is R-1, rowFromBoard(R2, Q, Res).

cellFromRow(1, [X|_], X) :- !.
cellFromRow(R, [_|Q], Res) :- R2 is R-1, cellFromRow(R2, Q, Res).

cell(X, Y, Board, Res) :- 
	rowFromBoard(X, Board, RowRes),
	cellFromRow(Y, RowRes, Res).


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
	enemyColor(X,Y)
	------------------------------
	Unifie X et Y avec les deux couleurs
	antagonistes.
*/
enemyColor(rouge, ocre).
enemyColor(ocre, rouge).

/* 
	nextTo(C, PosX, PosY, Board, Boolean)
	------------------------------
	Unifie le couple C avec des coordonnées
	voisines de celles de la position
	de coordonnées (PosX,PosY)

	- Vérifie si la cellule voisine est vide
		si Boolean est à true
*/
nextTo((X,Y), PosX, PosY, Board, true) :-
	X is PosX-1,Y is PosY, X>0, Y>0, emptyCell(X,Y,Board);
	X is PosX,Y is PosY-1, X>0, Y>0, emptyCell(X,Y,Board);
	X is PosX+1,Y is PosY, X>0, Y>0, emptyCell(X,Y,Board);
	X is PosX,Y is PosY+1, X>0, Y>0, emptyCell(X,Y,Board).

nextTo((X,Y), PosX, PosY, _, false) :-
	X is PosX-1,Y is PosY, X>0, Y>0;
	X is PosX,Y is PosY-1, X>0, Y>0;
	X is PosX+1,Y is PosY, X>0, Y>0;
	X is PosX,Y is PosY+1, X>0, Y>0.

/* 
	emptyCell(X,Y,Board)
	------------------------------
	Renvoie true si la cellule de coordonnées (X,Y)
	du plateau Board est vide ou contient un pion
*/
emptyCell(X,Y,Board) :- 
	cell(X,Y,Board, (_, CellContent)),
	CellContent = empty.

/* 
	getNeighbours(C, Moves)
	------------------------------
	Unifie Moves avec les différentes positions voisines
	atteignables par la position de coordonnnées C

getNeighbours((X,Y), Moves, Board) :- 
	setof(C, nextTo(C,X,Y,Board, false), Moves).


	getNeighboursOfList(ListeDeCouples, MovesTotaux)
	------------------------------
	Unifie MovesTotaux avec l'ensemble des positions atteignables
	depuis les positions contenues dans ListeDeCouples

getNeighboursOfList([],[]).
getNeighboursOfList([CoupleTete|QueueCouples], MovesTotaux) :-
	getNeighbours(CoupleTete, MovesCouple),
	getNeighboursOfList(QueueCouples, MovesQueues),
	concat(MovesCouple, MovesQueues, MovesTotaux).


	generateMoves(N, Couple, Res)
	------------------------------
	Unifie Res avec la liste des positions atteignables
	depuis la position de coordonnées Couple,
	en réalisant exactement N mouvements.

generateMoves(1, C, Board,Res) :- getNeighbours(C, Res), !.
generateMoves(K, C, Res) :-
	K2 is K-1,
	generateMoves(K2, C, MovesOne),
	getNeighboursOfList(MovesOne, MovesTwo),
	retire_doublons(MovesTwo, SubRes),
	retire_element(C, SubRes, Res), !.
*/