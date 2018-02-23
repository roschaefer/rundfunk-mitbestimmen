SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: history; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA IF NOT EXISTS history;


--
-- Name: temporal; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA IF NOT EXISTS temporal;


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: btree_gist; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS btree_gist WITH SCHEMA public;


--
-- Name: EXTENSION btree_gist; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION btree_gist IS 'support for indexing common datatypes in GiST';


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
-- Name: chronomodel_impressions_delete(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION chronomodel_impressions_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
            DECLARE _now timestamp;
            BEGIN
              _now := timezone('UTC', now());

              DELETE FROM history.impressions
              WHERE id = old.id AND validity = tsrange(_now, NULL);

              UPDATE history.impressions SET validity = tsrange(lower(validity), _now)
              WHERE id = old.id AND upper_inf(validity);

              DELETE FROM ONLY temporal.impressions
              WHERE id = old.id;

              RETURN OLD;
            END;
          $$;


--
-- Name: chronomodel_impressions_insert(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION chronomodel_impressions_insert() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
            BEGIN
              IF NEW.id IS NULL THEN
                NEW.id := nextval('temporal.impressions_id_seq');
              END IF;

              INSERT INTO temporal.impressions ( id, "response", "amount", "user_id", "broadcast_id", "created_at", "updated_at", "fixed" )
              VALUES ( NEW.id, NEW."response", NEW."amount", NEW."user_id", NEW."broadcast_id", NEW."created_at", NEW."updated_at", NEW."fixed" );

              INSERT INTO history.impressions ( id, "response", "amount", "user_id", "broadcast_id", "created_at", "updated_at", "fixed", validity )
              VALUES ( NEW.id, NEW."response", NEW."amount", NEW."user_id", NEW."broadcast_id", NEW."created_at", NEW."updated_at", NEW."fixed", tsrange(timezone('UTC', now()), NULL) );

              RETURN NEW;
            END;
          $$;


--
-- Name: chronomodel_impressions_update(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION chronomodel_impressions_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
            DECLARE _now timestamp;
            DECLARE _hid integer;
            DECLARE _old record;
            DECLARE _new record;
            BEGIN
              IF OLD IS NOT DISTINCT FROM NEW THEN
                RETURN NULL;
              END IF;

              _old := row(OLD."response", OLD."amount", OLD."user_id", OLD."broadcast_id", OLD."created_at", OLD."fixed");
              _new := row(NEW."response", NEW."amount", NEW."user_id", NEW."broadcast_id", NEW."created_at", NEW."fixed");

              IF _old IS NOT DISTINCT FROM _new THEN
                UPDATE ONLY temporal.impressions SET ( "response", "amount", "user_id", "broadcast_id", "created_at", "updated_at", "fixed" ) = ( NEW."response", NEW."amount", NEW."user_id", NEW."broadcast_id", NEW."created_at", NEW."updated_at", NEW."fixed" ) WHERE id = OLD.id;
                RETURN NEW;
              END IF;

              _now := timezone('UTC', now());
              _hid := NULL;

              SELECT hid INTO _hid FROM history.impressions WHERE id = OLD.id AND lower(validity) = _now;

              IF _hid IS NOT NULL THEN
                UPDATE history.impressions SET ( "response", "amount", "user_id", "broadcast_id", "created_at", "updated_at", "fixed" ) = ( NEW."response", NEW."amount", NEW."user_id", NEW."broadcast_id", NEW."created_at", NEW."updated_at", NEW."fixed" ) WHERE hid = _hid;
              ELSE
                UPDATE history.impressions SET validity = tsrange(lower(validity), _now)
                WHERE id = OLD.id AND upper_inf(validity);

                INSERT INTO history.impressions ( id, "response", "amount", "user_id", "broadcast_id", "created_at", "updated_at", "fixed", validity )
                     VALUES ( OLD.id, NEW."response", NEW."amount", NEW."user_id", NEW."broadcast_id", NEW."created_at", NEW."updated_at", NEW."fixed", tsrange(_now, NULL) );
              END IF;

              UPDATE ONLY temporal.impressions SET ( "response", "amount", "user_id", "broadcast_id", "created_at", "updated_at", "fixed" ) = ( NEW."response", NEW."amount", NEW."user_id", NEW."broadcast_id", NEW."created_at", NEW."updated_at", NEW."fixed" ) WHERE id = OLD.id;

              RETURN NEW;
            END;
          $$;


SET search_path = temporal, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: impressions; Type: TABLE; Schema: temporal; Owner: -
--

CREATE TABLE impressions (
    id integer NOT NULL,
    response integer DEFAULT 0 NOT NULL,
    amount numeric,
    user_id integer NOT NULL,
    broadcast_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    fixed boolean
);


SET search_path = history, pg_catalog;

--
-- Name: impressions; Type: TABLE; Schema: history; Owner: -
--

CREATE TABLE impressions (
    hid integer NOT NULL,
    validity tsrange NOT NULL,
    recorded_at timestamp without time zone DEFAULT timezone('UTC'::text, now()) NOT NULL
)
INHERITS (temporal.impressions);


--
-- Name: impressions_hid_seq; Type: SEQUENCE; Schema: history; Owner: -
--

CREATE SEQUENCE impressions_hid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: impressions_hid_seq; Type: SEQUENCE OWNED BY; Schema: history; Owner: -
--

ALTER SEQUENCE impressions_hid_seq OWNED BY impressions.hid;


SET search_path = public, pg_catalog;

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
-- Name: broadcasts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE broadcasts (
    id integer NOT NULL,
    title citext,
    description character varying,
    topic_id integer,
    format_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    creator_id integer,
    mediathek_identification integer,
    medium_id integer,
    schedule_id bigint,
    image_url character varying,
    broadcast_url character varying
);


--
-- Name: broadcasts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE broadcasts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: broadcasts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE broadcasts_id_seq OWNED BY broadcasts.id;


--
-- Name: format_translations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE format_translations (
    id bigint NOT NULL,
    format_id integer NOT NULL,
    locale character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    name character varying
);


--
-- Name: format_translations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE format_translations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: format_translations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE format_translations_id_seq OWNED BY format_translations.id;


--
-- Name: formats; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE formats (
    id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: formats_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE formats_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: formats_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE formats_id_seq OWNED BY formats.id;


--
-- Name: impressions; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW impressions AS
 SELECT impressions.id,
    impressions.response,
    impressions.amount,
    impressions.user_id,
    impressions.broadcast_id,
    impressions.created_at,
    impressions.updated_at,
    impressions.fixed
   FROM ONLY temporal.impressions;


--
-- Name: VIEW impressions; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON VIEW impressions IS '{"temporal":true,"copy_data":true,"chronomodel":"0.12.1"}';


--
-- Name: media; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE media (
    id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: media_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE media_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: media_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE media_id_seq OWNED BY media.id;


--
-- Name: medium_translations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE medium_translations (
    id bigint NOT NULL,
    medium_id integer NOT NULL,
    locale character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    name character varying
);


--
-- Name: medium_translations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE medium_translations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: medium_translations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE medium_translations_id_seq OWNED BY medium_translations.id;


--
-- Name: schedules; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE schedules (
    id bigint NOT NULL,
    broadcast_id bigint,
    station_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: schedules_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE schedules_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: schedules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE schedules_id_seq OWNED BY schedules.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: similarities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE similarities (
    id bigint NOT NULL,
    broadcast1_id integer,
    broadcast2_id integer,
    value numeric,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: similarities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE similarities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: similarities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE similarities_id_seq OWNED BY similarities.id;


--
-- Name: stations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE stations (
    id integer NOT NULL,
    name character varying,
    medium_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    broadcasts_count integer DEFAULT 0
);


--
-- Name: stations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE stations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: stations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE stations_id_seq OWNED BY stations.id;


--
-- Name: statistic_broadcasts; Type: MATERIALIZED VIEW; Schema: public; Owner: -
--

CREATE MATERIALIZED VIEW statistic_broadcasts AS
 SELECT broadcasts.id,
    broadcasts.title,
    count(impressions.id) AS impressions,
    avg(impressions.response) AS approval,
    avg(impressions.amount) AS average,
    COALESCE(sum(impressions.amount), (0)::numeric) AS total,
    COALESCE(((count(impressions.id))::numeric * ( SELECT avg(COALESCE(impressions_1.amount, (0)::numeric)) AS avg
           FROM impressions impressions_1)), (0)::numeric) AS expected_amount
   FROM (broadcasts
     LEFT JOIN impressions ON ((impressions.broadcast_id = broadcasts.id)))
  GROUP BY broadcasts.id, broadcasts.title
  WITH NO DATA;


--
-- Name: statistic_media; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW statistic_media AS
 SELECT media.id,
    count(*) AS broadcasts_count,
    sum(statistic_broadcasts.total) AS total,
    sum(statistic_broadcasts.expected_amount) AS expected_amount
   FROM ((media
     JOIN broadcasts ON ((media.id = broadcasts.medium_id)))
     JOIN statistic_broadcasts ON ((broadcasts.id = statistic_broadcasts.id)))
  GROUP BY media.id
UNION ALL
 SELECT media.id,
    0 AS broadcasts_count,
    0 AS total,
    0 AS expected_amount
   FROM (media
     LEFT JOIN broadcasts ON ((media.id = broadcasts.medium_id)))
  WHERE (broadcasts.medium_id IS NULL);


--
-- Name: statistic_medium_translations; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW statistic_medium_translations AS
 SELECT medium_translations.id,
    medium_translations.medium_id,
    medium_translations.locale,
    medium_translations.created_at,
    medium_translations.updated_at,
    medium_translations.name,
    medium_translations.medium_id AS statistic_medium_id
   FROM medium_translations;


--
-- Name: statistic_stations; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW statistic_stations AS
 SELECT stations.id,
    stations.name,
    stations.medium_id,
    count(*) AS broadcasts_count,
    sum((t.total / (t.stations_count)::numeric)) AS total,
    sum((t.expected_amount / (t.stations_count)::numeric)) AS expected_amount
   FROM ((( SELECT statistic_broadcasts.id AS broadcast_id,
            statistic_broadcasts.total,
            statistic_broadcasts.expected_amount,
            count(*) AS stations_count
           FROM (statistic_broadcasts
             JOIN schedules schedules_1 ON ((statistic_broadcasts.id = schedules_1.broadcast_id)))
          GROUP BY statistic_broadcasts.id, statistic_broadcasts.total, statistic_broadcasts.expected_amount) t
     JOIN schedules ON ((t.broadcast_id = schedules.broadcast_id)))
     JOIN stations ON ((schedules.station_id = stations.id)))
  GROUP BY stations.id, stations.name, stations.medium_id
UNION ALL
 SELECT stations.id,
    stations.name,
    stations.medium_id,
    0 AS broadcasts_count,
    0 AS total,
    0 AS expected_amount
   FROM (stations
     LEFT JOIN schedules ON ((stations.id = schedules.station_id)))
  WHERE (schedules.broadcast_id IS NULL);


--
-- Name: statistics; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW statistics AS
 SELECT t.id,
    t.title,
    t.impressions,
    ((t.positives)::double precision / (NULLIF(t.impressions, 0))::double precision) AS approval,
    COALESCE(((t.total)::double precision / (NULLIF(t.positives, 0))::double precision), (0)::double precision) AS average,
    t.total,
    ((t.impressions)::numeric * a.average_amount_per_selection) AS expected_amount
   FROM (( SELECT impressions.broadcast_id AS id,
            broadcasts.title,
            count(*) AS impressions,
            COALESCE(sum(
                CASE
                    WHEN (impressions.response = 1) THEN 1
                    ELSE 0
                END), (0)::bigint) AS positives,
            COALESCE(sum(impressions.amount), (0)::numeric) AS total
           FROM (temporal.impressions
             JOIN broadcasts ON ((impressions.broadcast_id = broadcasts.id)))
          GROUP BY impressions.broadcast_id, broadcasts.title) t
     LEFT JOIN ( SELECT (sum(impressions.amount) / (count(*))::numeric) AS average_amount_per_selection
           FROM temporal.impressions) a ON (true));


--
-- Name: topic_translations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE topic_translations (
    id bigint NOT NULL,
    topic_id integer NOT NULL,
    locale character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    name character varying
);


--
-- Name: topic_translations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE topic_translations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: topic_translations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE topic_translations_id_seq OWNED BY topic_translations.id;


--
-- Name: topics; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE topics (
    id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: topics_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE topics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: topics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE topics_id_seq OWNED BY topics.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE users (
    id integer NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    email character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    role integer DEFAULT 0,
    auth0_uid character varying,
    has_bad_email boolean DEFAULT false,
    latitude double precision,
    longitude double precision,
    country_code character varying,
    state_code character varying,
    postal_code character varying,
    city character varying,
    locale character varying
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
-- Name: versions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE versions (
    id bigint NOT NULL,
    item_type character varying NOT NULL,
    item_id integer NOT NULL,
    event character varying NOT NULL,
    whodunnit character varying,
    object text,
    created_at timestamp without time zone
);


--
-- Name: versions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: versions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE versions_id_seq OWNED BY versions.id;


SET search_path = temporal, pg_catalog;

--
-- Name: impressions_id_seq; Type: SEQUENCE; Schema: temporal; Owner: -
--

CREATE SEQUENCE impressions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: impressions_id_seq; Type: SEQUENCE OWNED BY; Schema: temporal; Owner: -
--

ALTER SEQUENCE impressions_id_seq OWNED BY impressions.id;


SET search_path = history, pg_catalog;

--
-- Name: impressions id; Type: DEFAULT; Schema: history; Owner: -
--

ALTER TABLE ONLY impressions ALTER COLUMN id SET DEFAULT nextval('temporal.impressions_id_seq'::regclass);


--
-- Name: impressions response; Type: DEFAULT; Schema: history; Owner: -
--

ALTER TABLE ONLY impressions ALTER COLUMN response SET DEFAULT 0;


--
-- Name: impressions hid; Type: DEFAULT; Schema: history; Owner: -
--

ALTER TABLE ONLY impressions ALTER COLUMN hid SET DEFAULT nextval('impressions_hid_seq'::regclass);


SET search_path = public, pg_catalog;

--
-- Name: broadcasts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY broadcasts ALTER COLUMN id SET DEFAULT nextval('broadcasts_id_seq'::regclass);


--
-- Name: format_translations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY format_translations ALTER COLUMN id SET DEFAULT nextval('format_translations_id_seq'::regclass);


--
-- Name: formats id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY formats ALTER COLUMN id SET DEFAULT nextval('formats_id_seq'::regclass);


--
-- Name: impressions response; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY impressions ALTER COLUMN response SET DEFAULT 0;


--
-- Name: media id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY media ALTER COLUMN id SET DEFAULT nextval('media_id_seq'::regclass);


--
-- Name: medium_translations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY medium_translations ALTER COLUMN id SET DEFAULT nextval('medium_translations_id_seq'::regclass);


--
-- Name: schedules id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY schedules ALTER COLUMN id SET DEFAULT nextval('schedules_id_seq'::regclass);


--
-- Name: similarities id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY similarities ALTER COLUMN id SET DEFAULT nextval('similarities_id_seq'::regclass);


--
-- Name: stations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY stations ALTER COLUMN id SET DEFAULT nextval('stations_id_seq'::regclass);


--
-- Name: topic_translations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY topic_translations ALTER COLUMN id SET DEFAULT nextval('topic_translations_id_seq'::regclass);


--
-- Name: topics id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY topics ALTER COLUMN id SET DEFAULT nextval('topics_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: versions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY versions ALTER COLUMN id SET DEFAULT nextval('versions_id_seq'::regclass);


SET search_path = temporal, pg_catalog;

--
-- Name: impressions id; Type: DEFAULT; Schema: temporal; Owner: -
--

ALTER TABLE ONLY impressions ALTER COLUMN id SET DEFAULT nextval('impressions_id_seq'::regclass);


SET search_path = history, pg_catalog;

--
-- Name: impressions impressions_pkey; Type: CONSTRAINT; Schema: history; Owner: -
--

ALTER TABLE ONLY impressions
    ADD CONSTRAINT impressions_pkey PRIMARY KEY (hid);


--
-- Name: impressions impressions_timeline_consistency; Type: CONSTRAINT; Schema: history; Owner: -
--

ALTER TABLE ONLY impressions
    ADD CONSTRAINT impressions_timeline_consistency EXCLUDE USING gist (id WITH =, validity WITH &&);


SET search_path = public, pg_catalog;

--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: broadcasts broadcasts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY broadcasts
    ADD CONSTRAINT broadcasts_pkey PRIMARY KEY (id);


--
-- Name: format_translations format_translations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY format_translations
    ADD CONSTRAINT format_translations_pkey PRIMARY KEY (id);


--
-- Name: formats formats_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY formats
    ADD CONSTRAINT formats_pkey PRIMARY KEY (id);


--
-- Name: media media_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY media
    ADD CONSTRAINT media_pkey PRIMARY KEY (id);


--
-- Name: medium_translations medium_translations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY medium_translations
    ADD CONSTRAINT medium_translations_pkey PRIMARY KEY (id);


--
-- Name: schedules schedules_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY schedules
    ADD CONSTRAINT schedules_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: similarities similarities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY similarities
    ADD CONSTRAINT similarities_pkey PRIMARY KEY (id);


--
-- Name: stations stations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY stations
    ADD CONSTRAINT stations_pkey PRIMARY KEY (id);


--
-- Name: topic_translations topic_translations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY topic_translations
    ADD CONSTRAINT topic_translations_pkey PRIMARY KEY (id);


--
-- Name: topics topics_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY topics
    ADD CONSTRAINT topics_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: versions versions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY versions
    ADD CONSTRAINT versions_pkey PRIMARY KEY (id);


SET search_path = temporal, pg_catalog;

--
-- Name: impressions impressions_pkey; Type: CONSTRAINT; Schema: temporal; Owner: -
--

ALTER TABLE ONLY impressions
    ADD CONSTRAINT impressions_pkey PRIMARY KEY (id);


SET search_path = history, pg_catalog;

--
-- Name: impressions_inherit_pkey; Type: INDEX; Schema: history; Owner: -
--

CREATE INDEX impressions_inherit_pkey ON impressions USING btree (id);


--
-- Name: impressions_instance_history; Type: INDEX; Schema: history; Owner: -
--

CREATE INDEX impressions_instance_history ON impressions USING btree (id, recorded_at);


--
-- Name: impressions_recorded_at; Type: INDEX; Schema: history; Owner: -
--

CREATE INDEX impressions_recorded_at ON impressions USING btree (recorded_at);


--
-- Name: index_impressions_on_broadcast_id; Type: INDEX; Schema: history; Owner: -
--

CREATE INDEX index_impressions_on_broadcast_id ON impressions USING btree (broadcast_id);


--
-- Name: index_impressions_on_user_id; Type: INDEX; Schema: history; Owner: -
--

CREATE INDEX index_impressions_on_user_id ON impressions USING btree (user_id);


--
-- Name: index_impressions_on_user_id_and_broadcast_id; Type: INDEX; Schema: history; Owner: -
--

CREATE INDEX index_impressions_on_user_id_and_broadcast_id ON impressions USING btree (user_id, broadcast_id);


--
-- Name: index_impressions_temporal_on_lower_validity; Type: INDEX; Schema: history; Owner: -
--

CREATE INDEX index_impressions_temporal_on_lower_validity ON impressions USING btree (lower(validity));


--
-- Name: index_impressions_temporal_on_upper_validity; Type: INDEX; Schema: history; Owner: -
--

CREATE INDEX index_impressions_temporal_on_upper_validity ON impressions USING btree (upper(validity));


--
-- Name: index_impressions_temporal_on_validity; Type: INDEX; Schema: history; Owner: -
--

CREATE INDEX index_impressions_temporal_on_validity ON impressions USING gist (validity);


SET search_path = public, pg_catalog;

--
-- Name: index_broadcasts_on_format_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_broadcasts_on_format_id ON broadcasts USING btree (format_id);


--
-- Name: index_broadcasts_on_mediathek_identification; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_broadcasts_on_mediathek_identification ON broadcasts USING btree (mediathek_identification);


--
-- Name: index_broadcasts_on_medium_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_broadcasts_on_medium_id ON broadcasts USING btree (medium_id);


--
-- Name: index_broadcasts_on_schedule_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_broadcasts_on_schedule_id ON broadcasts USING btree (schedule_id);


--
-- Name: index_broadcasts_on_title; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_broadcasts_on_title ON broadcasts USING btree (title);


--
-- Name: index_broadcasts_on_topic_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_broadcasts_on_topic_id ON broadcasts USING btree (topic_id);


--
-- Name: index_format_translations_on_format_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_format_translations_on_format_id ON format_translations USING btree (format_id);


--
-- Name: index_format_translations_on_locale; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_format_translations_on_locale ON format_translations USING btree (locale);


--
-- Name: index_medium_translations_on_locale; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_medium_translations_on_locale ON medium_translations USING btree (locale);


--
-- Name: index_medium_translations_on_medium_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_medium_translations_on_medium_id ON medium_translations USING btree (medium_id);


--
-- Name: index_schedules_on_broadcast_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_schedules_on_broadcast_id ON schedules USING btree (broadcast_id);


--
-- Name: index_schedules_on_broadcast_id_and_station_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_schedules_on_broadcast_id_and_station_id ON schedules USING btree (broadcast_id, station_id);


--
-- Name: index_schedules_on_station_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_schedules_on_station_id ON schedules USING btree (station_id);


--
-- Name: index_similarities_on_broadcast1_id_and_broadcast2_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_similarities_on_broadcast1_id_and_broadcast2_id ON similarities USING btree (broadcast1_id, broadcast2_id);


--
-- Name: index_stations_on_medium_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_stations_on_medium_id ON stations USING btree (medium_id);


--
-- Name: index_stations_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_stations_on_name ON stations USING btree (name);


--
-- Name: index_statistic_broadcasts_on_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_statistic_broadcasts_on_id ON statistic_broadcasts USING btree (id);


--
-- Name: index_topic_translations_on_locale; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_topic_translations_on_locale ON topic_translations USING btree (locale);


--
-- Name: index_topic_translations_on_topic_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_topic_translations_on_topic_id ON topic_translations USING btree (topic_id);


--
-- Name: index_users_on_auth0_uid; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_auth0_uid ON users USING btree (auth0_uid);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_versions_on_item_type_and_item_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_versions_on_item_type_and_item_id ON versions USING btree (item_type, item_id);


SET search_path = temporal, pg_catalog;

--
-- Name: index_impressions_on_broadcast_id; Type: INDEX; Schema: temporal; Owner: -
--

CREATE INDEX index_impressions_on_broadcast_id ON impressions USING btree (broadcast_id);


--
-- Name: index_impressions_on_user_id; Type: INDEX; Schema: temporal; Owner: -
--

CREATE INDEX index_impressions_on_user_id ON impressions USING btree (user_id);


--
-- Name: index_impressions_on_user_id_and_broadcast_id; Type: INDEX; Schema: temporal; Owner: -
--

CREATE UNIQUE INDEX index_impressions_on_user_id_and_broadcast_id ON impressions USING btree (user_id, broadcast_id);


SET search_path = public, pg_catalog;

--
-- Name: impressions chronomodel_delete; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER chronomodel_delete INSTEAD OF DELETE ON impressions FOR EACH ROW EXECUTE PROCEDURE chronomodel_impressions_delete();


--
-- Name: impressions chronomodel_insert; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER chronomodel_insert INSTEAD OF INSERT ON impressions FOR EACH ROW EXECUTE PROCEDURE chronomodel_impressions_insert();


--
-- Name: impressions chronomodel_update; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER chronomodel_update INSTEAD OF UPDATE ON impressions FOR EACH ROW EXECUTE PROCEDURE chronomodel_impressions_update();


--
-- Name: broadcasts fk_rails_37250dc78c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY broadcasts
    ADD CONSTRAINT fk_rails_37250dc78c FOREIGN KEY (topic_id) REFERENCES topics(id);


--
-- Name: stations fk_rails_749eb07017; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY stations
    ADD CONSTRAINT fk_rails_749eb07017 FOREIGN KEY (medium_id) REFERENCES media(id);


--
-- Name: broadcasts fk_rails_9eec935c8b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY broadcasts
    ADD CONSTRAINT fk_rails_9eec935c8b FOREIGN KEY (schedule_id) REFERENCES schedules(id);


--
-- Name: broadcasts fk_rails_a45e306ec3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY broadcasts
    ADD CONSTRAINT fk_rails_a45e306ec3 FOREIGN KEY (creator_id) REFERENCES users(id);


--
-- Name: broadcasts fk_rails_c39629e750; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY broadcasts
    ADD CONSTRAINT fk_rails_c39629e750 FOREIGN KEY (medium_id) REFERENCES media(id);


--
-- Name: broadcasts fk_rails_eee7654a34; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY broadcasts
    ADD CONSTRAINT fk_rails_eee7654a34 FOREIGN KEY (format_id) REFERENCES formats(id);


SET search_path = temporal, pg_catalog;

--
-- Name: impressions fk_rails_4fd47aaffd; Type: FK CONSTRAINT; Schema: temporal; Owner: -
--

ALTER TABLE ONLY impressions
    ADD CONSTRAINT fk_rails_4fd47aaffd FOREIGN KEY (broadcast_id) REFERENCES public.broadcasts(id);


--
-- Name: impressions fk_rails_a56f328f61; Type: FK CONSTRAINT; Schema: temporal; Owner: -
--

ALTER TABLE ONLY impressions
    ADD CONSTRAINT fk_rails_a56f328f61 FOREIGN KEY (broadcast_id) REFERENCES public.broadcasts(id);


--
-- Name: impressions fk_rails_da7bcadf25; Type: FK CONSTRAINT; Schema: temporal; Owner: -
--

ALTER TABLE ONLY impressions
    ADD CONSTRAINT fk_rails_da7bcadf25 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: impressions fk_rails_f0d87991a2; Type: FK CONSTRAINT; Schema: temporal; Owner: -
--

ALTER TABLE ONLY impressions
    ADD CONSTRAINT fk_rails_f0d87991a2 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20160809224140'),
('20160809224146'),
('20160809224150'),
('20160811185316'),
('20160811214537'),
('20160812190335'),
('20160814101736'),
('20160901091314'),
('20160918193233'),
('20160918203454'),
('20160918204157'),
('20160918221950'),
('20161002094607'),
('20161002180830'),
('20161003144843'),
('20161008174249'),
('20161009134715'),
('20161020202952'),
('20161201150907'),
('20161202154845'),
('20170106230717'),
('20170123141557'),
('20170123141558'),
('20170123142201'),
('20170123220015'),
('20170123222422'),
('20170128232948'),
('20170209001001'),
('20170209002421'),
('20170214174430'),
('20170220233015'),
('20170405202023'),
('20170405203200'),
('20170405203335'),
('20170505133857'),
('20170616141405'),
('20170619230928'),
('20170623142711'),
('20170726152244'),
('20170909130919'),
('20170909131424'),
('20170915181631'),
('20170916150704'),
('20170916164309'),
('20170916170224'),
('20170917155355'),
('20170920091618'),
('20170920143139'),
('20170922210359'),
('20170930144629'),
('20171018181816'),
('20171021173446'),
('20171025214229'),
('20171029000924'),
('20171111141249'),
('20171115195229'),
('20171115205013'),
('20171121223456'),
('20171123003201'),
('20180215143737'),
('20180223201113');


