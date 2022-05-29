SELECT n.nom, SUM(qc.quant*p.volume) AS volume
FROM navires n, voyages v, cargaison c, quant_carg qc, produits p
WHERE n.navire_id=v.navire_id
  AND v.voyage_id=c.voyage_id
  AND c.carg_id=qc.carg_id
  AND qc.prod_id=p.prod_id
GROUP BY n.nom