/* 
	showBoard
	------------------------------
	Affiche le contenu du plateau actuel
*/
showBoard :- baseBoard(1, Plat), write("  "), showColumns(1), showRows(1, Plat).

/* 
	showColumns(N)
	------------------------------
	Prédicat qui permet d'afficher
	les en-têtes de colonnes
*/
showColumns(N) :- N>6, nl, write("-----------------"), nl, !.
showColumns(N) :- write(" "), write(N), SubN is N + 1, showColumns(SubN).

/* 
	showRows(N, Row)
	------------------------------
	Affiche le contenu de la Nème ligne
*/
showRows(_, []) :- !.
showRows(NumLigne, [T|Q]) :- write(NumLigne), write("  "), N is NumLigne + 1, showCells(T), nl, showRows(N, Q).

/* 
	showRows(N, Row)
	------------------------------
	Affiche le contenu de la Nème cellule d'une ligne
*/
showCells([]).
showCells([(1, 0)|Q]) :-  write("- "), showCells(Q), !.
showCells([(2, 0)|Q]) :-  write("= "), showCells(Q), !.
showCells([(3, 0)|Q]) :-  write("# "), showCells(Q), !.
showCells([(_, 1)|Q]) :-  write("R "), showCells(Q), !.
showCells([(_, 2)|Q]) :-  write("r "), showCells(Q), !.
showCells([(_, 3)|Q]) :-  write("O "), showCells(Q), !.
showCells([(_, 4)|Q]) :-  write("o "), showCells(Q), !.
