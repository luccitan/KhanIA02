% ------------------------------------------------------------------
%	@developer : Tanguy LUCCI, UTC Student
%	@developer : Alexandre-Guillaume GUILBERT, UTC Student
% ------------------------------------------------------------------


% ==================================================================================
%							ALGORITHME MinMax			
% ==================================================================================

% L'algorithme MinMax présente un désavantage :
% 	 => si la prévision se fait trop loin, la possibilité simple de
%	 manger la Kalista ennemie peut être évitée.
% Pour cela, on teste d'abord la profondeur 1, et on regarde si on peut
% manger directement la Kalista ennemie. 
%     - Si oui, on le fait directement
%	  - Sinon, si une profondeur plus grande était recherchée, 
%     on réitère en incrémentant la profondeur de test
% On s'arrêtera donc au maximum à la profondeur maximale fixée (== difficulté)

generateMove(Brd, Khan, PlayerSide, BestMove) :-
	difficulty(Deepness),
	generateMove(Brd, Khan, PlayerSide, BestMove, 1, Deepness), !.

% Cas où l'itération d'essai est la profondeur maximale autorisée
generateMove(Brd, Khan, PlayerSide, BestMove, Deeptry, Deeptry) :-
	minMax(Brd, Khan, PlayerSide, Deeptry, (BestMove,_)), !.
% Cas où l'itération d'essai amène à une victoire instantanée : on la privilégie
generateMove(Brd, Khan, PlayerSide, BestMove, DeepTry, _) :-
	minMax(Brd, Khan, PlayerSide, DeepTry, ([Cstart,Cend],_)),
	createBrd(Brd, Cstart, Cend, BrdRes),
	enemyColor(PlayerSide, EnemySide), \+positionKalista(BrdRes, EnemySide, _),
	BestMove = [Cstart, Cend], !.
% Cas par défaut : on essaie de prévoir plus loin.
generateMove(Brd, Khan, PlayerSide, BestMove, DeepTry, Deepness) :-
	minMax(Brd, Khan, PlayerSide, DeepTry, ([Cstart,Cend],_)),
	createBrd(Brd, Cstart, Cend, BrdRes),
	enemyColor(PlayerSide, EnemySide), positionKalista(BrdRes, EnemySide, _),
	NextTry is DeepTry + 1,
	generateMove(Brd, Khan, PlayerSide, BestMove, NextTry, Deepness).


/*
	minMax(Brd,Khan, PlayerSide, ResBrd)
	------------------------------
	Unifie ResBrd avec le plateau optimal
	selon l'algorithme MinMax

	BestMove de la forme
	[(Xstart, Ystart), (Xend, Yend)]
*/
minMax(Brd, Khan, PlayerSide, 1, BestMoveTuple) :-
	possibleMoves(Brd, Khan, PlayerSide, MovesList,_),
	movesScore(PlayerSide, Brd, MovesList, MovesScoreList),
	maxMove(MovesScoreList, BestMoveTuple), !.
minMax(Brd, Khan, PlayerSide, Deepness, BestMoveTuple) :-
	possibleMoves(Brd, Khan, PlayerSide, MovesList,_),
	SubDeepness is Deepness - 1,
	minMaxMovesScore(Brd, Khan, PlayerSide, MovesList, SubDeepness, 1, MovesScoreList),
	maxMove(MovesScoreList, BestMoveTuple).

% --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- 
% 			Prédicat minMaxMovesScore
%	Utilisé pour générer les arborescences de mouvements et faire 'remonter' leur score
%	jusqu'aux mouvements de "profondeur 1"
% --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- 

minMaxMovesScore(_,_,_, [],_,_, []) :- !.

% Cas où on a atteint la profondeur maximale (Profondeur = Itération)
% 	- Profondeur impaire => on est en 'position MIN'
%   - Profondeur paire => on est en 'position MAX'
minMaxMovesScore(Brd, Khan, PlayerSide, [[Cstart,Cend]|MRL], Dpnss, Dpnss, [([Cstart, Cend],MoveScore)|MSRL]) :-
	createBrd(Brd,Cstart, Cend, BrdRes),
	1 is mod(Dpnss,2),
	enemyColor(PlayerSide, EnemySide),
	possibleMoves(BrdRes, Cstart, EnemySide, MovesList,_),
	movesScore(PlayerSide, BrdRes, MovesList, MovesScoreList),
	minMove(MovesScoreList, (_, MoveScore)),
	minMaxMovesScore(Brd, Khan, PlayerSide, MRL, Dpnss, Dpnss, MSRL), !.
minMaxMovesScore(Brd, Khan, PlayerSide, [[Cstart,Cend]|MRL], Dpnss, Dpnss, [([Cstart, Cend],MoveScore)|MSRL]) :-
	createBrd(Brd,Cstart, Cend, BrdRes),
	possibleMoves(BrdRes, Cstart, PlayerSide, MovesList,_),
	movesScore(PlayerSide, BrdRes, MovesList, MovesScoreList),
	maxMove(MovesScoreList, (_, MoveScore)),
	minMaxMovesScore(Brd, Khan, PlayerSide, MRL, Dpnss, Dpnss, MSRL), !.

% Cas d'une profondeur intermédiaire
% 	- Profondeur impaire => on est en 'position MIN'
%%  - Profondeur paire => on est en 'position MAX'
minMaxMovesScore(Brd,Khan,PlayerSide,[[Cstart,Cend]|MRL],Dpnss,Iteration,[([Cstart, Cend],MoveScore)|MSRL]) :-
	createBrd(Brd, Cstart, Cend, BrdRes),
	1 is mod(Dpnss,2),
	enemyColor(PlayerSide, EnemySide),
	possibleMoves(BrdRes, Cstart, EnemySide, MovesList,_),
	NextIteration is Iteration + 1,
	minMaxMovesScore(Brd, Khan, PlayerSide, MovesList, Dpnss, NextIteration, MovesScoreList),
	minMove(MovesScoreList, (_,MoveScore)),
	minMaxMovesScore(Brd, Khan, PlayerSide, MRL, Dpnss, Iteration, MSRL), !.
minMaxMovesScore(Brd,Khan,PlayerSide,[[Cstart,Cend]|MRL],Dpnss,Iteration,[([Cstart, Cend],MoveScore)|MSRL]) :-
	createBrd(Brd, Cstart, Cend, BrdRes),
	possibleMoves(BrdRes, Cstart, PlayerSide, MovesList,_),
	NextIteration is Iteration + 1,
	minMaxMovesScore(Brd, Khan, PlayerSide, MovesList, Dpnss, NextIteration, MovesScoreList),
	minMove(MovesScoreList, (_,MoveScore)),
	minMaxMovesScore(Brd, Khan, PlayerSide, MRL, Dpnss, Iteration, MSRL).

% --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- 
% --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- 

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
	createBrd(Brd, Cstart, Cend, BrdRes),
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

% ==================================================================================
%							FONCTION Score			
% ==================================================================================

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