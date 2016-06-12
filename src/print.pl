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
	showCurrentBoard
	------------------------------
	Affiche le contenu du plateau actuel
*/
showCurrentBoard :- board(Board), khan(Khan),
		showColumns, showBoard(Board, Khan).

/* 
	showBoard
	------------------------------
	Affiche le contenu du plateau Board
*/
showBoard(Board, Khan) :-
	showColumns, showRows(1, Board, Khan).

/* 
	showAllBaseBoard
	------------------------------
	Liste les plateaux de départs
*/
showAllBaseBoards :-
	subShowAllBaseBoards(1), subShowAllBaseBoards(2),
	subShowAllBaseBoards(3), subShowAllBaseBoards(4).

subShowAllBaseBoards(N) :-
	wSep(30), nl, wTab, write("PLATEAU "), write(N), nl, wSep(30), nl,
	baseBoard(N, Board), showBoard(Board, (0,0)), nl, nl.

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
showRows(_, [],_) :- !.
showRows(NumLigne, [T|Q], Khan) :-
	write(NumLigne), write(" |"),
	N is NumLigne + 1, 
	showCells(T, Khan, NumLigne, 1), nl, writeSubRow, showRows(N, Q, Khan).

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
showCells([], _,_,_) :- !.
showCells([Cell|Q], Khan, I, J) :-
	writeCell(Cell, Khan, I, J),
	SubJ is J + 1, showCells(Q, Khan, I, SubJ), !.

% writeCell
% sous-prédicat pour showCells

writeCell((1, empty),_,_,_) :- write(" - |"), !.
writeCell((2, empty),_,_,_) :- write(" = |"), !.
writeCell((3, empty),_,_,_) :- write(" # |"), !.
writeCell((_,kr),_,_,_) :- write("!R |"), !.
writeCell((_,ko),_,_,_) :- write("!O |"), !.
writeCell((_,sr),_,_,_) :- write(" r |"), !.
writeCell((_,so),_,_,_) :- write(" o |"), !.


