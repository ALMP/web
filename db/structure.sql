--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.2
-- Dumped by pg_dump version 9.6.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: locations; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA locations;


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: citext; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS citext WITH SCHEMA public;


--
-- Name: EXTENSION citext; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION citext IS 'data type for case-insensitive character strings';


--
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


SET search_path = public, pg_catalog;

--
-- Name: user_role; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE user_role AS ENUM (
    'User',
    'AdminUser'
);


--
-- Name: counter_cache(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION counter_cache() RETURNS trigger
    LANGUAGE plpgsql
    AS $_$
        DECLARE
          table_name text := quote_ident(TG_ARGV[0]);
          counter_name text := quote_ident(TG_ARGV[1]);
          fk_name text := quote_ident(TG_ARGV[2]);
          fk_changed boolean := false;
          fk_value integer;
          record record;
        BEGIN
          IF TG_OP = 'UPDATE' THEN
            record := NEW;
            EXECUTE 'SELECT ($1).' || fk_name || ' != ' || '($2).' || fk_name
            INTO fk_changed
            USING OLD, NEW;
          END IF;

          IF TG_OP = 'DELETE' OR fk_changed THEN
            record := OLD;
            EXECUTE 'SELECT ($1).' || fk_name INTO fk_value USING record;
            PERFORM increment_counter(table_name, counter_name, fk_value, -1);
          END IF;

          IF TG_OP = 'INSERT' OR fk_changed THEN
            record := NEW;
            EXECUTE 'SELECT ($1).' || fk_name INTO fk_value USING record;
            PERFORM increment_counter(table_name, counter_name, fk_value, 1);
          END IF;

          RETURN record;
        END;
      $_$;


--
-- Name: increment_counter(text, text, integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION increment_counter(table_name text, column_name text, id integer, step integer) RETURNS void
    LANGUAGE plpgsql
    AS $_$
        DECLARE
          table_name text := quote_ident(table_name);
          column_name text := quote_ident(column_name);
          conditions text := ' WHERE id = $1';
          updates text := column_name || '=' || column_name || '+' || step;
        BEGIN
          EXECUTE 'UPDATE ' || table_name || ' SET ' || updates || conditions
          USING id;
        END;
      $_$;


SET search_path = locations, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: codelists; Type: TABLE; Schema: locations; Owner: -
--

CREATE TABLE codelists (
    change character varying,
    country character varying,
    location character varying,
    name character varying,
    name_wo_diactric character varying,
    subdivision character varying,
    status character varying,
    function character varying,
    date character varying,
    iata character varying,
    coordinates character varying,
    remarks character varying
);


--
-- Name: country_codes; Type: TABLE; Schema: locations; Owner: -
--

CREATE TABLE country_codes (
    country_code character varying NOT NULL,
    country_name character varying
);


--
-- Name: function_classifiers; Type: TABLE; Schema: locations; Owner: -
--

CREATE TABLE function_classifiers (
    function_code character varying NOT NULL,
    function_description character varying
);


--
-- Name: status_indicators; Type: TABLE; Schema: locations; Owner: -
--

CREATE TABLE status_indicators (
    st_status character varying NOT NULL,
    st_description character varying
);


--
-- Name: subdivision_codes; Type: TABLE; Schema: locations; Owner: -
--

CREATE TABLE subdivision_codes (
    su_country character varying NOT NULL,
    su_code character varying NOT NULL,
    su_name character varying
);


SET search_path = public, pg_catalog;

--
-- Name: aggregated_ratings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE aggregated_ratings (
    id integer NOT NULL,
    confirmed_reviews_count integer DEFAULT 0,
    company_id integer,
    rating numeric DEFAULT 0,
    recommended numeric DEFAULT 0,
    thankful numeric DEFAULT 0,
    quality numeric DEFAULT 0,
    payments numeric DEFAULT 0,
    stability numeric DEFAULT 0,
    service numeric DEFAULT 0,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    other numeric DEFAULT 0,
    fairness numeric DEFAULT 0
);


--
-- Name: aggregated_ratings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE aggregated_ratings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: aggregated_ratings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE aggregated_ratings_id_seq OWNED BY aggregated_ratings.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE categories (
    id integer NOT NULL,
    fallback_locale_name citext,
    companies_count integer DEFAULT 0 NOT NULL
);


--
-- Name: categories_companies; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE categories_companies (
    category_id integer NOT NULL,
    company_id integer NOT NULL
);


--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE categories_id_seq OWNED BY categories.id;


--
-- Name: category_translations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE category_translations (
    id integer NOT NULL,
    category_id integer NOT NULL,
    locale character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    name citext
);


--
-- Name: category_translations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE category_translations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: category_translations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE category_translations_id_seq OWNED BY category_translations.id;


--
-- Name: cities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE cities (
    id integer NOT NULL,
    fallback_locale_name citext
);


--
-- Name: cities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE cities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE cities_id_seq OWNED BY cities.id;


--
-- Name: city_translations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE city_translations (
    id integer NOT NULL,
    city_id integer NOT NULL,
    locale character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    name citext
);


--
-- Name: city_translations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE city_translations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: city_translations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE city_translations_id_seq OWNED BY city_translations.id;


--
-- Name: companies; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE companies (
    id integer NOT NULL,
    name character varying NOT NULL,
    url character varying,
    email citext,
    phone character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    logo character varying,
    address character varying,
    industry character varying,
    goods_type character varying,
    external_key character varying,
    description text,
    city_id integer,
    zipcode character varying,
    last_review_added timestamp without time zone
);


--
-- Name: companies_goods; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE companies_goods (
    good_id integer NOT NULL,
    company_id integer NOT NULL
);


--
-- Name: companies_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE companies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: companies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE companies_id_seq OWNED BY companies.id;


--
-- Name: company_aliases; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE company_aliases (
    id integer NOT NULL,
    company_id integer,
    name character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: company_aliases_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE company_aliases_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: company_aliases_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE company_aliases_id_seq OWNED BY company_aliases.id;


--
-- Name: custom_ratings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE custom_ratings (
    id integer NOT NULL,
    title character varying,
    value integer DEFAULT 0,
    review_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: custom_ratings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE custom_ratings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: custom_ratings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE custom_ratings_id_seq OWNED BY custom_ratings.id;


--
-- Name: faq_translations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE faq_translations (
    id integer NOT NULL,
    faq_id integer NOT NULL,
    locale character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    question character varying,
    answer text
);


--
-- Name: faq_translations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE faq_translations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: faq_translations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE faq_translations_id_seq OWNED BY faq_translations.id;


--
-- Name: faqs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE faqs (
    id integer NOT NULL,
    "position" integer DEFAULT 0,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: faqs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE faqs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: faqs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE faqs_id_seq OWNED BY faqs.id;


--
-- Name: good_translations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE good_translations (
    id integer NOT NULL,
    good_id integer NOT NULL,
    locale character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    name citext
);


--
-- Name: good_translations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE good_translations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: good_translations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE good_translations_id_seq OWNED BY good_translations.id;


--
-- Name: goods; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE goods (
    id integer NOT NULL,
    fallback_locale_name citext,
    companies_count integer DEFAULT 0 NOT NULL,
    category_id integer
);


--
-- Name: goods_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE goods_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: goods_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE goods_id_seq OWNED BY goods.id;


--
-- Name: oauth_identities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE oauth_identities (
    id integer NOT NULL,
    provider character varying,
    uid character varying,
    user_id integer,
    data jsonb,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: oauth_identities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE oauth_identities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: oauth_identities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE oauth_identities_id_seq OWNED BY oauth_identities.id;


--
-- Name: pg_search_documents; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE pg_search_documents (
    id integer NOT NULL,
    content text,
    searchable_type character varying,
    searchable_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: pg_search_documents_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE pg_search_documents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pg_search_documents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE pg_search_documents_id_seq OWNED BY pg_search_documents.id;


--
-- Name: publications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE publications (
    id integer NOT NULL,
    link character varying,
    company_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    company_name character varying,
    head text,
    annotation text,
    date_of_publication date
);


--
-- Name: publications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE publications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: publications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE publications_id_seq OWNED BY publications.id;


--
-- Name: purchase_prices; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE purchase_prices (
    id integer NOT NULL,
    name character varying,
    company_id integer,
    kind character varying,
    status character varying,
    user_id integer,
    quantity integer DEFAULT 1,
    unit character varying,
    value_cents bigint DEFAULT 0,
    value_currency character varying DEFAULT 'usd'::character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    company_name character varying
);


--
-- Name: purchase_prices_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE purchase_prices_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: purchase_prices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE purchase_prices_id_seq OWNED BY purchase_prices.id;


--
-- Name: reviews; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE reviews (
    id integer NOT NULL,
    company_id integer,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    status character varying,
    company_name character varying,
    rating numeric DEFAULT 0,
    advantages text,
    disadvantages text,
    recommendations text,
    category character varying,
    quality integer,
    payments integer,
    service integer,
    stability integer,
    recommended boolean,
    thankful boolean,
    terms_of_use_confirmed boolean DEFAULT false,
    user_id integer,
    fairness integer DEFAULT 0
);


--
-- Name: reviews_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE reviews_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: reviews_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE reviews_id_seq OWNED BY reviews.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE users (
    id integer NOT NULL,
    email citext NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    type user_role DEFAULT 'User'::user_role NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip inet,
    last_sign_in_ip inet,
    confirmation_token character varying,
    confirmed_at timestamp without time zone,
    confirmation_sent_at timestamp without time zone,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    unconfirmed_email character varying,
    omniauthable boolean DEFAULT false,
    recommendator citext,
    remember_token character varying
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
-- Name: aggregated_ratings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY aggregated_ratings ALTER COLUMN id SET DEFAULT nextval('aggregated_ratings_id_seq'::regclass);


--
-- Name: categories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY categories ALTER COLUMN id SET DEFAULT nextval('categories_id_seq'::regclass);


--
-- Name: category_translations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY category_translations ALTER COLUMN id SET DEFAULT nextval('category_translations_id_seq'::regclass);


--
-- Name: cities id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY cities ALTER COLUMN id SET DEFAULT nextval('cities_id_seq'::regclass);


--
-- Name: city_translations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY city_translations ALTER COLUMN id SET DEFAULT nextval('city_translations_id_seq'::regclass);


--
-- Name: companies id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY companies ALTER COLUMN id SET DEFAULT nextval('companies_id_seq'::regclass);


--
-- Name: company_aliases id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY company_aliases ALTER COLUMN id SET DEFAULT nextval('company_aliases_id_seq'::regclass);


--
-- Name: custom_ratings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY custom_ratings ALTER COLUMN id SET DEFAULT nextval('custom_ratings_id_seq'::regclass);


--
-- Name: faq_translations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY faq_translations ALTER COLUMN id SET DEFAULT nextval('faq_translations_id_seq'::regclass);


--
-- Name: faqs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY faqs ALTER COLUMN id SET DEFAULT nextval('faqs_id_seq'::regclass);


--
-- Name: good_translations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY good_translations ALTER COLUMN id SET DEFAULT nextval('good_translations_id_seq'::regclass);


--
-- Name: goods id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY goods ALTER COLUMN id SET DEFAULT nextval('goods_id_seq'::regclass);


--
-- Name: oauth_identities id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY oauth_identities ALTER COLUMN id SET DEFAULT nextval('oauth_identities_id_seq'::regclass);


--
-- Name: pg_search_documents id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY pg_search_documents ALTER COLUMN id SET DEFAULT nextval('pg_search_documents_id_seq'::regclass);


--
-- Name: publications id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY publications ALTER COLUMN id SET DEFAULT nextval('publications_id_seq'::regclass);


--
-- Name: purchase_prices id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY purchase_prices ALTER COLUMN id SET DEFAULT nextval('purchase_prices_id_seq'::regclass);


--
-- Name: reviews id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY reviews ALTER COLUMN id SET DEFAULT nextval('reviews_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


SET search_path = locations, pg_catalog;

--
-- Name: country_codes country_codes_pkey; Type: CONSTRAINT; Schema: locations; Owner: -
--

ALTER TABLE ONLY country_codes
    ADD CONSTRAINT country_codes_pkey PRIMARY KEY (country_code);


--
-- Name: function_classifiers function_classifiers_pkey; Type: CONSTRAINT; Schema: locations; Owner: -
--

ALTER TABLE ONLY function_classifiers
    ADD CONSTRAINT function_classifiers_pkey PRIMARY KEY (function_code);


--
-- Name: status_indicators status_indicators_pkey; Type: CONSTRAINT; Schema: locations; Owner: -
--

ALTER TABLE ONLY status_indicators
    ADD CONSTRAINT status_indicators_pkey PRIMARY KEY (st_status);


SET search_path = public, pg_catalog;

--
-- Name: aggregated_ratings aggregated_ratings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY aggregated_ratings
    ADD CONSTRAINT aggregated_ratings_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: category_translations category_translations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY category_translations
    ADD CONSTRAINT category_translations_pkey PRIMARY KEY (id);


--
-- Name: cities cities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY cities
    ADD CONSTRAINT cities_pkey PRIMARY KEY (id);


--
-- Name: city_translations city_translations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY city_translations
    ADD CONSTRAINT city_translations_pkey PRIMARY KEY (id);


--
-- Name: companies companies_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY companies
    ADD CONSTRAINT companies_pkey PRIMARY KEY (id);


--
-- Name: company_aliases company_aliases_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY company_aliases
    ADD CONSTRAINT company_aliases_pkey PRIMARY KEY (id);


--
-- Name: custom_ratings custom_ratings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY custom_ratings
    ADD CONSTRAINT custom_ratings_pkey PRIMARY KEY (id);


--
-- Name: faq_translations faq_translations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY faq_translations
    ADD CONSTRAINT faq_translations_pkey PRIMARY KEY (id);


--
-- Name: faqs faqs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY faqs
    ADD CONSTRAINT faqs_pkey PRIMARY KEY (id);


--
-- Name: good_translations good_translations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY good_translations
    ADD CONSTRAINT good_translations_pkey PRIMARY KEY (id);


--
-- Name: goods goods_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY goods
    ADD CONSTRAINT goods_pkey PRIMARY KEY (id);


--
-- Name: oauth_identities oauth_identities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY oauth_identities
    ADD CONSTRAINT oauth_identities_pkey PRIMARY KEY (id);


--
-- Name: pg_search_documents pg_search_documents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY pg_search_documents
    ADD CONSTRAINT pg_search_documents_pkey PRIMARY KEY (id);


--
-- Name: publications publications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY publications
    ADD CONSTRAINT publications_pkey PRIMARY KEY (id);


--
-- Name: purchase_prices purchase_prices_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY purchase_prices
    ADD CONSTRAINT purchase_prices_pkey PRIMARY KEY (id);


--
-- Name: reviews reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY reviews
    ADD CONSTRAINT reviews_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_aggregated_ratings_on_company_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_aggregated_ratings_on_company_id ON aggregated_ratings USING btree (company_id);


--
-- Name: index_categories_companies_on_category_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_categories_companies_on_category_id ON categories_companies USING btree (category_id);


--
-- Name: index_categories_companies_on_company_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_categories_companies_on_company_id ON categories_companies USING btree (company_id);


--
-- Name: index_categories_companies_on_company_id_and_category_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_categories_companies_on_company_id_and_category_id ON categories_companies USING btree (company_id, category_id);


--
-- Name: index_category_translations_on_category_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_category_translations_on_category_id ON category_translations USING btree (category_id);


--
-- Name: index_category_translations_on_locale; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_category_translations_on_locale ON category_translations USING btree (locale);


--
-- Name: index_category_translations_on_name_gin_trgm_ops; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_category_translations_on_name_gin_trgm_ops ON category_translations USING gin (name gin_trgm_ops);


--
-- Name: index_city_translations_on_city_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_city_translations_on_city_id ON city_translations USING btree (city_id);


--
-- Name: index_city_translations_on_locale; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_city_translations_on_locale ON city_translations USING btree (locale);


--
-- Name: index_city_translations_on_name_gin_trgm_ops; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_city_translations_on_name_gin_trgm_ops ON city_translations USING gin (name gin_trgm_ops);


--
-- Name: index_companies_fts_english; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_companies_fts_english ON companies USING gin (((to_tsvector('english'::regconfig, COALESCE((name)::text, ''::text)) || to_tsvector('english'::regconfig, COALESCE(description, ''::text)))));


--
-- Name: index_companies_fts_russian; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_companies_fts_russian ON companies USING gin (((to_tsvector('russian'::regconfig, COALESCE((name)::text, ''::text)) || to_tsvector('russian'::regconfig, COALESCE(description, ''::text)))));


--
-- Name: index_companies_fts_simple; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_companies_fts_simple ON companies USING gin (((to_tsvector('simple'::regconfig, COALESCE((name)::text, ''::text)) || to_tsvector('simple'::regconfig, COALESCE(description, ''::text)))));


--
-- Name: index_companies_goods_on_company_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_companies_goods_on_company_id ON companies_goods USING btree (company_id);


--
-- Name: index_companies_goods_on_company_id_and_good_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_companies_goods_on_company_id_and_good_id ON companies_goods USING btree (company_id, good_id);


--
-- Name: index_companies_goods_on_good_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_companies_goods_on_good_id ON companies_goods USING btree (good_id);


--
-- Name: index_companies_on_email_gin_trgm_ops; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_companies_on_email_gin_trgm_ops ON companies USING gin (email gin_trgm_ops);


--
-- Name: index_companies_on_name_gin_trgm_ops; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_companies_on_name_gin_trgm_ops ON companies USING gin (name gin_trgm_ops);


--
-- Name: index_companies_on_phone_gin_trgm_ops; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_companies_on_phone_gin_trgm_ops ON companies USING gin (phone gin_trgm_ops);


--
-- Name: index_companies_on_url_gin_trgm_ops; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_companies_on_url_gin_trgm_ops ON companies USING gin (url gin_trgm_ops);


--
-- Name: index_companies_on_zipcode_gin_trgm_ops; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_companies_on_zipcode_gin_trgm_ops ON companies USING gin (zipcode gin_trgm_ops);


--
-- Name: index_company_aliases_on_company_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_company_aliases_on_company_id ON company_aliases USING btree (company_id);


--
-- Name: index_custom_ratings_on_review_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_custom_ratings_on_review_id ON custom_ratings USING btree (review_id);


--
-- Name: index_faq_translations_on_faq_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_faq_translations_on_faq_id ON faq_translations USING btree (faq_id);


--
-- Name: index_faq_translations_on_locale; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_faq_translations_on_locale ON faq_translations USING btree (locale);


--
-- Name: index_faqs_on_position; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_faqs_on_position ON faqs USING btree ("position");


--
-- Name: index_good_translations_on_good_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_translations_on_good_id ON good_translations USING btree (good_id);


--
-- Name: index_good_translations_on_locale; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_translations_on_locale ON good_translations USING btree (locale);


--
-- Name: index_good_translations_on_name_gin_trgm_ops; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_good_translations_on_name_gin_trgm_ops ON good_translations USING gin (name gin_trgm_ops);


--
-- Name: index_goods_on_category_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_goods_on_category_id ON goods USING btree (category_id);


--
-- Name: index_oauth_identities_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_oauth_identities_on_user_id ON oauth_identities USING btree (user_id);


--
-- Name: index_pg_search_documents_on_searchable_type_and_searchable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_pg_search_documents_on_searchable_type_and_searchable_id ON pg_search_documents USING btree (searchable_type, searchable_id);


--
-- Name: index_publications_on_company_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_publications_on_company_id ON publications USING btree (company_id);


--
-- Name: index_purchase_prices_on_company_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_purchase_prices_on_company_id ON purchase_prices USING btree (company_id);


--
-- Name: index_purchase_prices_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_purchase_prices_on_user_id ON purchase_prices USING btree (user_id);


--
-- Name: index_reviews_on_company_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_reviews_on_company_id ON reviews USING btree (company_id);


--
-- Name: index_reviews_on_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_reviews_on_status ON reviews USING btree (status);


--
-- Name: index_users_on_confirmation_token; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_confirmation_token ON users USING btree (confirmation_token);


--
-- Name: categories_companies update_category_companies_count; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_category_companies_count AFTER INSERT OR DELETE OR UPDATE ON categories_companies FOR EACH ROW EXECUTE PROCEDURE counter_cache('categories', 'companies_count', 'category_id');


--
-- Name: companies_goods update_goods_companies_count; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_goods_companies_count AFTER INSERT OR DELETE OR UPDATE ON companies_goods FOR EACH ROW EXECUTE PROCEDURE counter_cache('goods', 'companies_count', 'good_id');


--
-- Name: publications fk_rails_9c5b59dc35; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY publications
    ADD CONSTRAINT fk_rails_9c5b59dc35 FOREIGN KEY (company_id) REFERENCES companies(id);


--
-- Name: reviews fk_rails_c1a13c42e3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY reviews
    ADD CONSTRAINT fk_rails_c1a13c42e3 FOREIGN KEY (company_id) REFERENCES companies(id);


--
-- Name: aggregated_ratings fk_rails_d995d8f925; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY aggregated_ratings
    ADD CONSTRAINT fk_rails_d995d8f925 FOREIGN KEY (company_id) REFERENCES companies(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO schema_migrations (version) VALUES ('20161008155138'), ('20161008162804'), ('20161008170203'), ('20161008201010'), ('20161008202336'), ('20161009035909'), ('20161010064417'), ('20161012141143'), ('20161012142629'), ('20161012165511'), ('20161012165535'), ('20161012170531'), ('20161014195805'), ('20161014200048'), ('20161016125009'), ('20161016145341'), ('20161016152805'), ('20161018134330'), ('20161018171146'), ('20161021151655'), ('20161021151836'), ('20161103083216'), ('20161103114248'), ('20161107131819'), ('20161108054946'), ('20161108150125'), ('20161114181609'), ('20161115004522'), ('20161115010449'), ('20161115132001'), ('20161115134818'), ('20161116161335'), ('20161118202425'), ('20161118210025'), ('20161120172434'), ('20161120200716'), ('20161120220640'), ('20161121204216'), ('20161121204228'), ('20161121210755'), ('20161126163319'), ('20161126175055'), ('20161127205152'), ('20161130163049'), ('20161130172806'), ('20170104191352'), ('20170105153325'), ('20170105171430'), ('20170105201655'), ('20170115082244'), ('20170115112459'), ('20170115112512'), ('20170115112745'), ('20170115122705'), ('20170223073922'), ('20170225164200'), ('20170225191010'), ('20170226124154'), ('20170226141716'), ('20170226144500'), ('20170226163846'), ('20170227141716'), ('20170227144500'), ('20170302163846'), ('20170302211911');


