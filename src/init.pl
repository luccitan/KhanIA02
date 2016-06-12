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
	Correspondance des difficultés
	--------------------------------
	Utilisé pour la génération de mouvements dans l'IA.
	Cela correspond à la profondeur de mouvement prévue 
	par l'IA.
*/
correspDifficulty(easy, 1).
correspDifficulty(normal, 2).
correspDifficulty(hard, 3).

% ========================
% Prédicat d'intialisation
% ========================
initBoard(Board) :-
	triggerMatchMenu,
	choseBoardLoop(InitialBoard),
	positioningPhase(InitialBoard, Board),
	setBoard(Board).

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
	setPlayer(rouge, homme),
	setPlayer(ocre, homme), !.
triggerGameTypeChoice(2) :-
	writeMatchChoiceTypeAlert(2),
	setPlayer(rouge, homme),
	setPlayer(ocre, ia), !.
triggerGameTypeChoice(3) :-
	writeMatchChoiceTypeAlert(3),
	setPlayer(rouge, ia),
	setPlayer(ocre, ia), !.
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
	nl, wSep(60), nl, wSep(60), nl,
	write("1. - "),writeMatchChoiceTypeText(1), nl,
	write("2. - "),writeMatchChoiceTypeText(2), nl,
	write("3. - "),writeMatchChoiceTypeText(3), nl,
	wSep(60), nl, wSep(60), nl,
	write("Entrez un choix : "),
	read(CHOICE), nl, triggerGameTypeChoice(CHOICE),nl.

/* 
	============================================================
	============================================================
	Choix du plateau de jeu
	============================================================
	============================================================
*/

triggerBoardChoice(X, Board) :-
	X > 0, X < 4, !, 
	nl, write("Vous avez choisi le tableau "), write(X), write(" !"),
	baseBoard(X, Board), nl.
triggerBoardChoice(_,_) :-
	nl, write("Veuillez choisir un plateau entre 1 et 4 ... "), nl,
	fail.

/*
	choseBoardMenu
	------------------------------
	Affiche le menu de choix de plateau de départ
	récupère l'entrée de l'utilisateur,
	et réagit en conséquence
*/
choseBoardMenu(Board) :-
	nl, wSep(15), nl, 
	write("Choisissez un plateau : (tapez de 1 a 4)"), nl,
	read(CHOICE), nl, triggerBoardChoice(CHOICE, Board), nl.

/*
	choseBoardLoop
	------------------------------
	Lance la boucle de choix du plateau de départ
*/
choseBoardLoop(Board) :-
	wSep(50), nl, wTab, wTab, write("Choix du plateau de depart"), nl, wSep(50), nl,
	showAllBaseBoards,
	repeat, choseBoardMenu(Board), !.

/* 
	============================================================
	============================================================
	Positionnement des pions sur le plateau
	A faire : ajouter type de pièce dans un tuple/3
	============================================================
	============================================================
*/

/*
	positioningPhase
	------------------------------
	Lance les différentes étapes de positionnement
	des pièces
*/
positioningPhase(Board, ResBoard) :- 
	nl, nl, multipleWSep(3, 60), 
	wTab, write("Positionnement des pieces, camp ROUGE"), nl,
	playerPositioning(Board, rouge, SubBoard),
	nl, nl, multipleWSep(3, 60), 
	wTab, write("Positionnement des pieces, camp OCRE"), nl,
	playerPositioning(SubBoard, ocre, ResBoard),
	nl, multipleWSep(4, 60), 
	nl, writeln("Plateau de depart : "),
	showBoard(ResBoard, (0,0)), !.

/*
	playerPositioning
	------------------------------
	Lance le positionnement (IA ou Homme)
	selon le type de joueur qu'est le joueur
	du camp PlayerSide.
	Unifie le résultat du positionnement avec ResBoard.
*/
playerPositioning(Board, PlayerSide, ResBoard) :-
	player(PlayerSide, homme), !,
	humanPositioningMenu(Board, 1, PlayerSide, ResBoard).
playerPositioning(Board, PlayerSide, ResBoard) :-
	iaPositioningMenu(Board, 1, PlayerSide, ResBoard).

/*
	humanPositioningMenu
	------------------------------
	Lance le positionnement humain du joueur
	du camp PlayerSide
	Unifie le résultat du positionnement avec ResBoard.
*/
humanPositioningMenu(Board, 6, PlayerSide, ResBoard) :- 
	repeat, nl, wSep(20), nl,
	showBoard(Board, (0,0)),
	write(" [Joueur "), write(PlayerSide), writeln("] => position de la Kalista"),
	writeln("Inserez les coordonnees dans ce format : X,Y"),
	read(CHOICE), validPositioning(Board, PlayerSide, CHOICE, CellPower),
	pieceType(PlayerSide, kalista, Type),
	setCell(Board, (CellPower, Type), CHOICE, ResBoard).
humanPositioningMenu(Board, N, PlayerSide, ResBoard) :- 
	repeat, nl, wSep(20), nl,
	showBoard(Board, (0,0)),
	write(" [Joueur "), write(PlayerSide), write("] => position du sbire "),
	writeln(N), writeln("Inserez les coordonnees dans ce format : X,Y"),
	read(CHOICE),validPositioning(Board, PlayerSide, CHOICE, CellPower),
	M is N + 1,
	pieceType(PlayerSide, sbire, Type),
	setCell(Board, (CellPower, Type), CHOICE, SubBoard),
	humanPositioningMenu(SubBoard, M, PlayerSide, ResBoard).

/*
	iaPositioningMenu
	------------------------------
	Lance le positionnement IA du joueur
	du camp PlayerSide
	Unifie le résultat du positionnement avec ResBoard.
*/
iaPositioningMenu(Board, 7, PlayerSide, Board) :- 
	nl, write("Positionnement de l'IA du camp "), writeln(PlayerSide),
	showBoard(Board, (0,0)), !.
iaPositioningMenu(Board, 6, PlayerSide, ResBoard) :-
	repeat, generateRandomStartPosition(PlayerSide, (X,Y)),
	cell(X,Y, Board, (CellPower,empty)),
	pieceType(PlayerSide, kalista, Type),
	setCell(Board, (CellPower, Type), (X,Y), SubBoard),
	iaPositioningMenu(SubBoard, 7, PlayerSide, ResBoard).
iaPositioningMenu(Board, N, PlayerSide, ResBoard) :-
	repeat, generateRandomStartPosition(PlayerSide, (X,Y)),
	cell(X,Y, Board, (CellPower,empty)),
	M is N+1,
	pieceType(PlayerSide, sbire, Type),
	setCell(Board, (CellPower, Type), (X,Y), SubBoard),
	iaPositioningMenu(SubBoard, M, PlayerSide, ResBoard).

generateRandomStartPosition(ocre, (X,Y)) :-
	random(1,3,X), random(1,7,Y).
generateRandomStartPosition(rouge, (X,Y)) :-
	random(5,7,X), random(1,7,Y).
