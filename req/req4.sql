SELECT AVG(max_pass)
FROM (
    SELECT n1.navire_id, n1.nom ,n1.max_pass
    FROM voyages v1 NATURAL JOIN navires n1
    WHERE v1.class_voy = 'INTERC'
) as "vn"