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
:- include('tools.pl').
:- include('engine.pl').
:- include('init.pl').
:- include('minmax.pl').
:- include('dynamic.pl').
:- setDifficulty(easy).
:- dynamic player/2.
:- dynamic khan/1.
% Aide débuggage
:- set_prolog_flag(answer_write_options,[max_depth(0)]).

/*
	Correspondance des difficultés
	--------------------------------
	Utilisé pour la génération de mouvements dans l'IA.
	Cela correspond à la profondeur de mouvement prévue 
	par l'IA.
*/
correspDifficulty(easy, 1).
correspDifficulty(normal, 2).
correspDifficulty(hard, 3).

/*
	Boucle de départ
	--------------------------------
	Lance le jeu
*/
startGame :-
	initBoard(Board),
	setBoard(Board),
	gameRoundLoop.


