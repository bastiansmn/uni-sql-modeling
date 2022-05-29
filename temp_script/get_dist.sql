DROP FUNCTION IF EXISTS get_dist(port1 ports, port2 ports);

CREATE FUNCTION get_dist(port1 ports, port2 ports) RETURNS DOUBLE PRECISION
AS
$$
BEGIN
    RETURN 1.609344*3963.0*
           acos(
               (sin(port1.lattitude / (180/pi())) *
               sin(port2.lattitude / (180/pi()))) +
               cos(port1.lattitude / (180/pi())) *
               cos(port2.lattitude / (180/pi())) *
               cos(port2.longitude / (180/pi()) - port1.longitude / (180/pi()))
           );
END
$$
LANGUAGE plpgsql;

DROP FUNCTION get_dist(port1 ports, port2 ports);

SELECT *, get_dist(p1, p2) FROM ports p1, ports p2 WHERE p1.port_id!=p2.port_id;

