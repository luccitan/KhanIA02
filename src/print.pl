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
% Ecriture de séparateurs avec passages à la ligne
multipleWSep(0,_) :- !.
multipleWSep(K, N) :-
	wSep(N), nl, SK is K - 1, multipleWSep(SK, N).
% Ecriture d'une tabulation (2 espaces)
wTab :- write("  ").

/* 
	print(List)
	------------------------------
	Affiche la liste des tuples présents dans
	dans List
*/
print([]) :- !.
print([X|Q]) :-
	write("("),
	write(X),
	write(") "),
	print(Q).

/* 
	writeChoice(N)
	------------------------------
	Affiche la confirmation de choix
	de types de partie (Homme/IA vs Homme/IA)
*/
writeMatchChoiceTypeAlert(N) :- 
	N>0, N<4, !,
	write("Vous avez choisi le choix '"), writeMatchChoiceTypeText(N), writeln("' !").
writeMatchChoiceTypeAlert(_) :- 
	nl, 
	write("/!\\ Vous avez fait un mauvais choix ! Recommencez !"),
	fail.

/*
	restrictiveKhanMessage
	------------------------------
	Prédicat utilisé pour afficher un message d'info / alerte
	à l'utilisateur lors de sa demande de mouvements
*/
restrictiveKhanMessage(true) :-
	writeln("Le Khan est trop restrictif:  chaque piece est amovible ...").
restrictiveKhanMessage(false).

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
	============================================================
	============================================================
	Prédicats d'affichage de tableau
	============================================================
	============================================================
*/

/* 
	showAllBaseBrd
	------------------------------
	Liste les plateaux de départs
*/
showAllBaseBrds :-
	subShowAllBaseBrds(1), subShowAllBaseBrds(2),
	subShowAllBaseBrds(3), subShowAllBaseBrds(4).

subShowAllBaseBrds(N) :-
	wSep(30), nl, wTab, write("PLATEAU "), writeln(N), wSep(30), nl,
	baseBrd(N, Brd), showBrd(Brd, (0,0)), nl, nl.

/* 
	showCurrentBrd
	------------------------------
	Affiche le contenu du plateau actuel
*/
showCurrentBrd :- board(Brd), khan(Khan),
		showColumns, showBrd(Brd, Khan).

/* 
	showBrd
	------------------------------
	Affiche le contenu du plateau Brd
*/
showBrd(Brd, Khan) :-
	showColumns, showRows(1, Brd, Khan).

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
	N is NumLigne + 1, 
	write(NumLigne), write(" |"), showCellsPower(T, NumLigne, 1), nl,
	write("  |"), showCellsContent(T, Khan, NumLigne, 1), nl,
	writeSubRow, showRows(N, Q, Khan).

% writeSubRow / writeSubRowLoop
%"Sous"-prédicats pour boucler et faciliter l'écriture de showRows
writeSubRow :- wTab, write("+"), writeSubRowLoop(1).
writeSubRowLoop(N) :- N<7, write("---+"), Nb is N+1, writeSubRowLoop(Nb), !.
writeSubRowLoop(_) :- nl.



/* 
	showCellsPower(Tuple, Row)
	------------------------------
	Affiche la puissance de la Nème cellule d'une ligne
*/
showCellsPower([],_,_) :- !.
showCellsPower([Cell|Q], I, J) :-
	writeCellPower(Cell),
	SubJ is J + 1, showCellsPower(Q, I, SubJ), !.

/* 
	showCellsContent(Tuple, Row)
	------------------------------
	Affiche le contenu de la Nème cellule d'une ligne
*/
showCellsContent([], _,_,_) :- !.
showCellsContent([Cell|Q], (X,Y), I, J) :-
	I = X, J = Y, !,
	writeCellContent(Cell, true),
	SubJ is J + 1, showCellsContent(Q, (X,Y), I, SubJ).
showCellsContent([Cell|Q],Khan, I, J) :-
	writeCellContent(Cell, false),
	SubJ is J + 1, showCellsContent(Q, Khan, I, SubJ), !.

% writeCell
% sous-prédicat pour showCells
writeCellPower((1,_)) :- write("-  |"), !.
writeCellPower((2,_)) :- write("=  |"), !.
writeCellPower((3,_)) :- write("#  |"), !.

writeCellContent((_,empty),_) :- write("   |"), !.
writeCellContent((_,kr),false) :- write(" R |"), !.
writeCellContent((_,ko),false) :- write(" O |"), !.
writeCellContent((_,sr),false) :- write(" r |"), !.
writeCellContent((_,so),false) :- write(" o |"), !.
writeCellContent((_,kr),true) :- write("!R |"), !.
writeCellContent((_,ko),true) :- write("!O |"), !.
writeCellContent((_,sr),true) :- write("!r |"), !.
writeCellContent((_,so),true) :- write("!o |"), !.



