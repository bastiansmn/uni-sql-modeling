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

DROP DATABASE IF EXISTS postgres;
--
-- Name: postgres; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE postgres WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'fr_FR.UTF-8';


ALTER DATABASE postgres OWNER TO postgres;

\connect postgres

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
-- Name: DATABASE postgres; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON DATABASE postgres IS 'default administrative connection database';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: cargaison; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cargaison (
    carg_id integer NOT NULL,
    voyage_id integer NOT NULL,
    navire_id integer NOT NULL
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
    pass_descendu integer DEFAULT 0 NOT NULL
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
-- Name: lien_produit_cat; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lien_produit_cat (
    prod_id integer NOT NULL,
    cat_id integer NOT NULL
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
    max_pass integer NOT NULL
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
    cat integer DEFAULT 1 NOT NULL
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
-- Name: ports; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ports (
    port_id integer NOT NULL,
    name character varying NOT NULL,
    lattitude double precision NOT NULL,
    longitude double precision NOT NULL,
    nat_id integer NOT NULL,
    categorie integer NOT NULL
);


ALTER TABLE public.ports OWNER TO postgres;

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
    quant integer NOT NULL
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
    quant integer
);


ALTER TABLE public.prod_vendu_etp OWNER TO postgres;

--
-- Name: produits; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.produits (
    prod_id integer NOT NULL,
    nom character varying NOT NULL,
    est_perissable boolean DEFAULT false NOT NULL
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
    quant integer NOT NULL
);


ALTER TABLE public.quant_carg OWNER TO postgres;

--
-- Name: relations_nations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.relations_nations (
    nat_1_id integer NOT NULL,
    nat_2_id integer NOT NULL,
    relation character varying NOT NULL
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
    nb_pass_courants integer DEFAULT 0 NOT NULL
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



--
-- Data for Name: etapes; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: lien_produit_cat; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: nations; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: navires; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: navires_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.navires_type (type_id, name, cat) VALUES (2, 'Gallion', 2);
INSERT INTO public.navires_type (type_id, name, cat) VALUES (3, 'Gabare', 3);
INSERT INTO public.navires_type (type_id, name, cat) VALUES (1, 'Flûte', 1);


--
-- Data for Name: ports; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: prod_achete_etp; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: prod_cat; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: prod_vendu_etp; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: produits; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: quant_carg; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: relations_nations; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: voyages; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Name: cargaison_carg_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cargaison_carg_id_seq', 1, false);


--
-- Name: etapes_etape_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.etapes_etape_id_seq', 1, false);


--
-- Name: nations_nationalite_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.nations_nationalite_id_seq', 1, false);


--
-- Name: navires_navire_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.navires_navire_id_seq', 1, false);


--
-- Name: navires_type_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.navires_type_type_id_seq', 3, true);


--
-- Name: ports_port_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ports_port_id_seq', 1, false);


--
-- Name: prod_cat_prod_cat_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.prod_cat_prod_cat_id_seq', 1, false);


--
-- Name: produits_prod_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.produits_prod_id_seq', 1, false);


--
-- Name: voyages_voyage_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.voyages_voyage_id_seq', 1, false);


--
-- Name: cargaison cargaison_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cargaison
    ADD CONSTRAINT cargaison_pk PRIMARY KEY (carg_id);


--
-- Name: etapes etapes_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.etapes
    ADD CONSTRAINT etapes_pk PRIMARY KEY (etape_id, voyage_id, port_id);


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
-- Name: cargaison cargaison_navires_navire_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cargaison
    ADD CONSTRAINT cargaison_navires_navire_id_fk FOREIGN KEY (navire_id) REFERENCES public.navires(navire_id) ON UPDATE CASCADE ON DELETE CASCADE;


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
-- Name: ports ports_nations_nationalite_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ports
    ADD CONSTRAINT ports_nations_nationalite_id_fk FOREIGN KEY (nat_id) REFERENCES public.nations(nationalite_id) ON UPDATE CASCADE ON DELETE CASCADE;


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

