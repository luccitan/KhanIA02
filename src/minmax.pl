/*
	=================================
	========= FONCTION SCORE ========
	=================================
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
	subScoreEnemyKalistaDead(Board, PlayerSide, SC2),
	subScoreLonelyKalista(Board, PlayerSide, SC3),
	subScoreLessPiecesThanEnemy(Board, PlayerSide, SC4),
	subScoreDistanceFromEnemyKalista(Board, PlayerSide, SC5),
	subScoreNumberOfPower2(Board,PlayerSide, SC6),
	Score is SC1+SC2+SC3+SC4+SC5+SC6.

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