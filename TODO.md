* Ajouter un script SQL qui fait changer des bateaux de nationalité
* Voir si durée de voyage doit être présente dans table `voyages`
* Si navire pris par nation, set fin voyage null
* Constraint type voyage selon distance
* Si voyage = moyen, cargaison != périssable
* Simplifier les étapes
* Check nav.cat <= port.cat => peut mouiller
* Commercer et/ou débaruqer quand dans ports alliés
* Catégories de produits
* Lier relations_nations aux nations
* ...

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