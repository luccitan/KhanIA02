/*
	=========================================
	========= ALGORITHME MINMAX =============
	=========================================
*/

/*
	minMaxBrd, PlayerSide, ResBrd)
	------------------------------
	Unifie ResBrd avec le plateau optimal
	selon l'algorithme MinMax

	BestMove de la forme
	[(Xstart, Ystart), (Xend, Yend)]
*/

generateMove(Brd, Khan, PlayerSide, BestMove) :-
	difficulty(Deepness),
	minMax(Brd, Khan, PlayerSide, Deepness, (BestMove,_)).


minMax(Brd, Khan, PlayerSide, 1, BestMoveTuple) :-
	possibleMoves(Brd, Khan, PlayerSide, MovesList,_),
	movesScore(PlayerSide, Brd, MovesList, MovesScoreList),
	maxMove(MovesScoreList, BestMoveTuple), !.
minMax(Brd, Khan, PlayerSide, Deepness, BestMoveTuple) :-
	possibleMoves(Brd, Khan, PlayerSide, MovesList,_),
	SubDeepness is Deepness - 1,
	minMaxMovesScore(Brd, Khan, PlayerSide, MovesList, SubDeepness, 1, MovesScoreList),
	maxMove(MovesScoreList, BestMoveTuple).

minMaxMovesScore(_,_,_, [],_,_, []) :- !.
minMaxMovesScore(Brd, Khan, PlayerSide, [[Cstart,Cend]|MRL], Dpnss, Dpnss, [([Cstart, Cend],MoveScore)|MSRL]) :-
	modifyBrd(Brd,Cstart, Cend, BrdRes),
	1 is mod(Dpnss,2),
	enemyColor(PlayerSide, EnemySide),
	possibleMoves(BrdRes, Cstart, EnemySide, MovesList,_),
	movesScore(PlayerSide, BrdRes, MovesList, MovesScoreList),
	minMove(MovesScoreList, (_, MoveScore)),
	minMaxMovesScore(Brd, Khan, PlayerSide, MRL, Dpnss, Dpnss, MSRL), !.



/*
	boardsFromPiecesList(Brd, piecesList, BrdsList)
	------------------------------
	Retourne la liste complète des plateaux que l'on peut obtenir
	en partant d'une des pièces de piecesList
*/
boardsFromPiecesList(_, [], []) :- !.
boardsFromPiecesList(Brd, [P1|RestPieces], Res) :-
	boardsFrom(3, Brd, P1, SubRes1),
	boardsFromPiecesList(Brd, RestPieces, SubRes2),
	concat(SubRes1, SubRes2, Res).

/* 
	boardsScore(BrdsList, BrdAndScoreList)
	------------------------------
	Associe dans une nouvelle liste BrdAndScoreList
	un plateau et son score évalué
*/
movesScore(_, _, [], []) :- !.
movesScore(PlayerSide, Brd, [[Cstart,Cend]|Q],[([Cstart,Cend],Score)|NextCouples]) :-
	modifyBrd(Brd, Cstart, Cend, BrdRes),
	score(BrdRes, PlayerSide, Score),
	movesScore(PlayerSide, Brd, Q, NextCouples).

/* 
	minBrd(BrdsAndScoreList, Brd)
	------------------------------
	Unifie MinBrdScoreTuple
	avec le tuple (Brd, Score) du plateau
	avec le plus petit score
*/
minMove([FirstMove|Q], MinMoveScoreTuple) :-
	minMove(Q, FirstMove, MinMoveScoreTuple).
minMove([], MinMoveScoreTuple, MinMoveScoreTuple) :- !.
minMove([(Move,Scr)|Q], (_, LocalMinS), MinMoveScoreTuple) :-
	Scr < LocalMinS, !,
	minMove(Q, (Move,Scr), MinMoveScoreTuple).
minMove([_|Q], (LocalMinB, LocalMinS), MinMoveScoreTuple) :-
	minMove(Q, (LocalMinB,LocalMinS), MinMoveScoreTuple).

/* 
	maxBrd(BrdsAndScoreList, Brd)
	------------------------------
	Unifie MaxBrdScoreTuple
	avec le tuple (Brd, Score) du plateau
	avec le plus gros score
*/
maxMove([FirstMove|Q], MaxMoveScoreTuple) :-
	maxMove(Q, FirstMove, MaxMoveScoreTuple).
maxMove([], MaxMoveScoreTuple, MaxMoveScoreTuple) :- !.
maxMove([(Move,Scr)|Q], (_, LocalMaxS), MaxMoveScoreTuple) :-
	Scr > LocalMaxS, !,
	maxMove(Q, (Move,Scr), MaxMoveScoreTuple).
maxMove([_|Q], (LocalMaxB, LocalMaxS), MaxMoveScoreTuple) :-
	maxMove(Q, (LocalMaxB,LocalMaxS), MaxMoveScoreTuple).

/*
	=========================================
	========= FONCTION SCORE ================
	=========================================
*/
/* 
	score(Brd, PlayerSide, Score)
	------------------------------
	Unifie Score avec le score évalué
	par rapport à l'état du plateau dans Brd
	et le côté du joueur (ocre ou rouge) dans PlayerSide
*/
score(Brd, PlayerSide, Score)	:- 
	subScoreOwnKalistaDead(Brd, PlayerSide, SC1),
	SC1 = -10000, Score is SC1, !;
	subScoreEnemyKalistaDead(Brd, PlayerSide, SC2),
	SC2 = 10000, Score is SC2, !;
	subScoreLonelyKalista(Brd, PlayerSide, SC3),
	subScoreLessPiecesThanEnemy(Brd, PlayerSide, SC4),
	subScoreDistanceFromEnemyKalista(Brd, PlayerSide, SC5),
	subScoreNumberOfPower2(Brd,PlayerSide, SC6),
	Score is SC3+SC4+SC5+SC6.


/* 
	subScoreOwnKalistaDead(Brd, PlayerSide, ResultScore)
	------------------------------
	Unifie ResultScore avec :
		- 0 si la Kalista du joueur n'est pas morte
		- -10000 sinon
*/
subScoreOwnKalistaDead(Brd, PlayerSide, ResultScore) :-
	\+positionKalista(Brd, PlayerSide,_),
	ResultScore is -10000, !.
subScoreOwnKalistaDead(_,_, 0).

/* 
	subScoreEnemyKalistaDead(Brd, PlayerSide, ResultScore)
	------------------------------
	Unifie ResultScore avec :
		- 0 si la Kalista ennemie du joueur n'est pas morte
		- 10000 sinon
*/
subScoreEnemyKalistaDead(Brd, PlayerSide, ResultScore) :-
	enemyColor(PlayerSide, EnemySide), \+positionKalista(Brd, EnemySide,_),
	ResultScore is 10000, !.
subScoreEnemyKalistaDead(_,_, 0).

/* 
	subScoreLonelyKalista(Brd, PlayerSide, ResultScore)
	------------------------------
	Unifie ResultScore avec :
		- 350 si la Kalista du joueur est seule
		- 0 sinon
*/
subScoreLonelyKalista(Brd, PlayerSide, ResultScore) :-
	\+notLonelyKalista(Brd, PlayerSide),
	ResultScore is 350, !.
subScoreLonelyKalista(_,_,0).

% sous-prédicat pour le prédicat "subScoreEnemyKalistaDead"
% Retourne vrai si on trouve un sbire du bon côté dans le Brd
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
	subScoreLessPiecesThanEnemy(Brd, PlayerSide, ResultScore)
	------------------------------
	Unifie ResultScore avec :
		50 * (différence de pions entre le joueur et son adversaire)
*/
subScoreLessPiecesThanEnemy(Brd, PlayerSide, ResultScore) :-
	enemyColor(PlayerSide, EnemySide),
	countPieces(Brd, PlayerSide, COUNT1),
	countPieces(Brd, EnemySide, COUNT2),
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
	subScoreDistanceFromEnemyKalista(Brd, PlayerSide, ResultScore)
	------------------------------
	Unifie ResultScore avec :
		la valeur négative de la 3 * distance moyenne entre les pions
		et la kalista ennemie
	Plus la distance moyenne est grande, plus on est pénalisé
*/
subScoreDistanceFromEnemyKalista(Brd, PlayerSide, ResultScore) :-
	enemyColor(PlayerSide, EnemySide),
	positionKalista(Brd, EnemySide, PosEnemyKalista),
	sumDistancesFromEnemyKalista(Brd, PlayerSide, PosEnemyKalista, (1,1), SumDistances),
	countPieces(Brd, PlayerSide, NumberOfPieces),
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
	subScoreNumberOfPower2(Brd, PlayerSide, ResultScore)
	------------------------------
	Unifie ResultScore avec 
		- 25 * (nombre de pions sur une case de 2)
*/
subScoreNumberOfPower2(Brd, PlayerSide, ResultScore) :-
	numberOfPowerX(Brd, PlayerSide, 2, NumberOf2),
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