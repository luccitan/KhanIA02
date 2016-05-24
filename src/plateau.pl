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
writeChoice(X) :- X>0, X<4, write("Vous avez choisi le choix '"), writeChoiceText(X), write("' !"), nl.
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
	read(CHOICE), nl, showTypeMatchChoice(CHOICE), nl.

showTypeMatchChoice(X) :- X>0, X<4, writeChoice(X), !.
showTypeMatchChoice(_) :- nl, write("/!\\ Vous avez fait un mauvais choix ! Recommencez !"), fail.


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
