WITH RECURSIVE Access(prov, dest) AS
(
    SELECT provenance_id, destination_id FROM voyages
    UNION ALL
    SELECT voy.provenance_id, a.dest
    FROM voyages voy, access a
    WHERE voy.destination_id=a.prov
)
SELECT * FROM Access;