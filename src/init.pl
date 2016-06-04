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

positioning(7, _) :- !.
positioning(6, PlayerType) :- repeat, nl, wSep(20), nl,
								write("(joueur "), write(PlayerType), write(")"),
								write("Position de la piece Kalista"),
								M is 7, read(CHOICE), positionValide(CHOICE),
								player(PlayerType, X, L),
								writePieceIntoPlayer(PlayerType, kalista, L, CHOICE, Res),
								setPlayer(PlayerType, X, Res), positioning(M, PlayerType).

positioning(N, PlayerType) :- repeat, nl, wSep(20), nl,
								write("(joueur "), write(PlayerType), write(")"),
								write("Position de la piece sbire "),
								write(N), M is N + 1, read(CHOICE), positionValide(CHOICE),
								player(PlayerType, X, L),
								writePieceIntoPlayer(PlayerType, sbire, L, CHOICE, Res),
								setPlayer(PlayerType, X, Res), positioning(M, PlayerType).


writePieceIntoPlayer(rouge, sbire, L, CHOICE, Res) :- concat(L, [(sr,CHOICE)], Res).

writePieceIntoPlayer(rouge, kalista, L, CHOICE, Res) :- concat(L, [(kr, CHOICE)], Res).

writePieceIntoPlayer(ocre, sbire, L, CHOICE, Res) :- concat(L, [(so, CHOICE)], Res).

writePieceIntoPlayer(ocre, kalista, L, CHOICE, Res) :- concat(L, [(ko, CHOICE)], Res).


/*

modificationPlateau((X,Y)) :- baseBoard(1, board), parcoursSousListe(board, (X,Y), 1).

parcoursSousListe([T|Q], (X,Y), I) :- I = X, parcoursListe([T|Q], (X,Y), 1), !.
parcoursSousListe([T|Q], (X,Y), I) :- I < X, K IS I + 1, parcousSousListe([T|Q], (X,Y), K).

parcoursListe([T|Q], (X,Y), J) :- J = Y, modifierPosition(T), !.
parcoursListe([T|Q], (X,Y), J) :- J < Y, L IS J + 1, parcoursListe([T|Q], (X,Y), L).


modifierPosition((V1,V2)) :-

*/
