:- include('tools.pl').
:- include('init.pl').
:- include('engine.pl').

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