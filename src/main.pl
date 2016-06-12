/*
	=================================
	main.pl
	=================================
	Ce fichier contient les différents prédicats
	qui permettent d'inclure tout le projet
	et de gérer les prédicats dynamiques utiles
	au jeu
	-------------------------------
*/

:- include('print.pl').
:- include('tools.pl').
:- include('engine.pl').
:- include('init.pl').
:- include('minmax.pl').
:- include('dynamic.pl').

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
:- setBoard([
				[ (2,empty),(2,empty),(3,ko),(1,so),(2,so),(2,so) ],
				[ (1,empty),(3,empty),(1,empty),(3,so),(1,empty),(3,empty) ],
				[ (3,empty),(1,empty),(2,empty),(2,so),(3,empty),(1,empty) ],
				[ (2,empty),(3,empty),(1,empty),(3,sr),(1,empty),(2,empty) ],
				[ (2,empty),(1,empty),(3,empty),(1,sr),(3,empty),(2,empty) ],
				[ (1,empty),(3,kr),(2,empty),(2,empty),(1,empty),(3,empty) ]
]).*/

:- setDifficulty(easy).
:- dynamic player/2.
:- dynamic khan/1.
% Aide débuggage
:- set_prolog_flag(answer_write_options,[max_depth(0)]).