create function validate_type_voy(voy voyages) returns bool
as
$$
DECLARE
    prov ports;
    dest ports;
begin
    SELECT p.port_id, p.name, p.lattitude, p.longitude, p.categorie, p.nb_passagers, p.continent
    INTO prov
    FROM voyages v JOIN ports p ON p.port_id = v.provenance_id WHERE v.voyage_id = voy.voyage_id;

    SELECT p.port_id, p.name, p.lattitude, p.longitude, p.categorie, p.nb_passagers, p.continent
    INTO dest
    FROM voyages v JOIN ports p ON p.port_id = v.destination_id WHERE v.voyage_id = voy.voyage_id;

    IF voy.type_voy = 'COURT' THEN
        return get_dist(prov, dest) < 1000.0;
    ELSE IF voy.type_voy = 'MOYEN' THEN
        return get_dist(prov, dest) >= 1000.0 AND get_dist(prov, dest) <= 2000.0;
    ELSE
        return get_dist(prov, dest) > 2000.0;
    END IF;
    END IF;
END;
$$
LANGUAGE plpgsql;

ALTER TABLE voyages
    DROP CONSTRAINT validate_type_voy;

ALTER TABLE voyages
ADD CONSTRAINT validate_type_voy
CHECK (validate_type_voy(voyages)=true);