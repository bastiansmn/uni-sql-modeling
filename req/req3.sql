SELECT *
FROM navires n1 JOIN voyages v on n1.navire_id = v.navire_id
WHERE n1.nationalite_id IN (
    SELECT n.nationalite_id
    FROM nations n, lien_nat_port lnp , ports p
    WHERE p.port_id = v.provenance_id
      AND n.nationalite_id = lnp.nat_id
      AND lnp.port_id = p.port_id