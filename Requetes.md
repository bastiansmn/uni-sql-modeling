* Requetes :
 1) Récupérer le volume total d'une cargaison d'un navire (*Requête qui porte sur au moins trois tables*)
```sql
SELECT n.nom, SUM(qc.quant*p.volume) AS volume 
FROM navires n, voyages v, cargaison c, quant_carg qc, produits p 
WHERE n.navire_id=v.navire_id 
  AND v.voyage_id=c.voyage_id 
  AND c.carg_id=qc.carg_id 
  AND qc.prod_id=p.prod_id
GROUP BY n.nom
```

 2) Afficher le nom des nations en guerre (*Auto-jointure*)
```sql
SELECT n1.nom, n2.nom 
FROM nations n1 , nations n2 , relations_nations rn
WHERE n1.nationalite_id = rn.nat_1_id 
  AND n2.nationalite_id = rn.nat_2_id 
  AND rn.relation = 'GUERRE'
```

 3) La liste des navires dont tout les port de pays de departs de leur voyages sont identiques a leur nationalités (*sous-requête corrélée*)
```sql
SELECT n1.nom
FROM navires n1 JOIN voyages v on n1.navire_id = v.navire_id 
WHERE n1.nationalite_id IN (
    SELECT n.nationalite_id 
    FROM nations n, lien_nat_port lnp , ports p 
    WHERE p.port_id = v.provenance_id 
      AND n.nationalite_id = lnp.nat_id 
      AND lnp.port_id = p.port_id
)
```

 4) La moyenne des passagers maximaux sur les voyages intercontinentaux (*sous-requête dans le FROM*)
```sql
SELECT AVG(max_pass) 
FROM (
    SELECT n1.navire_id, n1.nom ,n1.max_pass 
    FROM voyages v1 NATURAL JOIN navires n1 
    WHERE v1.class_voy = 'INTERC'
) as "vn"
```

 5) Toutes les bateaux de nations qui ne sont pas en guerres. (*Sous-requête dans le WHERE*)
```sql
SELECT nav.nom FROM navires nav WHERE nav.nationalite_id NOT IN (
    SELECT nat.nationalite_id
    FROM nations nat, relations_nations rn
    WHERE (nat.nationalite_id = rn.nat_1_id OR nat.nationalite_id = rn.nat_2_id)
        AND rn.relation='GUERRE'
    )
```

 6) Les voyages qui comportent des produits périssables d'une valeur d'au moins 16€ le kilo.
```sql
SELECT DISTINCT p.prod_id, p.nom
FROM voyages v, cargaison c, quant_carg qc, produits p, lien_produit_cat lpc, prod_cat pc
WHERE v.voyage_id=c.voyage_id AND c.carg_id =qc.carg_id AND qc.prod_id=p.prod_id AND p.prod_id=lpc.prod_id AND lpc.cat_id=pc.prod_cat_id
    AND pc.nom='Valeur au kilo'
    AND p.est_perissable
    AND lpc.valeur>=16
```

 7) Les ports où il y a toujours en moyenne moins de passagers sortant que arrivants (*Requête statistiques*)
```sql
SELECT p.name
FROM etapes e NATURAL JOIN ports p
GROUP BY p.name
HAVING AVG(e.pass_monte-e.pass_descendu) > 0
```

 8) Nombre de produits dans une catégorie où la répartition des valeurs dans la catégorie est linéaire ou exponentielle (AVG() >= ((MAX() - MIN()) / 2) (*Requête nécessitant GROUP BY et HAVING*)
```sql
SELECT pc.nom
FROM produits p, lien_produit_cat lpc, prod_cat pc
WHERE p.prod_id=lpc.prod_id
    AND lpc.cat_id=pc.prod_cat_id
GROUP BY pc.nom
HAVING AVG(lpc.valeur) >= (MAX(lpc.valeur) + MIN(lpc.valeur)) / 2
```

 9) Les navires dont tous les voyages ont au moins une étape (*Condition de totalité*)
```sql
SELECT n.nom
FROM navires n
WHERE NOT EXISTS(
        SELECT *
        FROM voyages v
        WHERE v.navire_id=n.navire_id
            AND 0 IN (
                SELECT COUNT(*)
                FROM etapes e
                WHERE e.voyage_id=v.voyage_id
                GROUP BY e.voyage_id
            )
    )
    AND EXISTS(
        SELECT *
        FROM voyages v2
        WHERE v2.navire_id=n.navire_id
    );
```

 10) Moyenne des passagers maximums de tous les bateaux (toute nationalité confondue) (*Requête nécessitant le calcul de 2 agrégats*)
```sql
SELECT AVG(nnM.max)
FROM (SELECT MAX(n.max_pass)
FROM navires n, navires_type nt
WHERE n.type=nt.type_id
GROUP BY nt.cat) as nnM;
```

 11) Récupérer les voyages d'un navire (*LEFT JOIN*)
```sql
SELECT v.voyage_id
FROM voyages v LEFT JOIN navires n on n.navire_id = v.navire_id
```

 12) Récupérer le parcours des bateaux (*Requête récursive*)
```sql
WITH RECURSIVE Access(prov, dest) AS
(
    SELECT provenance_id, destination_id FROM voyages
    UNION ALL
    SELECT voy.provenance_id, a.dest
    FROM voyages voy, access a
    WHERE voy.destination_id=a.prov
)
SELECT * FROM Access;
```

 13) Les bateaux qui ont touts leurs voyages intercontinentaux (*Condition de totalité*)
```sql
-- Version corrélée
SELECT n.nom
FROM navires n, voyages v
WHERE n.navire_id=v.navire_id
    AND NOT EXISTS(
        SELECT *
        FROM voyages v1
        WHERE v1.voyage_id=v.voyage_id AND v1.class_voy!='INTERC'
    )
```

 14) Le nombre de passagers transportés vers chaque continents pour les voyages étant arrivés en 1754 (*Requête de statistiques*)
```sql
SELECT p.continent, SUM(v.nb_pass_courants)
FROM voyages v, ports p
WHERE v.destination_id=p.port_id
    AND EXTRACT(YEAR FROM v.date_fin)=1754
GROUP BY p.continent
```

 15) La quantité totale de produits disponibles dans chaque ports trié par le port le plus important (*Requête de statistiques*)
```sql
SELECT p.name, SUM(qp.quant) as total
FROM quant_port qp NATURAL JOIN ports p
GROUP BY p.name
ORDER BY total DESC 
```

 16) La nation qui a le plus de navires dont la catégorie est supérieure ou égale à 4 (*Requête de statistiques*)
```sql
SELECT nat.nom, COUNT(*) as c
FROM nations nat, navires nav, navires_type nt
WHERE nat.nationalite_id=nav.nationalite_id
    AND nav.type=nt.type_id
    AND nt.cat>=4
GROUP BY nat.nom
ORDER BY c DESC
LIMIT 1
```

 17) 

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