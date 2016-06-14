/*
	=================================
	dynamic.pl
	=================================
	Ce fichier contient la gestion
	des différents prédicats dynamiques
	-------------------------------
*/

/*
	setPlayer(PlayerColor, PlayerType, PlayerPieces)
	------------------------------
	Modifie le prédicat existant dynamique "joueur" de type "PlayerColor"
	en affectant PlayerType et PlayerPieces dans une liste
	Teste d'abord le retract si il y existe déjà un fait
	Sinon, il l'ajoute.
*/
setPlayer(PlayerColor, PlayerType) :-
	retractall(player(PlayerColor,_)),
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
setBrd(Brd) :-
	retractall(board(_)),
	assertz(board(Brd)), !.
setBrd(Brd) :-
	assertz(board(Brd)).

/*
	setKhan(Tab)
	------------------------------
	Modifie le prédicat dynamique du Khân
	Teste d'abord le retract si il y existe déjà un fait
	Sinon, il l'ajoute.
*/
setKhan(Khan) :-
	retractall(khan(_)),
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
