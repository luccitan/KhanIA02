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


piecesFromSide(Board, PlayerSide, Res) :-
	piecesFromSide(Board, PlayerSide, Res, 1, 1).

piecesFromSide([],_, [],_,_) :- !.
piecesFromSide([RowX|RowRest], PlayerSide, Res, X, Y) :-
	SubX is X+1,
	subPiecesFromSide(RowX, PlayerSide, SubRes1, X, 1),
	piecesFromSide(RowRest, PlayerSide,SubRes2, SubX, Y),
	concat(SubRes1, SubRes2, Res).

subPiecesFromSide([],_, [],_,_) :- !.
subPiecesFromSide( [(_,CellType)|CellRest], PlayerSide, [(X,Y)|Res], X, Y) :-
	typeFromSide(CellType, PlayerSide),!,
	SubY is Y + 1,
	subPiecesFromSide(CellRest,PlayerSide, Res, X, SubY).
subPiecesFromSide( [_|CellRest],PlayerSide, Res, X, Y) :-
	SubY is Y + 1,
	subPiecesFromSide(CellRest,PlayerSide, Res, X, SubY), !.


/* 
	modifyBoard(Board, CStart, CDest,BoardRes) 
	------------------------------
	Unifie BoardRes avec une version modifié de Board.
	Dans cette version modifié, la potentielle pièce
	aux coordonnées CStart est déplacée aux coordonnées
	CDest
*/
modifyBoard(Board, (Xstart, Ystart), (Xend, Yend),BoardRes) :-
	cell(Xstart, Ystart, Board, (CellPower,CellType)),
	cell(Xend, Yend, Board, (TargetCellPower, _)),
	setCell(Board, (CellPower, empty), (Xstart, Ystart), SubBoard),
	setCell(SubBoard, (TargetCellPower, CellType), (Xend, Yend), BoardRes).

setCell([X|Q], Cell, (1,J), [SubRes|Q]) :- 
	setRowCell(X, Cell, J, SubRes), !.
setCell([T|Q], Cell, (I,J), [T|SubRes]) :-
	SubI is I - 1,
	setCell(Q, Cell, (SubI, J), SubRes), !.

setRowCell([_|Q], Cell, 1, [Cell|Q]) :- !.
setRowCell([T|Q], Cell, J, [T|SubRow]) :-
	SubJ is J - 1,
	setRowCell(Q, Cell, SubJ, SubRow), !.

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
	nextTo(C, PosX, PosY, Board, Boolean)
	------------------------------
	Unifie le couple C avec des coordonnées
	voisines de celles de la position
	de coordonnées (PosX,PosY)

	- Vérifie si la cellule voisine est vide
		si Boolean est à true
*/
nextTo(Xstart, Ystart, Board, (Xres,Yres), true) :-
	Xres is Xstart - 1, Yres is Ystart,
		Xres>0, Yres>0, Xres<7, Yres<7,
		emptyCell(Xres,Yres,Board);
	Xres is Xstart, Yres is Ystart - 1,
		 Xres>0, Yres>0, Xres<7, Yres<7,
		 emptyCell(Xres,Yres,Board);
	Xres is Xstart + 1, Yres is Ystart,
		Xres>0, Yres>0, Xres<7, Yres<7,
		emptyCell(Xres,Yres,Board);
	Xres is Xstart, Yres is Ystart + 1,
		Xres>0, Yres>0, Xres<7, Yres<7,
		emptyCell(Xres,Yres,Board).

nextTo(Xstart, Ystart,_,(Xres,Yres), false) :-
	Xres is Xstart - 1, Yres is Ystart,
		Xres>0, Yres>0, Xres<7, Yres<7;
	Xres is Xstart, Yres is Ystart - 1,
		Xres>0, Yres>0, Xres<7, Yres<7;
	Xres is Xstart + 1, Yres is Ystart,
		Xres>0, Yres>0, Xres<7, Yres<7;
	Xres is Xstart, Yres is Ystart + 1,
		Xres>0, Yres>0, Xres<7, Yres<7.

/* 
	neighbours(Board, C, Moves)
	------------------------------
	Unifie Moves avec les différentes positions voisines
	atteignables par la position de coordonnnées C
*/
neighbourPositions(Board, (X,Y), Moves, CheckEmpty, History, NewHistory) :- 
	setof(C, nextTo(X,Y,Board,C, CheckEmpty), SubMoves),
	difference(SubMoves, History, Moves),
	concat(History, Moves, NewHistory).


/*
	neighboursOfList(Board, ListeDeCouples, MovesTotaux)
	------------------------------
	Unifie MovesTotaux avec l'ensemble des positions atteignables
	depuis les positions contenues dans ListeDeCouples
*/
neighbourPositionsFromList(_, [],[], _,History,History) :- !.
neighbourPositionsFromList(Board, [CoupleTete|QueueCouples], MovesTotaux, CheckEmpty, History, FinalHistory) :-
	neighbourPositions(Board, CoupleTete, MovesCouple, CheckEmpty, History, NewHistory),
	neighbourPositionsFromList(Board, QueueCouples, MovesQueues, CheckEmpty, NewHistory, FinalHistory),
	concat(MovesCouple, MovesQueues, MovesTotaux).


/*
	movesFrom(N, Board, Couple, Res)
	------------------------------
	Unifie Res avec la liste des positions atteignables
	depuis la position de coordonnées Couple,
	en réalisant exactement N mouvements.
*/
movesFrom(1, Board, C, Res) :- neighbourPositions(Board, C, Res, false, [C], _), !.
movesFrom(K, Board, C, Res) :-
	K2 is K-1,
	subMovesFrom(K2, Board, C, MovesOne, [C], NewHistory),
	neighbourPositionsFromList(Board, MovesOne, MovesTwo, false, NewHistory,_),
	friendPiecesFilter(C, Board, MovesTwo, Res).


subMovesFrom(1, Board, C, Res, History, NewHistory) :- 
	neighbourPositions(Board, C, Res, true, History, NewHistory), !.
subMovesFrom(K, Board, C, Res, History, FinalHistory) :-
	K2 is K-1,
	subMovesFrom(K2, Board, C, MovesOne, History, SubHistory),
	neighbourPositionsFromList(Board, MovesOne, Res, true, SubHistory, FinalHistory), !.

/*
	friendPiecesFilter(C, Board, SubRes, Res)
	------------------------------
	Unifie Res avec la liste des positions atteignables
	depuis C, retirée des positions avec pièces amis de C
*/
friendPiecesFilter((X,Y), Board, SubRes, Res) :-
	cell(X,Y, Board, (_,StartType)), StartType = ko,
	subFriendPiecesFilter(Board, SubRes, ocre, Res);
	cell(X,Y, Board, (_, StartType)), StartType = so,
	subFriendPiecesFilter(Board, SubRes, ocre, Res);
	cell(X,Y, Board, (_, StartType)), StartType = kr,
	subFriendPiecesFilter(Board, SubRes, rouge, Res);
	cell(X,Y, Board, (_,StartType)), StartType = sr,
	subFriendPiecesFilter(Board, SubRes, rouge, Res).

subFriendPiecesFilter(_, [], _, []) :- !.
subFriendPiecesFilter(Board, [(X,Y)|RestPos], ocre, Res) :-
	cell(X,Y, Board, (_,Type)), Type = ko,
	subFriendPiecesFilter(Board, RestPos, ocre, Res), !;
	cell(X,Y, Board, (_,Type)), Type = so,
	subFriendPiecesFilter(Board, RestPos, ocre, Res), !.
subFriendPiecesFilter(Board, [(X,Y)|RestPos], rouge, Res) :-
	cell(X,Y, Board, (_,Type)), Type = kr,
	subFriendPiecesFilter(Board, RestPos, rouge, Res), !;
	cell(X,Y, Board, (_,Type)), Type = sr,
	subFriendPiecesFilter(Board, RestPos, rouge, Res), !.
subFriendPiecesFilter(Board, [C|RestPos], PlayerType, [C|Res]) :-
	subFriendPiecesFilter(Board, RestPos, PlayerType, Res).

/*
	boardsFrom(Deepness, Board, StartPosition, Res)
	------------------------------
	Unifie Res avec la liste des plateaux générées
	avec les mouvements possibles depuis StartPosition
	et un nombre de "Deepness" mouvements
*/
boardsFrom(K, Board, StartPosition, BoardsList) :-
	movesFrom(K, Board, StartPosition, PositionsList),
	boardsFromPositions(StartPosition, Board, PositionsList, BoardsList).

/*
	boardsFromPositionsStartPosition, Board, PosList, BoardsList)
	------------------------------
	Unifie BoardsList avec la liste des plateaux générés
	en modifiant Board et en déplaçant la position StartPosition
	vers chaque élément de PosList
*/
boardsFromPositions(_,_,[], []) :- !.
boardsFromPositions(C, Board, [PosX|PosRest], [BoardRes|BoardsRest]) :-
	modifyBoard(Board, C, PosX, BoardRes),
	boardsFromPositions(C, Board, PosRest, BoardsRest).
