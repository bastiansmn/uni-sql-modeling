--
-- PostgreSQL database dump
--

-- Dumped from database version 14.3
-- Dumped by pg_dump version 14.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

DROP DATABASE IF EXISTS bdd_project;
--
-- Name: bdd_project; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE bdd_project WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'fr_FR.UTF-8';


ALTER DATABASE bdd_project OWNER TO postgres;

\connect bdd_project

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: DATABASE bdd_project; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON DATABASE bdd_project IS 'default administrative connection database';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: ports; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ports (
    port_id integer NOT NULL,
    name character varying NOT NULL,
    lattitude double precision NOT NULL,
    longitude double precision NOT NULL,
    categorie integer NOT NULL,
    nb_passagers integer DEFAULT 0 NOT NULL,
    continent character varying NOT NULL,
    CONSTRAINT validate_categorie CHECK (((categorie >= 1) AND (categorie <= 5))),
    CONSTRAINT validate_pass CHECK ((nb_passagers > 0))
);


ALTER TABLE public.ports OWNER TO postgres;

--
-- Name: get_dist(public.ports, public.ports); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.get_dist(port1 public.ports, port2 public.ports) RETURNS double precision
    LANGUAGE plpgsql
    AS $$
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
$$;


ALTER FUNCTION public.get_dist(port1 public.ports, port2 public.ports) OWNER TO postgres;

--
-- Name: validate_type_voy(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.validate_type_voy(voy_id integer) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
    prov ports;
    dest ports;
    voy voyages;
begin
    SELECT p.port_id, p.name, p.lattitude, p.longitude, p.categorie, p.nb_passagers, p.continent
    INTO prov
    FROM voyages v JOIN ports p ON p.port_id = v.provenance_id WHERE v.voyage_id = voy_id;

    SELECT p.port_id, p.name, p.lattitude, p.longitude, p.categorie, p.nb_passagers, p.continent
    INTO dest
    FROM voyages v JOIN ports p ON p.port_id = v.destination_id WHERE v.voyage_id = voy_id;

    SELECT *
    INTO voy
    FROM voyages WHERE voyage_id=voy_id;

    IF voy.type_voy = 'COURT' THEN
        return get_dist(prov, dest) < 1000.0;
    ELSE IF voy.type_voy = 'MOYEN' THEN
        return get_dist(prov, dest) >= 1000.0 AND get_dist(prov, dest) <= 2000.0;
    ELSE
        return get_dist(prov, dest) > 2000.0;
    END IF;
    END IF;
END;
$$;


ALTER FUNCTION public.validate_type_voy(voy_id integer) OWNER TO postgres;

--
-- Name: cargaison; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cargaison (
    carg_id integer NOT NULL,
    voyage_id integer NOT NULL
);


ALTER TABLE public.cargaison OWNER TO postgres;

--
-- Name: cargaison_carg_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cargaison_carg_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.cargaison_carg_id_seq OWNER TO postgres;

--
-- Name: cargaison_carg_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cargaison_carg_id_seq OWNED BY public.cargaison.carg_id;


--
-- Name: etapes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.etapes (
    etape_id integer NOT NULL,
    voyage_id integer NOT NULL,
    port_id integer NOT NULL,
    pass_monte integer DEFAULT 0 NOT NULL,
    pass_descendu integer DEFAULT 0 NOT NULL,
    date_arr date,
    CONSTRAINT check_name CHECK ((pass_descendu > 0)),
    CONSTRAINT validate_pass_monte CHECK ((pass_monte > 0))
);


ALTER TABLE public.etapes OWNER TO postgres;

--
-- Name: etapes_etape_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.etapes_etape_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.etapes_etape_id_seq OWNER TO postgres;

--
-- Name: etapes_etape_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.etapes_etape_id_seq OWNED BY public.etapes.etape_id;


--
-- Name: lien_nat_port; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lien_nat_port (
    nat_id integer NOT NULL,
    port_id integer NOT NULL
);


ALTER TABLE public.lien_nat_port OWNER TO postgres;

--
-- Name: lien_produit_cat; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lien_produit_cat (
    prod_id integer NOT NULL,
    cat_id integer NOT NULL,
    valeur double precision DEFAULT 0 NOT NULL
);


ALTER TABLE public.lien_produit_cat OWNER TO postgres;

--
-- Name: nations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.nations (
    nom character varying NOT NULL,
    nationalite_id integer NOT NULL
);


ALTER TABLE public.nations OWNER TO postgres;

--
-- Name: nations_nationalite_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.nations_nationalite_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.nations_nationalite_id_seq OWNER TO postgres;

--
-- Name: nations_nationalite_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.nations_nationalite_id_seq OWNED BY public.nations.nationalite_id;


--
-- Name: navires; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.navires (
    navire_id integer NOT NULL,
    type integer NOT NULL,
    nationalite_id integer NOT NULL,
    march_vol integer NOT NULL,
    max_pass integer NOT NULL,
    nom character varying DEFAULT ''::character varying NOT NULL,
    CONSTRAINT check_name CHECK ((march_vol > 0)),
    CONSTRAINT max_pass_check CHECK ((max_pass > 0))
);


ALTER TABLE public.navires OWNER TO postgres;

--
-- Name: navires_navire_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.navires_navire_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.navires_navire_id_seq OWNER TO postgres;

--
-- Name: navires_navire_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.navires_navire_id_seq OWNED BY public.navires.navire_id;


--
-- Name: navires_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.navires_type (
    type_id integer NOT NULL,
    name character varying NOT NULL,
    cat integer DEFAULT 1 NOT NULL,
    CONSTRAINT validate_cat CHECK (((cat >= 1) AND (cat <= 5)))
);


ALTER TABLE public.navires_type OWNER TO postgres;

--
-- Name: navires_type_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.navires_type_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.navires_type_type_id_seq OWNER TO postgres;

--
-- Name: navires_type_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.navires_type_type_id_seq OWNED BY public.navires_type.type_id;


--
-- Name: ports_port_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ports_port_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ports_port_id_seq OWNER TO postgres;

--
-- Name: ports_port_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ports_port_id_seq OWNED BY public.ports.port_id;


--
-- Name: prod_achete_etp; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.prod_achete_etp (
    prod_id integer NOT NULL,
    etape_id integer NOT NULL,
    quant integer NOT NULL,
    CONSTRAINT check_name CHECK ((quant > 0))
);


ALTER TABLE public.prod_achete_etp OWNER TO postgres;

--
-- Name: prod_cat; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.prod_cat (
    prod_cat_id integer NOT NULL,
    nom character varying NOT NULL,
    description text
);


ALTER TABLE public.prod_cat OWNER TO postgres;

--
-- Name: prod_cat_prod_cat_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.prod_cat_prod_cat_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.prod_cat_prod_cat_id_seq OWNER TO postgres;

--
-- Name: prod_cat_prod_cat_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.prod_cat_prod_cat_id_seq OWNED BY public.prod_cat.prod_cat_id;


--
-- Name: prod_vendu_etp; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.prod_vendu_etp (
    prod_id integer NOT NULL,
    etape_id integer NOT NULL,
    quant integer NOT NULL,
    CONSTRAINT check_name CHECK ((quant > 0))
);


ALTER TABLE public.prod_vendu_etp OWNER TO postgres;

--
-- Name: produits; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.produits (
    prod_id integer NOT NULL,
    nom character varying NOT NULL,
    est_perissable boolean DEFAULT false NOT NULL,
    volume double precision NOT NULL,
    CONSTRAINT check_name CHECK ((volume > (0)::double precision))
);


ALTER TABLE public.produits OWNER TO postgres;

--
-- Name: produits_prod_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.produits_prod_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.produits_prod_id_seq OWNER TO postgres;

--
-- Name: produits_prod_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.produits_prod_id_seq OWNED BY public.produits.prod_id;


--
-- Name: quant_carg; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.quant_carg (
    carg_id integer NOT NULL,
    prod_id integer NOT NULL,
    quant integer NOT NULL,
    CONSTRAINT check_name CHECK ((quant > 0))
);


ALTER TABLE public.quant_carg OWNER TO postgres;

--
-- Name: quant_port; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.quant_port (
    port_id integer NOT NULL,
    prod_id integer NOT NULL,
    quant integer NOT NULL,
    CONSTRAINT check_name CHECK ((quant > 0))
);


ALTER TABLE public.quant_port OWNER TO postgres;

--
-- Name: relations_nations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.relations_nations (
    nat_1_id integer NOT NULL,
    nat_2_id integer NOT NULL,
    relation character varying NOT NULL,
    CONSTRAINT check_name CHECK (((relation)::text = ANY ((ARRAY['ALLIES COMM'::character varying, 'ALLIES'::character varying, 'NEUTRES'::character varying, 'GUERRE'::character varying])::text[])))
);


ALTER TABLE public.relations_nations OWNER TO postgres;

--
-- Name: voyages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.voyages (
    voyage_id integer NOT NULL,
    destination_id integer NOT NULL,
    date_deb date NOT NULL,
    date_fin date,
    provenance_id integer NOT NULL,
    type_voy character varying NOT NULL,
    class_voy character varying NOT NULL,
    navire_id integer NOT NULL,
    nb_pass_courants integer DEFAULT 0 NOT NULL,
    CONSTRAINT validate_class_voy CHECK (((class_voy)::text = ANY ((ARRAY['EUROPE'::character varying, 'ASIE'::character varying, 'AMERIQUE'::character varying, 'AFRIQUE'::character varying, 'OCEANIE'::character varying, 'INTERC'::character varying])::text[]))),
    CONSTRAINT validate_date CHECK ((date_deb < date_fin)),
    CONSTRAINT validate_type_voy CHECK (((type_voy)::text = ANY ((ARRAY['COURT'::character varying, 'MOYEN'::character varying, 'LONG'::character varying])::text[]))),
    CONSTRAINT validate_type_voy_class_voy CHECK (((NOT ((class_voy)::text = 'INTERC'::text)) OR (((type_voy)::text = 'MOYEN'::text) OR ((type_voy)::text = 'LONG'::text))))
);


ALTER TABLE public.voyages OWNER TO postgres;

--
-- Name: voyages_voyage_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.voyages_voyage_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.voyages_voyage_id_seq OWNER TO postgres;

--
-- Name: voyages_voyage_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.voyages_voyage_id_seq OWNED BY public.voyages.voyage_id;


--
-- Name: cargaison carg_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cargaison ALTER COLUMN carg_id SET DEFAULT nextval('public.cargaison_carg_id_seq'::regclass);


--
-- Name: etapes etape_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.etapes ALTER COLUMN etape_id SET DEFAULT nextval('public.etapes_etape_id_seq'::regclass);


--
-- Name: nations nationalite_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nations ALTER COLUMN nationalite_id SET DEFAULT nextval('public.nations_nationalite_id_seq'::regclass);


--
-- Name: navires navire_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.navires ALTER COLUMN navire_id SET DEFAULT nextval('public.navires_navire_id_seq'::regclass);


--
-- Name: navires_type type_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.navires_type ALTER COLUMN type_id SET DEFAULT nextval('public.navires_type_type_id_seq'::regclass);


--
-- Name: ports port_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ports ALTER COLUMN port_id SET DEFAULT nextval('public.ports_port_id_seq'::regclass);


--
-- Name: prod_cat prod_cat_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prod_cat ALTER COLUMN prod_cat_id SET DEFAULT nextval('public.prod_cat_prod_cat_id_seq'::regclass);


--
-- Name: produits prod_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produits ALTER COLUMN prod_id SET DEFAULT nextval('public.produits_prod_id_seq'::regclass);


--
-- Name: voyages voyage_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.voyages ALTER COLUMN voyage_id SET DEFAULT nextval('public.voyages_voyage_id_seq'::regclass);


--
-- Data for Name: cargaison; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.cargaison (carg_id, voyage_id) VALUES (1, 6);


--
-- Data for Name: etapes; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.etapes (etape_id, voyage_id, port_id, pass_monte, pass_descendu, date_arr) VALUES (2, 6, 10, 20, 43, '1753-08-15');


--
-- Data for Name: lien_nat_port; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.lien_nat_port (nat_id, port_id) VALUES (1, 2);
INSERT INTO public.lien_nat_port (nat_id, port_id) VALUES (3, 5);
INSERT INTO public.lien_nat_port (nat_id, port_id) VALUES (3, 12);
INSERT INTO public.lien_nat_port (nat_id, port_id) VALUES (4, 7);
INSERT INTO public.lien_nat_port (nat_id, port_id) VALUES (5, 8);
INSERT INTO public.lien_nat_port (nat_id, port_id) VALUES (7, 10);
INSERT INTO public.lien_nat_port (nat_id, port_id) VALUES (6, 9);
INSERT INTO public.lien_nat_port (nat_id, port_id) VALUES (8, 3);
INSERT INTO public.lien_nat_port (nat_id, port_id) VALUES (9, 6);
INSERT INTO public.lien_nat_port (nat_id, port_id) VALUES (10, 11);


--
-- Data for Name: lien_produit_cat; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.lien_produit_cat (prod_id, cat_id, valeur) VALUES (1, 1, 15);
INSERT INTO public.lien_produit_cat (prod_id, cat_id, valeur) VALUES (1, 4, 0.3);
INSERT INTO public.lien_produit_cat (prod_id, cat_id, valeur) VALUES (1, 2, 10);
INSERT INTO public.lien_produit_cat (prod_id, cat_id, valeur) VALUES (2, 2, 20);
INSERT INTO public.lien_produit_cat (prod_id, cat_id, valeur) VALUES (2, 1, 21);


--
-- Data for Name: nations; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.nations (nom, nationalite_id) VALUES ('France', 1);
INSERT INTO public.nations (nom, nationalite_id) VALUES ('Portugal', 3);
INSERT INTO public.nations (nom, nationalite_id) VALUES ('Algerie', 4);
INSERT INTO public.nations (nom, nationalite_id) VALUES ('Tunisie', 5);
INSERT INTO public.nations (nom, nationalite_id) VALUES ('Indonesie', 6);
INSERT INTO public.nations (nom, nationalite_id) VALUES ('Afrique du sud', 7);
INSERT INTO public.nations (nom, nationalite_id) VALUES ('Hollande', 8);
INSERT INTO public.nations (nom, nationalite_id) VALUES ('Esapgne', 9);
INSERT INTO public.nations (nom, nationalite_id) VALUES ('Royaume-Uni', 10);


--
-- Data for Name: navires; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.navires (navire_id, type, nationalite_id, march_vol, max_pass, nom) VALUES (1, 3, 1, 100, 100, 'Sunny');
INSERT INTO public.navires (navire_id, type, nationalite_id, march_vol, max_pass, nom) VALUES (3, 4, 3, 100, 50, 'Usain Boat');
INSERT INTO public.navires (navire_id, type, nationalite_id, march_vol, max_pass, nom) VALUES (5, 7, 4, 400, 150, 'Black Pearl');
INSERT INTO public.navires (navire_id, type, nationalite_id, march_vol, max_pass, nom) VALUES (7, 6, 10, 100, 100, 'Revenge');
INSERT INTO public.navires (navire_id, type, nationalite_id, march_vol, max_pass, nom) VALUES (6, 7, 8, 200, 200, 'Hollandais Vollant');
INSERT INTO public.navires (navire_id, type, nationalite_id, march_vol, max_pass, nom) VALUES (8, 2, 10, 200, 200, 'HMS Intrépide');
INSERT INTO public.navires (navire_id, type, nationalite_id, march_vol, max_pass, nom) VALUES (9, 8, 10, 300, 200, 'HMS Endeavour');
INSERT INTO public.navires (navire_id, type, nationalite_id, march_vol, max_pass, nom) VALUES (10, 5, 9, 100, 50, 'Adrestia');
INSERT INTO public.navires (navire_id, type, nationalite_id, march_vol, max_pass, nom) VALUES (11, 7, 9, 200, 200, 'El Arca del Maestro');
INSERT INTO public.navires (navire_id, type, nationalite_id, march_vol, max_pass, nom) VALUES (12, 7, 1, 200, 250, 'Iphygénie');
INSERT INTO public.navires (navire_id, type, nationalite_id, march_vol, max_pass, nom) VALUES (13, 6, 1, 100, 150, 'Subtile');
INSERT INTO public.navires (navire_id, type, nationalite_id, march_vol, max_pass, nom) VALUES (14, 7, 5, 300, 300, 'Titanic II');


--
-- Data for Name: navires_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.navires_type (type_id, name, cat) VALUES (4, 'Caravelle', 4);
INSERT INTO public.navires_type (type_id, name, cat) VALUES (5, 'Chaloupe', 1);
INSERT INTO public.navires_type (type_id, name, cat) VALUES (6, 'Corvette', 2);
INSERT INTO public.navires_type (type_id, name, cat) VALUES (3, 'Gabare', 2);
INSERT INTO public.navires_type (type_id, name, cat) VALUES (1, 'Flûte', 3);
INSERT INTO public.navires_type (type_id, name, cat) VALUES (2, 'Gallion', 3);
INSERT INTO public.navires_type (type_id, name, cat) VALUES (8, 'Goelette', 5);
INSERT INTO public.navires_type (type_id, name, cat) VALUES (7, 'Fregate', 5);


--
-- Data for Name: ports; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.ports (port_id, name, lattitude, longitude, categorie, nb_passagers, continent) VALUES (2, 'Le Havre', 49.478898, 0.121575, 5, 1000, 'EUROPE');
INSERT INTO public.ports (port_id, name, lattitude, longitude, categorie, nb_passagers, continent) VALUES (3, 'Amsterdam', 50.402007, 4.878181, 3, 300, 'EUROPE');
INSERT INTO public.ports (port_id, name, lattitude, longitude, categorie, nb_passagers, continent) VALUES (5, 'Porto', 41.141764, -8.651026, 1, 50, 'EUROPE');
INSERT INTO public.ports (port_id, name, lattitude, longitude, categorie, nb_passagers, continent) VALUES (7, 'Alger', 36.765753, 3.066826, 4, 800, 'AFRIQUE');
INSERT INTO public.ports (port_id, name, lattitude, longitude, categorie, nb_passagers, continent) VALUES (8, 'Tunis', 36.810077, 10.286614, 4, 900, 'AFRIQUE');
INSERT INTO public.ports (port_id, name, lattitude, longitude, categorie, nb_passagers, continent) VALUES (9, 'Jakharta', -6.09956, 106.880726, 5, 1500, 'ASIE');
INSERT INTO public.ports (port_id, name, lattitude, longitude, categorie, nb_passagers, continent) VALUES (10, 'Le Cap', -33.910727, 18.439188, 2, 100, 'AFRIQUE');
INSERT INTO public.ports (port_id, name, lattitude, longitude, categorie, nb_passagers, continent) VALUES (11, 'Miami', 25.77262, -80.176333, 5, 2000, 'AMERIQUE');
INSERT INTO public.ports (port_id, name, lattitude, longitude, categorie, nb_passagers, continent) VALUES (12, 'Rio', -22.889034, -43.212734, 4, 1000, 'AMERIQUE');
INSERT INTO public.ports (port_id, name, lattitude, longitude, categorie, nb_passagers, continent) VALUES (4, 'Portsmouth', 50.816363, -1.095311, 2, 100, 'EUROPE');
INSERT INTO public.ports (port_id, name, lattitude, longitude, categorie, nb_passagers, continent) VALUES (6, 'Huelva', 37.257755, -6.96087, 4, 300, 'EUROPE');


--
-- Data for Name: prod_achete_etp; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.prod_achete_etp (prod_id, etape_id, quant) VALUES (8, 2, 10);


--
-- Data for Name: prod_cat; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.prod_cat (prod_cat_id, nom, description) VALUES (1, 'Durée de conservation', 'Nombre de jours avant péremption.');
INSERT INTO public.prod_cat (prod_cat_id, nom, description) VALUES (2, 'Valeur au kilo', 'Prix (en EUR) pour un kilo du produit (solide).');
INSERT INTO public.prod_cat (prod_cat_id, nom, description) VALUES (3, 'Valeur au litre', 'Prix (en EUR) pour un litre de produit (liquide)');
INSERT INTO public.prod_cat (prod_cat_id, nom, description) VALUES (4, 'Poids en kilo', 'Poids (en kg) du produit.');


--
-- Data for Name: prod_vendu_etp; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.prod_vendu_etp (prod_id, etape_id, quant) VALUES (9, 2, 3);


--
-- Data for Name: produits; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.produits (prod_id, nom, est_perissable, volume) VALUES (1, 'Oranges de Porto', true, 0.5);
INSERT INTO public.produits (prod_id, nom, est_perissable, volume) VALUES (2, 'Beurre', true, 0.2);
INSERT INTO public.produits (prod_id, nom, est_perissable, volume) VALUES (3, 'Boisseau de Sel', false, 0.9);
INSERT INTO public.produits (prod_id, nom, est_perissable, volume) VALUES (4, 'Chandelles', false, 0.4);
INSERT INTO public.produits (prod_id, nom, est_perissable, volume) VALUES (5, 'Savon', false, 0.3);
INSERT INTO public.produits (prod_id, nom, est_perissable, volume) VALUES (6, 'Sucre', false, 0.8);
INSERT INTO public.produits (prod_id, nom, est_perissable, volume) VALUES (7, 'Rhum', false, 1.7);
INSERT INTO public.produits (prod_id, nom, est_perissable, volume) VALUES (8, 'Café', false, 0.8);
INSERT INTO public.produits (prod_id, nom, est_perissable, volume) VALUES (9, 'Tabac', false, 0.4);
INSERT INTO public.produits (prod_id, nom, est_perissable, volume) VALUES (10, 'Colin', true, 0.2);
INSERT INTO public.produits (prod_id, nom, est_perissable, volume) VALUES (11, 'Dattes', true, 0.1);
INSERT INTO public.produits (prod_id, nom, est_perissable, volume) VALUES (12, 'Olives', true, 0.1);


--
-- Data for Name: quant_carg; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.quant_carg (carg_id, prod_id, quant) VALUES (1, 7, 10);
INSERT INTO public.quant_carg (carg_id, prod_id, quant) VALUES (1, 9, 4);
INSERT INTO public.quant_carg (carg_id, prod_id, quant) VALUES (1, 8, 10);


--
-- Data for Name: quant_port; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.quant_port (port_id, prod_id, quant) VALUES (2, 2, 30);
INSERT INTO public.quant_port (port_id, prod_id, quant) VALUES (2, 3, 21);
INSERT INTO public.quant_port (port_id, prod_id, quant) VALUES (2, 5, 5);
INSERT INTO public.quant_port (port_id, prod_id, quant) VALUES (2, 6, 36);
INSERT INTO public.quant_port (port_id, prod_id, quant) VALUES (3, 9, 86);
INSERT INTO public.quant_port (port_id, prod_id, quant) VALUES (3, 7, 10);
INSERT INTO public.quant_port (port_id, prod_id, quant) VALUES (5, 1, 79);
INSERT INTO public.quant_port (port_id, prod_id, quant) VALUES (5, 4, 32);
INSERT INTO public.quant_port (port_id, prod_id, quant) VALUES (6, 10, 67);
INSERT INTO public.quant_port (port_id, prod_id, quant) VALUES (6, 7, 13);
INSERT INTO public.quant_port (port_id, prod_id, quant) VALUES (7, 11, 89);
INSERT INTO public.quant_port (port_id, prod_id, quant) VALUES (7, 12, 75);
INSERT INTO public.quant_port (port_id, prod_id, quant) VALUES (8, 12, 89);
INSERT INTO public.quant_port (port_id, prod_id, quant) VALUES (8, 11, 75);
INSERT INTO public.quant_port (port_id, prod_id, quant) VALUES (9, 3, 45);
INSERT INTO public.quant_port (port_id, prod_id, quant) VALUES (9, 6, 13);
INSERT INTO public.quant_port (port_id, prod_id, quant) VALUES (9, 10, 2);
INSERT INTO public.quant_port (port_id, prod_id, quant) VALUES (10, 9, 43);
INSERT INTO public.quant_port (port_id, prod_id, quant) VALUES (11, 7, 103);
INSERT INTO public.quant_port (port_id, prod_id, quant) VALUES (11, 9, 76);
INSERT INTO public.quant_port (port_id, prod_id, quant) VALUES (12, 5, 85);
INSERT INTO public.quant_port (port_id, prod_id, quant) VALUES (12, 3, 43);
INSERT INTO public.quant_port (port_id, prod_id, quant) VALUES (10, 8, 94);
INSERT INTO public.quant_port (port_id, prod_id, quant) VALUES (9, 7, 10);
INSERT INTO public.quant_port (port_id, prod_id, quant) VALUES (9, 9, 4);
INSERT INTO public.quant_port (port_id, prod_id, quant) VALUES (9, 8, 10);


--
-- Data for Name: relations_nations; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.relations_nations (nat_1_id, nat_2_id, relation) VALUES (1, 3, 'GUERRE');
INSERT INTO public.relations_nations (nat_1_id, nat_2_id, relation) VALUES (3, 9, 'GUERRE');
INSERT INTO public.relations_nations (nat_1_id, nat_2_id, relation) VALUES (6, 5, 'GUERRE');
INSERT INTO public.relations_nations (nat_1_id, nat_2_id, relation) VALUES (10, 9, 'GUERRE');
INSERT INTO public.relations_nations (nat_1_id, nat_2_id, relation) VALUES (10, 7, 'ALLIES');
INSERT INTO public.relations_nations (nat_1_id, nat_2_id, relation) VALUES (9, 8, 'NEUTRES');
INSERT INTO public.relations_nations (nat_1_id, nat_2_id, relation) VALUES (6, 7, 'ALLIES');
INSERT INTO public.relations_nations (nat_1_id, nat_2_id, relation) VALUES (6, 8, 'ALLIES COMM');
INSERT INTO public.relations_nations (nat_1_id, nat_2_id, relation) VALUES (9, 1, 'GUERRE');
INSERT INTO public.relations_nations (nat_1_id, nat_2_id, relation) VALUES (1, 4, 'ALLIES COMM');


--
-- Data for Name: voyages; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.voyages (voyage_id, destination_id, date_deb, date_fin, provenance_id, type_voy, class_voy, navire_id, nb_pass_courants) VALUES (6, 9, '1753-03-04', '1754-01-10', 11, 'LONG', 'INTERC', 9, 177);


--
-- Name: cargaison_carg_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cargaison_carg_id_seq', 1, true);


--
-- Name: etapes_etape_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.etapes_etape_id_seq', 2, true);


--
-- Name: nations_nationalite_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.nations_nationalite_id_seq', 10, true);


--
-- Name: navires_navire_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.navires_navire_id_seq', 14, true);


--
-- Name: navires_type_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.navires_type_type_id_seq', 8, true);


--
-- Name: ports_port_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ports_port_id_seq', 12, true);


--
-- Name: prod_cat_prod_cat_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.prod_cat_prod_cat_id_seq', 4, true);


--
-- Name: produits_prod_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.produits_prod_id_seq', 12, true);


--
-- Name: voyages_voyage_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.voyages_voyage_id_seq', 6, true);


--
-- Name: cargaison cargaison_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cargaison
    ADD CONSTRAINT cargaison_pk PRIMARY KEY (carg_id);


--
-- Name: etapes etapes_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.etapes
    ADD CONSTRAINT etapes_pk PRIMARY KEY (etape_id);


--
-- Name: nations nations_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nations
    ADD CONSTRAINT nations_pk PRIMARY KEY (nationalite_id);


--
-- Name: navires navires_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.navires
    ADD CONSTRAINT navires_pk PRIMARY KEY (navire_id);


--
-- Name: navires_type navires_type_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.navires_type
    ADD CONSTRAINT navires_type_pk PRIMARY KEY (type_id);


--
-- Name: ports ports_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ports
    ADD CONSTRAINT ports_pk PRIMARY KEY (port_id);


--
-- Name: prod_cat prod_cat_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prod_cat
    ADD CONSTRAINT prod_cat_pk PRIMARY KEY (prod_cat_id);


--
-- Name: produits produits_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.produits
    ADD CONSTRAINT produits_pk PRIMARY KEY (prod_id);


--
-- Name: voyages voyages_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.voyages
    ADD CONSTRAINT voyages_pk PRIMARY KEY (voyage_id);


--
-- Name: cargaison_carg_id_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX cargaison_carg_id_uindex ON public.cargaison USING btree (carg_id);


--
-- Name: etapes_etape_id_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX etapes_etape_id_uindex ON public.etapes USING btree (etape_id);


--
-- Name: nations_nationalite_id_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX nations_nationalite_id_uindex ON public.nations USING btree (nationalite_id);


--
-- Name: nations_nom_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX nations_nom_uindex ON public.nations USING btree (nom);


--
-- Name: navires_navire_id_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX navires_navire_id_uindex ON public.navires USING btree (navire_id);


--
-- Name: navires_type_type_id_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX navires_type_type_id_uindex ON public.navires_type USING btree (type_id);


--
-- Name: ports_port_id_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ports_port_id_uindex ON public.ports USING btree (port_id);


--
-- Name: prod_cat_prod_cat_id_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX prod_cat_prod_cat_id_uindex ON public.prod_cat USING btree (prod_cat_id);


--
-- Name: produits_prod_id_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX produits_prod_id_uindex ON public.produits USING btree (prod_id);


--
-- Name: voyages_voyage_id_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX voyages_voyage_id_uindex ON public.voyages USING btree (voyage_id);


--
-- Name: cargaison cargaison_voyages_voyage_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cargaison
    ADD CONSTRAINT cargaison_voyages_voyage_id_fk FOREIGN KEY (voyage_id) REFERENCES public.voyages(voyage_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: etapes etapes_ports_port_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.etapes
    ADD CONSTRAINT etapes_ports_port_id_fk FOREIGN KEY (port_id) REFERENCES public.ports(port_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: etapes etapes_voyages_voyage_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.etapes
    ADD CONSTRAINT etapes_voyages_voyage_id_fk FOREIGN KEY (voyage_id) REFERENCES public.voyages(voyage_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: lien_nat_port lien_nat_port_nations_nationalite_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lien_nat_port
    ADD CONSTRAINT lien_nat_port_nations_nationalite_id_fk FOREIGN KEY (nat_id) REFERENCES public.nations(nationalite_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: lien_nat_port lien_nat_port_ports_port_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lien_nat_port
    ADD CONSTRAINT lien_nat_port_ports_port_id_fk FOREIGN KEY (port_id) REFERENCES public.ports(port_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: lien_produit_cat lien_produit_cat_prod_cat_prod_cat_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lien_produit_cat
    ADD CONSTRAINT lien_produit_cat_prod_cat_prod_cat_id_fk FOREIGN KEY (cat_id) REFERENCES public.prod_cat(prod_cat_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: lien_produit_cat lien_produit_cat_produits_prod_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lien_produit_cat
    ADD CONSTRAINT lien_produit_cat_produits_prod_id_fk FOREIGN KEY (prod_id) REFERENCES public.produits(prod_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: navires navires_nations_nationalite_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.navires
    ADD CONSTRAINT navires_nations_nationalite_id_fk FOREIGN KEY (nationalite_id) REFERENCES public.nations(nationalite_id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: navires navires_navires_type_type_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.navires
    ADD CONSTRAINT navires_navires_type_type_id_fk FOREIGN KEY (type) REFERENCES public.navires_type(type_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: prod_achete_etp prod_achete_etp_etapes_etape_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prod_achete_etp
    ADD CONSTRAINT prod_achete_etp_etapes_etape_id_fk FOREIGN KEY (etape_id) REFERENCES public.etapes(etape_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: prod_achete_etp prod_achete_etp_produits_prod_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prod_achete_etp
    ADD CONSTRAINT prod_achete_etp_produits_prod_id_fk FOREIGN KEY (prod_id) REFERENCES public.produits(prod_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: prod_vendu_etp prod_vendu_etp_etapes_etape_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prod_vendu_etp
    ADD CONSTRAINT prod_vendu_etp_etapes_etape_id_fk FOREIGN KEY (etape_id) REFERENCES public.etapes(etape_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: prod_vendu_etp prod_vendu_etp_produits_prod_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.prod_vendu_etp
    ADD CONSTRAINT prod_vendu_etp_produits_prod_id_fk FOREIGN KEY (prod_id) REFERENCES public.produits(prod_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: quant_carg quant_carg_cargaison_carg_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quant_carg
    ADD CONSTRAINT quant_carg_cargaison_carg_id_fk FOREIGN KEY (carg_id) REFERENCES public.cargaison(carg_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: quant_carg quant_carg_produits_prod_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quant_carg
    ADD CONSTRAINT quant_carg_produits_prod_id_fk FOREIGN KEY (prod_id) REFERENCES public.produits(prod_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: quant_port quant_port_ports_port_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quant_port
    ADD CONSTRAINT quant_port_ports_port_id_fk FOREIGN KEY (port_id) REFERENCES public.ports(port_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: quant_port quant_port_produits_prod_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.quant_port
    ADD CONSTRAINT quant_port_produits_prod_id_fk FOREIGN KEY (prod_id) REFERENCES public.produits(prod_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: relations_nations relations_nations_nations_nationalite_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.relations_nations
    ADD CONSTRAINT relations_nations_nations_nationalite_id_fk FOREIGN KEY (nat_1_id) REFERENCES public.nations(nationalite_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: relations_nations relations_nations_nations_nationalite_id_fk_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.relations_nations
    ADD CONSTRAINT relations_nations_nations_nationalite_id_fk_2 FOREIGN KEY (nat_2_id) REFERENCES public.nations(nationalite_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: voyages voyages_destination_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.voyages
    ADD CONSTRAINT voyages_destination_fk FOREIGN KEY (destination_id) REFERENCES public.ports(port_id);


--
-- Name: voyages voyages_navires_navire_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.voyages
    ADD CONSTRAINT voyages_navires_navire_id_fk FOREIGN KEY (navire_id) REFERENCES public.navires(navire_id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: voyages voyages_provenance_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.voyages
    ADD CONSTRAINT voyages_provenance_fk FOREIGN KEY (provenance_id) REFERENCES public.ports(port_id);


--
-- PostgreSQL database dump complete
--

