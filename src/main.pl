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
/*
	--------------------------------------------------------------
	-------------------------- NOTES -----------------------------
	----------------------- TEMPORAIRES --------------------------

	- Structure de la liste de pions d'un joueur :
			redPiecesList --> [(s, X1, Y1), (s, X2, Y2), (k, X3, Y3), (s, X4, Y4)]
			ocrePiecesList --> [(k, X1, Y1), (s, X2, Y2), (s, X3, Y3)]

	---------------------------------(-----------------------------
	--------------------------------------------------------------
*/

:- include('print.pl').
:- include('tools.pl').
:- include('engine.pl').
:- include('init.pl').
:- include('minmax.pl').

khan((1,3)).
player(ocre, homme, [(ko,1,2), (so, 3,3)]).
player(rouge, ia, [(so,2,2)]).

/* 
	setPlayer(PlayerColor, PlayerType, PlayerPieces)
	------------------------------
	Modifie le prédicat existant dynamique "joueur" de type "PlayerColor"
	en affectant PlayerType et PlayerPieces dans une liste
	Teste d'abord le retract si il y existe déjà un fait
	Sinon, il l'ajoute.
*/
setPlayer(PlayerColor, PlayerType, PlayerPieces) :-
	retract(player(PlayerColor,_,_)),
	asserta((player(PlayerColor, PlayerType, PlayerPieces))), !.
setPlayer(PlayerColor, PlayerType, PlayerPieces) :-
	asserta((player(PlayerColor, PlayerType, PlayerPieces))), !.


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

:- setBoard([
				[ (2,empty),(2,empty),(3,ko),(1,so),(2,so),(2,so) ],
				[ (1,empty),(3,empty),(1,empty),(3,empty),(1,empty),(3,empty) ],
				[ (3,empty),(1,empty),(2,empty),(2,so),(3,empty),(1,empty) ],
				[ (2,empty),(3,sr),(1,so),(3,sr),(1,empty),(2,empty) ],
				[ (2,empty),(1,empty),(3,sr),(1,empty),(3,empty),(2,empty) ],
				[ (1,empty),(3,kr),(2,empty),(2,empty),(1,empty),(3,empty) ]
]).