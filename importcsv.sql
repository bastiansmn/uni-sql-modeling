\connect bdd_project;

COPY cargaison
    FROM '/mnt/DATA/Projets/uni-sql-modeling/csv/cargaison.csv'
    DELIMITER ','
    CSV HEADER;

COPY etapes
    FROM '/mnt/DATA/Projets/uni-sql-modeling/csv/etapes.csv'
    DELIMITER ','
    CSV HEADER;

COPY lien_nat_port
    FROM '/mnt/DATA/Projets/uni-sql-modeling/csv/lien_nat_port.csv'
    DELIMITER ','
    CSV HEADER;

COPY lien_produit_cat
    FROM '/mnt/DATA/Projets/uni-sql-modeling/csv/lien_produit_cat.csv'
    DELIMITER ','
    CSV HEADER;

COPY nations
    FROM '/mnt/DATA/Projets/uni-sql-modeling/csv/nations.csv'
    DELIMITER ','
    CSV HEADER;

COPY navires
    FROM '/mnt/DATA/Projets/uni-sql-modeling/csv/navires.csv'
    DELIMITER ','
    CSV HEADER;

COPY navires_type
    FROM '/mnt/DATA/Projets/uni-sql-modeling/csv/navires_type.csv'
    DELIMITER ','
    CSV HEADER;

COPY ports
    FROM '/mnt/DATA/Projets/uni-sql-modeling/csv/ports.csv'
    DELIMITER ','
    CSV HEADER;

COPY prod_achete_etp
    FROM '/mnt/DATA/Projets/uni-sql-modeling/csv/prod_achete_etp.csv'
    DELIMITER ','
    CSV HEADER;

COPY prod_cat
    FROM '/mnt/DATA/Projets/uni-sql-modeling/csv/prod_cat.csv'
    DELIMITER ','
    CSV HEADER;

COPY prod_vendu_etp
    FROM '/mnt/DATA/Projets/uni-sql-modeling/csv/prod_vendu_etp.csv'
    DELIMITER ','
    CSV HEADER;

COPY produits
    FROM '/mnt/DATA/Projets/uni-sql-modeling/csv/produits.csv'
    DELIMITER ','
    CSV HEADER;

COPY quant_carg
    FROM '/mnt/DATA/Projets/uni-sql-modeling/csv/quant_carg.csv'
    DELIMITER ','
    CSV HEADER;

COPY quant_port
    FROM '/mnt/DATA/Projets/uni-sql-modeling/csv/quant_port.csv'
    DELIMITER ','
    CSV HEADER;

COPY relations_nations
    FROM '/mnt/DATA/Projets/uni-sql-modeling/csv/relations_nations.csv'
    DELIMITER ','
    CSV HEADER;

COPY voyages
    FROM '/mnt/DATA/Projets/uni-sql-modeling/csv/voyages.csv'
    DELIMITER ','
    CSV HEADER;
