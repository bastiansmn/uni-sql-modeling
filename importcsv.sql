\connect bdd2;

\COPY cargaison
    FROM 'csv\cargaison.csv'
    DELIMITER ','
    CSV HEADER;
    FIRSTROW = 2; -- as 1st one is header

COPY etapes
    FROM 'csv\etapes.csv'
    DELIMITER ','
    CSV HEADER;
    FIRSTROW = 2; -- as 1st one is header

COPY lien_nat_port
    FROM 'csv\lien_nat_port.csv'
    DELIMITER ','
    CSV HEADER;cargaison
    FIRSTROW = 2; -- as 1st one is header

COPY lien_produit_cat
    FROM 'csv\lien_produit_cat.csv'
    DELIMITER ','
    CSV HEADER;
    FIRSTROW = 2; -- as 1st one is header

COPY nations
    FROM 'csv\nations.csv'
    DELIMITER ','
    CSV HEADER;
    FIRSTROW = 2; -- as 1st one is header

COPY navires
    FROM 'csv\navires.csv'
    DELIMITER ','
    CSV HEADER;
    FIRSTROW = 2; -- as 1st one is header

COPY navires_type
    FROM 'csv\navires_type.csv'
    DELIMITER ','
    CSV HEADER;
    FIRSTROW = 2; -- as 1st one is header

COPY ports
    FROM 'csv\ports.csv'
    DELIMITER ','
    CSV HEADER;
    FIRSTROW = 2; -- as 1st one is header

COPY prod_achete_etp
    FROM 'csv\prod_achete_etp.csv'
    DELIMITER ','
    CSV HEADER;
    FIRSTROW = 2; -- as 1st one is header

COPY prod_cat
    FROM 'csv\prod_cat.csv'
    DELIMITER ','
    CSV HEADER;
    FIRSTROW = 2; -- as 1st one is header

COPY prod_vendu_etp
    FROM 'csv\prod_vendu_etp.csv'
    DELIMITER ','
    CSV HEADER;
    FIRSTROW = 2; -- as 1st one is header

COPY produits
    FROM 'csv\produits.csv'
    DELIMITER ','
    CSV HEADER;
    FIRSTROW = 2; -- as 1st one is header

COPY quant_carg
    FROM 'csv\quant_carg.csv'
    DELIMITER ','
    CSV HEADER;
    FIRSTROW = 2; -- as 1st one is header

COPY quant_port
    FROM 'csv\quant_port.csv'
    DELIMITER ','
    CSV HEADER;
    FIRSTROW = 2; -- as 1st one is header

COPY relations_nations
    FROM 'csv\relations_nations.csv'
    DELIMITER ','
    CSV HEADER;
    FIRSTROW = 2; -- as 1st one is header

COPY voyages
    FROM 'csv\voyages.csv'
    DELIMITER ','
    CSV HEADER;
    FIRSTROW = 2; -- as 1st one is header
