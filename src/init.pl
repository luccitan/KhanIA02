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

/*
Positionnement des pions sur le plateau
A faire : ajouter type de pièce dans un tuple/3
*/

positioningMenu :- player(_, homme, _), player(_, homme, _), positioning(1, rouge), positioning(1, ocre), !.
%positioningMenu :- player(_, homme, _), player(_, ia, _), positioning(1, rouge), positioningAuto(1, ocre), !.
%positioningMenu :- player(_, ia, _), player(_, ia, _), positioningAuto(1, rouge), positioningAuto(1, ocre), !.

positioning(6, _) :- !.
positioning(N, PlayerType) :- repeat, nl, wSep(20), nl,
								write("(joueur "), write(PlayerType), write(")"),
								write("Position de la piece "),
								write(N), M is N + 1, read(CHOICE), positionValide(CHOICE),
								player(PlayerType, X, L), concat(L, [CHOICE], Res),
								setPlayer(PlayerType, X, Res), positioning(M, PlayerType).
