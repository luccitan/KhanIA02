# TODO Liste à faire

Définition des étapes et des actions du projet à faire
(Ne contient pas de Prolog)

## Représentation des données

### Plateau de jeu

Plateau : liste de 6 sous-listes.
Chaque sous-liste représente une ligne.

Chaque élément de la sous-liste est un tuple représentant un élément.

ex : Première ligne -> 3ème élément ==> Ligne 1 Colonne 3.

Chaque élément est un tuple :

- Premier élément : valeur de la case {1,2,3}
- Deuxième élément : nature du pion
	- 0 : case vide
	- 1 : Kalista rouge
	- 2 : Sbire rouge
	- 3 : Kalista ocre
	- 4 : Sbire ocre

Compteur de sbires rouges perdus : mortsRouge

Compteur de sbires ocres perdus : mortsOcre

Valeur de la case  du pion coiffé par le Khan : valeurKhan

### Affichage du plateau
 	- Affichage des cases vides avec "X" ou " X" ?
 	- Affichage de la Kalista rouge avec "KR"
 	- Affichage de la Kalista ocre avec "KO"
 	- Affichage des sbires rouges avec "SR"
 	- Affichage des sbires ocres avec "SO"
 	- Ajout d'un ^ sur le pion coiffé par le Khan

## Etape 1 : Initialisation du jeu

initBoard(Board)

 - Initialiser la variable Board avec le plateau de base (voir le fichier MD "plateau-de-jeu"
 - Interface pour placer les pions au début du jeu
 - Interface pour la sélection d'un coup à jouer (Humain)

## Etape 2 et 3 : Partie IA

possiblesMoves(Board, player, PossibleMoveList)

### Calcul des positions de la case 1
On définit la fonction Pos1. On calcule toutes les positions accessibles par un mouvement à partir de la case courante. Soit (X, Y) la case courante, il y a 4 possibilités de déplacement :  
- (X + 1, Y)
- (X, Y + 1)
- (X - 1, Y)
- (X, Y - 1)

### Calcul des positions de la case 2

On définit la fonction Pos2. On calcule chaque Pos1 accessible à partir de Pos1 :

- L = Pos1(X,Y)
- Res = Pos1(L)


### Calcul des positions de la case 3

On définit la fonction Pos3. On calcule chaque pos1 à partir de pos2.
- L = Pos2(X,Y)
- Res = Pos1(L)

generateMove(Board, Player, Move)

--> Définit le coup optimal (utilisé pour un joueur IA) parmi les coups possibles

## Etape 4 :

Mettre tout ça en place et générer les boucles de gestion de jeu
