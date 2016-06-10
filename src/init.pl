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
	triggerIAChoice(N)
	------------------------------
	Initialise le jeu selon le choix
	du type de rencontre
*/
triggerIAChoice(1) :-
	writeMatchChoiceTypeAlert(1),
	setPlayer(rouge, homme, []),
	setPlayer(ocre, homme, []), !.
triggerIAChoice(2) :-
	writeMatchChoiceTypeAlert(2),
	setPlayer(rouge, homme, []),
	setPlayer(ocre, ia, []), !.
triggerIAChoice(3) :-
	writeMatchChoiceTypeAlert(3),
	setPlayer(rouge, ia, []),
	setPlayer(ocre, ia, []), !.
triggerIAChoice(X) :- writeMatchChoiceTypeAlert(X).

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
	read(CHOICE), nl, triggerIAChoice(CHOICE), nl.

/*Choix du plateau de jeu*/



/*
Positionnement des pions sur le plateau
A faire : ajouter type de pièce dans un tuple/3
*/

positioningMenu :- baseBoard(1, Board), setBoard(Board), player(_, homme, _),
player(_, homme, _), positioning(Board, 1, rouge, ResBoard), setBoard(ResBoard), positioning(ResBoard, 1, ocre, Board), setBoard(Board), !.
%positioningMenu :- player(_, homme, _), player(_, ia, _), positioning(1, rouge), positioningAuto(1, ocre), !.
%positioningMenu :- player(_, ia, _), player(_, ia, _), positioningAuto(1, rouge), positioningAuto(1, ocre), !.

positioning(_, 7, _, _) :- !.
positioning(Board, 6, PlayerType, ResBoard) :- repeat, nl, wSep(20), nl,
								write("(joueur "), write(PlayerType), write(")"),
								write("Position de la piece Kalista"),
								M is 7, read(CHOICE), positionValide(CHOICE),
								player(PlayerType, X, L),
								writePieceIntoPlayer(Board, PlayerType, kalista, L, CHOICE,  Res, ResBoard),
								setPlayer(PlayerType, X, Res), positioning(ResBoard, M, PlayerType, _).

positioning(Board, N, PlayerType, ResBoard) :- repeat, nl, wSep(20), nl,
								write("(joueur "), write(PlayerType), write(")"),
								write("Position de la piece sbire "),
								write(N), M is N + 1, read(CHOICE), positionValide(CHOICE),
								player(PlayerType, X, L),
								writePieceIntoPlayer(Board, PlayerType, sbire, L, CHOICE, Res, ResBoard),
								setPlayer(PlayerType, X, Res), positioning(ResBoard, M, PlayerType, _).


writePieceIntoPlayer(Board, rouge, sbire, L, (X,Y), Res, SubBoard) :- concat(L, [(sr,(X,Y))], Res),
cell(X, Y, Board, (CellPower,_)),
setCell(Board, (CellPower, sr), (X,Y), SubBoard).

writePieceIntoPlayer(Board, rouge, kalista, L, (X,Y), Res, SubBoard) :- concat(L, [(kr, (X,Y))], Res),
cell(X, Y, Board, (CellPower,_)),
setCell(Board, (CellPower, kr), (X,Y), SubBoard).

writePieceIntoPlayer(Board, ocre, sbire, L, (X,Y), Res, SubBoard) :- concat(L, [(so, (X,Y))], Res),
cell(X, Y, Board, (CellPower,_)),
setCell(Board, (CellPower, so), (X,Y), SubBoard).

writePieceIntoPlayer(Board, ocre, kalista, L, (X,Y), Res, SubBoard) :- concat(L, [(ko, (X,Y))], Res),
cell(X, Y, Board, (CellPower,_)),
setCell(Board, (CellPower, ko), (X,Y), SubBoard).
