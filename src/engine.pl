/*
	=================================
	engine.pl
	=================================
	
		- génération de mouvements possibles
	-------------------------------
*/

/* 
	============================================================
	============================================================
	Prédicats de génération de mouvements possibles
	============================================================
	============================================================
*/

/* 
	possibleMoves(Brd, PlayerSide, PossibleMoves, RestrictiveKhan)
	------------------------------
	Unifie PossibleMoves avec la liste des moves possibles
	par le joueur du camp PlayerSide à partir de Brd.

	Les moves sont de la forme :
		[(Xstart, Ystart), (Xend, Yend) ]
*/
possibleMoves(Brd, (Xkhan, Ykhan), PlayerSide, PossibleMoves, RestrictiveKhan) :-
	cell(Xkhan, Ykhan, Brd, (KhanPower, _)), KhanPower > 0,
	bPossibleMoves(Brd, Brd, PlayerSide, (1,1), KhanPower, PossibleMoves),
	PossibleMoves \= [], RestrictiveKhan = false, !.

% KhanPower = 0 se traduit par une ignorance du Khan et donc possibilité de bouger
% ce que l'on veut
possibleMoves(Brd, _, PlayerSide, PossibleMoves, true) :-
	bPossibleMoves(Brd, Brd, PlayerSide, (1,1), 0, PossibleMoves).

bPossibleMoves(_, [],_,_,_,[]) :- !.
bPossibleMoves(Brd, [RowX|RowRest], PlayerSide, (X,Y), KhanPower, PossibleMoves) :-
	SubX is X+1,
	subPossibleMoves(Brd, RowX, PlayerSide, (X,Y), KhanPower, SubRes1),
	bPossibleMoves(Brd, RowRest, PlayerSide,(SubX,Y),KhanPower, SubRes2),	
	concat(SubRes1, SubRes2, PossibleMoves).

subPossibleMoves(_,[],_,_,_,[]) :- !.
subPossibleMoves(Brd, [(CellPower,CellType)|CellRest],PlayerSide,(X,Y),0, PossibleMoves) :-
	typeFromSide(CellType, PlayerSide),
	movesFrom(CellPower,Brd, (X,Y), PossibleMovesFirst),
	SubY is Y + 1,
	subPossibleMoves(Brd, CellRest, PlayerSide, (X,SubY), 0, PossibleMovesRest),
	concat(PossibleMovesFirst, PossibleMovesRest, PossibleMoves).
subPossibleMoves(Brd, [(CellPower,CellType)|CellRest],PlayerSide, (X,Y),KhanPower, PossibleMoves) :-
	typeFromSide(CellType, PlayerSide),
	% Vérification autour du Khan
	CellPower = KhanPower, !,
	% Récupération des moves depuis cette position
	movesFrom(KhanPower,Brd, (X,Y), PossibleMovesFirst),
	SubY is Y + 1,
	subPossibleMoves(Brd, CellRest, PlayerSide, (X,SubY), KhanPower, PossibleMovesRest),
	concat(PossibleMovesFirst, PossibleMovesRest, PossibleMoves).
subPossibleMoves(Brd,[_|CellRest],PlayerSide,(X,Y), KhanPower, Res) :-
	SubY is Y + 1,
	subPossibleMoves(Brd, CellRest,PlayerSide, (X, SubY), KhanPower, Res), !.

/* 
	createBrd(Brd, CStart, CDest,BrdRes) 
	------------------------------
	Unifie BrdRes avec une version modifié de Brd.
	Dans cette version modifié, la potentielle pièce
	aux coordonnées CStart est déplacée aux coordonnées
	CDest
*/
createBrd(Brd, (Xstart, Ystart), (Xend, Yend),BrdRes) :-
	cell(Xstart, Ystart, Brd, (CellPower,CellType)),
	cell(Xend, Yend, Brd, (TargetCellPower, _)),
	setCell(Brd, (CellPower, empty), (Xstart, Ystart), SubBrd),
	setCell(SubBrd, (TargetCellPower, CellType), (Xend, Yend), BrdRes).

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
	nextTo(C, PosX, PosY, Brd, Boolean)
	------------------------------
	Unifie le couple C avec des coordonnées
	voisines de celles de la position
	de coordonnées (PosX,PosY)

	- Vérifie si la cellule voisine est vide
		si Boolean est à true
*/
nextTo(Xstart, Ystart, Brd, (Xres,Yres), true) :-
	Xres is Xstart - 1, Yres is Ystart,
		Xres>0, Yres>0, Xres<7, Yres<7,
		cell(Xres, Yres, Brd, (_,empty));
	Xres is Xstart, Yres is Ystart - 1,
		 Xres>0, Yres>0, Xres<7, Yres<7,
		 cell(Xres, Yres, Brd, (_,empty));
	Xres is Xstart + 1, Yres is Ystart,
		Xres>0, Yres>0, Xres<7, Yres<7,
		cell(Xres, Yres, Brd, (_,empty));
	Xres is Xstart, Yres is Ystart + 1,
		Xres>0, Yres>0, Xres<7, Yres<7,
		cell(Xres, Yres, Brd, (_,empty)).

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
	neighbours(Brd, C, Moves)
	------------------------------
	Unifie Moves avec les différentes positions voisines
	atteignables par la position de coordonnnées C
*/
neighbourPositions(Brd, (X,Y), Moves, CheckEmpty, History, NewHistory) :-
	findall(C, nextTo(X,Y,Brd,C, CheckEmpty), SubMoves),
	difference(SubMoves, History, Moves),
	concat(History, Moves, NewHistory).


/*
	neighboursOfList(Brd, ListeDeCouples, MovesTotaux)
	------------------------------
	Unifie MovesTotaux avec l'ensemble des positions atteignables
	depuis les positions contenues dans ListeDeCouples
*/
neighbourPositionsFromList(_, [],[], _,History,History) :- !.
neighbourPositionsFromList(Brd, [CoupleTete|QueueCouples], MovesTotaux, CheckEmpty, History, FinalHistory) :-
	neighbourPositions(Brd, CoupleTete, MovesCouple, CheckEmpty, History, NewHistory),
	neighbourPositionsFromList(Brd, QueueCouples, MovesQueues, CheckEmpty, NewHistory, FinalHistory),
	concat(MovesCouple, MovesQueues, MovesTotaux).

/*
	movesFrom(K, Brd, C, MovesFrom)
	------------------------------
	Unifie MovesFrom avec la liste des mouvements
	possibles depuis la position C, en faisant K déplacements
	sur le plateau Brd.
	Les mouvements sont de la forme (C, CoordonnesdArrivee)
*/
movesFrom(K, Brd, C, MovesFrom) :-
	positionsFrom(K, Brd, C, PositionsFrom),
	subMovesFrom(C, PositionsFrom, MovesFrom).

subMovesFrom(_,[],[]) :- !.
subMovesFrom(C, [Pos|RestPos], [[C, Pos]|RestMoves]) :-
	subMovesFrom(C, RestPos, RestMoves).
	
/*
	positionsFrom(K, Brd, Couple, Res)
	------------------------------
	Unifie Res avec la liste des positions atteignables
	depuis la position de coordonnées Couple,
	en réalisant exactement K mouvements.
*/
positionsFrom(1, Brd, C, Res) :- 
	neighbourPositions(Brd, C, SubRes, false, [C], _), 
	friendPiecesFilter(C, Brd, SubRes, Res), !.
positionsFrom(K, Brd, C, Res) :-
	K2 is K-1,
	subPositionsFrom(K2, Brd, C, MovesOne, [C], NewHistory),
	neighbourPositionsFromList(Brd, MovesOne, MovesTwo, false, NewHistory,_),
	friendPiecesFilter(C, Brd, MovesTwo, Res).


subPositionsFrom(1, Brd, C, Res, History, NewHistory) :- 
	neighbourPositions(Brd, C, Res, true, History, NewHistory), !.
subPositionsFrom(K, Brd, C, Res, History, FinalHistory) :-
	K2 is K-1,
	subPositionsFrom(K2, Brd, C, MovesOne, History, SubHistory),
	neighbourPositionsFromList(Brd, MovesOne, Res, true, SubHistory, FinalHistory), !.

/*
	friendPiecesFilter(C, Brd, SubRes, Res)
	------------------------------
	Unifie Res avec la liste des positions atteignables
	depuis C, retirée des positions avec pièces amis de C
*/
friendPiecesFilter((X,Y), Brd, SubRes, Res) :-
	cell(X,Y, Brd, (_,StartType)), StartType = ko, !,
	subFriendPiecesFilter(Brd, SubRes, ocre, Res);
	cell(X,Y, Brd, (_, StartType)), StartType = so, !,
	subFriendPiecesFilter(Brd, SubRes, ocre, Res);
	cell(X,Y, Brd, (_, StartType)), StartType = kr, !,
	subFriendPiecesFilter(Brd, SubRes, rouge, Res);
	cell(X,Y, Brd, (_,StartType)), StartType = sr,
	subFriendPiecesFilter(Brd, SubRes, rouge, Res).

subFriendPiecesFilter(_, [], _, []) :- !.
subFriendPiecesFilter(Brd, [(X,Y)|RestPos], ocre, Res) :-
	cell(X,Y, Brd, (_,Type)), Type = ko,
	subFriendPiecesFilter(Brd, RestPos, ocre, Res), !;
	cell(X,Y, Brd, (_,Type)), Type = so,
	subFriendPiecesFilter(Brd, RestPos, ocre, Res), !.
subFriendPiecesFilter(Brd, [(X,Y)|RestPos], rouge, Res) :-
	cell(X,Y, Brd, (_,Type)), Type = kr,
	subFriendPiecesFilter(Brd, RestPos, rouge, Res), !;
	cell(X,Y, Brd, (_,Type)), Type = sr,
	subFriendPiecesFilter(Brd, RestPos, rouge, Res), !.
subFriendPiecesFilter(Brd, [C|RestPos], PlayerType, [C|Res]) :-
	subFriendPiecesFilter(Brd, RestPos, PlayerType, Res).

/*
	boardsFrom(Deepness, Brd, StartPosition, Res)
	------------------------------
	Unifie Res avec la liste des plateaux générées
	avec les mouvements possibles depuis StartPosition
	et un nombre de "Deepness" mouvements
*/
boardsFrom(K, Brd, StartPosition, BrdsList) :-
	movesFrom(K, Brd, StartPosition, PositionsList),
	boardsFromPositions(StartPosition, Brd, PositionsList, BrdsList).

/*
	boardsFromPositionsStartPosition, Brd, PosList, BrdsList)
	------------------------------
	Unifie BrdsList avec la liste des plateaux générés
	en modifiant Brd et en déplaçant la position StartPosition
	vers chaque élément de PosList
*/
boardsFromPositions(_,_,[], []) :- !.
boardsFromPositions(C, Brd, [PosX|PosRest], [BrdRes|BrdsRest]) :-
	createBrd(Brd, C, PosX, BrdRes),
	boardsFromPositions(C, Brd, PosRest, BrdsRest).

powerOfCurrentKhan(Brd, PowerOfCurrentKhan) :-
	khan((XKhan,YKhan)), 
	XKhan >= 1, XKhan =< 6, YKhan >= 1, YKhan =< 6, !,
	cell(XKhan, YKhan, Brd, (PowerOfCurrentKhan, _)).
powerOfCurrentKhan(_,0).