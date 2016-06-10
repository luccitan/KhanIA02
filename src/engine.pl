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
	possibleMoves(Board, PlayerSide, PossibleMoves)
	------------------------------
	Unifie PossibleMoves avec la liste des moves possibles
	par le joueur du camp PlayerSide à partir de Board.

	Les moves sont de la forme :
		[(Xstart, Ystart), (Xend, Yend) ]
*/
possibleMoves(Board, PlayerSide, PossibleMoves) :-
	powerOfCurrentKhan(Board, KhanPower),
	possibleMoves(Board, Board, PlayerSide, (1,1), KhanPower, PossibleMoves),
	PossibleMoves \= [], !.
% KhanPower = 0 se traduit par une ignorance du Khan et donc possibilité de bouger
% ce que l'on veut
possibleMoves(Board, PlayerSide, PossibleMoves) :-
	write("Khan trop restrictif, chaque piece est amovible ..."),
	possibleMoves(Board, Board, PlayerSide, (1,1), 0, PossibleMoves).

possibleMoves(_, [],_,_,_,[]) :- !.
possibleMoves(Board, [RowX|RowRest], PlayerSide, (X,Y), KhanPower, PossibleMoves) :-
	SubX is X+1,
	subPossibleMoves(Board, RowX, PlayerSide, (X,Y), KhanPower, SubRes1),
	possibleMoves(Board, RowRest, PlayerSide,(SubX,Y),KhanPower, SubRes2),	
	concat(SubRes1, SubRes2, PossibleMoves).

subPossibleMoves(_,[],_,_,_,[]) :- !.
subPossibleMoves(Board, [(CellPower,CellType)|CellRest],PlayerSide,(X,Y),0, PossibleMoves) :-
	typeFromSide(CellType, PlayerSide),
	movesFrom(CellPower,Board, (X,Y), PossibleMovesFirst),
	SubY is Y + 1,
	subPossibleMoves(Board, CellRest, PlayerSide, (X,SubY), 0, PossibleMovesRest),
	concat(PossibleMovesFirst, PossibleMovesRest, PossibleMoves).
subPossibleMoves(Board, [(CellPower,CellType)|CellRest],PlayerSide, (X,Y),KhanPower, PossibleMoves) :-
	typeFromSide(CellType, PlayerSide),
	% Vérification autour du Khan
	CellPower = KhanPower, !,
	% Récupération des moves depuis cette position
	movesFrom(KhanPower,Board, (X,Y), PossibleMovesFirst),
	SubY is Y + 1,
	subPossibleMoves(Board, CellRest, PlayerSide, (X,SubY), KhanPower, PossibleMovesRest),
	concat(PossibleMovesFirst, PossibleMovesRest, PossibleMoves).
subPossibleMoves(Board,[_|CellRest],PlayerSide,(X,Y), KhanPower, Res) :-
	SubY is Y + 1,
	subPossibleMoves(Board, CellRest,PlayerSide, (X, SubY), KhanPower, Res), !.

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
	findall(C, nextTo(X,Y,Board,C, CheckEmpty), SubMoves),
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


movesFrom(K, Board, C, MovesFrom) :-
	positionsFrom(K, Board, C, PositionsFrom),
	subMovesFrom(C, PositionsFrom, MovesFrom).

subMovesFrom(_,[],[]) :- !.
subMovesFrom(C, [Pos|RestPos], [[C, Pos]|RestMoves]) :-
	subMovesFrom(C, RestPos, RestMoves).
	
/*
	positionsFrom(K, Board, Couple, Res)
	------------------------------
	Unifie Res avec la liste des positions atteignables
	depuis la position de coordonnées Couple,
	en réalisant exactement K mouvements.
*/
positionsFrom(1, Board, C, Res) :- 
	neighbourPositions(Board, C, SubRes, false, [C], _), 
	friendPiecesFilter(C, Board, SubRes, Res), !.
positionsFrom(K, Board, C, Res) :-
	K2 is K-1,
	subPositionsFrom(K2, Board, C, MovesOne, [C], NewHistory),
	neighbourPositionsFromList(Board, MovesOne, MovesTwo, false, NewHistory,_),
	friendPiecesFilter(C, Board, MovesTwo, Res).


subPositionsFrom(1, Board, C, Res, History, NewHistory) :- 
	neighbourPositions(Board, C, Res, true, History, NewHistory), !.
subPositionsFrom(K, Board, C, Res, History, FinalHistory) :-
	K2 is K-1,
	subPositionsFrom(K2, Board, C, MovesOne, History, SubHistory),
	neighbourPositionsFromList(Board, MovesOne, Res, true, SubHistory, FinalHistory), !.

/*
	friendPiecesFilter(C, Board, SubRes, Res)
	------------------------------
	Unifie Res avec la liste des positions atteignables
	depuis C, retirée des positions avec pièces amis de C
*/
friendPiecesFilter((X,Y), Board, SubRes, Res) :-
	cell(X,Y, Board, (_,StartType)), StartType = ko, !,
	subFriendPiecesFilter(Board, SubRes, ocre, Res);
	cell(X,Y, Board, (_, StartType)), StartType = so, !,
	subFriendPiecesFilter(Board, SubRes, ocre, Res);
	cell(X,Y, Board, (_, StartType)), StartType = kr, !,
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

powerOfCurrentKhan(Board, PowerOfCurrentKhan) :-
	khan((XKhan,YKhan)),
	cell(XKhan, YKhan, Board, (PowerOfCurrentKhan, _)).