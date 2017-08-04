--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


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


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: condition_translations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE condition_translations (
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

CREATE SEQUENCE condition_translations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: condition_translations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE condition_translations_id_seq OWNED BY condition_translations.id;


--
-- Name: conditions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE conditions (
    id integer NOT NULL,
    global boolean DEFAULT true,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    trackable_usages_count integer DEFAULT 0
);


--
-- Name: conditions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE conditions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: conditions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE conditions_id_seq OWNED BY conditions.id;


--
-- Name: crono_jobs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE crono_jobs (
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

CREATE SEQUENCE crono_jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: crono_jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE crono_jobs_id_seq OWNED BY crono_jobs.id;


--
-- Name: food_translations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE food_translations (
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

CREATE SEQUENCE food_translations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: food_translations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE food_translations_id_seq OWNED BY food_translations.id;


--
-- Name: foods; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE foods (
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

CREATE SEQUENCE foods_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: foods_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE foods_id_seq OWNED BY foods.id;


--
-- Name: profiles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE profiles (
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
    most_recent_doses hstore,
    screen_name character varying,
    most_recent_conditions_positions hstore,
    most_recent_symptoms_positions hstore,
    most_recent_treatments_positions hstore,
    pressure_units integer DEFAULT 0,
    temperature_units integer DEFAULT 0,
    beta_tester boolean DEFAULT false,
    notify boolean DEFAULT true,
    notify_token character varying,
    slug_name character varying,
    notify_top_posts boolean DEFAULT true
);


--
-- Name: profiles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE profiles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE profiles_id_seq OWNED BY profiles.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: symptom_translations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE symptom_translations (
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

CREATE SEQUENCE symptom_translations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: symptom_translations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE symptom_translations_id_seq OWNED BY symptom_translations.id;


--
-- Name: symptoms; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE symptoms (
    id integer NOT NULL,
    global boolean DEFAULT true,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    trackable_usages_count integer DEFAULT 0
);


--
-- Name: symptoms_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE symptoms_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: symptoms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE symptoms_id_seq OWNED BY symptoms.id;


--
-- Name: tag_translations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE tag_translations (
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

CREATE SEQUENCE tag_translations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tag_translations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tag_translations_id_seq OWNED BY tag_translations.id;


--
-- Name: tags; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE tags (
    id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    global boolean DEFAULT true,
    trackable_usages_count integer DEFAULT 0
);


--
-- Name: tags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tags_id_seq OWNED BY tags.id;


--
-- Name: trackable_usages; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE trackable_usages (
    id integer NOT NULL,
    user_id integer,
    trackable_id integer,
    trackable_type character varying,
    count integer DEFAULT 1,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: trackable_usages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE trackable_usages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: trackable_usages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE trackable_usages_id_seq OWNED BY trackable_usages.id;


--
-- Name: trackings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE trackings (
    id integer NOT NULL,
    user_id integer,
    trackable_id integer,
    trackable_type character varying,
    start_at date,
    end_at date,
    color_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: trackings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE trackings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: trackings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE trackings_id_seq OWNED BY trackings.id;


--
-- Name: treatment_translations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE treatment_translations (
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

CREATE SEQUENCE treatment_translations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: treatment_translations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE treatment_translations_id_seq OWNED BY treatment_translations.id;


--
-- Name: treatments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE treatments (
    id integer NOT NULL,
    global boolean DEFAULT true,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    trackable_usages_count integer DEFAULT 0
);


--
-- Name: treatments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE treatments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: treatments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE treatments_id_seq OWNED BY treatments.id;


--
-- Name: user_conditions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE user_conditions (
    id integer NOT NULL,
    user_id integer,
    condition_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: user_conditions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE user_conditions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_conditions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE user_conditions_id_seq OWNED BY user_conditions.id;


--
-- Name: user_foods; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE user_foods (
    id integer NOT NULL,
    user_id integer,
    food_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: user_foods_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE user_foods_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_foods_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE user_foods_id_seq OWNED BY user_foods.id;


--
-- Name: user_symptoms; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE user_symptoms (
    id integer NOT NULL,
    user_id integer,
    symptom_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: user_symptoms_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE user_symptoms_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_symptoms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE user_symptoms_id_seq OWNED BY user_symptoms.id;


--
-- Name: user_tags; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE user_tags (
    id integer NOT NULL,
    user_id integer,
    tag_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: user_tags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE user_tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE user_tags_id_seq OWNED BY user_tags.id;


--
-- Name: user_treatments; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE user_treatments (
    id integer NOT NULL,
    user_id integer,
    treatment_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: user_treatments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE user_treatments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_treatments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE user_treatments_id_seq OWNED BY user_treatments.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
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

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: weathers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE weathers (
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
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: weathers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE weathers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: weathers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE weathers_id_seq OWNED BY weathers.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY condition_translations ALTER COLUMN id SET DEFAULT nextval('condition_translations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY conditions ALTER COLUMN id SET DEFAULT nextval('conditions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY crono_jobs ALTER COLUMN id SET DEFAULT nextval('crono_jobs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY food_translations ALTER COLUMN id SET DEFAULT nextval('food_translations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY foods ALTER COLUMN id SET DEFAULT nextval('foods_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY profiles ALTER COLUMN id SET DEFAULT nextval('profiles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY symptom_translations ALTER COLUMN id SET DEFAULT nextval('symptom_translations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY symptoms ALTER COLUMN id SET DEFAULT nextval('symptoms_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tag_translations ALTER COLUMN id SET DEFAULT nextval('tag_translations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tags ALTER COLUMN id SET DEFAULT nextval('tags_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY trackable_usages ALTER COLUMN id SET DEFAULT nextval('trackable_usages_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY trackings ALTER COLUMN id SET DEFAULT nextval('trackings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY treatment_translations ALTER COLUMN id SET DEFAULT nextval('treatment_translations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY treatments ALTER COLUMN id SET DEFAULT nextval('treatments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_conditions ALTER COLUMN id SET DEFAULT nextval('user_conditions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_foods ALTER COLUMN id SET DEFAULT nextval('user_foods_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_symptoms ALTER COLUMN id SET DEFAULT nextval('user_symptoms_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_tags ALTER COLUMN id SET DEFAULT nextval('user_tags_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_treatments ALTER COLUMN id SET DEFAULT nextval('user_treatments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY weathers ALTER COLUMN id SET DEFAULT nextval('weathers_id_seq'::regclass);


--
-- Name: condition_translations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY condition_translations
    ADD CONSTRAINT condition_translations_pkey PRIMARY KEY (id);


--
-- Name: conditions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY conditions
    ADD CONSTRAINT conditions_pkey PRIMARY KEY (id);


--
-- Name: crono_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY crono_jobs
    ADD CONSTRAINT crono_jobs_pkey PRIMARY KEY (id);


--
-- Name: food_translations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY food_translations
    ADD CONSTRAINT food_translations_pkey PRIMARY KEY (id);


--
-- Name: foods_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY foods
    ADD CONSTRAINT foods_pkey PRIMARY KEY (id);


--
-- Name: profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY profiles
    ADD CONSTRAINT profiles_pkey PRIMARY KEY (id);


--
-- Name: symptom_translations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY symptom_translations
    ADD CONSTRAINT symptom_translations_pkey PRIMARY KEY (id);


--
-- Name: symptoms_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY symptoms
    ADD CONSTRAINT symptoms_pkey PRIMARY KEY (id);


--
-- Name: tag_translations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY tag_translations
    ADD CONSTRAINT tag_translations_pkey PRIMARY KEY (id);


--
-- Name: tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: trackable_usages_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY trackable_usages
    ADD CONSTRAINT trackable_usages_pkey PRIMARY KEY (id);


--
-- Name: trackings_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY trackings
    ADD CONSTRAINT trackings_pkey PRIMARY KEY (id);


--
-- Name: treatment_translations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY treatment_translations
    ADD CONSTRAINT treatment_translations_pkey PRIMARY KEY (id);


--
-- Name: treatments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY treatments
    ADD CONSTRAINT treatments_pkey PRIMARY KEY (id);


--
-- Name: user_conditions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY user_conditions
    ADD CONSTRAINT user_conditions_pkey PRIMARY KEY (id);


--
-- Name: user_foods_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY user_foods
    ADD CONSTRAINT user_foods_pkey PRIMARY KEY (id);


--
-- Name: user_symptoms_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY user_symptoms
    ADD CONSTRAINT user_symptoms_pkey PRIMARY KEY (id);


--
-- Name: user_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY user_tags
    ADD CONSTRAINT user_tags_pkey PRIMARY KEY (id);


--
-- Name: user_treatments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY user_treatments
    ADD CONSTRAINT user_treatments_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: weathers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY weathers
    ADD CONSTRAINT weathers_pkey PRIMARY KEY (id);


--
-- Name: index_condition_translations_on_condition_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_condition_translations_on_condition_id ON condition_translations USING btree (condition_id);


--
-- Name: index_condition_translations_on_locale; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_condition_translations_on_locale ON condition_translations USING btree (locale);


--
-- Name: index_crono_jobs_on_job_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_crono_jobs_on_job_id ON crono_jobs USING btree (job_id);


--
-- Name: index_food_translations_on_food_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_food_translations_on_food_id ON food_translations USING btree (food_id);


--
-- Name: index_food_translations_on_locale; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_food_translations_on_locale ON food_translations USING btree (locale);


--
-- Name: index_foods_on_ndb_no; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_foods_on_ndb_no ON foods USING btree (ndb_no);


--
-- Name: index_profiles_on_slug_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_profiles_on_slug_name ON profiles USING btree (slug_name);


--
-- Name: index_profiles_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_profiles_on_user_id ON profiles USING btree (user_id);


--
-- Name: index_symptom_translations_on_locale; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_symptom_translations_on_locale ON symptom_translations USING btree (locale);


--
-- Name: index_symptom_translations_on_symptom_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_symptom_translations_on_symptom_id ON symptom_translations USING btree (symptom_id);


--
-- Name: index_tag_translations_on_locale; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_tag_translations_on_locale ON tag_translations USING btree (locale);


--
-- Name: index_tag_translations_on_tag_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_tag_translations_on_tag_id ON tag_translations USING btree (tag_id);


--
-- Name: index_trackable_usages_on_trackable_type_and_trackable_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_trackable_usages_on_trackable_type_and_trackable_id ON trackable_usages USING btree (trackable_type, trackable_id);


--
-- Name: index_trackable_usages_on_unique_columns; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_trackable_usages_on_unique_columns ON trackable_usages USING btree (user_id, trackable_type, trackable_id);


--
-- Name: index_trackable_usages_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_trackable_usages_on_user_id ON trackable_usages USING btree (user_id);


--
-- Name: index_trackings_on_trackable_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_trackings_on_trackable_type ON trackings USING btree (trackable_type);


--
-- Name: index_trackings_on_trackable_type_and_trackable_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_trackings_on_trackable_type_and_trackable_id ON trackings USING btree (trackable_type, trackable_id);


--
-- Name: index_trackings_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_trackings_on_user_id ON trackings USING btree (user_id);


--
-- Name: index_trackings_unique_trackable; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_trackings_unique_trackable ON trackings USING btree (user_id, trackable_id, trackable_type, start_at);


--
-- Name: index_treatment_translations_on_locale; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_treatment_translations_on_locale ON treatment_translations USING btree (locale);


--
-- Name: index_treatment_translations_on_treatment_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_treatment_translations_on_treatment_id ON treatment_translations USING btree (treatment_id);


--
-- Name: index_user_conditions_on_condition_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_user_conditions_on_condition_id ON user_conditions USING btree (condition_id);


--
-- Name: index_user_conditions_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_user_conditions_on_user_id ON user_conditions USING btree (user_id);


--
-- Name: index_user_foods_on_food_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_user_foods_on_food_id ON user_foods USING btree (food_id);


--
-- Name: index_user_foods_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_user_foods_on_user_id ON user_foods USING btree (user_id);


--
-- Name: index_user_symptoms_on_symptom_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_user_symptoms_on_symptom_id ON user_symptoms USING btree (symptom_id);


--
-- Name: index_user_symptoms_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_user_symptoms_on_user_id ON user_symptoms USING btree (user_id);


--
-- Name: index_user_tags_on_tag_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_user_tags_on_tag_id ON user_tags USING btree (tag_id);


--
-- Name: index_user_tags_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_user_tags_on_user_id ON user_tags USING btree (user_id);


--
-- Name: index_user_treatments_on_treatment_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_user_treatments_on_treatment_id ON user_treatments USING btree (treatment_id);


--
-- Name: index_user_treatments_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_user_treatments_on_user_id ON user_treatments USING btree (user_id);


--
-- Name: index_users_on_authentication_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_authentication_token ON users USING btree (authentication_token);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_invitation_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_invitation_token ON users USING btree (invitation_token);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: index_weathers_on_date_and_postal_code; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_weathers_on_date_and_postal_code ON weathers USING btree (date, postal_code);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: fk_rails_0ef098da93; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_treatments
    ADD CONSTRAINT fk_rails_0ef098da93 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_rails_1fa14e4e8c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_conditions
    ADD CONSTRAINT fk_rails_1fa14e4e8c FOREIGN KEY (condition_id) REFERENCES conditions(id);


--
-- Name: fk_rails_47c01ca983; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_conditions
    ADD CONSTRAINT fk_rails_47c01ca983 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_rails_493dc44b5f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY trackings
    ADD CONSTRAINT fk_rails_493dc44b5f FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_rails_49855db565; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_treatments
    ADD CONSTRAINT fk_rails_49855db565 FOREIGN KEY (treatment_id) REFERENCES treatments(id);


--
-- Name: fk_rails_53d2120ad1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY trackable_usages
    ADD CONSTRAINT fk_rails_53d2120ad1 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_rails_7156651ad8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_tags
    ADD CONSTRAINT fk_rails_7156651ad8 FOREIGN KEY (tag_id) REFERENCES tags(id);


--
-- Name: fk_rails_86699b81a3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_symptoms
    ADD CONSTRAINT fk_rails_86699b81a3 FOREIGN KEY (symptom_id) REFERENCES symptoms(id);


--
-- Name: fk_rails_8aa2688684; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_foods
    ADD CONSTRAINT fk_rails_8aa2688684 FOREIGN KEY (food_id) REFERENCES foods(id);


--
-- Name: fk_rails_af9e05e5ff; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_foods
    ADD CONSTRAINT fk_rails_af9e05e5ff FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_rails_cde825af18; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_symptoms
    ADD CONSTRAINT fk_rails_cde825af18 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_rails_e424190865; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY profiles
    ADD CONSTRAINT fk_rails_e424190865 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_rails_ea0382482a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_tags
    ADD CONSTRAINT fk_rails_ea0382482a FOREIGN KEY (user_id) REFERENCES users(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20160101154821');

INSERT INTO schema_migrations (version) VALUES ('20160106154821');

INSERT INTO schema_migrations (version) VALUES ('20160119185831');

INSERT INTO schema_migrations (version) VALUES ('20160128112500');

INSERT INTO schema_migrations (version) VALUES ('20160128114341');

INSERT INTO schema_migrations (version) VALUES ('20160128191053');

INSERT INTO schema_migrations (version) VALUES ('20160128191329');

INSERT INTO schema_migrations (version) VALUES ('20160128210332');

INSERT INTO schema_migrations (version) VALUES ('20160129063945');

INSERT INTO schema_migrations (version) VALUES ('20160129064538');

INSERT INTO schema_migrations (version) VALUES ('20160211105611');

INSERT INTO schema_migrations (version) VALUES ('20160224141256');

INSERT INTO schema_migrations (version) VALUES ('20160404073700');

INSERT INTO schema_migrations (version) VALUES ('20160404073731');

INSERT INTO schema_migrations (version) VALUES ('20160426222232');

INSERT INTO schema_migrations (version) VALUES ('20160427055217');

INSERT INTO schema_migrations (version) VALUES ('20160608161002');

INSERT INTO schema_migrations (version) VALUES ('20160711182546');

INSERT INTO schema_migrations (version) VALUES ('20161206135858');

INSERT INTO schema_migrations (version) VALUES ('20161214131805');

INSERT INTO schema_migrations (version) VALUES ('20161216123757');

INSERT INTO schema_migrations (version) VALUES ('20161230090023');

INSERT INTO schema_migrations (version) VALUES ('20170413144043');

INSERT INTO schema_migrations (version) VALUES ('20170504065043');

INSERT INTO schema_migrations (version) VALUES ('20170508151200');

INSERT INTO schema_migrations (version) VALUES ('20170509114220');

INSERT INTO schema_migrations (version) VALUES ('20170612160120');

INSERT INTO schema_migrations (version) VALUES ('20170717153650');

INSERT INTO schema_migrations (version) VALUES ('20170731083613');

INSERT INTO schema_migrations (version) VALUES ('20170731123835');

INSERT INTO schema_migrations (version) VALUES ('20170731125044');

INSERT INTO schema_migrations (version) VALUES ('20170801124153');

