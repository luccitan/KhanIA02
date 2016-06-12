/*
	=================================
	init.pl
	=================================
	Ce fichier contient les différents prédicats
	qui permettent d'initialiser les joueurs, leurs status,
	le plateau et les pions
	-------------------------------
*/

/*
	baseBoard(N, Board)
	------------------------------
	Unifie Board avec la Nème possibilité
	de plateau initial
*/
baseBoard(1, [
				[ (2,empty),(2,empty),(3,empty),(1,empty),(2,empty),(2,empty) ],
				[ (1,empty),(3,empty),(1,empty),(3,empty),(1,empty),(3,empty) ],
				[ (3,empty),(1,empty),(2,empty),(2,empty),(3,empty),(1,empty) ],
				[ (2,empty),(3,empty),(1,empty),(3,empty),(1,empty),(2,empty) ],
				[ (2,empty),(1,empty),(3,empty),(1,empty),(3,empty),(2,empty) ],
				[ (1,empty),(3,empty),(2,empty),(2,empty),(1,empty),(3,empty) ]
			]).
baseBoard(2, [
				[ (1,empty),(2,empty),(2,empty),(3,empty),(1,empty),(2,empty) ],
				[ (3,empty),(1,empty),(3,empty),(1,empty),(3,empty),(2,empty) ],
				[ (2,empty),(3,empty),(1,empty),(2,empty),(1,empty),(3,empty) ],
				[ (2,empty),(1,empty),(3,empty),(2,empty),(3,empty),(1,empty) ],
				[ (1,empty),(3,empty),(1,empty),(3,empty),(1,empty),(2,empty) ],
				[ (3,empty),(2,empty),(2,empty),(1,empty),(3,empty),(2,empty) ]
			]).
baseBoard(3, [
				[ (3,empty),(1,empty),(2,empty),(2,empty),(3,empty),(1,empty) ],
				[ (2,empty),(3,empty),(1,empty),(3,empty),(1,empty),(2,empty) ],
				[ (2,empty),(1,empty),(3,empty),(1,empty),(3,empty),(2,empty) ],
				[ (1,empty),(3,empty),(2,empty),(2,empty),(1,empty),(3,empty) ],
				[ (3,empty),(1,empty),(3,empty),(1,empty),(3,empty),(1,empty) ],
				[ (2,empty),(2,empty),(1,empty),(3,empty),(2,empty),(2,empty) ]
			]).
baseBoard(4, [
				[ (2,empty),(3,empty),(1,empty),(2,empty),(2,empty),(3,empty) ],
				[ (2,empty),(1,empty),(3,empty),(1,empty),(3,empty),(1,empty) ],
				[ (1,empty),(3,empty),(2,empty),(3,empty),(1,empty),(2,empty) ],
				[ (3,empty),(1,empty),(2,empty),(1,empty),(3,empty),(2,empty) ],
				[ (2,empty),(3,empty),(1,empty),(3,empty),(1,empty),(3,empty) ],
				[ (2,empty),(1,empty),(3,empty),(2,empty),(2,empty),(1,empty) ]
			]).

/* 
	============================================================
	============================================================
	Choix du type de jeu 
		(Homme vs Homme / Homme vs IA / IA vs IA)
	============================================================
	============================================================
*/

/*
	triggerGameTypeChoice(N)
	------------------------------
	Initialise le jeu selon le choix
	du type de rencontre
*/
triggerGameTypeChoice(1) :-
	writeMatchChoiceTypeAlert(1),
	setPlayer(rouge, homme, []),
	setPlayer(ocre, homme, []), !.
triggerGameTypeChoice(2) :-
	writeMatchChoiceTypeAlert(2),
	setPlayer(rouge, homme, []),
	setPlayer(ocre, ia, []), !.
triggerGameTypeChoice(3) :-
	writeMatchChoiceTypeAlert(3),
	setPlayer(rouge, ia, []),
	setPlayer(ocre, ia, []), !.
triggerGameTypeChoice(X) :- writeMatchChoiceTypeAlert(X).

/*
	triggerMatchMenu
	------------------------------
	Déclenche la boucle de menu de choix
	de type de rencontre
*/
triggerMatchMenu :- repeat, typeMatchMenu, !.

/*
	typeMatchMenu
	------------------------------
	Affiche le menu de choix de type de rencontre,
	récupère l'entrée de l'utilisateur,
	et réagit en conséquence
*/
typeMatchMenu :-
	nl,	wSep(20), nl,
	write("1. - "),writeMatchChoiceTypeText(1), nl,
	write("2. - "),writeMatchChoiceTypeText(2), nl,
	write("3. - "),writeMatchChoiceTypeText(3), nl,
	wSep(20), nl,
	write("Entrez un choix : "),
	read(CHOICE), nl, triggerGameTypeChoice(CHOICE),nl.

/* 
	============================================================
	============================================================
	Choix du plateau de jeu
	============================================================
	============================================================
*/

triggerBoardChoice(X) :-
	X > 0, X < 4, !, 
	nl, write("Vous avez choisi le tableau "), write(X), write(" !"),
	baseBoard(X, Board), setBoard(Board), nl.
triggerBoardChoice(_) :-
	nl, write("Veuillez choisir un plateau entre 1 et 4 ... "), nl,
	fail.

/*
	choseBoardMenu
	------------------------------
	Affiche le menu de choix de plateau de départ
	récupère l'entrée de l'utilisateur,
	et réagit en conséquence
*/
choseBoardMenu :-
	nl, wSep(15), nl, 
	write("Choisissez un plateau : (tapez de 1 a 4)"), nl,
	read(CHOICE), nl, triggerBoardChoice(CHOICE), nl.

/*
	choseBoardLoop
	------------------------------
	Lance la boucle de choix du plateau de départ
*/
choseBoardLoop :-
	wSep(50), nl, wTab, wTab, write("Choix du plateau de départ"), nl, wSep(50), nl,
	showAllBaseBoards,
	repeat, choseBoardMenu, !.

/* 
	============================================================
	============================================================
	Positionnement des pions sur le plateau
	A faire : ajouter type de pièce dans un tuple/3
	============================================================
	============================================================
*/

positioningMenu :- 
	baseBoard(1, Board), setBoard(Board),
	nl, nl, wSep(50), nl,
	wTab, write("Positionnement des pieces, camp ROUGE"), nl,
	playerPositioning(Board, rouge, SubBoard),
	nl, nl, wSep(50), nl,
	wTab, write("Positionnement des pieces, camp OCRE"), nl,
	playerPositioning(SubBoard, ocre, ResBoard),
	showBoard(ResBoard, (0,0)),
	setBoard(ResBoard), !.

playerPositioning(Board, PlayerSide, ResBoard) :-
	player(PlayerSide, homme, _), !,
	humanPositioning(Board, 1, PlayerSide, ResBoard).

%positioningMenu :- player(_, homme, _), player(_, ia, _), humanPositioning(1, rouge), positioningAuto(1, ocre), !.
%positioningMenu :- player(_, ia, _), player(_, ia, _), positioningAuto(1, rouge), positioningAuto(1, ocre), !.

humanPositioning(Board, 7, _, Board) :- !.
humanPositioning(Board, 6, PlayerSide, ResBoard) :- 
	repeat, nl, wSep(20), nl,
	showBoard(Board, (0,0)),
	write(" [Joueur "), write(PlayerSide), write("] => position de la Kalista"),
	nl, write("Inserez les coordonnees dans ce format : X,Y"), nl,
	M is 7, read(CHOICE), validPositioning(Board, PlayerSide, CHOICE),
	player(PlayerSide, X, L),
	writePieceIntoPlayer(Board, PlayerSide, kalista, L, CHOICE,  Res, ResBoard),
	setPlayer(PlayerSide, X, Res), humanPositioning(ResBoard, M, PlayerSide, _).

humanPositioning(Board, N, PlayerSide, ResBoard) :- 
	repeat, nl, wSep(20), nl,
	showBoard(Board, (0,0)),
	write(" [Joueur "), write(PlayerSide), write("] => position du sbire "), write(N),
	nl, write("Inserez les coordonnees dans ce format : X,Y"), nl,
	M is N + 1, read(CHOICE), validPositioning(Board, PlayerSide, CHOICE),
	player(PlayerSide, X, L),
	writePieceIntoPlayer(Board, PlayerSide, sbire, L, CHOICE, Res, SubBoard),
	setPlayer(PlayerSide, X, Res), humanPositioning(SubBoard, M, PlayerSide, ResBoard).


writePieceIntoPlayer(Board, rouge, sbire, L, (X,Y), Res, SubBoard) :-
	 concat(L, [(sr,(X,Y))], Res),
	cell(X, Y, Board, (CellPower,_)),
	setCell(Board, (CellPower, sr), (X,Y), SubBoard).

writePieceIntoPlayer(Board, rouge, kalista, L, (X,Y), Res, SubBoard) :-
	concat(L, [(kr, (X,Y))], Res),
	cell(X, Y, Board, (CellPower,_)),
	setCell(Board, (CellPower, kr), (X,Y), SubBoard).

writePieceIntoPlayer(Board, ocre, sbire, L, (X,Y), Res, SubBoard) :-
	concat(L, [(so, (X,Y))], Res),
	cell(X, Y, Board, (CellPower,_)),
	setCell(Board, (CellPower, so), (X,Y), SubBoard).

writePieceIntoPlayer(Board, ocre, kalista, L, (X,Y), Res, SubBoard) :- 
	concat(L, [(ko, (X,Y))], Res),
	cell(X, Y, Board, (CellPower,_)),
	setCell(Board, (CellPower, ko), (X,Y), SubBoard).
