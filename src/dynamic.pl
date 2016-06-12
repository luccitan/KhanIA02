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
