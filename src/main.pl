/*
	=================================
	main.pl
	=================================
	Ce fichier contient les différents prédicats
	qui permettent d'inclure tout le projet
	et contient les initialisations et l'appel de base du jeu
	-------------------------------
*/

:- include('print.pl').
:- include('internaltools.pl').
:- include('externaltools.pl').
:- include('engine.pl').
:- include('init.pl').
:- include('minmax.pl').
:- include('dynamic.pl').

/* 
	============================================================
	============================================================
	Prédicats généraux (boucle de jeu, prédicat de départ, ...)
	============================================================
	============================================================
*/

/*
	startGame
	--------------------------------
	Lance le jeu
*/
startGame :-
	initBoard(Board),
	setBoard(Board),
	setKhan((0,0)),
	gameRoundLoop(rouge).

/*
	gameRoundLoop(PlayerSide)
	--------------------------------
	Round du jeu côté PlayerSide
	Termine si l'une des Kalista est morte.
*/
gameRoundLoop(_) :-
	board(Board), khan(Khan), \+positionKalista(Board, ocre, _), !,
	nl, multipleWSep(2, 60), nl,
	writeln("Le joueur ROUGE est gagnant !"),
	writeln("Tableau de fin :"),
	nl, showBoard(Board, Khan),
	nl, multipleWSep(2, 60), nl.
gameRoundLoop(_) :-
	board(Board), khan(Khan), \+positionKalista(Board, rouge, _), !,
	nl, multipleWSep(2, 60), nl,
	writeln("Le joueur OCRE est gagnant !"),
	writeln("Tableau de fin :"),
	nl, showBoard(Board, Khan),
	nl, multipleWSep(2, 60), nl.
gameRoundLoop(PlayerSide) :-
	board(Board), khan(Khan),
	nl, multipleWSep(3, 60), nl,
	wTab, write("C est au tour du joueur "), write(PlayerSide), writeln(" ..."),
	nl, showBoard(Board, Khan), nl,
	doRound(Board, PlayerSide),
	enemyColor(PlayerSide, EnemySide),
	gameRoundLoop(EnemySide).

/*
	doRound(PlayerSide)
	--------------------------------
	Exécution d'un round
	selon si le joueur est humain ou une IA
*/
doRound(Board, PlayerSide) :-
	player(PlayerSide, ia), !,
	generateMove(Board, PlayerSide, [StartPosition, EndPosition]),
	modifyBoard(Board, StartPosition, EndPosition, BoardRes),
	setKhan(EndPosition), setBoard(BoardRes).	
doRound(Board, PlayerSide) :-
	possibleMoves(Board, PlayerSide, PossibleMoves),
	askTheMove(PossibleMoves, [StartPosition, EndPosition]),
	modifyBoard(Board, StartPosition, EndPosition, BoardRes),
	setKhan(EndPosition), setBoard(BoardRes).

askTheMove(PossibleMoves, Move) :-
	nl, wSep(60), nl,
	repeat,
	wTab, write("Position de depart - de la forme X,Y : "), read(Cstart), nl,
	wTab, write("Position d'arrivee - de la forme X,Y : "), read(Cend), nl,
	moveAskedPossible(Cstart, Cend, PossibleMoves),
	Move = [Cstart,Cend].

moveAskedPossible(Cstart,Cend, PossibleMoves) :-
	\+element([Cstart, Cend], PossibleMoves), !,
	writeln("Le mouvement donne est interdit ... Donnez-en un autre !"),
	fail.
moveAskedPossible(_,_,_).

/* 
	============================================================
	============================================================
	Initialisation du jeu, des paramètres, ...
	============================================================
	============================================================
*/
:- setDifficulty(easy).
:- dynamic player/2.
:- dynamic khan/1.
% Aide débuggage
:- set_prolog_flag(answer_write_options,[max_depth(0)]).