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
	retract(joueur(PlayerColor,_,_)),
	asserta((joueur(PlayerColor, PlayerType, PlayerPieces))), !.
setPlayer(PlayerColor, PlayerType, PlayerPieces) :-
	asserta((joueur(PlayerColor, PlayerType, PlayerPieces))), !.


/* 
	setTableau(Tab)
	------------------------------
	Modifie le prédicat dynamique du tableau
	Teste d'abord le retract si il y existe déjà un fait
	Sinon, il l'ajoute.
*/
setTableau(Tab) :-
	retract(tableau(_)),
	assertz(tableau(Tab)), !.
setTableau(Tab) :-
	assertz(tableau(Tab)).