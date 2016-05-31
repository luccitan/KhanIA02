/*
	=================================
	tools.pl
	=================================
	Ce fichier contient les différents prédicats
	qui sont "externes" au projet mais qui sont utiles
	d'une manière ou une autre
	dans la manipulation des données
	-------------------------------
*/

/* 
	element(X, L)
	------------------------------
	Prédicat qui retourne VRAI si :
	un élément X (argument 1) est présent dans la liste L (argument 2)
*/
element(X, [X|_]).
element(X, [_|Q]) :- element(X,Q).

/* 
	concat(Liste1, Liste2, ListeResultat)
	------------------------------
	Prédicat qui unifie ListeResultat
	avec la concaténation des listes Liste1 et Liste2
*/
concat([], L, L).
concat(L, [], L).
concat([T|Q], L2, [T|Res]) :- concat(Q, L2, Res).


/* 
	retire_element(X, L1, L2)
	------------------------------
	Prédicat qui déplace dans L2 la première occurence de l'élément X dans L
*/
retire_element(_, [], []).
retire_element(X, [X|Q], Q) :- !.
retire_element(X, [T|Q], [T|Res]) :- retire_element(X, Q, Res).

/* 
	retire_elements(X, L1, L2)
	------------------------------
	Prédicat qui déplace dans L2 TOUTES les occurences de l'élément X dans L
*/
retire_elements(_, [], []).
retire_elements(X, [X|Q], Res) :- retire_elements(X, Q, Res), !.
retire_elements(X, [T|Q], [T|Res]) :- retire_elements(X,Q,Res).

/* 
	retire_doublons(L, Res)
	------------------------------
	Prédicat qui insère dans Res la liste L retirée de tous ses doublons
	Res devient donc un 'ensemble'
*/
retire_doublons([], []).
retire_doublons([T|Q], [T|R]) :- retire_elements(T, Q, Res), retire_doublons(Res, R).

/*
	difference(L1, L2, Res)
	------------------------------
	Prédicat qui retire les éléments de L2 présents dans L1
	et met le résultat filtré dans Res
*/
difference([],_,[]).
difference([T|Q], L2, [T|Res]) :- \+element(T, L2), difference(Q, L2, Res), !.
difference([T|Q], L2, Res) :- element(T,L2), difference(Q, L2, Res), !.