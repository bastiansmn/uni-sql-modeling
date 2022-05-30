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