/* --
	Initialisation des plateaux de bases
	--
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

showBoard() :- baseBoard(1, Plat), showRows(Plat).

showRows([]).
showRows([T|Q]) :- showCells(T), nl, afficherLigne(Q).

showCells([]).
showCells([(1, 0)|Q]) :-  write("- "), showCells(Q), !.
showCells([(2, 0)|Q]) :-  write("= "), showCells(Q), !.
showCells([(3, 0)|Q]) :-  write("# "), showCells(Q), !.
showCells([(_, 1)|Q]) :-  write("R "), showCells(Q), !.
showCells([(_, 2)|Q]) :-  write("r "), showCells(Q), !.
showCells([(_, 3)|Q]) :-  write("0 "), showCells(Q), !.
showCells([(_, 4)|Q]) :-  write("o "), showCells(Q), !.
