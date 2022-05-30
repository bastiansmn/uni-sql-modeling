SELECT n1.nom, n2.nom
FROM nations n1 , nations n2 , relations_nations rn
WHERE n1.nationalite_id = rn.nat_1_id
  AND n2.nationalite_id = rn.nat_2_id
  AND rn.relation = 'GUERRE'