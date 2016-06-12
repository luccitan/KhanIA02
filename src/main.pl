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
	Boucle de départ
	--------------------------------
	Lance le jeu
*//*
startGame :-
	initBoard(Board),
	setBoard(Board),
	gameRoundLoop.*/

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