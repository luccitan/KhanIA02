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
				[ (2,vide),(2,vide),(3,vide),(1,vide),(2,vide),(2,vide) ],
				[ (1,vide),(3,vide),(1,vide),(3,vide),(1,vide),(3,vide) ],
				[ (3,vide),(1,vide),(2,vide),(2,vide),(3,vide),(1,vide) ],
				[ (2,vide),(3,vide),(1,vide),(3,vide),(1,vide),(2,vide) ],
				[ (2,vide),(1,vide),(3,vide),(1,vide),(3,vide),(2,vide) ],
				[ (1,vide),(3,vide),(2,vide),(2,vide),(1,vide),(3,vide) ]
			]).
baseBoard(2, [
				[ (1,vide),(2,vide),(2,vide),(3,vide),(1,vide),(2,vide) ],
				[ (3,vide),(1,vide),(3,vide),(1,vide),(3,vide),(2,vide) ],
				[ (2,vide),(3,vide),(1,vide),(2,vide),(1,vide),(3,vide) ],
				[ (2,vide),(1,vide),(3,vide),(2,vide),(3,vide),(1,vide) ],
				[ (1,vide),(3,vide),(1,vide),(3,vide),(1,vide),(2,vide) ],
				[ (3,vide),(2,vide),(2,vide),(1,vide),(3,vide),(2,vide) ]
			]).
baseBoard(3, [
				[ (3,vide),(1,vide),(2,vide),(2,vide),(3,vide),(1,vide) ],
				[ (2,vide),(3,vide),(1,vide),(3,vide),(1,vide),(2,vide) ],
				[ (2,vide),(1,vide),(3,vide),(1,vide),(3,vide),(2,vide) ],
				[ (1,vide),(3,vide),(2,vide),(2,vide),(1,vide),(3,vide) ],
				[ (3,vide),(1,vide),(3,vide),(1,vide),(3,vide),(1,vide) ],
				[ (2,vide),(2,vide),(1,vide),(3,vide),(2,vide),(2,vide) ]
			]).
baseBoard(4, [
				[ (2,vide),(3,vide),(1,vide),(2,vide),(2,vide),(3,vide) ],
				[ (2,vide),(1,vide),(3,vide),(1,vide),(3,vide),(1,vide) ],
				[ (1,vide),(3,vide),(2,vide),(3,vide),(1,vide),(2,vide) ],
				[ (3,vide),(1,vide),(2,vide),(1,vide),(3,vide),(2,vide) ],
				[ (2,vide),(3,vide),(1,vide),(3,vide),(1,vide),(3,vide) ],
				[ (2,vide),(1,vide),(3,vide),(2,vide),(2,vide),(1,vide) ]
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
