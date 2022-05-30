SELECT pc.nom
FROM produits p, lien_produit_cat lpc, prod_cat pc
WHERE p.prod_id=lpc.prod_id
    AND lpc.cat_id=pc.prod_cat_id
GROUP BY pc.nom
HAVING AVG(lpc.valeur) >= (MAX(lpc.valeur) + MIN(lpc.valeur)) / 2