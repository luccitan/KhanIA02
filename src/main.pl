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
	gameRoundLoop(rouge).

/*
	gameRoundLoop(PlayerSide)
	--------------------------------
	Round du jeu côté PlayerSide
	Termine si l'une des Kalista est morte.
*/
gameRoundLoop(_) :-
	board(Board), \+positionKalista(Board, ocre, _), !,
	nl, multipleWSep(4, 60), nl,
	writeln("Le joueur ROUGE est gagnant !").
gameRoundLoop(_) :-
	board(Board),khan(Khan), \+positionKalista(Board, rouge, _), !,
	nl, showBoard(Board, Khan),
	nl, multipleWSep(4, 60), nl,
	writeln("Le joueur OCRE est gagnant !").
gameRoundLoop(PlayerSide) :-
	board(Board), khan(Khan),
	nl, multipleWSep(3, 60), nl,
	wTab, write("C est au tour du joueur "), writeln(PlayerSide),
	doRound(Board, PlayerSide),
	nl, showBoard(Board, Khan), nl,
	enemyColor(PlayerSide, EnemySide),
	gameRoundLoop(EnemySide).

doRound(Board, PlayerSide) :-
	player(PlayerSide, ia), !,
	generateMove(Board, PlayerSide, [StartPosition, EndPosition]),
	modifyBoard(Board, StartPosition, EndPosition, BoardRes),
	setKhan(EndPosition), setBoard(BoardRes).	

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