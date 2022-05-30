SELECT v.voyage_id
FROM voyages v LEFT JOIN navires n on n.navire_id = v.navire_id