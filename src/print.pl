/*
	=================================
	print.pl
	=================================
	Ce fichier contient les différents prédicats
	qui permettent de gérer l'affichage et l'interfaçage du jeu
	avec le ou les joueurs
	-------------------------------
*/

% Ecriture d'un séparateur sur N cases
wSep(0) :- !.
wSep(N) :- write("_"), Nb is N-1, wSep(Nb).
% Ecriture d'une tabulation (2 espaces)
wTab :- write("  ").

/* 
	writeChoice(N)
	------------------------------
	Affiche la confirmation de choix
	de types de partie (Homme/IA vs Homme/IA)
*/
writeMatchChoiceTypeAlert(N) :- 
	N>0, N<4, !,
	write("Vous avez choisi le choix '"), writeMatchChoiceTypeText(N), write("' !"), nl.
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
	showBoard
	------------------------------
	Affiche le contenu du plateau actuel
*/

showBoard :- baseBoard(1, Plat), showColumns, showRows(1, Plat).

/* 
	showColumns
	------------------------------
	Prédicat qui permet d'afficher
	les en-têtes de colonnes
*/
showColumns :-
	nl, wTab, writeSubColumnLoop(1), nl,
	wTab, wSep(25), nl.

% writeSubColumn / writeSubColumnLoop
%"Sous"-prédicats pour boucler et faciliter l'écriture de showColumns
writeSubColumnLoop(N) :- N<7, writeSubColumn(N), Nb is N+1, writeSubColumnLoop(Nb), !.
writeSubColumnLoop(_) :- write(" ").
writeSubColumn(N) :- wTab, write(N), write(" ").


/* 
	showRows(N, Row)
	------------------------------
	Affiche le contenu de la Nème ligne
*/
showRows(_, []) :- !.
showRows(NumLigne, [T|Q]) :-
	write(NumLigne), write(" |"),
	N is NumLigne + 1, 
	showCells(T), nl, writeSubRow, showRows(N, Q).

% writeSubRow / writeSubRowLoop
%"Sous"-prédicats pour boucler et faciliter l'écriture de showRows
writeSubRow :-wTab, write("+"), writeSubRowLoop(1).
writeSubRowLoop(N) :- N<7, write("---+"), Nb is N+1, writeSubRowLoop(Nb), !.
writeSubRowLoop(_) :- nl.

/* 
	showCells(Tuple, Row)
	------------------------------
	Affiche le contenu de la Nème cellule d'une ligne
*/
showCells([]).
showCells([(1, 0)|Q]) :-  write(" - |"), showCells(Q), !.
showCells([(2, 0)|Q]) :-  write(" = |"), showCells(Q), !.
showCells([(3, 0)|Q]) :-  write(" # |"), showCells(Q), !.
showCells([(_, 1)|Q]) :-  write(" R |"), showCells(Q), !.
showCells([(_, 2)|Q]) :-  write(" r |"), showCells(Q), !.
showCells([(_, 3)|Q]) :-  write(" O |"), showCells(Q), !.
showCells([(_, 4)|Q]) :-  write(" o |"), showCells(Q), !.
