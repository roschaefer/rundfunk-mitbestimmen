

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;


CREATE SCHEMA IF NOT EXISTS history;



CREATE SCHEMA IF NOT EXISTS temporal;



CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;



COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';



CREATE EXTENSION IF NOT EXISTS btree_gist WITH SCHEMA public;



COMMENT ON EXTENSION btree_gist IS 'support for indexing common datatypes in GiST';



CREATE EXTENSION IF NOT EXISTS citext WITH SCHEMA public;



COMMENT ON EXTENSION citext IS 'data type for case-insensitive character strings';



CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;



COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


SET search_path = public, pg_catalog;


CREATE FUNCTION chronomodel_broadcasts_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
            DECLARE _now timestamp;
            BEGIN
              _now := timezone('UTC', now());

              DELETE FROM history.broadcasts
              WHERE id = old.id AND validity = tsrange(_now, NULL);

              UPDATE history.broadcasts SET validity = tsrange(lower(validity), _now)
              WHERE id = old.id AND upper_inf(validity);

              DELETE FROM ONLY temporal.broadcasts
              WHERE id = old.id;

              RETURN OLD;
            END;
          $$;



CREATE FUNCTION chronomodel_broadcasts_insert() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
            BEGIN
              IF NEW.id IS NULL THEN
                NEW.id := nextval('temporal.broadcasts_id_seq');
              END IF;

              INSERT INTO temporal.broadcasts ( id, "title", "description", "topic_id", "format_id", "created_at", "updated_at", "creator_id", "mediathek_identification", "medium_id", "schedule_id", "approval" )
              VALUES ( NEW.id, NEW."title", NEW."description", NEW."topic_id", NEW."format_id", NEW."created_at", NEW."updated_at", NEW."creator_id", NEW."mediathek_identification", NEW."medium_id", NEW."schedule_id", NEW."approval" );

              INSERT INTO history.broadcasts ( id, "title", "description", "topic_id", "format_id", "created_at", "updated_at", "creator_id", "mediathek_identification", "medium_id", "schedule_id", "approval", validity )
              VALUES ( NEW.id, NEW."title", NEW."description", NEW."topic_id", NEW."format_id", NEW."created_at", NEW."updated_at", NEW."creator_id", NEW."mediathek_identification", NEW."medium_id", NEW."schedule_id", NEW."approval", tsrange(timezone('UTC', now()), NULL) );

              RETURN NEW;
            END;
          $$;



CREATE FUNCTION chronomodel_broadcasts_update() RETURNS trigger
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

              _old := row(OLD."approval");
              _new := row(NEW."approval");

              IF _old IS NOT DISTINCT FROM _new THEN
                UPDATE ONLY temporal.broadcasts SET ( "title", "description", "topic_id", "format_id", "created_at", "updated_at", "creator_id", "mediathek_identification", "medium_id", "schedule_id", "approval" ) = ( NEW."title", NEW."description", NEW."topic_id", NEW."format_id", NEW."created_at", NEW."updated_at", NEW."creator_id", NEW."mediathek_identification", NEW."medium_id", NEW."schedule_id", NEW."approval" ) WHERE id = OLD.id;
                RETURN NEW;
              END IF;

              _now := timezone('UTC', now());
              _hid := NULL;

              SELECT hid INTO _hid FROM history.broadcasts WHERE id = OLD.id AND lower(validity) = _now;

              IF _hid IS NOT NULL THEN
                UPDATE history.broadcasts SET ( "title", "description", "topic_id", "format_id", "created_at", "updated_at", "creator_id", "mediathek_identification", "medium_id", "schedule_id", "approval" ) = ( NEW."title", NEW."description", NEW."topic_id", NEW."format_id", NEW."created_at", NEW."updated_at", NEW."creator_id", NEW."mediathek_identification", NEW."medium_id", NEW."schedule_id", NEW."approval" ) WHERE hid = _hid;
              ELSE
                UPDATE history.broadcasts SET validity = tsrange(lower(validity), _now)
                WHERE id = OLD.id AND upper_inf(validity);

                INSERT INTO history.broadcasts ( id, "title", "description", "topic_id", "format_id", "created_at", "updated_at", "creator_id", "mediathek_identification", "medium_id", "schedule_id", "approval", validity )
                     VALUES ( OLD.id, NEW."title", NEW."description", NEW."topic_id", NEW."format_id", NEW."created_at", NEW."updated_at", NEW."creator_id", NEW."mediathek_identification", NEW."medium_id", NEW."schedule_id", NEW."approval", tsrange(_now, NULL) );
              END IF;

              UPDATE ONLY temporal.broadcasts SET ( "title", "description", "topic_id", "format_id", "created_at", "updated_at", "creator_id", "mediathek_identification", "medium_id", "schedule_id", "approval" ) = ( NEW."title", NEW."description", NEW."topic_id", NEW."format_id", NEW."created_at", NEW."updated_at", NEW."creator_id", NEW."mediathek_identification", NEW."medium_id", NEW."schedule_id", NEW."approval" ) WHERE id = OLD.id;

              RETURN NEW;
            END;
          $$;


SET search_path = temporal, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;


CREATE TABLE broadcasts (
    id integer NOT NULL,
    title public.citext,
    description character varying,
    topic_id integer,
    format_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    creator_id integer,
    mediathek_identification integer,
    medium_id integer,
    schedule_id bigint,
    approval double precision
);


SET search_path = history, pg_catalog;


CREATE TABLE broadcasts (
    hid integer NOT NULL,
    validity tsrange NOT NULL,
    recorded_at timestamp without time zone DEFAULT timezone('UTC'::text, now()) NOT NULL
)
INHERITS (temporal.broadcasts);



CREATE SEQUENCE broadcasts_hid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE broadcasts_hid_seq OWNED BY broadcasts.hid;


SET search_path = public, pg_catalog;


CREATE TABLE ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);



CREATE VIEW broadcasts AS
 SELECT broadcasts.id,
    broadcasts.title,
    broadcasts.description,
    broadcasts.topic_id,
    broadcasts.format_id,
    broadcasts.created_at,
    broadcasts.updated_at,
    broadcasts.creator_id,
    broadcasts.mediathek_identification,
    broadcasts.medium_id,
    broadcasts.schedule_id,
    broadcasts.approval
   FROM ONLY temporal.broadcasts;



COMMENT ON VIEW broadcasts IS '{"temporal":true,"copy_data":true,"journal":["approval"],"chronomodel":"0.11.1"}';



CREATE TABLE format_translations (
    id bigint NOT NULL,
    format_id integer NOT NULL,
    locale character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    name character varying
);



CREATE SEQUENCE format_translations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE format_translations_id_seq OWNED BY format_translations.id;



CREATE TABLE formats (
    id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);



CREATE SEQUENCE formats_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE formats_id_seq OWNED BY formats.id;



CREATE TABLE impressions (
    id integer NOT NULL,
    response integer,
    amount numeric,
    user_id integer,
    broadcast_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    fixed boolean
);



CREATE SEQUENCE impressions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE impressions_id_seq OWNED BY impressions.id;



CREATE TABLE media (
    id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);



CREATE SEQUENCE media_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE media_id_seq OWNED BY media.id;



CREATE TABLE medium_translations (
    id bigint NOT NULL,
    medium_id integer NOT NULL,
    locale character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    name character varying
);



CREATE SEQUENCE medium_translations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE medium_translations_id_seq OWNED BY medium_translations.id;



CREATE TABLE schedules (
    id bigint NOT NULL,
    broadcast_id bigint,
    station_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);



CREATE SEQUENCE schedules_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE schedules_id_seq OWNED BY schedules.id;



CREATE TABLE schema_migrations (
    version character varying NOT NULL
);



CREATE TABLE stations (
    id integer NOT NULL,
    name character varying,
    medium_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    broadcasts_count integer DEFAULT 0
);



CREATE SEQUENCE stations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE stations_id_seq OWNED BY stations.id;



CREATE VIEW statistic_broadcasts AS
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
           FROM (impressions
             JOIN temporal.broadcasts ON ((impressions.broadcast_id = broadcasts.id)))
          GROUP BY impressions.broadcast_id, broadcasts.title) t
     LEFT JOIN ( SELECT (sum(impressions.amount) / (count(*))::numeric) AS average_amount_per_selection
           FROM impressions) a ON (true))
UNION ALL
 SELECT broadcasts.id,
    broadcasts.title,
    0 AS impressions,
    NULL::double precision AS approval,
    NULL::double precision AS average,
    0 AS total,
    0 AS expected_amount
   FROM (temporal.broadcasts
     LEFT JOIN impressions ON ((broadcasts.id = impressions.broadcast_id)))
  WHERE (impressions.broadcast_id IS NULL);



CREATE VIEW statistic_media AS
 SELECT media.id,
    count(*) AS broadcasts_count,
    sum(statistic_broadcasts.total) AS total,
    sum(statistic_broadcasts.expected_amount) AS expected_amount
   FROM ((media
     JOIN temporal.broadcasts ON ((media.id = broadcasts.medium_id)))
     JOIN statistic_broadcasts ON ((broadcasts.id = statistic_broadcasts.id)))
  GROUP BY media.id
UNION ALL
 SELECT media.id,
    0 AS broadcasts_count,
    0 AS total,
    0 AS expected_amount
   FROM (media
     LEFT JOIN temporal.broadcasts ON ((media.id = broadcasts.medium_id)))
  WHERE (broadcasts.medium_id IS NULL);



CREATE VIEW statistic_medium_translations AS
 SELECT medium_translations.id,
    medium_translations.medium_id,
    medium_translations.locale,
    medium_translations.created_at,
    medium_translations.updated_at,
    medium_translations.name,
    medium_translations.medium_id AS statistic_medium_id
   FROM medium_translations;



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
           FROM (impressions
             JOIN temporal.broadcasts ON ((impressions.broadcast_id = broadcasts.id)))
          GROUP BY impressions.broadcast_id, broadcasts.title) t
     LEFT JOIN ( SELECT (sum(impressions.amount) / (count(*))::numeric) AS average_amount_per_selection
           FROM impressions) a ON (true));



CREATE TABLE topic_translations (
    id bigint NOT NULL,
    topic_id integer NOT NULL,
    locale character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    name character varying
);



CREATE SEQUENCE topic_translations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE topic_translations_id_seq OWNED BY topic_translations.id;



CREATE TABLE topics (
    id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);



CREATE SEQUENCE topics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE topics_id_seq OWNED BY topics.id;



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



CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE users_id_seq OWNED BY users.id;



CREATE TABLE versions (
    id bigint NOT NULL,
    item_type character varying NOT NULL,
    item_id integer NOT NULL,
    event character varying NOT NULL,
    whodunnit character varying,
    object text,
    created_at timestamp without time zone
);



CREATE SEQUENCE versions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE versions_id_seq OWNED BY versions.id;


SET search_path = temporal, pg_catalog;


CREATE SEQUENCE broadcasts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE broadcasts_id_seq OWNED BY broadcasts.id;


SET search_path = history, pg_catalog;


ALTER TABLE ONLY broadcasts ALTER COLUMN id SET DEFAULT nextval('temporal.broadcasts_id_seq'::regclass);



ALTER TABLE ONLY broadcasts ALTER COLUMN hid SET DEFAULT nextval('broadcasts_hid_seq'::regclass);


SET search_path = public, pg_catalog;


ALTER TABLE ONLY format_translations ALTER COLUMN id SET DEFAULT nextval('format_translations_id_seq'::regclass);



ALTER TABLE ONLY formats ALTER COLUMN id SET DEFAULT nextval('formats_id_seq'::regclass);



ALTER TABLE ONLY impressions ALTER COLUMN id SET DEFAULT nextval('impressions_id_seq'::regclass);



ALTER TABLE ONLY media ALTER COLUMN id SET DEFAULT nextval('media_id_seq'::regclass);



ALTER TABLE ONLY medium_translations ALTER COLUMN id SET DEFAULT nextval('medium_translations_id_seq'::regclass);



ALTER TABLE ONLY schedules ALTER COLUMN id SET DEFAULT nextval('schedules_id_seq'::regclass);



ALTER TABLE ONLY stations ALTER COLUMN id SET DEFAULT nextval('stations_id_seq'::regclass);



ALTER TABLE ONLY topic_translations ALTER COLUMN id SET DEFAULT nextval('topic_translations_id_seq'::regclass);



ALTER TABLE ONLY topics ALTER COLUMN id SET DEFAULT nextval('topics_id_seq'::regclass);



ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);



ALTER TABLE ONLY versions ALTER COLUMN id SET DEFAULT nextval('versions_id_seq'::regclass);


SET search_path = temporal, pg_catalog;


ALTER TABLE ONLY broadcasts ALTER COLUMN id SET DEFAULT nextval('broadcasts_id_seq'::regclass);


SET search_path = history, pg_catalog;


ALTER TABLE ONLY broadcasts
    ADD CONSTRAINT broadcasts_pkey PRIMARY KEY (hid);



ALTER TABLE ONLY broadcasts
    ADD CONSTRAINT broadcasts_timeline_consistency EXCLUDE USING gist (id WITH =, validity WITH &&);


SET search_path = public, pg_catalog;


ALTER TABLE ONLY ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);



ALTER TABLE ONLY format_translations
    ADD CONSTRAINT format_translations_pkey PRIMARY KEY (id);



ALTER TABLE ONLY formats
    ADD CONSTRAINT formats_pkey PRIMARY KEY (id);



ALTER TABLE ONLY impressions
    ADD CONSTRAINT impressions_pkey PRIMARY KEY (id);



ALTER TABLE ONLY media
    ADD CONSTRAINT media_pkey PRIMARY KEY (id);



ALTER TABLE ONLY medium_translations
    ADD CONSTRAINT medium_translations_pkey PRIMARY KEY (id);



ALTER TABLE ONLY schedules
    ADD CONSTRAINT schedules_pkey PRIMARY KEY (id);



ALTER TABLE ONLY schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);



ALTER TABLE ONLY stations
    ADD CONSTRAINT stations_pkey PRIMARY KEY (id);



ALTER TABLE ONLY topic_translations
    ADD CONSTRAINT topic_translations_pkey PRIMARY KEY (id);



ALTER TABLE ONLY topics
    ADD CONSTRAINT topics_pkey PRIMARY KEY (id);



ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);



ALTER TABLE ONLY versions
    ADD CONSTRAINT versions_pkey PRIMARY KEY (id);


SET search_path = temporal, pg_catalog;


ALTER TABLE ONLY broadcasts
    ADD CONSTRAINT broadcasts_pkey PRIMARY KEY (id);


SET search_path = history, pg_catalog;


CREATE INDEX broadcasts_inherit_pkey ON broadcasts USING btree (id);



CREATE INDEX broadcasts_instance_history ON broadcasts USING btree (id, recorded_at);



CREATE INDEX broadcasts_recorded_at ON broadcasts USING btree (recorded_at);



CREATE INDEX index_broadcasts_on_format_id ON broadcasts USING btree (format_id);



CREATE INDEX index_broadcasts_on_mediathek_identification ON broadcasts USING btree (mediathek_identification);



CREATE INDEX index_broadcasts_on_medium_id ON broadcasts USING btree (medium_id);



CREATE INDEX index_broadcasts_on_schedule_id ON broadcasts USING btree (schedule_id);



CREATE INDEX index_broadcasts_on_title ON broadcasts USING btree (title);



CREATE INDEX index_broadcasts_on_topic_id ON broadcasts USING btree (topic_id);



CREATE INDEX index_broadcasts_temporal_on_lower_validity ON broadcasts USING btree (lower(validity));



CREATE INDEX index_broadcasts_temporal_on_upper_validity ON broadcasts USING btree (upper(validity));



CREATE INDEX index_broadcasts_temporal_on_validity ON broadcasts USING gist (validity);


SET search_path = public, pg_catalog;


CREATE INDEX index_format_translations_on_format_id ON format_translations USING btree (format_id);



CREATE INDEX index_format_translations_on_locale ON format_translations USING btree (locale);



CREATE INDEX index_impressions_on_broadcast_id ON impressions USING btree (broadcast_id);



CREATE INDEX index_impressions_on_user_id ON impressions USING btree (user_id);



CREATE UNIQUE INDEX index_impressions_on_user_id_and_broadcast_id ON impressions USING btree (user_id, broadcast_id);



CREATE INDEX index_medium_translations_on_locale ON medium_translations USING btree (locale);



CREATE INDEX index_medium_translations_on_medium_id ON medium_translations USING btree (medium_id);



CREATE INDEX index_schedules_on_broadcast_id ON schedules USING btree (broadcast_id);



CREATE UNIQUE INDEX index_schedules_on_broadcast_id_and_station_id ON schedules USING btree (broadcast_id, station_id);



CREATE INDEX index_schedules_on_station_id ON schedules USING btree (station_id);



CREATE INDEX index_stations_on_medium_id ON stations USING btree (medium_id);



CREATE UNIQUE INDEX index_stations_on_name ON stations USING btree (name);



CREATE INDEX index_topic_translations_on_locale ON topic_translations USING btree (locale);



CREATE INDEX index_topic_translations_on_topic_id ON topic_translations USING btree (topic_id);



CREATE UNIQUE INDEX index_users_on_auth0_uid ON users USING btree (auth0_uid);



CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);



CREATE INDEX index_versions_on_item_type_and_item_id ON versions USING btree (item_type, item_id);


SET search_path = temporal, pg_catalog;


CREATE INDEX index_broadcasts_on_format_id ON broadcasts USING btree (format_id);



CREATE UNIQUE INDEX index_broadcasts_on_mediathek_identification ON broadcasts USING btree (mediathek_identification);



CREATE INDEX index_broadcasts_on_medium_id ON broadcasts USING btree (medium_id);



CREATE INDEX index_broadcasts_on_schedule_id ON broadcasts USING btree (schedule_id);



CREATE UNIQUE INDEX index_broadcasts_on_title ON broadcasts USING btree (title);



CREATE INDEX index_broadcasts_on_topic_id ON broadcasts USING btree (topic_id);


SET search_path = public, pg_catalog;


CREATE TRIGGER chronomodel_delete INSTEAD OF DELETE ON broadcasts FOR EACH ROW EXECUTE PROCEDURE chronomodel_broadcasts_delete();



CREATE TRIGGER chronomodel_insert INSTEAD OF INSERT ON broadcasts FOR EACH ROW EXECUTE PROCEDURE chronomodel_broadcasts_insert();



CREATE TRIGGER chronomodel_update INSTEAD OF UPDATE ON broadcasts FOR EACH ROW EXECUTE PROCEDURE chronomodel_broadcasts_update();



ALTER TABLE ONLY stations
    ADD CONSTRAINT fk_rails_749eb07017 FOREIGN KEY (medium_id) REFERENCES media(id);



ALTER TABLE ONLY impressions
    ADD CONSTRAINT fk_rails_a56f328f61 FOREIGN KEY (broadcast_id) REFERENCES temporal.broadcasts(id);



ALTER TABLE ONLY impressions
    ADD CONSTRAINT fk_rails_da7bcadf25 FOREIGN KEY (user_id) REFERENCES users(id);


SET search_path = temporal, pg_catalog;


ALTER TABLE ONLY broadcasts
    ADD CONSTRAINT fk_rails_37250dc78c FOREIGN KEY (topic_id) REFERENCES public.topics(id);



ALTER TABLE ONLY broadcasts
    ADD CONSTRAINT fk_rails_9eec935c8b FOREIGN KEY (schedule_id) REFERENCES public.schedules(id);



ALTER TABLE ONLY broadcasts
    ADD CONSTRAINT fk_rails_a45e306ec3 FOREIGN KEY (creator_id) REFERENCES public.users(id);



ALTER TABLE ONLY broadcasts
    ADD CONSTRAINT fk_rails_c39629e750 FOREIGN KEY (medium_id) REFERENCES public.media(id);



ALTER TABLE ONLY broadcasts
    ADD CONSTRAINT fk_rails_eee7654a34 FOREIGN KEY (format_id) REFERENCES public.formats(id);



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
('20171015210454'),
('20171015210622');

