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

