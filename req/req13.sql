-- Version corrélée
SELECT n.nom
FROM navires n, voyages v
WHERE n.navire_id=v.navire_id
    AND NOT EXISTS(
        SELECT *
        FROM voyages v1
        WHERE v1.voyage_id=v.voyage_id AND v1.class_voy!='INTERC'
    )
