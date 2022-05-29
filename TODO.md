* Scripts :
 1) Création de voyage + étaps (cargaison comprise)
 2) Prise d'un bateau par une nation

* Requetes :
 1) Récupérer le volume total d'une cargaison d'un navire
 2) Afficher les nations en guerre
 3) sous requete corr
 4) sous requete ds FROM
 5) sous requete ds WHERE
 6) Nombre de produits dans une catégorie où la répartition des valeurs dans la catégorie est linéaire ou exponentielle (AVG() >= ((MAX() - MIN()) / 2)
 7) Les navires de chaques nations qui ont au moins une étape
 8) Moyenne des passagers maximums de tous les bateaux (toute nationalité confondue)
 9) Récupérer les voyages d'un navire
 10) Tous les bateaux arrivés à la date X du jour Y
 11) Récupérer le parcours d'un bateau entre une date X et une autre Y

* CSV de copie de données
* Remplir README
* Revoir les contraintes

# Liste des contraintes :
- la cargaison de la depart = cargaison max du navire
- a larrivé, toute la cargaison du navire va dans le port et ainsi que tout les passagers
- la date de debut = date de fin + 2 semaines
- si dest = provenance alors nb_etapes >=1
- date de fin est NULL par defaut
- les voyages moyen et long n'ont pas de cargaison perissable(seulement cargaison seche)
- definir les types de voyages avec leur distances
- si voyage est intercontinentale alors categorie du navire et celle du port = 5
- voyage intercontale = soit moyen ou long
- si voyage est long il doit avoir une etape a +- 500km
- la categorie du port de chaque etape > categorie navire
- Si y'a une guerre entre une nation A et B et que le navire demarre depuis le port de la nation A alors le navire ne peut pas arriver a la nation B
- Si A et B sont alliés et que le navire demarre depuis A alors il doit arriver dans B ou ses Alliés
-
# 20 Questions :
1) 