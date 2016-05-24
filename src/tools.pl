element(X, [X|_]).
element(X, [_|Q]) :- element(X,Q).