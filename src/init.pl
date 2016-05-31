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
				[ (2,0),(2,0),(3,0),(1,0),(2,0),(2,0) ],
				[ (1,0),(3,0),(1,0),(3,0),(1,0),(3,0) ],
				[ (3,0),(1,0),(2,0),(2,0),(3,0),(1,0) ],
				[ (2,0),(3,0),(1,0),(3,0),(1,0),(2,0) ],
				[ (2,0),(1,0),(3,0),(1,0),(3,0),(2,0) ],
				[ (1,0),(3,0),(2,0),(2,0),(1,0),(3,0) ]
			]).
baseBoard(2, [
				[ (1,0),(2,0),(2,0),(3,0),(1,0),(2,0) ],
				[ (3,0),(1,0),(3,0),(1,0),(3,0),(2,0) ],
				[ (2,0),(3,0),(1,0),(2,0),(1,0),(3,0) ],
				[ (2,0),(1,0),(3,0),(2,0),(3,0),(1,0) ],
				[ (1,0),(3,0),(1,0),(3,0),(1,0),(2,0) ],
				[ (3,0),(2,0),(2,0),(1,0),(3,0),(2,0) ]
			]).
baseBoard(3, [
				[ (3,0),(1,0),(2,0),(2,0),(3,0),(1,0) ],
				[ (2,0),(3,0),(1,0),(3,0),(1,0),(2,0) ],
				[ (2,0),(1,0),(3,0),(1,0),(3,0),(2,0) ],
				[ (1,0),(3,0),(2,0),(2,0),(1,0),(3,0) ],
				[ (3,0),(1,0),(3,0),(1,0),(3,0),(1,0) ],
				[ (2,0),(2,0),(1,0),(3,0),(2,0),(2,0) ]
			]).
baseBoard(4, [
				[ (2,0),(3,0),(1,0),(2,0),(2,0),(3,0) ],
				[ (2,0),(1,0),(3,0),(1,0),(3,0),(1,0) ],
				[ (1,0),(3,0),(2,0),(3,0),(1,0),(2,0) ],
				[ (3,0),(1,0),(2,0),(1,0),(3,0),(2,0) ],
				[ (2,0),(3,0),(1,0),(3,0),(1,0),(3,0) ],
				[ (2,0),(1,0),(3,0),(2,0),(2,0),(1,0) ]
			]).


writeSeperator :- write("---------").

/* 
	writeChoice(N)
	------------------------------
	Affiche la confirmation de choix
	de types de partie (Homme/IA vs Homme/IA)
*/
writeMatchChoiceTypeAlert(N) :- 
	N>0, N<4, !,
	write("Vous avez choisi le choix '"), writeChoiceText(N), write("' !"), nl.
writeMatchChoiceTypeAlert(_) :- nl, write("/!\\ Vous avez fait un mauvais choix ! Recommencez !"), fail.

/* 
	writeChoiceText(N)
	------------------------------
	Affiche le choix de la Nème
	possibilité de match 
*/
writeMatchChoiceTypeText(1) :- write("Homme vs Homme."), !.
writeMatchChoiceTypeText(2) :- write("Homme vs IA."), !.
writeMatchChoiceTypeText(3) :- write("IA vs IA."), !.


/* 
	triggerIAChoice(N)
	------------------------------
	Initialise le jeu selon le choix
	du type de rencontre
*/
triggerIAChoice(1) :-
	writeMatchChoiceTypeAlert(1),
	initPlayer(rouge, homme, []),
	initPlayer(ocre, homme, []), !.
triggerIAChoice(2) :-
	writeMatchChoiceTypeAlert(2),
	initPlayer(rouge, homme, []),
	initPlayer(ocre, ia, []), !.
triggerIAChoice(3) :-
	writeMatchChoiceTypeAlert(3),
	initPlayer(rouge, ia, []),
	initPlayer(ocre, ia, []), !.
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
	nl,
	writeSeperator,
	nl,
	write("1. - "),writeMatchChoiceTypeText(1), nl,
	write("2. - "),writeMatchChoiceTypeText(2), nl,
	write("3. - "),writeMatchChoiceTypeText(3), nl,
	write("Entrez un choix : "),
	read(CHOICE), nl, triggerIAChoice(CHOICE), nl.
