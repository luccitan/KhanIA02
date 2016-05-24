/*
	Ensemble de prédicats outils
	qui ne découlent pas directement du projet, qui sont génériques
	mais qui sont utiles à son utilisation
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