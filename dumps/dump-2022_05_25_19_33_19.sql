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
    port_id integer NOT NULL
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
-- Name: nations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.nations (
    nom character varying NOT NULL
);


ALTER TABLE public.nations OWNER TO postgres;

--
-- Name: navires; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.navires (
    navire_id integer NOT NULL,
    type character varying NOT NULL,
    categorie integer NOT NULL,
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
-- Name: voyages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.voyages (
    voyage_id integer NOT NULL,
    destination_id integer NOT NULL,
    date_deb date NOT NULL,
    date_fin date,
    provenance_id integer NOT NULL,
    type_voy character varying NOT NULL,
    class_voy character varying NOT NULL
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
-- Name: navires navire_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.navires ALTER COLUMN navire_id SET DEFAULT nextval('public.navires_navire_id_seq'::regclass);


--
-- Name: ports port_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ports ALTER COLUMN port_id SET DEFAULT nextval('public.ports_port_id_seq'::regclass);


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
-- Data for Name: nations; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: navires; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: ports; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- Data for Name: produits; Type: TABLE DATA; Schema: public; Owner: postgres
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
-- Name: navires_navire_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.navires_navire_id_seq', 1, false);


--
-- Name: ports_port_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ports_port_id_seq', 1, false);


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
    ADD CONSTRAINT etapes_pk PRIMARY KEY (etape_id);


--
-- Name: nations nations_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nations
    ADD CONSTRAINT nations_pk PRIMARY KEY (nom);


--
-- Name: navires navires_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.navires
    ADD CONSTRAINT navires_pk PRIMARY KEY (navire_id);


--
-- Name: ports ports_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ports
    ADD CONSTRAINT ports_pk PRIMARY KEY (port_id);


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
-- Name: nations_nom_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX nations_nom_uindex ON public.nations USING btree (nom);


--
-- Name: navires_navire_id_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX navires_navire_id_uindex ON public.navires USING btree (navire_id);


--
-- Name: ports_port_id_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ports_port_id_uindex ON public.ports USING btree (port_id);


--
-- Name: produits_prod_id_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX produits_prod_id_uindex ON public.produits USING btree (prod_id);


--
-- Name: voyages_voyage_id_uindex; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX voyages_voyage_id_uindex ON public.voyages USING btree (voyage_id);


--
-- PostgreSQL database dump complete
--

