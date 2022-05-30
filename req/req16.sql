SELECT nat.nom, COUNT(*) as c
FROM nations nat, navires nav, navires_type nt
WHERE nat.nationalite_id=nav.nationalite_id
    AND nav.type=nt.type_id
    AND nt.cat>=4
GROUP BY nat.nom
ORDER BY c DESC
LIMIT 1