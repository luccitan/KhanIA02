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

/*
	setPlayer(PlayerColor, PlayerType, PlayerPieces)
	------------------------------
	Modifie le prédicat existant dynamique "joueur" de type "PlayerColor"
	en affectant PlayerType et PlayerPieces dans une liste
	Teste d'abord le retract si il y existe déjà un fait
	Sinon, il l'ajoute.
*/
setPlayer(PlayerColor, PlayerType) :-
	retract(player(PlayerColor,_)),
	asserta((player(PlayerColor, PlayerType))), !.
setPlayer(PlayerColor, PlayerType) :-
	asserta((player(PlayerColor, PlayerType))), !.


/*
	setTableau(Tab)
	------------------------------
	Modifie le prédicat dynamique du tableau
	Teste d'abord le retract si il y existe déjà un fait
	Sinon, il l'ajoute.
*/
setBoard(Board) :-
	retract(board(_)),
	assertz(board(Board)), !.
setBoard(Board) :-
	assertz(board(Board)).

/*
	setKhan(Tab)
	------------------------------
	Modifie le prédicat dynamique du Khân
	Teste d'abord le retract si il y existe déjà un fait
	Sinon, il l'ajoute.
*/
setKhan(Khan) :-
	retract(khan(_)),
	assertz(khan(Khan)), !.
setKhan(Khan) :-
	assertz(khan(Khan)).

/*
	setDifficulty(difficulty)
	------------------------------
	Modifie le prédicat dynamique de la difficulté
*/
setDifficulty(Difficulty) :-
	correspDifficulty(Difficulty, Deepness),
	retract(difficulty(_)), assertz(difficulty(Deepness)), !.
setDifficulty(Difficulty) :-
	correspDifficulty(Difficulty, Deepness),
	assertz(difficulty(Deepness)).

correspDifficulty(easy, 1).
correspDifficulty(normal, 2).
correspDifficulty(hard, 3).

:- setBoard([
				[ (2,empty),(2,empty),(3,ko),(1,so),(2,so),(2,so) ],
				[ (1,empty),(3,empty),(1,empty),(3,so),(1,empty),(3,empty) ],
				[ (3,empty),(1,empty),(2,empty),(2,so),(3,empty),(1,empty) ],
				[ (2,empty),(3,empty),(1,empty),(3,sr),(1,empty),(2,empty) ],
				[ (2,empty),(1,empty),(3,empty),(1,sr),(3,empty),(2,empty) ],
				[ (1,empty),(3,kr),(2,empty),(2,empty),(1,empty),(3,empty) ]
]).

:- setDifficulty(easy).
:- dynamic player/2.
:- dynamic khan/1.
% Aide débuggage
:- set_prolog_flag(answer_write_options,[max_depth(0)]).