/* == NOTES === */


/* Librairie et prédicat de rotation de matrice */
:- use_module(library(clpfd)).

matrix_rotated(Xss, Zss) :-
   transpose(Xss, Yss),
   maplist(reverse, Yss, Zss).

 /* I/O */

/* Exemple de récupération d'une variable */
 read_animal(X) :-
  write('please type animal name:'),
  nl,
  read(X),
  animal(X).
