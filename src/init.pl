% ------------------------------------------------------------------
%	@developer : Tanguy LUCCI, UTC Student
%	@developer : Alexandre-Guillaume GUILBERT, UTC Student
% ------------------------------------------------------------------


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
initBrd(Brd) :-
	triggerMatchMenu,
	choseBrdLoop(InitialBrd),
	positioningPhase(InitialBrd, Brd),
	setBrd(Brd).

/*
	baseBrd(N, Brd)
	------------------------------
	Unifie Brd avec la Nème possibilité
	de plateau initial
*/
baseBrd(1, [
				[ (2,empty),(2,empty),(3,empty),(1,empty),(2,empty),(2,empty) ],
				[ (1,empty),(3,empty),(1,empty),(3,empty),(1,empty),(3,empty) ],
				[ (3,empty),(1,empty),(2,empty),(2,empty),(3,empty),(1,empty) ],
				[ (2,empty),(3,empty),(1,empty),(3,empty),(1,empty),(2,empty) ],
				[ (2,empty),(1,empty),(3,empty),(1,empty),(3,empty),(2,empty) ],
				[ (1,empty),(3,empty),(2,empty),(2,empty),(1,empty),(3,empty) ]
			]).
baseBrd(2, [
				[ (1,empty),(2,empty),(2,empty),(3,empty),(1,empty),(2,empty) ],
				[ (3,empty),(1,empty),(3,empty),(1,empty),(3,empty),(2,empty) ],
				[ (2,empty),(3,empty),(1,empty),(2,empty),(1,empty),(3,empty) ],
				[ (2,empty),(1,empty),(3,empty),(2,empty),(3,empty),(1,empty) ],
				[ (1,empty),(3,empty),(1,empty),(3,empty),(1,empty),(2,empty) ],
				[ (3,empty),(2,empty),(2,empty),(1,empty),(3,empty),(2,empty) ]
			]).
baseBrd(3, [
				[ (3,empty),(1,empty),(2,empty),(2,empty),(3,empty),(1,empty) ],
				[ (2,empty),(3,empty),(1,empty),(3,empty),(1,empty),(2,empty) ],
				[ (2,empty),(1,empty),(3,empty),(1,empty),(3,empty),(2,empty) ],
				[ (1,empty),(3,empty),(2,empty),(2,empty),(1,empty),(3,empty) ],
				[ (3,empty),(1,empty),(3,empty),(1,empty),(3,empty),(1,empty) ],
				[ (2,empty),(2,empty),(1,empty),(3,empty),(2,empty),(2,empty) ]
			]).
baseBrd(4, [
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

triggerBrdChoice(X, Brd) :-
	X >= 1, X =< 4, !, 
	nl, write("Vous avez choisi le tableau "), write(X), write(" !"),
	baseBrd(X, Brd), nl.
triggerBrdChoice(_,_) :-
	nl, write("Veuillez choisir un plateau entre 1 et 4 ... "), nl,
	fail.

/*
	choseBrdMenu
	------------------------------
	Affiche le menu de choix de plateau de départ
	récupère l'entrée de l'utilisateur,
	et réagit en conséquence
*/
choseBrdMenu(Brd) :-
	nl, wSep(15), nl, 
	write("Choisissez un plateau : (tapez de 1 a 4)"), nl,
	read(CHOICE), nl, triggerBrdChoice(CHOICE, Brd), nl.

/*
	choseBrdLoop
	------------------------------
	Lance la boucle de choix du plateau de départ
*/
choseBrdLoop(Brd) :-
	wSep(50), nl, wTab, wTab, write("Choix du plateau de depart"), nl, wSep(50), nl,
	showAllBaseBrds,
	repeat, choseBrdMenu(Brd), !.

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
positioningPhase(Brd, ResBrd) :- 
	nl, nl, multipleWSep(3, 60), 
	wTab, write("Positionnement des pieces, camp ROUGE"), nl,
	playerPositioning(Brd, rouge, SubBrd),
	nl, nl, multipleWSep(3, 60), 
	wTab, write("Positionnement des pieces, camp OCRE"), nl,
	playerPositioning(SubBrd, ocre, ResBrd),
	nl, multipleWSep(4, 60), 
	nl, writeln("Plateau de depart : "),
	showBrd(ResBrd, (0,0)), !.

/*
	playerPositioning
	------------------------------
	Lance le positionnement (IA ou Homme)
	selon le type de joueur qu'est le joueur
	du camp PlayerSide.
	Unifie le résultat du positionnement avec ResBrd.
*/
playerPositioning(Brd, PlayerSide, ResBrd) :-
	player(PlayerSide, homme), !,
	humanPositioningMenu(Brd, 1, PlayerSide, ResBrd).
playerPositioning(Brd, PlayerSide, ResBrd) :-
	iaPositioningMenu(Brd, 1, PlayerSide, ResBrd).

/*
	humanPositioningMenu
	------------------------------
	Lance le positionnement humain du joueur
	du camp PlayerSide
	Unifie le résultat du positionnement avec ResBrd.
*/
humanPositioningMenu(Brd, 6, PlayerSide, ResBrd) :- 
	repeat, nl, wSep(20), nl,
	showBrd(Brd, (0,0)),
	write(" [Joueur "), write(PlayerSide), writeln("] => position de la Kalista"),
	write("Inserez les coordonnees dans ce format : X,Y "),
	read(CHOICE), validPositioning(Brd, PlayerSide, CHOICE, CellPower),
	pieceType(PlayerSide, kalista, Type),
	setCell(Brd, (CellPower, Type), CHOICE, ResBrd).
humanPositioningMenu(Brd, N, PlayerSide, ResBrd) :- 
	repeat, nl, wSep(20), nl,
	showBrd(Brd, (0,0)),
	write(" [Joueur "), write(PlayerSide), write("] => position du sbire "),
	writeln(N), write("Inserez les coordonnees dans ce format : X,Y "),
	read(CHOICE),validPositioning(Brd, PlayerSide, CHOICE, CellPower),
	M is N + 1,
	pieceType(PlayerSide, sbire, Type),
	setCell(Brd, (CellPower, Type), CHOICE, SubBrd),
	humanPositioningMenu(SubBrd, M, PlayerSide, ResBrd).

/*
	iaPositioningMenu
	------------------------------
	Lance le positionnement IA du joueur
	du camp PlayerSide
	Unifie le résultat du positionnement avec ResBrd.
*/
iaPositioningMenu(Brd, 7, PlayerSide, Brd) :- 
	nl, write("Positionnement de l'IA du camp "), writeln(PlayerSide),
	showBrd(Brd, (0,0)), !.
iaPositioningMenu(Brd, 6, PlayerSide, ResBrd) :-
	repeat, generateRandomStartPosition(PlayerSide, (X,Y)),
	cell(X,Y, Brd, (CellPower,empty)),
	pieceType(PlayerSide, kalista, Type),
	setCell(Brd, (CellPower, Type), (X,Y), SubBrd),
	iaPositioningMenu(SubBrd, 7, PlayerSide, ResBrd).
iaPositioningMenu(Brd, N, PlayerSide, ResBrd) :-
	repeat, generateRandomStartPosition(PlayerSide, (X,Y)),
	cell(X,Y, Brd, (CellPower,empty)),
	M is N+1,
	pieceType(PlayerSide, sbire, Type),
	setCell(Brd, (CellPower, Type), (X,Y), SubBrd),
	iaPositioningMenu(SubBrd, M, PlayerSide, ResBrd).


/*
	generateRandomStartPosition
	------------------------------
	Génére des coordonnées aléatoires pour
	le placement des pions pour l'IA
*/
generateRandomStartPosition(ocre, (X,Y)) :-
	random(1,3,X), random(1,7,Y).
generateRandomStartPosition(rouge, (X,Y)) :-
	random(5,7,X), random(1,7,Y).
