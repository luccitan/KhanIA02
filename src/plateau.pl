/* --
	Initialisation des plateaux de bases
	--
*/
plateauDeBase(1, [ 
				[ (2,0),(2,0),(3,0),(1,0),(2,0),(2,0) ],
				[ (1,0),(3,0),(1,0),(3,0),(1,0),(3,0) ],
				[ (3,0),(1,0),(2,0),(2,0),(3,0),(1,0) ],
				[ (2,0),(3,0),(1,0),(3,0),(1,0),(2,0) ],
				[ (2,0),(1,0),(3,0),(1,0),(3,0),(2,0) ], 
				[ (1,0),(3,0),(2,0),(2,0),(1,0),(3,0) ]
			]).
plateauDeBase(2, [ 
				[ (1,0),(2,0),(2,0),(3,0),(1,0),(2,0) ],
				[ (3,0),(1,0),(3,0),(1,0),(3,0),(2,0) ],
				[ (2,0),(3,0),(1,0),(2,0),(1,0),(3,0) ],
				[ (2,0),(1,0),(3,0),(2,0),(3,0),(1,0) ],
				[ (1,0),(3,0),(1,0),(3,0),(1,0),(2,0) ],
				[ (3,0),(2,0),(2,0),(1,0),(3,0),(2,0) ]
			]).
plateauDeBase(3, [ 
				[ (3,0),(1,0),(2,0),(2,0),(3,0),(1,0) ],
				[ (2,0),(3,0),(1,0),(3,0),(1,0),(2,0) ],
				[ (2,0),(1,0),(3,0),(1,0),(3,0),(2,0) ],
				[ (1,0),(3,0),(2,0),(2,0),(1,0),(3,0) ],
				[ (3,0),(1,0),(3,0),(1,0),(3,0),(1,0) ],
				[ (2,0),(2,0),(1,0),(3,0),(2,0),(2,0) ]
			]).
plateauDeBase(4, [ 
				[ (2,0),(3,0),(1,0),(2,0),(2,0),(3,0) ], 
				[ (2,0),(1,0),(3,0),(1,0),(3,0),(1,0) ],
				[ (1,0),(3,0),(2,0),(3,0),(1,0),(2,0) ],
				[ (3,0),(1,0),(2,0),(1,0),(3,0),(2,0) ],
				[ (2,0),(3,0),(1,0),(3,0),(1,0),(3,0) ],
				[ (2,0),(1,0),(3,0),(2,0),(2,0),(1,0) ]
			]).


/* Fonctions d'écritures */

writeSeperator :- write("---------").
writeChoice(1) :- write("Vous avez choisi le choix '"), writeChoiceText(1), write("' !"), nl.
writeChoice(2) :- write("Vous avez choisi le choix '"), writeChoiceText(2), write("' !"), nl.
writeChoice(3) :- write("Vous avez choisi le choix '"), writeChoiceText(3), write("' !"), nl.
writeChoice(_) :- nl, write("/!\\ Vous avez fait un mauvais choix ! Recommencez !"), fail.
writeChoiceText(1) :- write("Homme vs Homme."), !.
writeChoiceText(2) :- write("Homme vs IA."), !.
writeChoiceText(3) :- write("IA vs IA."), !.

/* 
	Prédicats pour demander si on veut faire une partie 
	- 1) HOMME VS HOMME
	- 2) HOMME VS ROBOT
	- 3) ROBOT VS ROBOT
*/
typeMatchMenuLoop :- repeat, typeMatchMenu, !.

typeMatchMenu :- 
	nl,
	writeSeperator,
	nl,
	write("1. - "),writeChoiceText(1), nl,
	write("2. - "),writeChoiceText(2), nl,
	write("3. - "),writeChoiceText(3), nl,
	write("Entrez un choix : "),
	read(CHOICE), nl, writeChoice(CHOICE), nl.

afficherPlateau() :- plateauDeBase(1, Plat), afficherLignes(Plat).

afficherLignes([]).
afficherLignes([T|Q]) :- afficherCases(T), nl, afficherLigne(Q).

afficherCases([]).
afficherCases([(1, 0)|Q]) :-  write("- "), afficherCases(Q), !.
afficherCases([(2, 0)|Q]) :-  write("= "), afficherCases(Q), !.
afficherCases([(3, 0)|Q]) :-  write("# "), afficherCases(Q), !.
afficherCases([(_, 1)|Q]) :-  write("R "), afficherCases(Q), !.
afficherCases([(_, 2)|Q]) :-  write("r "), afficherCases(Q), !.
afficherCases([(_, 3)|Q]) :-  write("0 "), afficherCases(Q), !.
afficherCases([(_, 4)|Q]) :-  write("o "), afficherCases(Q), !.
