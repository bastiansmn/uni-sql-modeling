SELECT p.continent, SUM(v.nb_pass_courants)
FROM voyages v, ports p
WHERE v.destination_id=p.port_id
    AND EXTRACT(YEAR FROM v.date_fin)=1754
GROUP BY p.continent