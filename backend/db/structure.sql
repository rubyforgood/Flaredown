--
-- PostgreSQL database dump
--

-- Dumped from database version 13.2
-- Dumped by pg_dump version 13.2

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
-- Name: hstore; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS hstore WITH SCHEMA public;


--
-- Name: EXTENSION hstore; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION hstore IS 'data type for storing sets of (key, value) pairs';


--
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: condition_translations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.condition_translations (
    id integer NOT NULL,
    condition_id integer NOT NULL,
    locale character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    name character varying
);


--
-- Name: condition_translations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.condition_translations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: condition_translations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.condition_translations_id_seq OWNED BY public.condition_translations.id;


--
-- Name: conditions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.conditions (
    id integer NOT NULL,
    global boolean DEFAULT true,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    trackable_usages_count integer DEFAULT 0
);


--
-- Name: conditions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.conditions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: conditions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.conditions_id_seq OWNED BY public.conditions.id;


--
-- Name: crono_jobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.crono_jobs (
    id integer NOT NULL,
    job_id character varying NOT NULL,
    log text,
    last_performed_at timestamp without time zone,
    healthy boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: crono_jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.crono_jobs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: crono_jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.crono_jobs_id_seq OWNED BY public.crono_jobs.id;


--
-- Name: food_translations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.food_translations (
    id integer NOT NULL,
    food_id integer NOT NULL,
    locale character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    long_desc character varying NOT NULL,
    shrt_desc character varying,
    comname character varying,
    sciname character varying
);


--
-- Name: food_translations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.food_translations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: food_translations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.food_translations_id_seq OWNED BY public.food_translations.id;


--
-- Name: foods; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.foods (
    id integer NOT NULL,
    ndb_no character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    global boolean DEFAULT true,
    trackable_usages_count integer DEFAULT 0
);


--
-- Name: foods_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.foods_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: foods_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.foods_id_seq OWNED BY public.foods.id;


--
-- Name: positions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.positions (
    id integer NOT NULL,
    postal_code character varying NOT NULL,
    location_name character varying NOT NULL,
    latitude numeric(10,7),
    longitude numeric(10,7)
);


--
-- Name: positions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.positions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: positions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.positions_id_seq OWNED BY public.positions.id;


--
-- Name: profiles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.profiles (
    id integer NOT NULL,
    user_id integer,
    country_id character varying,
    birth_date date,
    sex_id character varying,
    onboarding_step_id character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    ethnicity_ids_string character varying,
    day_habit_id character varying,
    education_level_id character varying,
    day_walking_hours integer,
    most_recent_doses public.hstore,
    screen_name character varying,
    most_recent_conditions_positions public.hstore,
    most_recent_symptoms_positions public.hstore,
    most_recent_treatments_positions public.hstore,
    pressure_units integer DEFAULT 0,
    temperature_units integer DEFAULT 0,
    beta_tester boolean DEFAULT false,
    notify boolean DEFAULT true,
    notify_token character varying,
    slug_name character varying,
    notify_top_posts boolean DEFAULT true,
    checkin_reminder boolean DEFAULT false,
    checkin_reminder_at timestamp without time zone,
    time_zone_name character varying,
    reminder_job_id character varying,
    rejected_type character varying
);


--
-- Name: profiles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.profiles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.profiles_id_seq OWNED BY public.profiles.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: symptom_translations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.symptom_translations (
    id integer NOT NULL,
    symptom_id integer NOT NULL,
    locale character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    name character varying
);


--
-- Name: symptom_translations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.symptom_translations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: symptom_translations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.symptom_translations_id_seq OWNED BY public.symptom_translations.id;


--
-- Name: symptoms; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.symptoms (
    id integer NOT NULL,
    global boolean DEFAULT true,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    trackable_usages_count integer DEFAULT 0
);


--
-- Name: symptoms_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.symptoms_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: symptoms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.symptoms_id_seq OWNED BY public.symptoms.id;


--
-- Name: tag_translations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tag_translations (
    id integer NOT NULL,
    tag_id integer NOT NULL,
    locale character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    name character varying
);


--
-- Name: tag_translations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tag_translations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tag_translations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tag_translations_id_seq OWNED BY public.tag_translations.id;


--
-- Name: tags; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.tags (
    id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    global boolean DEFAULT true,
    trackable_usages_count integer DEFAULT 0
);


--
-- Name: tags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tags_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tags_id_seq OWNED BY public.tags.id;


--
-- Name: trackable_usages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.trackable_usages (
    id integer NOT NULL,
    user_id integer,
    trackable_type character varying,
    trackable_id integer,
    count integer DEFAULT 1,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: trackable_usages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.trackable_usages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: trackable_usages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.trackable_usages_id_seq OWNED BY public.trackable_usages.id;


--
-- Name: trackings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.trackings (
    id integer NOT NULL,
    user_id integer,
    trackable_type character varying,
    trackable_id integer,
    start_at date,
    end_at date,
    color_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: trackings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.trackings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: trackings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.trackings_id_seq OWNED BY public.trackings.id;


--
-- Name: treatment_translations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.treatment_translations (
    id integer NOT NULL,
    treatment_id integer NOT NULL,
    locale character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    name character varying
);


--
-- Name: treatment_translations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.treatment_translations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: treatment_translations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.treatment_translations_id_seq OWNED BY public.treatment_translations.id;


--
-- Name: treatments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.treatments (
    id integer NOT NULL,
    global boolean DEFAULT true,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    trackable_usages_count integer DEFAULT 0
);


--
-- Name: treatments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.treatments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: treatments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.treatments_id_seq OWNED BY public.treatments.id;


--
-- Name: user_conditions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_conditions (
    id integer NOT NULL,
    user_id integer,
    condition_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: user_conditions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_conditions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_conditions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.user_conditions_id_seq OWNED BY public.user_conditions.id;


--
-- Name: user_foods; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_foods (
    id integer NOT NULL,
    user_id integer,
    food_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: user_foods_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_foods_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_foods_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.user_foods_id_seq OWNED BY public.user_foods.id;


--
-- Name: user_symptoms; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_symptoms (
    id integer NOT NULL,
    user_id integer,
    symptom_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: user_symptoms_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_symptoms_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_symptoms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.user_symptoms_id_seq OWNED BY public.user_symptoms.id;


--
-- Name: user_tags; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_tags (
    id integer NOT NULL,
    user_id integer,
    tag_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: user_tags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_tags_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.user_tags_id_seq OWNED BY public.user_tags.id;


--
-- Name: user_treatments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_treatments (
    id integer NOT NULL,
    user_id integer,
    treatment_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: user_treatments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_treatments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_treatments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.user_treatments_id_seq OWNED BY public.user_treatments.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id integer NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying,
    last_sign_in_ip character varying,
    authentication_token character varying NOT NULL,
    invitation_token character varying,
    invitation_created_at timestamp without time zone,
    invitation_sent_at timestamp without time zone,
    invitation_accepted_at timestamp without time zone,
    invitation_limit integer,
    invited_by_id integer,
    invited_by_type character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: weathers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.weathers (
    id integer NOT NULL,
    date date,
    postal_code character varying,
    icon character varying,
    summary character varying,
    temperature_min double precision,
    temperature_max double precision,
    precip_intensity double precision,
    pressure double precision,
    humidity double precision,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    position_id integer
);


--
-- Name: weathers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.weathers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: weathers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.weathers_id_seq OWNED BY public.weathers.id;


--
-- Name: condition_translations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.condition_translations ALTER COLUMN id SET DEFAULT nextval('public.condition_translations_id_seq'::regclass);


--
-- Name: conditions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.conditions ALTER COLUMN id SET DEFAULT nextval('public.conditions_id_seq'::regclass);


--
-- Name: crono_jobs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crono_jobs ALTER COLUMN id SET DEFAULT nextval('public.crono_jobs_id_seq'::regclass);


--
-- Name: food_translations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.food_translations ALTER COLUMN id SET DEFAULT nextval('public.food_translations_id_seq'::regclass);


--
-- Name: foods id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.foods ALTER COLUMN id SET DEFAULT nextval('public.foods_id_seq'::regclass);


--
-- Name: positions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.positions ALTER COLUMN id SET DEFAULT nextval('public.positions_id_seq'::regclass);


--
-- Name: profiles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.profiles ALTER COLUMN id SET DEFAULT nextval('public.profiles_id_seq'::regclass);


--
-- Name: symptom_translations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.symptom_translations ALTER COLUMN id SET DEFAULT nextval('public.symptom_translations_id_seq'::regclass);


--
-- Name: symptoms id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.symptoms ALTER COLUMN id SET DEFAULT nextval('public.symptoms_id_seq'::regclass);


--
-- Name: tag_translations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tag_translations ALTER COLUMN id SET DEFAULT nextval('public.tag_translations_id_seq'::regclass);


--
-- Name: tags id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tags ALTER COLUMN id SET DEFAULT nextval('public.tags_id_seq'::regclass);


--
-- Name: trackable_usages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.trackable_usages ALTER COLUMN id SET DEFAULT nextval('public.trackable_usages_id_seq'::regclass);


--
-- Name: trackings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.trackings ALTER COLUMN id SET DEFAULT nextval('public.trackings_id_seq'::regclass);


--
-- Name: treatment_translations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.treatment_translations ALTER COLUMN id SET DEFAULT nextval('public.treatment_translations_id_seq'::regclass);


--
-- Name: treatments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.treatments ALTER COLUMN id SET DEFAULT nextval('public.treatments_id_seq'::regclass);


--
-- Name: user_conditions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_conditions ALTER COLUMN id SET DEFAULT nextval('public.user_conditions_id_seq'::regclass);


--
-- Name: user_foods id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_foods ALTER COLUMN id SET DEFAULT nextval('public.user_foods_id_seq'::regclass);


--
-- Name: user_symptoms id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_symptoms ALTER COLUMN id SET DEFAULT nextval('public.user_symptoms_id_seq'::regclass);


--
-- Name: user_tags id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_tags ALTER COLUMN id SET DEFAULT nextval('public.user_tags_id_seq'::regclass);


--
-- Name: user_treatments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_treatments ALTER COLUMN id SET DEFAULT nextval('public.user_treatments_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: weathers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.weathers ALTER COLUMN id SET DEFAULT nextval('public.weathers_id_seq'::regclass);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: condition_translations condition_translations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.condition_translations
    ADD CONSTRAINT condition_translations_pkey PRIMARY KEY (id);


--
-- Name: conditions conditions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.conditions
    ADD CONSTRAINT conditions_pkey PRIMARY KEY (id);


--
-- Name: crono_jobs crono_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.crono_jobs
    ADD CONSTRAINT crono_jobs_pkey PRIMARY KEY (id);


--
-- Name: food_translations food_translations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.food_translations
    ADD CONSTRAINT food_translations_pkey PRIMARY KEY (id);


--
-- Name: foods foods_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.foods
    ADD CONSTRAINT foods_pkey PRIMARY KEY (id);


--
-- Name: positions positions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.positions
    ADD CONSTRAINT positions_pkey PRIMARY KEY (id);


--
-- Name: profiles profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: symptom_translations symptom_translations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.symptom_translations
    ADD CONSTRAINT symptom_translations_pkey PRIMARY KEY (id);


--
-- Name: symptoms symptoms_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.symptoms
    ADD CONSTRAINT symptoms_pkey PRIMARY KEY (id);


--
-- Name: tag_translations tag_translations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tag_translations
    ADD CONSTRAINT tag_translations_pkey PRIMARY KEY (id);


--
-- Name: tags tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: trackable_usages trackable_usages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.trackable_usages
    ADD CONSTRAINT trackable_usages_pkey PRIMARY KEY (id);


--
-- Name: trackings trackings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.trackings
    ADD CONSTRAINT trackings_pkey PRIMARY KEY (id);


--
-- Name: treatment_translations treatment_translations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.treatment_translations
    ADD CONSTRAINT treatment_translations_pkey PRIMARY KEY (id);


--
-- Name: treatments treatments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.treatments
    ADD CONSTRAINT treatments_pkey PRIMARY KEY (id);


--
-- Name: user_conditions user_conditions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_conditions
    ADD CONSTRAINT user_conditions_pkey PRIMARY KEY (id);


--
-- Name: user_foods user_foods_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_foods
    ADD CONSTRAINT user_foods_pkey PRIMARY KEY (id);


--
-- Name: user_symptoms user_symptoms_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_symptoms
    ADD CONSTRAINT user_symptoms_pkey PRIMARY KEY (id);


--
-- Name: user_tags user_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_tags
    ADD CONSTRAINT user_tags_pkey PRIMARY KEY (id);


--
-- Name: user_treatments user_treatments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_treatments
    ADD CONSTRAINT user_treatments_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: weathers weathers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.weathers
    ADD CONSTRAINT weathers_pkey PRIMARY KEY (id);


--
-- Name: idx_fts_food_translations_en; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_fts_food_translations_en ON public.food_translations USING gin (to_tsvector('english'::regconfig, (long_desc)::text)) WHERE ((locale)::text = 'en'::text);


--
-- Name: idx_fts_food_translations_it; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_fts_food_translations_it ON public.food_translations USING gin (to_tsvector('italian'::regconfig, (long_desc)::text)) WHERE ((locale)::text = 'it'::text);


--
-- Name: index_condition_translations_on_condition_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_condition_translations_on_condition_id ON public.condition_translations USING btree (condition_id);


--
-- Name: index_condition_translations_on_locale; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_condition_translations_on_locale ON public.condition_translations USING btree (locale);


--
-- Name: index_crono_jobs_on_job_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_crono_jobs_on_job_id ON public.crono_jobs USING btree (job_id);


--
-- Name: index_food_translations_on_food_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_food_translations_on_food_id ON public.food_translations USING btree (food_id);


--
-- Name: index_food_translations_on_locale; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_food_translations_on_locale ON public.food_translations USING btree (locale);


--
-- Name: index_foods_on_ndb_no; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_foods_on_ndb_no ON public.foods USING btree (ndb_no);


--
-- Name: index_profiles_on_slug_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_profiles_on_slug_name ON public.profiles USING btree (slug_name);


--
-- Name: index_profiles_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_profiles_on_user_id ON public.profiles USING btree (user_id);


--
-- Name: index_symptom_translations_on_locale; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_symptom_translations_on_locale ON public.symptom_translations USING btree (locale);


--
-- Name: index_symptom_translations_on_symptom_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_symptom_translations_on_symptom_id ON public.symptom_translations USING btree (symptom_id);


--
-- Name: index_tag_translations_on_locale; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tag_translations_on_locale ON public.tag_translations USING btree (locale);


--
-- Name: index_tag_translations_on_tag_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tag_translations_on_tag_id ON public.tag_translations USING btree (tag_id);


--
-- Name: index_trackable_usages_on_trackable_type_and_trackable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_trackable_usages_on_trackable_type_and_trackable_id ON public.trackable_usages USING btree (trackable_type, trackable_id);


--
-- Name: index_trackable_usages_on_unique_columns; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_trackable_usages_on_unique_columns ON public.trackable_usages USING btree (user_id, trackable_type, trackable_id);


--
-- Name: index_trackable_usages_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_trackable_usages_on_user_id ON public.trackable_usages USING btree (user_id);


--
-- Name: index_trackings_on_trackable_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_trackings_on_trackable_type ON public.trackings USING btree (trackable_type);


--
-- Name: index_trackings_on_trackable_type_and_trackable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_trackings_on_trackable_type_and_trackable_id ON public.trackings USING btree (trackable_type, trackable_id);


--
-- Name: index_trackings_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_trackings_on_user_id ON public.trackings USING btree (user_id);


--
-- Name: index_trackings_unique_trackable; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_trackings_unique_trackable ON public.trackings USING btree (user_id, trackable_id, trackable_type, start_at);


--
-- Name: index_treatment_translations_on_locale; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_treatment_translations_on_locale ON public.treatment_translations USING btree (locale);


--
-- Name: index_treatment_translations_on_treatment_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_treatment_translations_on_treatment_id ON public.treatment_translations USING btree (treatment_id);


--
-- Name: index_user_conditions_on_condition_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_user_conditions_on_condition_id ON public.user_conditions USING btree (condition_id);


--
-- Name: index_user_conditions_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_user_conditions_on_user_id ON public.user_conditions USING btree (user_id);


--
-- Name: index_user_foods_on_food_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_user_foods_on_food_id ON public.user_foods USING btree (food_id);


--
-- Name: index_user_foods_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_user_foods_on_user_id ON public.user_foods USING btree (user_id);


--
-- Name: index_user_symptoms_on_symptom_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_user_symptoms_on_symptom_id ON public.user_symptoms USING btree (symptom_id);


--
-- Name: index_user_symptoms_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_user_symptoms_on_user_id ON public.user_symptoms USING btree (user_id);


--
-- Name: index_user_tags_on_tag_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_user_tags_on_tag_id ON public.user_tags USING btree (tag_id);


--
-- Name: index_user_tags_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_user_tags_on_user_id ON public.user_tags USING btree (user_id);


--
-- Name: index_user_treatments_on_treatment_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_user_treatments_on_treatment_id ON public.user_treatments USING btree (treatment_id);


--
-- Name: index_user_treatments_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_user_treatments_on_user_id ON public.user_treatments USING btree (user_id);


--
-- Name: index_users_on_authentication_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_authentication_token ON public.users USING btree (authentication_token);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: index_users_on_invitation_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_invitation_token ON public.users USING btree (invitation_token);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_reset_password_token ON public.users USING btree (reset_password_token);


--
-- Name: index_weathers_on_date_and_postal_code; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_weathers_on_date_and_postal_code ON public.weathers USING btree (date, postal_code);


--
-- Name: user_treatments fk_rails_0ef098da93; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_treatments
    ADD CONSTRAINT fk_rails_0ef098da93 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: user_conditions fk_rails_1fa14e4e8c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_conditions
    ADD CONSTRAINT fk_rails_1fa14e4e8c FOREIGN KEY (condition_id) REFERENCES public.conditions(id);


--
-- Name: user_conditions fk_rails_47c01ca983; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_conditions
    ADD CONSTRAINT fk_rails_47c01ca983 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: trackings fk_rails_493dc44b5f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.trackings
    ADD CONSTRAINT fk_rails_493dc44b5f FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: user_treatments fk_rails_49855db565; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_treatments
    ADD CONSTRAINT fk_rails_49855db565 FOREIGN KEY (treatment_id) REFERENCES public.treatments(id);


--
-- Name: trackable_usages fk_rails_53d2120ad1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.trackable_usages
    ADD CONSTRAINT fk_rails_53d2120ad1 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: user_tags fk_rails_7156651ad8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_tags
    ADD CONSTRAINT fk_rails_7156651ad8 FOREIGN KEY (tag_id) REFERENCES public.tags(id);


--
-- Name: user_symptoms fk_rails_86699b81a3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_symptoms
    ADD CONSTRAINT fk_rails_86699b81a3 FOREIGN KEY (symptom_id) REFERENCES public.symptoms(id);


--
-- Name: user_foods fk_rails_8aa2688684; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_foods
    ADD CONSTRAINT fk_rails_8aa2688684 FOREIGN KEY (food_id) REFERENCES public.foods(id);


--
-- Name: user_foods fk_rails_af9e05e5ff; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_foods
    ADD CONSTRAINT fk_rails_af9e05e5ff FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: weathers fk_rails_be80d9361d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.weathers
    ADD CONSTRAINT fk_rails_be80d9361d FOREIGN KEY (position_id) REFERENCES public.positions(id);


--
-- Name: user_symptoms fk_rails_cde825af18; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_symptoms
    ADD CONSTRAINT fk_rails_cde825af18 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: profiles fk_rails_e424190865; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT fk_rails_e424190865 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: user_tags fk_rails_ea0382482a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_tags
    ADD CONSTRAINT fk_rails_ea0382482a FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20160101154821'),
('20160106154821'),
('20160119185831'),
('20160128112500'),
('20160128114341'),
('20160128191053'),
('20160128191329'),
('20160128210332'),
('20160129063945'),
('20160129064538'),
('20160211105611'),
('20160224141256'),
('20160404073700'),
('20160404073731'),
('20160426222232'),
('20160427055217'),
('20160608161002'),
('20160711182546'),
('20161206135858'),
('20161214131805'),
('20161216123757'),
('20161230090023'),
('20170413144043'),
('20170504065043'),
('20170508151200'),
('20170509114220'),
('20170612160120'),
('20170717153650'),
('20170731083613'),
('20170731123835'),
('20170731125044'),
('20170801124153'),
('20170817154145'),
('20170818085110'),
('20170822122800'),
('20171011142928');


