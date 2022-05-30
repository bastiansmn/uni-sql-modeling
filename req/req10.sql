SELECT AVG(nnM.max)
FROM (SELECT MAX(n.max_pass)
FROM navires n, navires_type nt
WHERE n.type=nt.type_id
GROUP BY nt.cat) as nnM;