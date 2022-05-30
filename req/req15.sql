SELECT p.name, SUM(qp.quant) as total
FROM quant_port qp NATURAL JOIN ports p
GROUP BY p.name
ORDER BY total DESC