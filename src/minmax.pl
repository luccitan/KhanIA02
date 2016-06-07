/*
	=========================================
	========= ALGORITHME MINMAX =============
	=========================================
*/

/*
	minMaxBoard, PlayerSide, ResBoard)
	------------------------------
	Unifie ResBoard avec le plateau optimal
	selon l'algorithme MinMax
*/

minMax(Board, PlayerSide, ResBoard) :-
	%difficulty(Deepness),
	minMax(Board, PlayerSide, 2, 1, (ResBoard,_)), !.

minMax(Board, PlayerSide, Deepness, Iteration, ResBoardTuple) :-
	Iteration = Deepness, !,
	boardsFromBoard(Board, PlayerSide, BoardsList),
	boardsScore(PlayerSide, BoardsList, BoardsScoreList),
	maxBoard(BoardsScoreList, ResBoardTuple).

% Partie IA avec plus de profondeur dans l'algo MinMax

/*
minMax(Board, PlayerSide, Deepness, Iteration, ResBoardTuple) :-
	SubIteration is Iteration + 1,
	write("1 - minMax"), nl,
	boardsFromBoard(Board, PlayerSide, BoardsList),
	write("2 - minMax"), nl,
	minMaxScoreList(BoardsList, PlayerSide, Deepness, SubIteration, MinMaxScoreList),
	write("3 - minMax"), nl,
	maxBoard(MinMaxScoreList, ResBoardTuple).

minMaxScore(Board, PlayerSide, Deepness, Iteration, Score) :-
	Deepness = Iteration,
	Iteration mod 2 = 1,
	enemyColor(PlayerSide, EnemySide),
	boardsFromBoard(Board, EnemySide, BoardsList),
	boardsScore(PlayerSide, BoardsList, BoardsScoreList),
	minBoard(BoardsScoreList, (_, Score)), !.	
minMaxScore(Board, PlayerSide, Deepness, Iteration, Score) :-
	Deepness = Iteration,
	write("--"), write(Iteration), write("--"), nl,
	boardsFromBoard(Board, PlayerSide, BoardsList),
	write("2 - minMaxScore"), nl,
	boardsScore(PlayerSide, BoardsList, BoardsScoreList),
	write("3 - minMaxScore"), nl,
	maxBoard(BoardsScoreList, (_, Score)), !.
minMaxScore(Board, PlayerSide, Deepness, Iteration, Score) :-
	SubIteration is Iteration + 1,
	Iteration mod 2 = 1,
	enemyColor(PlayerSide, EnemySide),
	boardsFromBoard(Board, EnemySide, BoardsList),
	minMaxScoreList(BoardsList, PlayerSide, Deepness, SubIteration, MinMaxScoreList),
	minBoard(MinMaxScoreList, (_,Score)), !.
minMaxScore(Board, PlayerSide, Deepness, Iteration, Score) :-
	SubIteration is Iteration + 1,
	boardsFromBoard(Board, PlayerSide, BoardsList),
	minMaxScoreList(BoardsList, PlayerSide, Deepness, SubIteration, MinMaxScoreList),
	maxBoard(MinMaxScoreList, (_,Score)), !.

minMaxScoreList([],_,_,_,[]) :- !.
minMaxScoreList([B1|BRest], PlayerSide, Deepness, Iteration, [(B1,Score)|Rest]) :-
	minMaxScore(B1, PlayerSide, Deepness, Iteration, Score),
	minMaxScoreList(BRest, PlayerSide, Deepness, Iteration, Rest).


testMinMax(PlayerSide) :-
	board(Board), khan(Khan),
	minMax(Board, PlayerSide, ResBoard),
	showColumns, showRows(1, ResBoard, Khan).
*/

/*
	boardsFromBoard(Board, piecesList, BoardsList)
	------------------------------
	Retourne la liste des plateaux accessibles depuis un coup
	effectuée par le joueur de côté PlayerSide,
	à partir de Board.
*/
boardsFromBoard(Board, PlayerSide, BoardsList) :-
	piecesFromSide(Board, PlayerSide, PositionsList),
	boardsFromPiecesList(Board, PositionsList, BoardsList).
/*
	boardsFromPiecesList(Board, piecesList, BoardsList)
	------------------------------
	Retourne la liste complète des plateaux que l'on peut obtenir
	en partant d'une des pièces de piecesList
*/
boardsFromPiecesList(_, [], []) :- !.
boardsFromPiecesList(Board, [P1|RestPieces], Res) :-
	boardsFrom(3, Board, P1, SubRes1),
	boardsFromPiecesList(Board, RestPieces, SubRes2),
	concat(SubRes1, SubRes2, Res).

	 
/* 
	boardsScore(BoardsList, BoardAndScoreList)
	------------------------------
	Associe dans une nouvelle liste BoardAndScoreList
	un plateau et son score évalué
*/
boardsScore(_, [], []) :- !.
boardsScore(PlayerSide, [X|Q], [(X,Score)|NextCouples]) :-
	score(X, PlayerSide, Score),
	boardsScore(PlayerSide, Q, NextCouples).

/* 
	minBoard(BoardsAndScoreList, Board)
	------------------------------
	Unifie MinBoardScoreTuple
	avec le tuple (Board, Score) du plateau
	avec le plus petit score
*/
minBoard([FirstBoard|Q], MinBoardScoreTuple) :-
	minBoard(Q, FirstBoard, MinBoardScoreTuple).
minBoard([], MinBoardScoreTuple, MinBoardScoreTuple) :- !.
minBoard([(Brd,Scr)|Q], (_, LocalMinS), MinBoardScoreTuple) :-
	Scr < LocalMinS, !,
	minBoard(Q, (Brd,Scr), MinBoardScoreTuple).
minBoard([_|Q], (LocalMinB, LocalMinS), MinBoardScoreTuple) :-
	minBoard(Q, (LocalMinB,LocalMinS), MinBoardScoreTuple).

/* 
	maxBoard(BoardsAndScoreList, Board)
	------------------------------
	Unifie MaxBoardScoreTuple
	avec le tuple (Board, Score) du plateau
	avec le plus gros score
*/
maxBoard([FirstBoard|Q], MaxBoardScoreTuple) :-
	maxBoard(Q, FirstBoard, MaxBoardScoreTuple).
maxBoard([], MaxBoardScoreTuple, MaxBoardScoreTuple) :- !.
maxBoard([(Brd,Scr)|Q], (_, LocalMaxS), MaxBoardScoreTuple) :-
	Scr > LocalMaxS, !,
	maxBoard(Q, (Brd,Scr), MaxBoardScoreTuple).
maxBoard([_|Q], (LocalMaxB, LocalMaxS), MaxBoardScoreTuple) :-
	maxBoard(Q, (LocalMaxB,LocalMaxS), MaxBoardScoreTuple).

/*
	=========================================
	========= FONCTION SCORE ================
	=========================================
*/
/* 
	score(Board, PlayerSide, Score)
	------------------------------
	Unifie Score avec le score évalué
	par rapport à l'état du plateau dans Board
	et le côté du joueur (ocre ou rouge) dans PlayerSide
*/
score(Board, PlayerSide, Score)	:- 
	subScoreOwnKalistaDead(Board, PlayerSide, SC1),
	SC1 = -10000, Score is SC1, !;
	subScoreEnemyKalistaDead(Board, PlayerSide, SC2),
	SC2 = 10000, Score is SC2, !;
	subScoreLonelyKalista(Board, PlayerSide, SC3),
	subScoreLessPiecesThanEnemy(Board, PlayerSide, SC4),
	subScoreDistanceFromEnemyKalista(Board, PlayerSide, SC5),
	subScoreNumberOfPower2(Board,PlayerSide, SC6),
	Score is SC3+SC4+SC5+SC6.

pieceFromColor((_,kr), rouge).
pieceFromColor((_,sr), rouge).
pieceFromColor((_,ko), ocre).
pieceFromColor((_,so), ocre).
pieceOfPower2AndColor((2,kr), rouge).
pieceOfPower2AndColor((2,sr), rouge).
pieceOfPower2AndColor((2,ko), ocre).
pieceOfPower2AndColor((2,so), ocre).

/* 
	subScoreOwnKalistaDead(Board, PlayerSide, ResultScore)
	------------------------------
	Unifie ResultScore avec :
		- 0 si la Kalista du joueur n'est pas morte
		- -10000 sinon
*/
subScoreOwnKalistaDead(Board, PlayerSide, ResultScore) :-
	\+positionKalista(Board, PlayerSide,_),
	ResultScore is -10000, !.
subScoreOwnKalistaDead(_,_, 0).

/* 
	subScoreEnemyKalistaDead(Board, PlayerSide, ResultScore)
	------------------------------
	Unifie ResultScore avec :
		- 0 si la Kalista ennemie du joueur n'est pas morte
		- 10000 sinon
*/
subScoreEnemyKalistaDead(Board, PlayerSide, ResultScore) :-
	enemyColor(PlayerSide, EnemySide), \+positionKalista(Board, EnemySide,_),
	ResultScore is 10000, !.
subScoreEnemyKalistaDead(_,_, 0).

/* 
	subScoreLonelyKalista(Board, PlayerSide, ResultScore)
	------------------------------
	Unifie ResultScore avec :
		- 350 si la Kalista du joueur est seule
		- 0 sinon
*/
subScoreLonelyKalista(Board, PlayerSide, ResultScore) :-
	\+notLonelyKalista(Board, PlayerSide),
	ResultScore is 350, !.
subScoreLonelyKalista(_,_,0).

% sous-prédicat pour le prédicat "subScoreEnemyKalistaDead"
% Retourne vrai si on trouve un sbire du bon côté dans le Board
notLonelyKalista([X|_], PlayerSide) :-
	subNotLonelyKalista(X, PlayerSide).
notLonelyKalista([_|Q], PlayerSide) :-
	notLonelyKalista(Q, PlayerSide).

% sous-prédicat pour le prédicat "NotLonelyKalista"
subNotLonelyKalista([(_,so)|_], ocre) :- !.
subNotLonelyKalista([(_,sr)|_], rouge) :- !.
subNotLonelyKalista([_|Q], PlayerSide) :-
	subNotLonelyKalista(Q, PlayerSide).

/* 
	subScoreLessPiecesThanEnemy(Board, PlayerSide, ResultScore)
	------------------------------
	Unifie ResultScore avec :
		50 * (différence de pions entre le joueur et son adversaire)
*/
subScoreLessPiecesThanEnemy(Board, PlayerSide, ResultScore) :-
	enemyColor(PlayerSide, EnemySide),
	countPieces(Board, PlayerSide, COUNT1),
	countPieces(Board, EnemySide, COUNT2),
	ResultScore is 50*(-COUNT1+ COUNT2).

% prédicat principalement utilisé pour "subScoreLessPiecesThanEnemy"
countPieces([],_,0) :- !.
countPieces([X|Q], PlayerSide, Count) :-
	subCountPieces(X, PlayerSide, Count1),
	countPieces(Q, PlayerSide, Count2),
	Count is Count1+Count2.

% sous-prédicat pour le prédicat "countPieces"
subCountPieces([],_, 0).
subCountPieces([Piece|Q], PlayerSide, Count) :-
	pieceFromColor(Piece, PlayerSide),
	subCountPieces(Q, PlayerSide, SubCount), Count is SubCount + 1, !.
subCountPieces([_|Q],PlayerSide, Count) :-
	subCountPieces(Q,PlayerSide, Count), !.

/* 
	subScoreDistanceFromEnemyKalista(Board, PlayerSide, ResultScore)
	------------------------------
	Unifie ResultScore avec :
		la valeur négative de la 3 * distance moyenne entre les pions
		et la kalista ennemie
	Plus la distance moyenne est grande, plus on est pénalisé
*/
subScoreDistanceFromEnemyKalista(Board, PlayerSide, ResultScore) :-
	enemyColor(PlayerSide, EnemySide),
	positionKalista(Board, EnemySide, PosEnemyKalista),
	sumDistancesFromEnemyKalista(Board, PlayerSide, PosEnemyKalista, (1,1), SumDistances),
	countPieces(Board, PlayerSide, NumberOfPieces),
	SubResultScore is SumDistances/NumberOfPieces,
	ResultScore is ceil(SubResultScore) * -3.

sumDistancesFromEnemyKalista([],_,_,_,0).
sumDistancesFromEnemyKalista([T|Q], PlayerSide, PosEnemyKalista, (X,Y), Res) :-
	subSumDistancesFromEnemyKalista(T, PlayerSide, PosEnemyKalista, (X,Y), Sum1),
	X2 is X + 1,
	sumDistancesFromEnemyKalista(Q, PlayerSide, PosEnemyKalista, (X2,Y), Sum2),
	Res is Sum1 + Sum2.

subSumDistancesFromEnemyKalista([],_,_,_,0).
subSumDistancesFromEnemyKalista([Piece|Q], PlayerSide, PosEnemyKalista, (X,Y), Res) :-
	pieceFromColor(Piece, PlayerSide),
	distancePos((X,Y), PosEnemyKalista, Add),
	Y2 is Y+1,
	subSumDistancesFromEnemyKalista(Q, PlayerSide, PosEnemyKalista, (X,Y2), SubRes),
	Res is SubRes + Add, !.
subSumDistancesFromEnemyKalista([_|Q], PlayerSide, PosEnemyKalista, (X,Y), Res) :-
	Y2 is Y+1,
	subSumDistancesFromEnemyKalista(Q, PlayerSide, PosEnemyKalista, (X,Y2), Res).

distancePos((PosX1, PosY1), (PosX2,PosY2), Distance) :-
	Distance is abs(PosX1 - PosX2) + abs(PosY1 - PosY2).

/* 
	subScoreNumberOfPower2(Board, PlayerSide, ResultScore)
	------------------------------
	Unifie ResultScore avec 
		- 25 * (nombre de pions sur une case de 2)
*/
subScoreNumberOfPower2(Board, PlayerSide, ResultScore) :-
	numberOfPowerX(Board, PlayerSide, 2, NumberOf2),
	ResultScore is -25 * NumberOf2.

% prédicat principalement utilisé pour "subScoreNumberOfPower2"
numberOfPowerX([], _, _, 0).
numberOfPowerX([X|Q], PlayerSide, Power, Count) :-
	subNumberOfPowerX(X, PlayerSide, Power, Count1),
	numberOfPowerX(Q, PlayerSide, Power, Count2),
	Count is Count1 + Count2.
subNumberOfPowerX([], _,_, 0).
subNumberOfPowerX([Piece|Q], PlayerSide, X, Count) :-
	pieceOfPower2AndColor(Piece, PlayerSide),
	subNumberOfPowerX(Q, PlayerSide, X, SubCount), Count is SubCount + 1, !.
subNumberOfPowerX([_|Q],PlayerSide, X, Count) :-
	subNumberOfPowerX(Q,PlayerSide, X, Count), !.