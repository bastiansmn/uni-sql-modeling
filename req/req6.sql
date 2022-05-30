SELECT DISTINCT p.prod_id, p.nom
FROM voyages v, cargaison c, quant_carg qc, produits p, lien_produit_cat lpc, prod_cat pc
WHERE v.voyage_id=c.voyage_id AND c.carg_id =qc.carg_id AND qc.prod_id=p.prod_id AND p.prod_id=lpc.prod_id AND lpc.cat_id=pc.prod_cat_id
    AND pc.nom='Valeur au kilo'
    AND p.est_perissable
    AND lpc.valeur>=16