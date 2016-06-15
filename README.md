# UTC - IA02 (P16)
> Projet de jeu de société (jeu du Khan) sous Prolog
> Tanguy LUCCI & Alexandre-Guillaume Gilbert


### Structure du projet

>Le projet contient 8 fichiers :
> - **main.pl** : il inclut l’intégralité des autres fichiers. De plus, il contient les prédicats qui permettent de démarrer le jeu (lancement du jeu ainsi que la boucle de tour de jeu). Il initialise également le jeu avec une difficulté et en déclarant les prédicats dynamiques qui vont être utilisés.
> - **print.pl** : Il contient les prédicats spécialisés dans l’affichage. Ceci inclut l’affichage du plateau ou encore les prédicats outils pour les affichages utilisateurs (lors de la prise de position).
> - **internaltools.pl** : Il contient les différents prédicats outils permettant de manipuler les données du jeu et d’en récupérer des informations.
>    - ex: extraire le tuple de la cellule d’un tableau, connaître la couleur ennemie d’une autre couleur, etc…
> - **externaltools.pl** : Il contient différents prédicats qui sont externes au projet, qui permettent de faire des manipulations basiques et/ou abstraites de données.
>     - ex: concaténer deux listes, connaître la longueur d’une liste, etc...
> - **init.pl** : Il contient tous les prédicats nécessaires à l’initialisation du jeu : interface/menu de choix de type de jeu (Homme vs Homme, Homme VS IA, IA vs IA), interface/menu du choix de plateau de départ, positionnement des pièces au démarrage, …
> - **engine.pl** : Il contient les prédicats permettant de générer des mouvements et/ou de générer un plateau à partir de données tels qu’un mouvement donné et un plateau initial.
> - **minimax.pl** : Il contient les prédicats de l’IA. L’algorithme MinMax y est implémentée, à l’aide d’une fonction score et de sous-fonctions scores.
> - **dynamic.pl** : Il contient les prédicats permettant de modifier les prédicats dynamiques (un état de joueur, le plateau courant de jeu, la difficulté, la position courante du Khan)

### En savoir plus ...

Le rapport complet est disponible dans [docs/rapport.pdf](docs/rapport.pdf "Rapport")
