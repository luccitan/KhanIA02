:- include('tools.pl').
:- include('init.pl').
:- include('engine.pl').

/* 
	initPlayer(PlayerColor, PlayerType, PlayerPieces)
	------------------------------
	Initialise le prédicat dynamique "joueur" de type "PlayerColor"
	en affectant PlayerType et PlayerPieces dans une liste
*/
initPlayer(PlayerColor, PlayerType, PlayerPieces) :-
	asserta((joueur(PlayerColor, PlayerType, PlayerPieces))).

/* 
	setPlayer(PlayerColor, PlayerType, PlayerPieces)
	------------------------------
	Modifie le prédicat existant dynamique "joueur" de type "PlayerColor"
	en affectant PlayerType et PlayerPieces dans une liste
*/
setPlayer(PlayerColor, PlayerType, PlayerPieces) :-
	retract(joueur(PlayerColor,_,_)),
	asserta((joueur(PlayerColor, PlayerType, PlayerPieces))).

/* 
	initTableau(Tab)
	------------------------------
	Initialise le prédicat dynamique du tableau
*/
initTableau(Tab) :-
	assertz(tableau(Tab)).

/* 
	setTableau(Tab)
	------------------------------
	Initialise le prédicat dynamique du tableau
*/
setTableau(Tab) :-
	retract(tableau(_)),
	assertz(tableau(Tab)).