--
-- PostgreSQL database dump
--

\restrict z7wL4fpf4Y8Put2VvKBgHRxVJS2MwOppyXF7Xb6UKVtaLWZTwpMnZx3wYtTwubf

-- Dumped from database version 17.1 (Debian 17.1-1.pgdg120+1)
-- Dumped by pg_dump version 17.9

-- Started on 2026-04-13 16:05:25 UTC

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 4 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: pg_database_owner
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO pg_database_owner;

--
-- TOC entry 3451 (class 0 OID 0)
-- Dependencies: 4
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: pg_database_owner
--

COMMENT ON SCHEMA public IS 'standard public schema';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 217 (class 1259 OID 16385)
-- Name: customer; Type: TABLE; Schema: public; Owner: MyUser
--

CREATE TABLE public.customer (
    customer_id integer NOT NULL,
    first_name character varying(50) NOT NULL,
    last_name character varying(50) NOT NULL,
    phone character varying(15) NOT NULL,
    email character varying(100) NOT NULL,
    created_at date NOT NULL,
    is_active integer DEFAULT 1,
    CONSTRAINT customer_email_check CHECK (((email)::text ~~ '%_@_%.__%'::text)),
    CONSTRAINT customer_is_active_check CHECK ((is_active = ANY (ARRAY[0, 1]))),
    CONSTRAINT customer_phone_check CHECK ((length((phone)::text) >= 7))
);


ALTER TABLE public.customer OWNER TO "MyUser";

--
-- TOC entry 221 (class 1259 OID 16438)
-- Name: feedback; Type: TABLE; Schema: public; Owner: MyUser
--

CREATE TABLE public.feedback (
    feedback_id integer NOT NULL,
    rating integer NOT NULL,
    comment character varying(500),
    feedback_date date NOT NULL,
    reservation_id integer NOT NULL,
    CONSTRAINT feedback_rating_check CHECK (((rating >= 1) AND (rating <= 5)))
);


ALTER TABLE public.feedback OWNER TO "MyUser";

--
-- TOC entry 223 (class 1259 OID 16460)
-- Name: loyalty; Type: TABLE; Schema: public; Owner: MyUser
--

CREATE TABLE public.loyalty (
    loyalty_id integer NOT NULL,
    points integer NOT NULL,
    last_updated date NOT NULL,
    customer_id integer NOT NULL,
    tier_id integer NOT NULL,
    CONSTRAINT loyalty_points_check CHECK ((points >= 0))
);


ALTER TABLE public.loyalty OWNER TO "MyUser";

--
-- TOC entry 222 (class 1259 OID 16453)
-- Name: loyalty_tier; Type: TABLE; Schema: public; Owner: MyUser
--

CREATE TABLE public.loyalty_tier (
    tier_id integer NOT NULL,
    level character varying(50) NOT NULL
);


ALTER TABLE public.loyalty_tier OWNER TO "MyUser";

--
-- TOC entry 225 (class 1259 OID 16485)
-- Name: loyalty_transaction; Type: TABLE; Schema: public; Owner: MyUser
--

CREATE TABLE public.loyalty_transaction (
    transaction_id integer NOT NULL,
    points_change integer NOT NULL,
    created_at date NOT NULL,
    loyalty_id integer NOT NULL,
    reason_id integer NOT NULL,
    CONSTRAINT loyalty_transaction_points_change_check CHECK ((points_change <> 0))
);


ALTER TABLE public.loyalty_transaction OWNER TO "MyUser";

--
-- TOC entry 224 (class 1259 OID 16478)
-- Name: reason; Type: TABLE; Schema: public; Owner: MyUser
--

CREATE TABLE public.reason (
    reason_id integer NOT NULL,
    description character varying(100) NOT NULL
);


ALTER TABLE public.reason OWNER TO "MyUser";

--
-- TOC entry 219 (class 1259 OID 16405)
-- Name: reservation; Type: TABLE; Schema: public; Owner: MyUser
--

CREATE TABLE public.reservation (
    reservation_id integer NOT NULL,
    datetime date NOT NULL,
    party_size integer NOT NULL,
    special_requests character varying(255),
    created_at date NOT NULL,
    customer_id integer NOT NULL,
    status_id integer NOT NULL,
    CONSTRAINT reservation_party_size_check CHECK (((party_size > 0) AND (party_size <= 20)))
);


ALTER TABLE public.reservation OWNER TO "MyUser";

--
-- TOC entry 218 (class 1259 OID 16398)
-- Name: status_type; Type: TABLE; Schema: public; Owner: MyUser
--

CREATE TABLE public.status_type (
    status_id integer NOT NULL,
    description character varying(50) NOT NULL
);


ALTER TABLE public.status_type OWNER TO "MyUser";

--
-- TOC entry 220 (class 1259 OID 16421)
-- Name: waitlist; Type: TABLE; Schema: public; Owner: MyUser
--

CREATE TABLE public.waitlist (
    waitlist_id integer NOT NULL,
    party_size integer NOT NULL,
    request_time date NOT NULL,
    est_wait_time integer NOT NULL,
    customer_id integer NOT NULL,
    status_id integer NOT NULL,
    CONSTRAINT waitlist_est_wait_time_check CHECK (((est_wait_time >= 0) AND (est_wait_time <= 300))),
    CONSTRAINT waitlist_party_size_check CHECK (((party_size > 0) AND (party_size <= 20)))
);


ALTER TABLE public.waitlist OWNER TO "MyUser";

--
-- TOC entry 3437 (class 0 OID 16385)
-- Dependencies: 217
-- Data for Name: customer; Type: TABLE DATA; Schema: public; Owner: MyUser
--

INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (1, 'Forrest', 'Greatbach', '0519950275', 'fgreatbach0@freewebs.com', '2024-03-23', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (2, 'Aleksandr', 'Ring', '0569637693', 'aring1@vistaprint.com', '2025-12-22', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (3, 'Fallon', 'Stabbins', '0527205866', 'fstabbins2@chicagotribune.com', '2022-09-21', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (4, 'Allx', 'Yakushkev', '0594462014', 'ayakushkev3@yolasite.com', '2022-08-29', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (5, 'Welsh', 'Phillpotts', '0548784763', 'wphillpotts4@ustream.tv', '2023-07-11', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (6, 'Konstance', 'Buxsey', '0594609454', 'kbuxsey5@gmpg.org', '2025-11-26', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (7, 'Jerrilyn', 'Uccelli', '0521595332', 'juccelli6@bravesites.com', '2025-03-24', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (8, 'Ilene', 'Raincin', '0562739635', 'iraincin7@prweb.com', '2022-02-11', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (9, 'Phylys', 'Jamieson', '0534175230', 'pjamieson8@wp.com', '2024-01-13', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (10, 'Erl', 'Berth', '0573976638', 'eberth9@globo.com', '2025-03-14', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (11, 'Ralph', 'Zimmermeister', '0521510631', 'rzimmermeistera@freewebs.com', '2022-01-01', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (12, 'Gilligan', 'Housen', '0544219379', 'ghousenb@lycos.com', '2023-08-19', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (13, 'Margi', 'Pervew', '0554177541', 'mpervewc@example.com', '2023-04-18', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (14, 'Sashenka', 'Peart', '0597145825', 'speartd@sbwire.com', '2022-01-07', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (15, 'Adaline', 'De Pero', '0500266623', 'adeperoe@constantcontact.com', '2022-04-06', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (16, 'Launce', 'Sauniere', '0576099688', 'lsaunieref@newsvine.com', '2024-11-13', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (17, 'Sollie', 'Cambridge', '0518738300', 'scambridgeg@taobao.com', '2024-06-08', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (18, 'Hortense', 'Lindwasser', '0510580280', 'hlindwasserh@google.ru', '2025-07-11', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (19, 'Meridith', 'Matterson', '0548976800', 'mmattersoni@nationalgeographic.com', '2024-06-08', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (20, 'Ashton', 'Tillot', '0532653192', 'atillotj@sitemeter.com', '2023-11-04', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (21, 'Sig', 'Castard', '0546451029', 'scastardk@wsj.com', '2023-05-20', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (22, 'Rodger', 'Tansley', '0536371384', 'rtansleyl@surveymonkey.com', '2023-03-02', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (23, 'Isa', 'Dutson', '0527961286', 'idutsonm@cam.ac.uk', '2024-10-20', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (24, 'Florella', 'Vankeev', '0508152734', 'fvankeevn@google.com', '2022-12-12', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (25, 'Nanette', 'Meecher', '0550970486', 'nmeechero@psu.edu', '2023-07-30', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (26, 'Maximilian', 'Henner', '0564390333', 'mhennerp@last.fm', '2023-01-02', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (27, 'Cate', 'Radolf', '0562536169', 'cradolfq@princeton.edu', '2023-10-27', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (28, 'Sidnee', 'Orknay', '0579865384', 'sorknayr@cornell.edu', '2024-03-26', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (29, 'Amelia', 'Pringle', '0506530434', 'apringles@furl.net', '2024-08-12', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (30, 'Caresa', 'Rase', '0515744581', 'craset@prweb.com', '2024-05-26', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (31, 'Bartlet', 'Gammidge', '0585567462', 'bgammidgeu@virginia.edu', '2024-10-04', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (32, 'Monty', 'Nelthorp', '0516613046', 'mnelthorpv@google.nl', '2023-06-27', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (33, 'Velvet', 'Blench', '0557487614', 'vblenchw@jigsy.com', '2025-07-05', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (34, 'Jeremias', 'Stainbridge', '0589784095', 'jstainbridgex@naver.com', '2023-09-13', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (35, 'Jackquelin', 'Gulliman', '0588076028', 'jgullimany@mayoclinic.com', '2025-08-26', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (36, 'Stanly', 'Fudge', '0518197988', 'sfudgez@artisteer.com', '2024-08-16', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (37, 'Cesya', 'Di Nisco', '0538177976', 'cdinisco10@odnoklassniki.ru', '2024-02-23', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (38, 'Alic', 'Insley', '0513344402', 'ainsley11@gov.uk', '2023-05-20', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (39, 'Derril', 'Shorton', '0551224584', 'dshorton12@e-recht24.de', '2025-07-04', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (40, 'Niccolo', 'Silverston', '0514289840', 'nsilverston13@pbs.org', '2023-02-11', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (41, 'Timi', 'Milthorpe', '0577167962', 'tmilthorpe14@g.co', '2025-05-24', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (42, 'Nataniel', 'Vreede', '0581987234', 'nvreede15@ibm.com', '2025-08-27', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (43, 'Alberto', 'Jonuzi', '0524236524', 'ajonuzi16@ibm.com', '2024-05-19', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (44, 'Worden', 'Keming', '0593099011', 'wkeming17@zdnet.com', '2024-02-25', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (45, 'Joey', 'Lelliott', '0564677123', 'jlelliott18@rediff.com', '2023-09-24', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (46, 'Bernardine', 'Setterthwait', '0592128712', 'bsetterthwait19@w3.org', '2023-08-30', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (47, 'Suzette', 'Gregore', '0522228426', 'sgregore1a@lulu.com', '2023-02-28', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (48, 'Merwin', 'Chatters', '0522312662', 'mchatters1b@cbc.ca', '2023-11-06', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (49, 'Oralle', 'Sylvester', '0509189357', 'osylvester1c@51.la', '2025-01-22', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (50, 'Juditha', 'Awdry', '0559564852', 'jawdry1d@hubpages.com', '2024-11-05', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (51, 'Alberta', 'Carnier', '0594220525', 'acarnier1e@vk.com', '2022-03-17', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (52, 'Elliott', 'Gymblett', '0547107690', 'egymblett1f@feedburner.com', '2022-03-29', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (53, 'Curcio', 'Brewers', '0575395691', 'cbrewers1g@nature.com', '2024-02-21', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (54, 'George', 'Mossom', '0504753221', 'gmossom1h@vistaprint.com', '2022-04-24', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (55, 'Talbot', 'Deaville', '0540104896', 'tdeaville1i@dailymail.co.uk', '2022-08-02', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (56, 'Randa', 'Linnitt', '0549484553', 'rlinnitt1j@clickbank.net', '2022-08-23', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (57, 'Magdalen', 'Luca', '0520001997', 'mluca1k@ocn.ne.jp', '2023-04-13', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (58, 'Reinaldo', 'Hazlegrove', '0564430219', 'rhazlegrove1l@nymag.com', '2024-10-09', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (59, 'Austin', 'Tebbe', '0598624890', 'atebbe1m@vkontakte.ru', '2022-04-22', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (60, 'Jewelle', 'Bonder', '0526150805', 'jbonder1n@google.com', '2025-03-15', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (61, 'Mei', 'Clashe', '0546351435', 'mclashe1o@economist.com', '2023-04-05', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (62, 'Peterus', 'Elizabeth', '0596565362', 'pelizabeth1p@wufoo.com', '2023-11-08', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (63, 'Seana', 'Yaakov', '0532560368', 'syaakov1q@statcounter.com', '2022-02-02', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (64, 'Marley', 'Seleway', '0551127150', 'mseleway1r@linkedin.com', '2025-11-28', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (65, 'Cheri', 'MacQueen', '0516100596', 'cmacqueen1s@army.mil', '2023-01-23', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (66, 'Netta', 'Boyington', '0583509417', 'nboyington1t@bigcartel.com', '2023-11-06', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (67, 'Karleen', 'Denekamp', '0598381943', 'kdenekamp1u@over-blog.com', '2024-08-01', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (68, 'Wadsworth', 'Elfleet', '0531960003', 'welfleet1v@yellowbook.com', '2025-03-06', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (69, 'Coraline', 'Degenhardt', '0550315647', 'cdegenhardt1w@imageshack.us', '2022-12-19', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (70, 'Louise', 'Danbrook', '0557251522', 'ldanbrook1x@google.it', '2025-07-12', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (71, 'Harlen', 'Ellaman', '0536386139', 'hellaman1y@hubpages.com', '2023-07-06', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (72, 'Marylinda', 'Sycamore', '0545998494', 'msycamore1z@rakuten.co.jp', '2022-03-03', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (73, 'Roseann', 'Stace', '0546620061', 'rstace20@jigsy.com', '2024-11-15', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (74, 'Huey', 'Morehall', '0523254478', 'hmorehall21@theguardian.com', '2024-03-03', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (75, 'Rania', 'Edkins', '0592461571', 'redkins22@youku.com', '2025-06-13', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (76, 'Natty', 'Tootell', '0532017301', 'ntootell23@artisteer.com', '2024-10-06', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (77, 'Dani', 'Malinson', '0588005615', 'dmalinson24@jugem.jp', '2025-01-31', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (78, 'Thornie', 'Churchman', '0519486722', 'tchurchman25@fastcompany.com', '2025-11-16', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (79, 'Brice', 'Brunning', '0565913039', 'bbrunning26@alexa.com', '2023-11-25', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (80, 'Ingaborg', 'Nussey', '0550701075', 'inussey27@moonfruit.com', '2022-04-18', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (81, 'Zola', 'Rolingson', '0581414874', 'zrolingson28@dyndns.org', '2024-05-31', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (82, 'Karole', 'Feld', '0514317246', 'kfeld29@harvard.edu', '2022-03-09', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (83, 'Daveta', 'Sinkin', '0576075442', 'dsinkin2a@bandcamp.com', '2025-11-16', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (84, 'Newton', 'Woakes', '0522998378', 'nwoakes2b@youtube.com', '2025-09-01', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (85, 'Maryellen', 'Maseres', '0586193979', 'mmaseres2c@sciencedaily.com', '2023-04-06', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (86, 'Franny', 'Nangle', '0536765660', 'fnangle2d@soundcloud.com', '2025-05-29', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (87, 'Heloise', 'Mauser', '0587450627', 'hmauser2e@wired.com', '2023-02-28', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (88, 'Josepha', 'Pickard', '0581973340', 'jpickard2f@ycombinator.com', '2023-04-20', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (89, 'Sarene', 'Giacovazzo', '0525166342', 'sgiacovazzo2g@scientificamerican.com', '2023-12-15', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (90, 'Verina', 'Monini', '0590640111', 'vmonini2h@pagesperso-orange.fr', '2025-09-27', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (91, 'Gabriello', 'Woodison', '0565258623', 'gwoodison2i@stumbleupon.com', '2022-04-20', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (92, 'Wilhelm', 'Gillyett', '0510815034', 'wgillyett2j@ameblo.jp', '2024-10-13', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (93, 'Margaretta', 'Letts', '0563897474', 'mletts2k@virginia.edu', '2024-09-02', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (94, 'Aharon', 'Maypother', '0543325480', 'amaypother2l@chronoengine.com', '2025-05-02', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (95, 'Catherina', 'Garlicke', '0504088510', 'cgarlicke2m@ifeng.com', '2024-05-20', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (96, 'Cilka', 'Renfield', '0565962583', 'crenfield2n@baidu.com', '2024-02-12', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (97, 'Goldy', 'Van de Vlies', '0539844149', 'gvandevlies2o@ucla.edu', '2025-11-23', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (98, 'Web', 'Flann', '0520507947', 'wflann2p@g.co', '2025-01-19', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (99, 'Avram', 'Ivimey', '0519256077', 'aivimey2q@com.com', '2025-04-15', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (100, 'Nollie', 'Gergely', '0534250686', 'ngergely2r@cargocollective.com', '2023-05-31', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (101, 'Byrle', 'Mc Pake', '0568985827', 'bmcpake2s@github.io', '2025-05-04', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (102, 'Karena', 'Lanfer', '0503837196', 'klanfer2t@oaic.gov.au', '2025-04-13', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (103, 'Johnette', 'Clohissy', '0518550737', 'jclohissy2u@go.com', '2024-06-13', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (104, 'Jedd', 'Vasilyev', '0522360355', 'jvasilyev2v@bandcamp.com', '2024-07-15', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (105, 'Benn', 'Spittall', '0529123919', 'bspittall2w@archive.org', '2024-05-19', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (106, 'Angelica', 'Lewzey', '0566776135', 'alewzey2x@craigslist.org', '2024-01-29', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (107, 'Gretchen', 'Maffioni', '0537845460', 'gmaffioni2y@imdb.com', '2025-11-04', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (108, 'Mathilde', 'Phelips', '0580632463', 'mphelips2z@bizjournals.com', '2022-05-09', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (109, 'Edlin', 'Whiffen', '0578629357', 'ewhiffen30@princeton.edu', '2024-09-10', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (110, 'Damara', 'Affuso', '0505279369', 'daffuso31@oaic.gov.au', '2023-07-18', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (111, 'Maye', 'Canny', '0512984134', 'mcanny32@facebook.com', '2025-11-25', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (112, 'Sawyer', 'O''Mullaney', '0522842130', 'somullaney33@goo.ne.jp', '2023-12-13', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (113, 'Benito', 'Mutlow', '0585534923', 'bmutlow34@cloudflare.com', '2023-01-21', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (114, 'Caressa', 'Ciementini', '0500918779', 'cciementini35@freewebs.com', '2023-09-07', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (115, 'Lucky', 'Inggall', '0511244318', 'linggall36@cdbaby.com', '2025-11-02', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (116, 'Avram', 'Alyoshin', '0575789741', 'aalyoshin37@tiny.cc', '2025-05-16', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (117, 'Kala', 'Cuttell', '0591239766', 'kcuttell38@google.com.au', '2024-10-20', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (118, 'Kaja', 'Ferby', '0572025677', 'kferby39@skype.com', '2025-01-05', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (119, 'Janeva', 'Bending', '0594306001', 'jbending3a@mac.com', '2024-04-26', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (120, 'Godfree', 'Darridon', '0570339018', 'gdarridon3b@instagram.com', '2023-03-22', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (121, 'Umberto', 'Long', '0596712205', 'ulong3c@merriam-webster.com', '2024-08-28', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (122, 'Cal', 'Phetteplace', '0557722376', 'cphetteplace3d@usgs.gov', '2025-10-14', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (123, 'Clem', 'Brunsdon', '0567799287', 'cbrunsdon3e@mapquest.com', '2022-09-22', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (124, 'Miguel', 'Latek', '0550533541', 'mlatek3f@berkeley.edu', '2022-07-05', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (125, 'Kacie', 'Symon', '0564817549', 'ksymon3g@admin.ch', '2024-03-23', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (126, 'Hubey', 'Amis', '0588266459', 'hamis3h@liveinternet.ru', '2022-07-31', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (127, 'Nat', 'Cantrill', '0595069797', 'ncantrill3i@wp.com', '2025-03-29', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (128, 'Elinor', 'Thacker', '0563220084', 'ethacker3j@mediafire.com', '2022-01-28', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (129, 'Natala', 'Gallimore', '0540452833', 'ngallimore3k@wired.com', '2024-08-12', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (130, 'Charmane', 'Bowich', '0587391918', 'cbowich3l@instagram.com', '2023-05-19', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (131, 'Nefen', 'Veronique', '0584464135', 'nveronique3m@china.com.cn', '2024-07-13', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (132, 'Theresina', 'Monkman', '0520030522', 'tmonkman3n@dmoz.org', '2025-05-19', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (133, 'Nester', 'Millichap', '0548257639', 'nmillichap3o@fotki.com', '2025-08-07', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (134, 'Georas', 'Jozefowicz', '0527831921', 'gjozefowicz3p@comcast.net', '2022-09-20', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (135, 'Rickert', 'Tidridge', '0599441991', 'rtidridge3q@live.com', '2023-12-25', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (136, 'Vinnie', 'Absalom', '0512793180', 'vabsalom3r@noaa.gov', '2025-01-21', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (137, 'Conroy', 'Pegden', '0573669825', 'cpegden3s@g.co', '2022-01-16', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (138, 'Ardyce', 'Frensche', '0508378407', 'afrensche3t@wunderground.com', '2024-06-06', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (139, 'Maurie', 'O''Hallagan', '0554984806', 'mohallagan3u@usnews.com', '2022-02-21', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (140, 'Ermina', 'Macauley', '0529811105', 'emacauley3v@nhs.uk', '2025-10-28', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (141, 'Dawna', 'Pomfret', '0509917569', 'dpomfret3w@friendfeed.com', '2024-03-23', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (142, 'Leonore', 'Widdecombe', '0557275842', 'lwiddecombe3x@dailymail.co.uk', '2022-12-06', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (143, 'Gusty', 'Barrasse', '0594964460', 'gbarrasse3y@intel.com', '2024-10-28', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (144, 'Lorens', 'Onions', '0573046748', 'lonions3z@mayoclinic.com', '2025-04-25', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (145, 'Robinet', 'Rosa', '0503984476', 'rrosa40@ameblo.jp', '2022-11-26', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (146, 'Paten', 'Cass', '0550012339', 'pcass41@163.com', '2023-02-28', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (147, 'Johnath', 'Harse', '0522843649', 'jharse42@flavors.me', '2023-10-25', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (148, 'Niels', 'Ivanin', '0509601351', 'nivanin43@bluehost.com', '2023-02-28', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (149, 'Buddie', 'Bayston', '0509773468', 'bbayston44@phoca.cz', '2024-06-02', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (150, 'Sigismund', 'Cassella', '0570937929', 'scassella45@google.ca', '2024-03-21', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (151, 'Spencer', 'Ruffy', '0514139436', 'sruffy46@omniture.com', '2022-02-02', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (152, 'Beverlie', 'Southerton', '0578873763', 'bsoutherton47@cbsnews.com', '2023-07-10', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (153, 'Barthel', 'Rowan', '0531556972', 'browan48@cafepress.com', '2024-12-16', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (154, 'Karna', 'Vernazza', '0566925028', 'kvernazza49@cbsnews.com', '2025-11-02', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (155, 'Aretha', 'Murdy', '0578146730', 'amurdy4a@unc.edu', '2024-11-12', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (156, 'Edgar', 'Dullard', '0522845282', 'edullard4b@discovery.com', '2024-09-24', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (157, 'Carlyle', 'McLleese', '0528443275', 'cmclleese4c@apple.com', '2025-07-11', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (158, 'Gerick', 'Iori', '0502616449', 'giori4d@microsoft.com', '2022-01-21', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (159, 'Pansy', 'Highnam', '0590036545', 'phighnam4e@blogspot.com', '2022-10-30', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (160, 'Dugald', 'Yardy', '0552375388', 'dyardy4f@aol.com', '2024-05-03', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (161, 'Ewart', 'Seif', '0591565404', 'eseif4g@topsy.com', '2022-08-22', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (162, 'Terri', 'Colenutt', '0507045312', 'tcolenutt4h@woothemes.com', '2024-06-15', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (163, 'Noni', 'O''Fihillie', '0508100838', 'nofihillie4i@merriam-webster.com', '2023-12-15', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (164, 'Yul', 'Tong', '0507404973', 'ytong4j@wp.com', '2024-05-14', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (165, 'Maryl', 'Keddie', '0544534100', 'mkeddie4k@wikimedia.org', '2024-12-31', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (166, 'Maurice', 'Hallut', '0540744763', 'mhallut4l@com.com', '2024-12-19', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (167, 'Clio', 'Sagg', '0543652809', 'csagg4m@webs.com', '2022-11-17', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (168, 'Kean', 'Sibille', '0505504651', 'ksibille4n@springer.com', '2022-05-10', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (169, 'Durant', 'Ashmole', '0528115222', 'dashmole4o@spiegel.de', '2024-07-06', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (170, 'Lynsey', 'Seggie', '0527905738', 'lseggie4p@google.it', '2025-05-05', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (171, 'Mario', 'Biskup', '0507442612', 'mbiskup4q@tiny.cc', '2022-10-04', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (172, 'Alia', 'McBain', '0521923539', 'amcbain4r@vistaprint.com', '2024-06-10', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (173, 'Francklyn', 'Colwill', '0520435543', 'fcolwill4s@buzzfeed.com', '2023-05-09', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (174, 'Ansel', 'Good', '0535354722', 'agood4t@jugem.jp', '2022-07-01', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (175, 'Quinn', 'Izhak', '0573983594', 'qizhak4u@ning.com', '2024-10-02', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (176, 'Freddie', 'Fuke', '0587774510', 'ffuke4v@upenn.edu', '2023-05-29', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (177, 'Cullan', 'Piller', '0563625162', 'cpiller4w@marriott.com', '2025-03-06', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (178, 'Amy', 'Chucks', '0512778348', 'achucks4x@ask.com', '2025-07-06', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (179, 'Fredelia', 'Scedall', '0523516495', 'fscedall4y@google.cn', '2024-10-02', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (180, 'Pietra', 'Darco', '0587684911', 'pdarco4z@wsj.com', '2022-01-14', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (181, 'Kerry', 'Sneezem', '0570926264', 'ksneezem50@ebay.co.uk', '2025-05-18', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (182, 'Randi', 'Blaycock', '0574895551', 'rblaycock51@exblog.jp', '2024-11-16', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (183, 'Lonee', 'Weiser', '0513352503', 'lweiser52@cnet.com', '2022-03-28', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (184, 'Burnaby', 'Tiffin', '0588817031', 'btiffin53@cdc.gov', '2024-07-28', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (185, 'Willa', 'McMahon', '0507233746', 'wmcmahon54@berkeley.edu', '2022-04-23', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (186, 'Collin', 'Keddie', '0581476865', 'ckeddie55@washington.edu', '2025-03-04', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (187, 'Yvor', 'Laugharne', '0523287082', 'ylaugharne56@yahoo.co.jp', '2022-06-25', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (188, 'Elvin', 'Nend', '0540224422', 'enend57@behance.net', '2025-03-12', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (189, 'Winslow', 'Dumblton', '0542166597', 'wdumblton58@gov.uk', '2024-04-09', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (190, 'Elaina', 'Feetham', '0575707443', 'efeetham59@dell.com', '2024-04-20', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (191, 'Ulrica', 'Pollak', '0538547992', 'upollak5a@cafepress.com', '2022-08-15', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (192, 'Lanita', 'Tirrell', '0528560265', 'ltirrell5b@liveinternet.ru', '2023-08-11', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (193, 'Currey', 'Stafford', '0507429037', 'cstafford5c@zimbio.com', '2023-01-30', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (194, 'Selene', 'Annable', '0553322298', 'sannable5d@altervista.org', '2022-11-21', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (195, 'Judas', 'Tomaszynski', '0574360694', 'jtomaszynski5e@sun.com', '2023-06-10', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (196, 'Isabelle', 'Verriour', '0588534325', 'iverriour5f@buzzfeed.com', '2022-09-24', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (197, 'Edi', 'Matton', '0540311802', 'ematton5g@liveinternet.ru', '2022-08-18', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (198, 'Brianna', 'Hadenton', '0580921513', 'bhadenton5h@ox.ac.uk', '2024-11-10', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (199, 'Ronica', 'Kippling', '0512975634', 'rkippling5i@cdbaby.com', '2023-09-19', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (200, 'Marianne', 'Gallyon', '0553371163', 'mgallyon5j@eepurl.com', '2025-06-04', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (201, 'Jane', 'Realy', '0596560102', 'jrealy5k@symantec.com', '2023-03-08', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (202, 'Val', 'Maddison', '0569546504', 'vmaddison5l@studiopress.com', '2022-12-15', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (203, 'Rey', 'Itzkovwitch', '0527239197', 'ritzkovwitch5m@businesswire.com', '2025-07-01', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (204, 'Ivette', 'Jopling', '0538328621', 'ijopling5n@google.cn', '2025-11-16', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (205, 'Jemmy', 'Hedderly', '0571780435', 'jhedderly5o@tripod.com', '2023-07-13', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (206, 'Fritz', 'Tudgay', '0535386000', 'ftudgay5p@unc.edu', '2022-01-16', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (207, 'Joleen', 'Sheilds', '0566466405', 'jsheilds5q@google.de', '2023-12-10', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (208, 'Newton', 'Insko', '0552889792', 'ninsko5r@youtube.com', '2023-06-08', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (209, 'Eyde', 'Burrage', '0552722726', 'eburrage5s@economist.com', '2022-03-17', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (210, 'Allix', 'Packer', '0502558891', 'apacker5t@hostgator.com', '2023-06-09', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (211, 'Dotti', 'Surby', '0524259741', 'dsurby5u@wordpress.org', '2023-11-25', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (212, 'Ola', 'Simak', '0595764278', 'osimak5v@mashable.com', '2024-03-01', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (213, 'Falito', 'Courvert', '0501782914', 'fcourvert5w@unc.edu', '2025-07-13', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (214, 'Corie', 'Tween', '0531493621', 'ctween5x@unicef.org', '2023-05-25', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (215, 'Elva', 'Berdale', '0564094821', 'eberdale5y@tumblr.com', '2023-08-07', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (216, 'Royall', 'Dominik', '0528169087', 'rdominik5z@meetup.com', '2025-01-20', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (217, 'Gardner', 'De Lasci', '0518112090', 'gdelasci60@nps.gov', '2025-10-29', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (218, 'Baily', 'Cockshott', '0598049749', 'bcockshott61@example.com', '2024-03-16', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (219, 'Harmonie', 'Dunkley', '0545641376', 'hdunkley62@cafepress.com', '2025-03-26', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (220, 'Livvy', 'Ganforth', '0597503925', 'lganforth63@deliciousdays.com', '2025-01-26', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (221, 'Gannon', 'Norrey', '0579252102', 'gnorrey64@illinois.edu', '2022-09-17', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (222, 'Marlane', 'Arlett', '0502809390', 'marlett65@prnewswire.com', '2024-04-23', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (223, 'Hamish', 'Larrett', '0518022893', 'hlarrett66@slashdot.org', '2022-07-27', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (224, 'Nisse', 'Ceaser', '0507766171', 'nceaser67@mayoclinic.com', '2022-09-01', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (225, 'Alastair', 'Rubinovici', '0586042743', 'arubinovici68@miitbeian.gov.cn', '2023-05-16', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (226, 'Myrilla', 'Kacheler', '0569917145', 'mkacheler69@linkedin.com', '2024-07-04', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (227, 'Dale', 'Aguirrezabala', '0589500953', 'daguirrezabala6a@purevolume.com', '2023-09-01', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (228, 'Mellie', 'Greatrex', '0571512199', 'mgreatrex6b@blog.com', '2022-11-08', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (229, 'Korrie', 'Liddyard', '0528745648', 'kliddyard6c@bravesites.com', '2025-11-09', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (230, 'Phyllis', 'Enever', '0555997765', 'penever6d@prnewswire.com', '2025-12-22', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (231, 'Baxy', 'Donoghue', '0589486782', 'bdonoghue6e@examiner.com', '2022-11-14', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (232, 'Link', 'Rilings', '0509049190', 'lrilings6f@cargocollective.com', '2022-02-23', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (233, 'Clemens', 'Elcott', '0521491189', 'celcott6g@pcworld.com', '2022-09-02', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (234, 'Sherill', 'Lusty', '0563487282', 'slusty6h@posterous.com', '2023-08-28', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (235, 'Caryl', 'Harris', '0578502846', 'charris6i@bloglines.com', '2022-02-01', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (236, 'Ursala', 'Bramelt', '0585441033', 'ubramelt6j@walmart.com', '2023-10-22', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (237, 'Amargo', 'McMichell', '0541431899', 'amcmichell6k@bizjournals.com', '2023-10-06', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (238, 'Felic', 'Pywell', '0548624317', 'fpywell6l@moonfruit.com', '2023-04-23', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (239, 'Darell', 'De Michetti', '0574076217', 'ddemichetti6m@friendfeed.com', '2025-07-24', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (240, 'Thornton', 'McMoyer', '0502658767', 'tmcmoyer6n@netvibes.com', '2025-01-06', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (241, 'Margy', 'Cowles', '0556672058', 'mcowles6o@cornell.edu', '2025-01-27', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (242, 'Margeaux', 'Cusworth', '0540336516', 'mcusworth6p@hugedomains.com', '2022-04-15', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (243, 'Thatch', 'Voas', '0501120489', 'tvoas6q@dailymotion.com', '2024-08-29', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (244, 'Karlen', 'Weekes', '0532945734', 'kweekes6r@umn.edu', '2022-04-08', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (245, 'Chase', 'Yakovliv', '0509466978', 'cyakovliv6s@telegraph.co.uk', '2025-05-24', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (246, 'Mindy', 'Snarie', '0533461236', 'msnarie6t@tinypic.com', '2024-08-17', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (247, 'Hiram', 'McClymond', '0547403339', 'hmcclymond6u@wikipedia.org', '2023-03-14', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (248, 'Giffer', 'Caple', '0575400938', 'gcaple6v@whitehouse.gov', '2024-07-03', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (249, 'Judas', 'Brand-Hardy', '0569287910', 'jbrandhardy6w@whitehouse.gov', '2022-11-16', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (250, 'Kari', 'Galilee', '0531118088', 'kgalilee6x@utexas.edu', '2025-12-21', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (251, 'Amory', 'Revie', '0528629796', 'arevie6y@latimes.com', '2024-09-20', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (252, 'Audrye', 'Crinkley', '0501011134', 'acrinkley6z@nasa.gov', '2023-12-28', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (253, 'Papageno', 'Strase', '0539073496', 'pstrase70@uiuc.edu', '2022-08-21', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (254, 'Isiahi', 'Chretien', '0554180793', 'ichretien71@state.tx.us', '2022-01-14', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (255, 'Justino', 'Farreil', '0519481353', 'jfarreil72@miitbeian.gov.cn', '2025-10-27', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (256, 'Berny', 'Babar', '0512388217', 'bbabar73@addthis.com', '2023-12-04', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (257, 'Che', 'Peaden', '0587058153', 'cpeaden74@sourceforge.net', '2025-01-06', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (258, 'Pooh', 'Leat', '0530422192', 'pleat75@moonfruit.com', '2025-07-27', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (259, 'Eliot', 'Yuille', '0547208848', 'eyuille76@ow.ly', '2022-01-15', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (260, 'Marita', 'Dorracott', '0501410212', 'mdorracott77@stumbleupon.com', '2024-07-10', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (261, 'Kylie', 'Grodden', '0530872802', 'kgrodden78@ning.com', '2024-09-15', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (262, 'Carmelina', 'McEvoy', '0558140244', 'cmcevoy79@360.cn', '2023-03-11', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (263, 'Osborn', 'Dowley', '0572954557', 'odowley7a@princeton.edu', '2025-04-21', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (264, 'Alethea', 'Treacher', '0568118351', 'atreacher7b@multiply.com', '2023-04-11', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (265, 'Lamont', 'Couthard', '0536237710', 'lcouthard7c@desdev.cn', '2025-05-29', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (266, 'Aylmer', 'Krolman', '0508566824', 'akrolman7d@techcrunch.com', '2025-10-04', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (267, 'Starr', 'Hentze', '0521214352', 'shentze7e@japanpost.jp', '2023-02-02', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (268, 'Priscella', 'Elderkin', '0527895625', 'pelderkin7f@boston.com', '2025-09-09', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (269, 'Marillin', 'Midner', '0501419420', 'mmidner7g@bigcartel.com', '2023-11-08', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (270, 'Carla', 'Lideard', '0503839909', 'clideard7h@pcworld.com', '2025-11-24', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (271, 'Jobyna', 'Center', '0537314554', 'jcenter7i@umn.edu', '2025-09-09', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (272, 'Emelda', 'Napoli', '0579684256', 'enapoli7j@reuters.com', '2025-11-28', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (273, 'Reeba', 'Pilsworth', '0599190568', 'rpilsworth7k@scientificamerican.com', '2022-04-10', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (274, 'Maxy', 'Bim', '0533117940', 'mbim7l@gmpg.org', '2023-03-24', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (275, 'Reginald', 'Tafani', '0510122066', 'rtafani7m@geocities.jp', '2024-07-29', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (276, 'Hope', 'Lewsie', '0593483488', 'hlewsie7n@engadget.com', '2025-08-16', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (277, 'Aileen', 'Noad', '0537670368', 'anoad7o@example.com', '2023-08-03', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (278, 'Lanie', 'Dufaire', '0549266105', 'ldufaire7p@vk.com', '2024-08-31', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (279, 'Bridgette', 'Giacoboni', '0596149852', 'bgiacoboni7q@bbb.org', '2023-06-23', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (280, 'Bertie', 'Mounfield', '0590770787', 'bmounfield7r@ustream.tv', '2022-08-06', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (281, 'Chaddy', 'Rosewell', '0527664872', 'crosewell7s@barnesandnoble.com', '2025-01-17', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (282, 'Bev', 'Handrik', '0558088620', 'bhandrik7t@blogger.com', '2022-06-17', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (283, 'Alejandro', 'Maseyk', '0592092177', 'amaseyk7u@cornell.edu', '2022-02-25', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (284, 'Skippie', 'Forestall', '0579463295', 'sforestall7v@berkeley.edu', '2025-11-04', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (285, 'Cassie', 'Loughman', '0511338020', 'cloughman7w@booking.com', '2024-08-25', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (286, 'Zaneta', 'Belli', '0525464052', 'zbelli7x@hhs.gov', '2024-02-29', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (287, 'Carly', 'Cafe', '0533717116', 'ccafe7y@bing.com', '2025-12-10', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (288, 'Ninette', 'Allmen', '0507426288', 'nallmen7z@phoca.cz', '2022-08-23', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (289, 'Bree', 'Toth', '0517407488', 'btoth80@accuweather.com', '2023-10-01', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (290, 'Kienan', 'Nairns', '0525997993', 'knairns81@comcast.net', '2025-08-21', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (291, 'Darryl', 'Oury', '0548784951', 'doury82@mac.com', '2025-04-09', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (292, 'Joel', 'Eisikovitsh', '0500901389', 'jeisikovitsh83@php.net', '2025-01-20', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (293, 'Crawford', 'Morrell', '0591232760', 'cmorrell84@myspace.com', '2025-12-21', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (294, 'Milty', 'Molohan', '0558859163', 'mmolohan85@plala.or.jp', '2025-10-15', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (295, 'Goldina', 'Santo', '0506501945', 'gsanto86@ucsd.edu', '2025-02-17', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (296, 'Krishnah', 'Prene', '0588186051', 'kprene87@vk.com', '2022-08-22', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (297, 'Cherie', 'Honniebal', '0501924125', 'chonniebal88@go.com', '2022-01-17', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (298, 'Paulo', 'Paradis', '0552329234', 'pparadis89@senate.gov', '2025-03-10', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (299, 'Shepard', 'Auty', '0511538351', 'sauty8a@chron.com', '2025-12-23', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (300, 'Homere', 'Ends', '0554893056', 'hends8b@bbb.org', '2024-03-29', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (301, 'Hew', 'Breydin', '0512548896', 'hbreydin8c@squidoo.com', '2022-04-26', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (302, 'Lily', 'MacMorland', '0545149017', 'lmacmorland8d@umich.edu', '2023-08-19', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (303, 'Alaine', 'Cowderoy', '0597947432', 'acowderoy8e@yelp.com', '2023-07-16', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (304, 'Dari', 'Shambrooke', '0552929257', 'dshambrooke8f@imgur.com', '2024-01-29', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (305, 'Bowie', 'Menicomb', '0523256770', 'bmenicomb8g@blogs.com', '2024-06-02', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (306, 'Siusan', 'Pignon', '0596694720', 'spignon8h@ucla.edu', '2023-11-07', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (307, 'Lishe', 'Waleran', '0571914314', 'lwaleran8i@opensource.org', '2023-02-28', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (308, 'Doro', 'Gehring', '0548765305', 'dgehring8j@tripod.com', '2025-02-07', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (309, 'Annamarie', 'McCullen', '0511331631', 'amccullen8k@altervista.org', '2025-07-24', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (310, 'Luz', 'Bresson', '0521004477', 'lbresson8l@miitbeian.gov.cn', '2025-10-11', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (311, 'Cordey', 'Monson', '0562682267', 'cmonson8m@biblegateway.com', '2022-08-30', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (312, 'Hildagarde', 'Sanpher', '0517075567', 'hsanpher8n@economist.com', '2023-04-15', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (313, 'Corrine', 'Bescoby', '0591048954', 'cbescoby8o@tuttocitta.it', '2025-12-14', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (314, 'Carolann', 'Callow', '0576986700', 'ccallow8p@house.gov', '2024-10-04', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (315, 'Camey', 'Harken', '0527897254', 'charken8q@bigcartel.com', '2023-01-26', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (316, 'Ulrike', 'Upfold', '0583641397', 'uupfold8r@yolasite.com', '2024-10-06', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (317, 'Renato', 'Matyas', '0580838746', 'rmatyas8s@comsenz.com', '2024-02-19', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (318, 'Fanchette', 'Howitt', '0502823756', 'fhowitt8t@tripod.com', '2024-01-17', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (319, 'Etta', 'Johnes', '0542109326', 'ejohnes8u@altervista.org', '2025-03-06', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (320, 'Gabriel', 'Batha', '0512539048', 'gbatha8v@so-net.ne.jp', '2024-03-04', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (321, 'Corilla', 'Willgress', '0546910280', 'cwillgress8w@cbsnews.com', '2025-12-07', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (322, 'Brana', 'Wysome', '0599008202', 'bwysome8x@joomla.org', '2022-04-15', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (323, 'Stephenie', 'Matiashvili', '0585631555', 'smatiashvili8y@berkeley.edu', '2023-10-10', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (324, 'Ced', 'Presley', '0593853402', 'cpresley8z@slate.com', '2024-01-01', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (325, 'Florencia', 'Fincke', '0518811401', 'ffincke90@harvard.edu', '2023-07-03', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (326, 'Zolly', 'Meni', '0518801469', 'zmeni91@zimbio.com', '2022-10-19', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (327, 'Sergei', 'Pavlishchev', '0560049688', 'spavlishchev92@themeforest.net', '2023-09-18', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (328, 'Maribeth', 'Ciccotto', '0503714521', 'mciccotto93@webeden.co.uk', '2025-12-22', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (329, 'Leupold', 'Piddletown', '0562676921', 'lpiddletown94@quantcast.com', '2022-06-12', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (330, 'Torrin', 'McGeoch', '0584617212', 'tmcgeoch95@harvard.edu', '2022-10-04', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (331, 'Austin', 'Pegler', '0514717317', 'apegler96@odnoklassniki.ru', '2025-12-26', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (332, 'Tani', 'Adlington', '0508931543', 'tadlington97@1und1.de', '2023-12-14', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (333, 'Alli', 'Turle', '0552833862', 'aturle98@home.pl', '2022-12-24', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (334, 'Gussi', 'Batterbee', '0583126550', 'gbatterbee99@salon.com', '2024-10-18', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (335, 'Raven', 'Scones', '0530864362', 'rscones9a@unesco.org', '2023-11-24', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (336, 'Yasmin', 'Mityushin', '0511289476', 'ymityushin9b@google.nl', '2023-02-07', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (337, 'Izabel', 'Grinyov', '0587077991', 'igrinyov9c@seesaa.net', '2023-11-11', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (338, 'Kelila', 'Vanns', '0518199738', 'kvanns9d@usda.gov', '2024-01-29', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (339, 'Joli', 'Slater', '0510318818', 'jslater9e@auda.org.au', '2025-12-26', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (340, 'Corette', 'Vance', '0525436668', 'cvance9f@auda.org.au', '2022-07-25', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (341, 'Jojo', 'Lavallin', '0582439739', 'jlavallin9g@wikispaces.com', '2025-01-24', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (342, 'Kipp', 'Imort', '0569247262', 'kimort9h@indiatimes.com', '2024-01-24', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (343, 'Raddie', 'Menicomb', '0581416060', 'rmenicomb9i@marriott.com', '2022-06-09', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (344, 'Sigismundo', 'Bergeon', '0575675188', 'sbergeon9j@addthis.com', '2022-11-20', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (345, 'Kass', 'Whyler', '0570693087', 'kwhyler9k@nymag.com', '2022-02-21', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (346, 'Reid', 'Mithon', '0501802192', 'rmithon9l@uiuc.edu', '2025-09-17', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (347, 'Ermengarde', 'Cawdell', '0570174274', 'ecawdell9m@guardian.co.uk', '2025-04-07', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (348, 'Clementius', 'Whiteson', '0505471028', 'cwhiteson9n@instagram.com', '2023-10-28', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (349, 'Bram', 'Pragnall', '0535190684', 'bpragnall9o@upenn.edu', '2025-06-22', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (350, 'Carlye', 'Vlasyuk', '0505628096', 'cvlasyuk9p@delicious.com', '2025-03-07', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (351, 'Shanta', 'Stannering', '0584464349', 'sstannering9q@odnoklassniki.ru', '2025-01-04', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (352, 'Daven', 'Nasi', '0512687697', 'dnasi9r@bloglovin.com', '2023-09-09', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (353, 'Freeland', 'Van der Daal', '0575627171', 'fvanderdaal9s@g.co', '2022-02-02', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (354, 'Curtis', 'Faltskog', '0536330462', 'cfaltskog9t@163.com', '2023-01-25', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (355, 'Ambros', 'Shrieve', '0533818516', 'ashrieve9u@storify.com', '2024-10-24', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (356, 'Garey', 'Jurgen', '0587857287', 'gjurgen9v@prlog.org', '2024-02-05', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (357, 'Ward', 'Blamey', '0552088354', 'wblamey9w@nature.com', '2023-12-09', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (358, 'Kirk', 'Cottrell', '0566855087', 'kcottrell9x@blogtalkradio.com', '2025-12-21', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (359, 'Karole', 'Torregiani', '0540084961', 'ktorregiani9y@europa.eu', '2025-06-29', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (360, 'Currie', 'Headley', '0544515440', 'cheadley9z@addthis.com', '2022-01-26', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (361, 'Ali', 'Dawidowicz', '0583725171', 'adawidowicza0@webeden.co.uk', '2025-06-18', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (362, 'Efren', 'Curnnokk', '0595943114', 'ecurnnokka1@answers.com', '2022-05-08', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (363, 'Huntington', 'Gergler', '0507072767', 'hgerglera2@mediafire.com', '2022-08-23', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (364, 'Jodi', 'Dilnot', '0531098288', 'jdilnota3@engadget.com', '2025-01-08', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (365, 'Selie', 'Flecknoe', '0583381187', 'sflecknoea4@tamu.edu', '2023-01-16', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (366, 'Max', 'Lillecrop', '0524703621', 'mlillecropa5@ucla.edu', '2025-05-28', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (367, 'Eberto', 'Rutigliano', '0508156069', 'erutiglianoa6@sina.com.cn', '2022-06-15', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (368, 'Ugo', 'Vowden', '0545999703', 'uvowdena7@myspace.com', '2023-03-13', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (369, 'Avigdor', 'Jiruca', '0577910121', 'ajirucaa8@drupal.org', '2022-05-01', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (370, 'Faye', 'Cowpertwait', '0565577291', 'fcowpertwaita9@multiply.com', '2024-04-23', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (371, 'William', 'Terbeck', '0506830948', 'wterbeckaa@sun.com', '2023-09-22', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (372, 'Llywellyn', 'Kennea', '0534313520', 'lkenneaab@utexas.edu', '2022-01-27', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (373, 'Lonni', 'Samett', '0581295663', 'lsamettac@usnews.com', '2024-06-30', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (374, 'Mariann', 'Tummasutti', '0549962787', 'mtummasuttiad@storify.com', '2024-04-12', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (375, 'Sandy', 'Corbin', '0566518832', 'scorbinae@opensource.org', '2024-04-10', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (376, 'Lorne', 'Merit', '0555597494', 'lmeritaf@msn.com', '2025-05-27', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (377, 'Bert', 'Helstrom', '0502378743', 'bhelstromag@chronoengine.com', '2024-05-30', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (378, 'Teresa', 'Rabbage', '0582262462', 'trabbageah@unc.edu', '2022-05-17', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (379, 'Ellen', 'Trewhela', '0539472146', 'etrewhelaai@businessinsider.com', '2022-07-26', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (380, 'Mead', 'Bury', '0589916219', 'mburyaj@addtoany.com', '2024-10-01', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (381, 'Bryon', 'Haddon', '0508750245', 'bhaddonak@ocn.ne.jp', '2023-05-15', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (382, 'Anya', 'Colicot', '0584989150', 'acolicotal@yahoo.co.jp', '2024-08-06', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (383, 'Ashlie', 'Donovin', '0583941005', 'adonovinam@imgur.com', '2022-04-09', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (384, 'Pris', 'Emmer', '0511986393', 'pemmeran@dell.com', '2025-03-19', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (385, 'Andras', 'Farlowe', '0560833569', 'afarloweao@about.me', '2025-10-09', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (386, 'Kaitlynn', 'Banbury', '0509258558', 'kbanburyap@alexa.com', '2024-02-21', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (387, 'Wini', 'Josephsen', '0509616739', 'wjosephsenaq@cnbc.com', '2022-02-20', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (388, 'Nichols', 'Sinkings', '0563878221', 'nsinkingsar@abc.net.au', '2022-09-27', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (389, 'Priscella', 'Irons', '0549157403', 'pironsas@ning.com', '2022-07-29', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (390, 'Shay', 'Nardoni', '0546741129', 'snardoniat@is.gd', '2024-10-21', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (391, 'Janel', 'Ohrt', '0541710662', 'johrtau@i2i.jp', '2024-05-14', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (392, 'Kitty', 'Wasielewicz', '0576204207', 'kwasielewiczav@npr.org', '2023-10-23', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (393, 'Casey', 'Dorken', '0515343092', 'cdorkenaw@army.mil', '2022-12-06', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (394, 'Sophi', 'Stepney', '0561695085', 'sstepneyax@rakuten.co.jp', '2025-04-15', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (395, 'Inessa', 'Peacher', '0583041998', 'ipeacheray@creativecommons.org', '2024-07-21', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (396, 'Ula', 'Bettam', '0550708961', 'ubettamaz@wisc.edu', '2025-08-12', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (397, 'Ardra', 'Cassley', '0503031494', 'acassleyb0@icio.us', '2022-01-19', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (398, 'Jammal', 'McCuaig', '0570182428', 'jmccuaigb1@shutterfly.com', '2023-09-11', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (399, 'Kyla', 'Aukland', '0596812596', 'kauklandb2@foxnews.com', '2024-05-22', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (400, 'Osmond', 'Siddens', '0556578462', 'osiddensb3@weibo.com', '2025-02-14', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (401, 'Blake', 'Tydeman', '0552739068', 'btydemanb4@google.com.br', '2023-08-18', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (402, 'Jorry', 'Goodier', '0574215876', 'jgoodierb5@google.it', '2025-10-09', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (403, 'Bella', 'Billin', '0529625296', 'bbillinb6@devhub.com', '2025-12-30', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (404, 'Denny', 'Martignoni', '0547818442', 'dmartignonib7@tamu.edu', '2025-05-07', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (405, 'Dallas', 'Rushe', '0589528357', 'drusheb8@virginia.edu', '2023-06-25', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (406, 'Kori', 'Furman', '0502696570', 'kfurmanb9@github.io', '2024-01-13', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (407, 'Samuele', 'Duchatel', '0566930539', 'sduchatelba@dion.ne.jp', '2023-10-18', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (408, 'Ashlee', 'Rankine', '0576346442', 'arankinebb@redcross.org', '2024-09-17', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (409, 'Willey', 'Guntrip', '0583427236', 'wguntripbc@baidu.com', '2024-01-23', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (410, 'Hendrick', 'Carbine', '0598118871', 'hcarbinebd@goodreads.com', '2025-10-01', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (411, 'Christalle', 'O'' Liddy', '0518099236', 'coliddybe@google.com.au', '2023-03-18', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (412, 'Gram', 'Elham', '0521241609', 'gelhambf@prnewswire.com', '2022-03-09', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (413, 'Valentine', 'MacCleod', '0547959603', 'vmaccleodbg@earthlink.net', '2022-11-14', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (414, 'Darleen', 'Clemenzi', '0568241558', 'dclemenzibh@jalbum.net', '2025-01-26', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (415, 'Papagena', 'Praill', '0569046319', 'ppraillbi@loc.gov', '2023-07-30', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (416, 'Garnet', 'Guerner', '0582164786', 'gguernerbj@nih.gov', '2025-10-20', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (417, 'Linet', 'Ullrich', '0570726076', 'lullrichbk@umich.edu', '2022-04-15', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (418, 'Silvanus', 'Rivers', '0569663162', 'sriversbl@hugedomains.com', '2023-02-17', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (419, 'Ophelie', 'Eltone', '0505067149', 'oeltonebm@epa.gov', '2023-11-26', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (420, 'Akim', 'Loftie', '0579462293', 'aloftiebn@topsy.com', '2022-11-22', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (421, 'Addy', 'Champerlen', '0590489029', 'achamperlenbo@cocolog-nifty.com', '2023-06-18', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (422, 'Farand', 'Judkins', '0541293529', 'fjudkinsbp@free.fr', '2022-02-03', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (423, 'June', 'Simcox', '0543813274', 'jsimcoxbq@dyndns.org', '2025-07-12', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (424, 'Stephan', 'Amiss', '0529661330', 'samissbr@umn.edu', '2024-08-29', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (425, 'Valentino', 'Bucklee', '0585449253', 'vbuckleebs@macromedia.com', '2022-05-29', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (426, 'Bob', 'Zorzetti', '0581327018', 'bzorzettibt@odnoklassniki.ru', '2022-02-22', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (427, 'Egor', 'Jenkin', '0599675114', 'ejenkinbu@noaa.gov', '2023-02-09', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (428, 'Chaunce', 'O''dell', '0584296515', 'codellbv@trellian.com', '2025-12-13', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (429, 'Jelene', 'Hurkett', '0541083111', 'jhurkettbw@mashable.com', '2024-11-28', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (430, 'Billye', 'Cabrer', '0515297694', 'bcabrerbx@pcworld.com', '2023-11-12', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (431, 'Jule', 'Looks', '0543236671', 'jlooksby@rakuten.co.jp', '2025-08-02', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (432, 'Glenna', 'Kingswood', '0594479583', 'gkingswoodbz@ovh.net', '2023-07-04', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (433, 'Josselyn', 'Carvilla', '0589384716', 'jcarvillac0@360.cn', '2023-12-04', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (434, 'Karita', 'Yorath', '0589119110', 'kyorathc1@eventbrite.com', '2024-09-21', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (435, 'Binni', 'Dennick', '0589768527', 'bdennickc2@gnu.org', '2023-01-26', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (436, 'Shelba', 'Giacoppo', '0556671943', 'sgiacoppoc3@acquirethisname.com', '2025-08-24', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (437, 'Leigh', 'Springthorp', '0536088300', 'lspringthorpc4@gov.uk', '2025-06-22', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (438, 'Brana', 'Mullarkey', '0586079713', 'bmullarkeyc5@auda.org.au', '2024-09-15', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (439, 'Thorvald', 'Dudden', '0520333028', 'tduddenc6@imdb.com', '2023-06-06', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (440, 'Gracie', 'McCafferty', '0526190253', 'gmccaffertyc7@facebook.com', '2022-12-08', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (441, 'Jay', 'Gwyllt', '0527453537', 'jgwylltc8@flavors.me', '2022-10-24', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (442, 'Kathye', 'Gummow', '0515275963', 'kgummowc9@163.com', '2022-10-15', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (443, 'Maud', 'Calabry', '0513670904', 'mcalabryca@arizona.edu', '2022-01-19', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (444, 'Felizio', 'Potticary', '0574137952', 'fpotticarycb@mozilla.com', '2025-07-22', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (445, 'Ardelle', 'Sheldon', '0578026142', 'asheldoncc@taobao.com', '2023-08-24', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (446, 'Karon', 'Johnsee', '0574387962', 'kjohnseecd@fastcompany.com', '2022-04-20', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (447, 'Barr', 'Tidey', '0562381345', 'btideyce@edublogs.org', '2022-10-27', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (448, 'Delmar', 'Chellam', '0568141128', 'dchellamcf@archive.org', '2025-02-28', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (449, 'Allyce', 'Corr', '0530311087', 'acorrcg@hostgator.com', '2025-07-02', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (450, 'Krissie', 'McPike', '0552365623', 'kmcpikech@soundcloud.com', '2024-02-03', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (451, 'Latrena', 'Andreazzi', '0526740789', 'landreazzici@altervista.org', '2022-07-12', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (452, 'Spike', 'Witsey', '0533552837', 'switseycj@ameblo.jp', '2025-08-14', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (453, 'Teddy', 'Raigatt', '0516923789', 'traigattck@so-net.ne.jp', '2023-08-09', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (454, 'Ase', 'Fellini', '0593773591', 'afellinicl@digg.com', '2023-06-21', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (455, 'Libbie', 'Roby', '0572768782', 'lrobycm@taobao.com', '2022-11-03', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (456, 'Riley', 'Fleury', '0565464057', 'rfleurycn@wordpress.com', '2022-03-25', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (457, 'Evonne', 'Mendonca', '0590272659', 'emendoncaco@ask.com', '2025-05-25', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (458, 'Abel', 'Shemming', '0527653822', 'ashemmingcp@illinois.edu', '2024-08-14', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (459, 'Guido', 'Wadelin', '0538591561', 'gwadelincq@barnesandnoble.com', '2022-04-24', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (460, 'Vivyan', 'Arber', '0594876321', 'varbercr@discovery.com', '2023-12-26', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (461, 'Sebastiano', 'Stebbings', '0513450255', 'sstebbingscs@spiegel.de', '2023-09-11', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (462, 'Abigale', 'Arnson', '0540038522', 'aarnsonct@weebly.com', '2025-08-18', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (463, 'Marijn', 'Loffel', '0589119186', 'mloffelcu@craigslist.org', '2024-01-07', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (464, 'Jesselyn', 'Fouch', '0547266665', 'jfouchcv@elpais.com', '2022-08-13', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (465, 'Tiertza', 'Stoak', '0525183062', 'tstoakcw@chron.com', '2023-09-13', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (466, 'Cristiano', 'McFie', '0502725903', 'cmcfiecx@fc2.com', '2024-12-20', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (467, 'Clarey', 'Millership', '0563848268', 'cmillershipcy@themeforest.net', '2022-03-01', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (468, 'Monah', 'Chidlow', '0541948064', 'mchidlowcz@flavors.me', '2024-10-11', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (469, 'Renate', 'Jedrzejczak', '0563777180', 'rjedrzejczakd0@hhs.gov', '2022-11-28', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (470, 'Lizzie', 'Stuchburie', '0588090142', 'lstuchburied1@ifeng.com', '2024-11-28', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (471, 'Luelle', 'Yorston', '0537581988', 'lyorstond2@sciencedirect.com', '2022-04-21', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (472, 'Joscelin', 'Mendonca', '0523715183', 'jmendoncad3@geocities.com', '2024-11-09', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (473, 'Ilka', 'Arnley', '0581001881', 'iarnleyd4@icio.us', '2023-01-02', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (474, 'Fidelity', 'Headland', '0531031685', 'fheadlandd5@apache.org', '2024-12-04', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (475, 'Eliza', 'Elias', '0565843782', 'eeliasd6@ca.gov', '2023-05-02', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (476, 'Rita', 'Gregol', '0505055730', 'rgregold7@latimes.com', '2025-11-29', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (477, 'Demetris', 'Craythorn', '0557988982', 'dcraythornd8@hubpages.com', '2022-10-05', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (478, 'Karl', 'Wickey', '0521433538', 'kwickeyd9@netscape.com', '2024-09-27', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (479, 'Lynette', 'Birnie', '0553816375', 'lbirnieda@unicef.org', '2023-06-16', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (480, 'Lawrence', 'Shetliff', '0530323534', 'lshetliffdb@friendfeed.com', '2025-03-11', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (481, 'Merridie', 'Bemrose', '0568707970', 'mbemrosedc@topsy.com', '2022-10-04', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (482, 'Benjie', 'Piell', '0510208705', 'bpielldd@g.co', '2022-03-22', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (483, 'Cecily', 'Clardge', '0577649521', 'cclardgede@gizmodo.com', '2025-10-28', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (484, 'Bernard', 'Iacobacci', '0569346915', 'biacobaccidf@irs.gov', '2025-02-13', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (485, 'Dixie', 'Gieraths', '0580860606', 'dgierathsdg@youku.com', '2025-05-31', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (486, 'Clark', 'Eborall', '0521903876', 'ceboralldh@bloglines.com', '2022-11-06', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (487, 'Nonna', 'Northcote', '0574931502', 'nnorthcotedi@feedburner.com', '2022-08-31', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (488, 'Gipsy', 'Codrington', '0512912547', 'gcodringtondj@topsy.com', '2022-06-22', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (489, 'Harley', 'Penrice', '0579524202', 'hpenricedk@dmoz.org', '2022-08-05', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (490, 'Avictor', 'McGloin', '0552690469', 'amcgloindl@gizmodo.com', '2023-10-23', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (491, 'Dorena', 'Laurie', '0555745037', 'dlauriedm@bbb.org', '2024-02-04', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (492, 'Euell', 'Grimmert', '0574554882', 'egrimmertdn@deliciousdays.com', '2023-12-29', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (493, 'Ninon', 'Wellfare', '0579947187', 'nwellfaredo@ning.com', '2022-09-05', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (494, 'Korney', 'Lynam', '0568922144', 'klynamdp@etsy.com', '2025-12-09', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (495, 'Devan', 'Rishbrook', '0572392900', 'drishbrookdq@shinystat.com', '2023-04-16', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (496, 'Chip', 'Tuxell', '0548933488', 'ctuxelldr@youtu.be', '2025-09-27', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (497, 'Zack', 'Knoton', '0521625763', 'zknotonds@businessinsider.com', '2025-01-04', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (498, 'Rhonda', 'Lahy', '0501148653', 'rlahydt@bluehost.com', '2024-04-04', 0);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (499, 'Vivi', 'Sumner', '0583114780', 'vsumnerdu@cafepress.com', '2023-03-30', 1);
INSERT INTO public.customer (customer_id, first_name, last_name, phone, email, created_at, is_active) VALUES (500, 'Cobbie', 'Olander', '0571531874', 'colanderdv@cafepress.com', '2025-04-03', 1);


--
-- TOC entry 3441 (class 0 OID 16438)
-- Dependencies: 221
-- Data for Name: feedback; Type: TABLE DATA; Schema: public; Owner: MyUser
--



--
-- TOC entry 3443 (class 0 OID 16460)
-- Dependencies: 223
-- Data for Name: loyalty; Type: TABLE DATA; Schema: public; Owner: MyUser
--

INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (1, 3265, '2023-02-17', 1, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (2, 1838, '2023-11-05', 2, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (3, 1159, '2022-09-06', 3, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (4, 4422, '2022-05-03', 4, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (5, 7281, '2025-12-21', 5, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (6, 8813, '2025-12-18', 6, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (7, 4638, '2025-12-21', 7, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (8, 4041, '2023-03-03', 8, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (9, 3328, '2024-04-26', 9, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (10, 9756, '2023-03-23', 10, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (11, 244, '2023-06-11', 11, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (12, 3923, '2024-12-19', 12, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (13, 5945, '2022-01-04', 13, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (14, 8417, '2024-05-23', 14, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (15, 5428, '2022-10-24', 15, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (16, 3612, '2023-06-26', 16, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (17, 5644, '2024-12-12', 17, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (18, 2909, '2022-07-28', 18, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (19, 4679, '2025-09-30', 19, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (20, 3030, '2022-04-13', 20, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (21, 7918, '2022-07-28', 21, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (22, 8180, '2025-05-03', 22, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (23, 8987, '2023-06-02', 23, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (24, 2711, '2024-06-17', 24, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (25, 8790, '2023-04-27', 25, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (26, 1614, '2024-11-02', 26, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (27, 1903, '2025-12-19', 27, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (28, 571, '2023-03-08', 28, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (29, 4004, '2022-10-22', 29, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (30, 3939, '2024-08-11', 30, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (31, 6664, '2024-07-12', 31, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (32, 8399, '2024-10-10', 32, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (33, 1806, '2024-06-07', 33, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (34, 9031, '2024-06-28', 34, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (35, 1601, '2024-09-10', 35, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (36, 9571, '2025-06-04', 36, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (37, 609, '2024-10-13', 37, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (38, 6856, '2025-10-03', 38, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (39, 7100, '2025-08-27', 39, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (40, 7642, '2025-11-22', 40, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (41, 1821, '2023-02-19', 41, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (42, 8679, '2022-10-17', 42, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (43, 5449, '2022-08-27', 43, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (44, 1624, '2023-02-20', 44, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (45, 5612, '2023-03-14', 45, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (46, 9578, '2023-01-17', 46, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (47, 8778, '2024-05-08', 47, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (48, 5538, '2025-09-30', 48, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (49, 6663, '2024-09-11', 49, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (50, 2728, '2025-05-09', 50, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (51, 2348, '2024-11-29', 51, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (52, 4142, '2022-12-12', 52, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (53, 3419, '2025-05-11', 53, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (54, 5424, '2022-02-18', 54, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (55, 9485, '2024-01-25', 55, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (56, 7945, '2023-11-25', 56, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (57, 7511, '2025-01-07', 57, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (58, 5997, '2024-08-08', 58, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (59, 2723, '2023-11-20', 59, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (60, 6579, '2025-06-18', 60, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (61, 7337, '2022-05-17', 61, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (62, 9962, '2023-03-31', 62, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (63, 9594, '2025-06-03', 63, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (64, 2256, '2023-01-31', 64, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (65, 2044, '2022-10-23', 65, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (66, 8340, '2024-02-07', 66, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (67, 4633, '2023-02-13', 67, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (68, 4355, '2023-03-10', 68, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (69, 3919, '2022-06-17', 69, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (70, 4216, '2025-06-08', 70, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (71, 8925, '2023-04-23', 71, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (72, 6435, '2022-04-20', 72, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (73, 5025, '2024-03-28', 73, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (74, 3766, '2023-03-15', 74, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (75, 4432, '2025-03-07', 75, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (76, 7473, '2022-09-21', 76, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (77, 5662, '2022-04-30', 77, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (78, 7545, '2025-03-27', 78, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (79, 6009, '2025-12-14', 79, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (80, 9614, '2025-01-08', 80, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (81, 2641, '2022-04-30', 81, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (82, 3651, '2023-09-24', 82, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (83, 8712, '2025-06-05', 83, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (84, 5825, '2023-01-28', 84, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (85, 4738, '2023-10-22', 85, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (86, 1405, '2025-08-01', 86, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (87, 4128, '2023-12-06', 87, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (88, 9455, '2022-03-18', 88, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (89, 5781, '2023-05-05', 89, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (90, 4436, '2022-12-12', 90, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (91, 6700, '2022-03-21', 91, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (92, 9895, '2024-09-08', 92, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (93, 726, '2025-07-20', 93, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (94, 8762, '2024-11-28', 94, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (95, 3568, '2022-12-10', 95, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (96, 5789, '2023-03-09', 96, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (97, 5408, '2023-07-17', 97, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (98, 9610, '2024-11-02', 98, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (99, 5842, '2024-01-07', 99, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (100, 6385, '2025-02-23', 100, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (101, 3884, '2023-01-10', 101, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (102, 6113, '2024-10-08', 102, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (103, 1631, '2023-06-14', 103, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (104, 4009, '2022-08-17', 104, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (105, 8416, '2022-03-07', 105, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (106, 1776, '2023-08-09', 106, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (107, 6723, '2025-03-31', 107, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (108, 9820, '2023-12-30', 108, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (109, 3869, '2022-10-05', 109, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (110, 7656, '2023-01-06', 110, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (111, 1202, '2023-01-08', 111, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (112, 8087, '2022-05-21', 112, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (113, 9522, '2024-11-01', 113, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (114, 4078, '2024-11-26', 114, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (115, 1278, '2022-09-09', 115, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (116, 660, '2025-08-21', 116, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (117, 7849, '2022-08-08', 117, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (118, 5400, '2024-08-06', 118, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (119, 6519, '2024-12-20', 119, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (120, 1293, '2022-03-10', 120, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (121, 8790, '2022-06-12', 121, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (122, 2913, '2023-09-25', 122, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (123, 2927, '2022-01-04', 123, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (124, 8689, '2024-12-26', 124, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (125, 4054, '2022-01-17', 125, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (126, 4643, '2025-02-20', 126, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (127, 5913, '2025-01-03', 127, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (128, 8505, '2024-11-03', 128, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (129, 8350, '2022-07-09', 129, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (130, 2399, '2022-01-01', 130, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (131, 9849, '2025-07-06', 131, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (132, 4014, '2023-09-27', 132, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (133, 5577, '2024-03-28', 133, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (134, 7415, '2024-05-13', 134, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (135, 3165, '2025-08-19', 135, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (136, 4091, '2024-12-29', 136, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (137, 6794, '2025-07-11', 137, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (138, 8766, '2022-07-30', 138, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (139, 8648, '2025-05-18', 139, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (140, 6233, '2024-01-02', 140, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (141, 7058, '2023-10-27', 141, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (142, 7381, '2022-02-22', 142, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (143, 3176, '2024-05-11', 143, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (144, 6808, '2025-05-25', 144, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (145, 1747, '2025-11-15', 145, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (146, 366, '2024-01-11', 146, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (147, 4242, '2025-01-04', 147, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (148, 3475, '2025-07-18', 148, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (149, 6352, '2022-01-02', 149, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (150, 1710, '2024-06-05', 150, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (151, 9874, '2022-04-21', 151, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (152, 9625, '2025-08-19', 152, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (153, 4218, '2024-06-07', 153, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (154, 1956, '2025-01-13', 154, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (155, 2330, '2022-12-23', 155, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (156, 9776, '2025-05-11', 156, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (157, 7571, '2022-11-22', 157, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (158, 6942, '2023-09-22', 158, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (159, 3357, '2023-12-01', 159, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (160, 444, '2022-09-05', 160, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (161, 7918, '2024-05-25', 161, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (162, 4194, '2024-11-07', 162, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (163, 1430, '2025-11-29', 163, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (164, 910, '2024-07-01', 164, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (165, 5232, '2023-01-14', 165, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (166, 3897, '2025-12-03', 166, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (167, 1091, '2023-01-28', 167, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (168, 6627, '2025-03-03', 168, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (169, 4176, '2023-03-15', 169, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (170, 2566, '2024-12-26', 170, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (171, 481, '2023-10-02', 171, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (172, 2036, '2023-02-28', 172, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (173, 5561, '2025-10-01', 173, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (174, 8906, '2024-04-28', 174, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (175, 2424, '2023-12-03', 175, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (176, 1396, '2023-04-13', 176, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (177, 5750, '2023-01-25', 177, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (178, 9089, '2025-05-06', 178, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (179, 6782, '2023-05-21', 179, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (180, 2212, '2024-12-13', 180, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (181, 9662, '2024-10-28', 181, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (182, 7010, '2022-01-02', 182, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (183, 538, '2023-02-26', 183, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (184, 3499, '2024-04-16', 184, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (185, 5765, '2023-11-05', 185, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (186, 7852, '2025-06-21', 186, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (187, 4325, '2022-06-14', 187, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (188, 8769, '2023-08-02', 188, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (189, 3675, '2024-01-22', 189, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (190, 1519, '2025-01-23', 190, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (191, 8490, '2025-01-05', 191, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (192, 1307, '2022-04-07', 192, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (193, 2215, '2025-04-18', 193, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (194, 22, '2024-12-17', 194, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (195, 2599, '2023-01-20', 195, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (196, 7061, '2022-07-10', 196, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (197, 1404, '2025-11-12', 197, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (198, 7917, '2025-09-29', 198, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (199, 7022, '2023-08-11', 199, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (200, 9931, '2024-10-14', 200, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (201, 4919, '2022-11-11', 201, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (202, 1116, '2024-10-03', 202, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (203, 9666, '2024-11-23', 203, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (204, 2883, '2022-06-18', 204, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (205, 8660, '2022-03-20', 205, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (206, 178, '2024-10-09', 206, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (207, 2256, '2025-06-27', 207, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (208, 7969, '2022-09-18', 208, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (209, 3381, '2025-09-28', 209, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (210, 7114, '2024-12-18', 210, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (211, 2514, '2023-06-29', 211, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (212, 8110, '2022-01-06', 212, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (213, 8184, '2024-04-04', 213, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (214, 9012, '2024-05-03', 214, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (215, 5784, '2023-05-17', 215, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (216, 4539, '2022-10-10', 216, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (217, 5117, '2024-11-12', 217, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (218, 5500, '2024-11-25', 218, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (219, 8032, '2025-06-29', 219, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (220, 7345, '2025-12-13', 220, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (221, 9953, '2022-02-16', 221, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (222, 5726, '2022-03-30', 222, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (223, 2794, '2025-05-24', 223, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (224, 5325, '2022-07-21', 224, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (225, 2281, '2023-05-13', 225, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (226, 8473, '2025-03-13', 226, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (227, 8009, '2025-08-19', 227, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (228, 2449, '2025-03-17', 228, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (229, 9278, '2023-09-16', 229, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (230, 5441, '2025-08-01', 230, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (231, 749, '2024-09-21', 231, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (232, 9156, '2023-07-17', 232, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (233, 3077, '2025-09-22', 233, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (234, 26, '2022-05-13', 234, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (235, 9272, '2025-03-18', 235, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (236, 527, '2022-11-23', 236, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (237, 6885, '2024-08-14', 237, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (238, 9096, '2024-03-07', 238, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (239, 7387, '2022-07-21', 239, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (240, 2277, '2024-01-24', 240, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (241, 6508, '2022-04-19', 241, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (242, 7208, '2023-03-06', 242, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (243, 65, '2024-05-02', 243, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (244, 6037, '2022-06-25', 244, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (245, 5473, '2023-05-28', 245, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (246, 7167, '2025-10-07', 246, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (247, 4915, '2022-01-17', 247, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (248, 3069, '2025-08-18', 248, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (249, 2628, '2024-07-24', 249, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (250, 6313, '2023-03-03', 250, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (251, 7422, '2024-03-06', 251, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (252, 1197, '2024-11-22', 252, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (253, 9073, '2025-09-16', 253, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (254, 6560, '2024-01-19', 254, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (255, 8618, '2023-04-30', 255, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (256, 1181, '2022-02-11', 256, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (257, 5012, '2024-11-02', 257, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (258, 1044, '2023-09-07', 258, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (259, 3881, '2022-01-13', 259, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (260, 7703, '2022-04-07', 260, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (261, 879, '2022-09-28', 261, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (262, 5773, '2024-01-24', 262, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (263, 6499, '2025-04-12', 263, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (264, 7898, '2022-12-05', 264, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (265, 1801, '2022-03-23', 265, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (266, 2999, '2023-03-04', 266, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (267, 1600, '2022-10-13', 267, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (268, 1937, '2024-04-10', 268, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (269, 5167, '2024-05-03', 269, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (270, 1346, '2024-05-01', 270, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (271, 7335, '2023-04-13', 271, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (272, 4180, '2023-05-10', 272, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (273, 1446, '2023-05-13', 273, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (274, 8666, '2023-11-09', 274, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (275, 9431, '2025-04-20', 275, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (276, 6881, '2022-11-02', 276, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (277, 6082, '2024-12-16', 277, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (278, 7288, '2022-12-05', 278, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (279, 107, '2025-02-17', 279, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (280, 8616, '2024-12-19', 280, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (281, 4728, '2023-04-18', 281, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (282, 4700, '2024-02-21', 282, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (283, 3119, '2023-11-10', 283, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (284, 2088, '2024-11-30', 284, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (285, 1715, '2025-01-05', 285, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (286, 2812, '2022-10-15', 286, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (287, 406, '2022-01-30', 287, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (288, 69, '2023-12-16', 288, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (289, 5100, '2025-07-22', 289, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (290, 4271, '2022-05-08', 290, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (291, 2915, '2025-03-15', 291, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (292, 875, '2025-05-02', 292, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (293, 1450, '2023-01-12', 293, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (294, 9566, '2024-01-10', 294, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (295, 1492, '2023-09-28', 295, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (296, 632, '2024-09-17', 296, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (297, 7508, '2025-04-20', 297, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (298, 6289, '2023-04-24', 298, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (299, 638, '2025-02-12', 299, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (300, 6667, '2022-10-02', 300, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (301, 5024, '2022-03-09', 301, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (302, 6292, '2025-09-25', 302, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (303, 8076, '2023-08-19', 303, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (304, 1566, '2025-01-18', 304, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (305, 4667, '2025-06-20', 305, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (306, 4921, '2022-11-01', 306, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (307, 3594, '2024-03-04', 307, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (308, 9516, '2024-01-09', 308, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (309, 9395, '2022-04-22', 309, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (310, 4175, '2024-01-24', 310, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (311, 3282, '2023-12-16', 311, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (312, 3576, '2023-12-13', 312, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (313, 4833, '2023-10-20', 313, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (314, 7518, '2024-12-17', 314, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (315, 6973, '2023-07-17', 315, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (316, 5967, '2023-10-16', 316, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (317, 7012, '2024-08-28', 317, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (318, 9730, '2025-05-12', 318, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (319, 2690, '2025-12-03', 319, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (320, 8605, '2022-10-17', 320, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (321, 8790, '2022-04-10', 321, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (322, 8273, '2022-03-24', 322, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (323, 9775, '2024-09-04', 323, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (324, 7683, '2022-03-28', 324, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (325, 5877, '2025-04-21', 325, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (326, 4907, '2025-01-29', 326, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (327, 1196, '2024-08-13', 327, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (328, 154, '2024-06-23', 328, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (329, 9302, '2022-02-04', 329, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (330, 8951, '2025-02-09', 330, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (331, 8971, '2025-07-20', 331, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (332, 2264, '2023-12-27', 332, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (333, 9774, '2023-04-27', 333, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (334, 4457, '2025-10-31', 334, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (335, 9836, '2022-10-16', 335, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (336, 8362, '2024-03-12', 336, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (337, 6336, '2022-06-29', 337, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (338, 6870, '2025-10-03', 338, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (339, 9541, '2025-12-25', 339, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (340, 7891, '2025-10-08', 340, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (341, 9119, '2025-02-01', 341, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (342, 1516, '2024-07-26', 342, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (343, 1932, '2024-02-02', 343, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (344, 6226, '2024-04-16', 344, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (345, 6566, '2022-08-24', 345, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (346, 6038, '2023-04-24', 346, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (347, 640, '2025-03-28', 347, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (348, 3070, '2024-10-16', 348, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (349, 6599, '2024-11-23', 349, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (350, 8683, '2024-09-29', 350, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (351, 1284, '2024-05-26', 351, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (352, 8994, '2022-04-11', 352, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (353, 7916, '2022-03-25', 353, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (354, 7741, '2024-10-25', 354, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (355, 4311, '2025-01-13', 355, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (356, 7109, '2023-10-25', 356, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (357, 2019, '2025-02-25', 357, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (358, 236, '2022-05-26', 358, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (359, 9426, '2025-05-01', 359, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (360, 635, '2024-01-23', 360, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (361, 7254, '2024-02-18', 361, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (362, 9101, '2023-12-03', 362, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (363, 1515, '2022-09-15', 363, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (364, 6037, '2023-09-21', 364, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (365, 691, '2022-10-02', 365, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (366, 2218, '2023-10-06', 366, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (367, 6999, '2025-11-12', 367, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (368, 4874, '2025-03-06', 368, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (369, 9634, '2024-07-24', 369, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (370, 7059, '2025-11-03', 370, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (371, 2678, '2025-07-13', 371, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (372, 5380, '2022-11-09', 372, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (373, 442, '2024-12-20', 373, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (374, 9399, '2025-12-29', 374, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (375, 2274, '2023-08-25', 375, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (376, 7883, '2025-07-12', 376, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (377, 5249, '2023-11-12', 377, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (378, 6716, '2024-07-11', 378, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (379, 4595, '2024-03-16', 379, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (380, 4195, '2025-03-19', 380, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (381, 6124, '2022-02-07', 381, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (382, 810, '2023-02-07', 382, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (383, 6864, '2024-04-10', 383, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (384, 9198, '2022-04-23', 384, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (385, 7733, '2023-02-01', 385, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (386, 193, '2025-01-03', 386, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (387, 782, '2024-01-05', 387, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (388, 8615, '2022-05-29', 388, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (389, 6398, '2024-07-29', 389, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (390, 8965, '2025-09-19', 390, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (391, 1595, '2025-02-01', 391, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (392, 2375, '2022-08-19', 392, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (393, 8924, '2023-03-09', 393, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (394, 2836, '2024-07-09', 394, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (395, 600, '2023-12-03', 395, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (396, 2137, '2025-04-11', 396, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (397, 794, '2025-10-03', 397, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (398, 7732, '2022-02-22', 398, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (399, 7259, '2023-03-24', 399, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (400, 5690, '2023-01-06', 400, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (401, 4234, '2022-06-02', 401, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (402, 9520, '2024-10-11', 402, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (403, 8110, '2023-05-11', 403, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (404, 3701, '2022-03-26', 404, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (405, 9724, '2022-07-17', 405, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (406, 9011, '2024-05-26', 406, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (407, 5981, '2025-02-21', 407, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (408, 3763, '2024-09-16', 408, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (409, 5600, '2022-02-19', 409, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (410, 9112, '2022-10-22', 410, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (411, 4937, '2022-11-04', 411, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (412, 5035, '2022-03-31', 412, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (413, 7660, '2024-01-31', 413, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (414, 1656, '2023-03-04', 414, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (415, 9961, '2024-06-05', 415, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (416, 3714, '2022-07-14', 416, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (417, 5131, '2024-08-14', 417, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (418, 6463, '2023-02-14', 418, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (419, 6219, '2025-12-02', 419, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (420, 1238, '2022-07-26', 420, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (421, 9523, '2023-06-23', 421, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (422, 3240, '2025-07-06', 422, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (423, 1578, '2023-04-16', 423, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (424, 1621, '2023-04-07', 424, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (425, 286, '2025-04-11', 425, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (426, 9093, '2025-01-09', 426, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (427, 6935, '2022-11-27', 427, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (428, 6883, '2024-05-13', 428, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (429, 8240, '2022-10-21', 429, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (430, 9770, '2025-08-04', 430, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (431, 4150, '2023-08-28', 431, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (432, 7748, '2023-02-10', 432, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (433, 3686, '2024-02-08', 433, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (434, 9019, '2024-01-31', 434, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (435, 2797, '2022-01-18', 435, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (436, 82, '2023-11-28', 436, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (437, 9041, '2023-11-11', 437, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (438, 6559, '2025-03-30', 438, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (439, 888, '2023-07-13', 439, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (440, 5562, '2022-04-27', 440, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (441, 8865, '2023-07-06', 441, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (442, 4357, '2023-05-31', 442, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (443, 7482, '2025-12-12', 443, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (444, 3944, '2023-10-26', 444, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (445, 4093, '2022-11-04', 445, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (446, 4996, '2024-11-18', 446, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (447, 2644, '2025-08-24', 447, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (448, 9108, '2022-07-06', 448, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (449, 2888, '2025-04-20', 449, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (450, 9555, '2025-10-22', 450, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (451, 8610, '2022-03-07', 451, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (452, 7156, '2022-04-29', 452, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (453, 537, '2022-03-17', 453, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (454, 8153, '2022-12-30', 454, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (455, 477, '2025-09-16', 455, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (456, 1956, '2025-06-14', 456, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (457, 1170, '2025-06-25', 457, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (458, 6101, '2024-04-16', 458, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (459, 5200, '2022-04-22', 459, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (460, 5041, '2025-04-16', 460, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (461, 7340, '2022-05-31', 461, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (462, 7375, '2023-09-03', 462, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (463, 2258, '2024-03-24', 463, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (464, 2645, '2025-01-23', 464, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (465, 4636, '2024-04-02', 465, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (466, 682, '2022-11-25', 466, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (467, 944, '2025-06-29', 467, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (468, 7046, '2023-07-25', 468, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (469, 4227, '2025-02-02', 469, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (470, 6141, '2023-09-18', 470, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (471, 1611, '2023-01-26', 471, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (472, 3260, '2024-10-14', 472, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (473, 8081, '2022-06-25', 473, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (474, 9468, '2025-02-19', 474, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (475, 2407, '2024-10-01', 475, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (476, 9353, '2023-11-16', 476, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (477, 8119, '2025-01-23', 477, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (478, 3062, '2022-04-22', 478, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (479, 1474, '2024-06-24', 479, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (480, 5787, '2024-05-15', 480, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (481, 8202, '2024-02-13', 481, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (482, 6373, '2023-03-11', 482, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (483, 5501, '2024-06-15', 483, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (484, 5204, '2023-09-30', 484, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (485, 4916, '2025-03-27', 485, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (486, 4330, '2022-11-14', 486, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (487, 3131, '2023-07-25', 487, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (488, 5922, '2023-12-17', 488, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (489, 811, '2024-01-31', 489, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (490, 3941, '2022-05-22', 490, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (491, 9936, '2024-10-04', 491, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (492, 1226, '2022-04-02', 492, 2);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (493, 1730, '2023-02-07', 493, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (494, 8566, '2022-05-17', 494, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (495, 3872, '2024-04-30', 495, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (496, 4458, '2024-10-10', 496, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (497, 1394, '2022-08-31', 497, 3);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (498, 4652, '2025-09-06', 498, 1);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (499, 812, '2022-03-26', 499, 4);
INSERT INTO public.loyalty (loyalty_id, points, last_updated, customer_id, tier_id) VALUES (500, 3108, '2024-12-11', 500, 4);


--
-- TOC entry 3442 (class 0 OID 16453)
-- Dependencies: 222
-- Data for Name: loyalty_tier; Type: TABLE DATA; Schema: public; Owner: MyUser
--

INSERT INTO public.loyalty_tier (tier_id, level) VALUES (1, 'Bronze');
INSERT INTO public.loyalty_tier (tier_id, level) VALUES (2, 'Silver');
INSERT INTO public.loyalty_tier (tier_id, level) VALUES (3, 'Gold');
INSERT INTO public.loyalty_tier (tier_id, level) VALUES (4, 'Platinum');


--
-- TOC entry 3445 (class 0 OID 16485)
-- Dependencies: 225
-- Data for Name: loyalty_transaction; Type: TABLE DATA; Schema: public; Owner: MyUser
--



--
-- TOC entry 3444 (class 0 OID 16478)
-- Dependencies: 224
-- Data for Name: reason; Type: TABLE DATA; Schema: public; Owner: MyUser
--

INSERT INTO public.reason (reason_id, description) VALUES (1, 'Dining Purchase');
INSERT INTO public.reason (reason_id, description) VALUES (2, 'Referral Bonus');
INSERT INTO public.reason (reason_id, description) VALUES (3, 'Birthday Reward');
INSERT INTO public.reason (reason_id, description) VALUES (4, 'Sign-Up Bonus');
INSERT INTO public.reason (reason_id, description) VALUES (5, 'Review Bonus');
INSERT INTO public.reason (reason_id, description) VALUES (6, 'Points Redemption');
INSERT INTO public.reason (reason_id, description) VALUES (7, 'Promotional Offer');
INSERT INTO public.reason (reason_id, description) VALUES (8, 'Penalty Adjustment');


--
-- TOC entry 3439 (class 0 OID 16405)
-- Dependencies: 219
-- Data for Name: reservation; Type: TABLE DATA; Schema: public; Owner: MyUser
--



--
-- TOC entry 3438 (class 0 OID 16398)
-- Dependencies: 218
-- Data for Name: status_type; Type: TABLE DATA; Schema: public; Owner: MyUser
--

INSERT INTO public.status_type (status_id, description) VALUES (1, 'Pending');
INSERT INTO public.status_type (status_id, description) VALUES (2, 'Confirmed');
INSERT INTO public.status_type (status_id, description) VALUES (3, 'Cancelled');
INSERT INTO public.status_type (status_id, description) VALUES (4, 'Completed');
INSERT INTO public.status_type (status_id, description) VALUES (5, 'No-Show');
INSERT INTO public.status_type (status_id, description) VALUES (6, 'Waiting');
INSERT INTO public.status_type (status_id, description) VALUES (7, 'Seated');
INSERT INTO public.status_type (status_id, description) VALUES (8, 'Expired');


--
-- TOC entry 3440 (class 0 OID 16421)
-- Dependencies: 220
-- Data for Name: waitlist; Type: TABLE DATA; Schema: public; Owner: MyUser
--



--
-- TOC entry 3252 (class 2606 OID 16397)
-- Name: customer customer_email_key; Type: CONSTRAINT; Schema: public; Owner: MyUser
--

ALTER TABLE ONLY public.customer
    ADD CONSTRAINT customer_email_key UNIQUE (email);


--
-- TOC entry 3254 (class 2606 OID 16395)
-- Name: customer customer_phone_key; Type: CONSTRAINT; Schema: public; Owner: MyUser
--

ALTER TABLE ONLY public.customer
    ADD CONSTRAINT customer_phone_key UNIQUE (phone);


--
-- TOC entry 3256 (class 2606 OID 16393)
-- Name: customer customer_pkey; Type: CONSTRAINT; Schema: public; Owner: MyUser
--

ALTER TABLE ONLY public.customer
    ADD CONSTRAINT customer_pkey PRIMARY KEY (customer_id);


--
-- TOC entry 3266 (class 2606 OID 16445)
-- Name: feedback feedback_pkey; Type: CONSTRAINT; Schema: public; Owner: MyUser
--

ALTER TABLE ONLY public.feedback
    ADD CONSTRAINT feedback_pkey PRIMARY KEY (feedback_id);


--
-- TOC entry 3268 (class 2606 OID 16447)
-- Name: feedback feedback_reservation_id_key; Type: CONSTRAINT; Schema: public; Owner: MyUser
--

ALTER TABLE ONLY public.feedback
    ADD CONSTRAINT feedback_reservation_id_key UNIQUE (reservation_id);


--
-- TOC entry 3274 (class 2606 OID 16467)
-- Name: loyalty loyalty_customer_id_key; Type: CONSTRAINT; Schema: public; Owner: MyUser
--

ALTER TABLE ONLY public.loyalty
    ADD CONSTRAINT loyalty_customer_id_key UNIQUE (customer_id);


--
-- TOC entry 3276 (class 2606 OID 16465)
-- Name: loyalty loyalty_pkey; Type: CONSTRAINT; Schema: public; Owner: MyUser
--

ALTER TABLE ONLY public.loyalty
    ADD CONSTRAINT loyalty_pkey PRIMARY KEY (loyalty_id);


--
-- TOC entry 3270 (class 2606 OID 16459)
-- Name: loyalty_tier loyalty_tier_level_key; Type: CONSTRAINT; Schema: public; Owner: MyUser
--

ALTER TABLE ONLY public.loyalty_tier
    ADD CONSTRAINT loyalty_tier_level_key UNIQUE (level);


--
-- TOC entry 3272 (class 2606 OID 16457)
-- Name: loyalty_tier loyalty_tier_pkey; Type: CONSTRAINT; Schema: public; Owner: MyUser
--

ALTER TABLE ONLY public.loyalty_tier
    ADD CONSTRAINT loyalty_tier_pkey PRIMARY KEY (tier_id);


--
-- TOC entry 3282 (class 2606 OID 16490)
-- Name: loyalty_transaction loyalty_transaction_pkey; Type: CONSTRAINT; Schema: public; Owner: MyUser
--

ALTER TABLE ONLY public.loyalty_transaction
    ADD CONSTRAINT loyalty_transaction_pkey PRIMARY KEY (transaction_id);


--
-- TOC entry 3278 (class 2606 OID 16484)
-- Name: reason reason_description_key; Type: CONSTRAINT; Schema: public; Owner: MyUser
--

ALTER TABLE ONLY public.reason
    ADD CONSTRAINT reason_description_key UNIQUE (description);


--
-- TOC entry 3280 (class 2606 OID 16482)
-- Name: reason reason_pkey; Type: CONSTRAINT; Schema: public; Owner: MyUser
--

ALTER TABLE ONLY public.reason
    ADD CONSTRAINT reason_pkey PRIMARY KEY (reason_id);


--
-- TOC entry 3262 (class 2606 OID 16410)
-- Name: reservation reservation_pkey; Type: CONSTRAINT; Schema: public; Owner: MyUser
--

ALTER TABLE ONLY public.reservation
    ADD CONSTRAINT reservation_pkey PRIMARY KEY (reservation_id);


--
-- TOC entry 3258 (class 2606 OID 16404)
-- Name: status_type status_type_description_key; Type: CONSTRAINT; Schema: public; Owner: MyUser
--

ALTER TABLE ONLY public.status_type
    ADD CONSTRAINT status_type_description_key UNIQUE (description);


--
-- TOC entry 3260 (class 2606 OID 16402)
-- Name: status_type status_type_pkey; Type: CONSTRAINT; Schema: public; Owner: MyUser
--

ALTER TABLE ONLY public.status_type
    ADD CONSTRAINT status_type_pkey PRIMARY KEY (status_id);


--
-- TOC entry 3264 (class 2606 OID 16427)
-- Name: waitlist waitlist_pkey; Type: CONSTRAINT; Schema: public; Owner: MyUser
--

ALTER TABLE ONLY public.waitlist
    ADD CONSTRAINT waitlist_pkey PRIMARY KEY (waitlist_id);


--
-- TOC entry 3287 (class 2606 OID 16448)
-- Name: feedback feedback_reservation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: MyUser
--

ALTER TABLE ONLY public.feedback
    ADD CONSTRAINT feedback_reservation_id_fkey FOREIGN KEY (reservation_id) REFERENCES public.reservation(reservation_id);


--
-- TOC entry 3288 (class 2606 OID 16468)
-- Name: loyalty loyalty_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: MyUser
--

ALTER TABLE ONLY public.loyalty
    ADD CONSTRAINT loyalty_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customer(customer_id);


--
-- TOC entry 3289 (class 2606 OID 16473)
-- Name: loyalty loyalty_tier_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: MyUser
--

ALTER TABLE ONLY public.loyalty
    ADD CONSTRAINT loyalty_tier_id_fkey FOREIGN KEY (tier_id) REFERENCES public.loyalty_tier(tier_id);


--
-- TOC entry 3290 (class 2606 OID 16491)
-- Name: loyalty_transaction loyalty_transaction_loyalty_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: MyUser
--

ALTER TABLE ONLY public.loyalty_transaction
    ADD CONSTRAINT loyalty_transaction_loyalty_id_fkey FOREIGN KEY (loyalty_id) REFERENCES public.loyalty(loyalty_id);


--
-- TOC entry 3291 (class 2606 OID 16496)
-- Name: loyalty_transaction loyalty_transaction_reason_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: MyUser
--

ALTER TABLE ONLY public.loyalty_transaction
    ADD CONSTRAINT loyalty_transaction_reason_id_fkey FOREIGN KEY (reason_id) REFERENCES public.reason(reason_id);


--
-- TOC entry 3283 (class 2606 OID 16411)
-- Name: reservation reservation_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: MyUser
--

ALTER TABLE ONLY public.reservation
    ADD CONSTRAINT reservation_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customer(customer_id);


--
-- TOC entry 3284 (class 2606 OID 16416)
-- Name: reservation reservation_status_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: MyUser
--

ALTER TABLE ONLY public.reservation
    ADD CONSTRAINT reservation_status_id_fkey FOREIGN KEY (status_id) REFERENCES public.status_type(status_id);


--
-- TOC entry 3285 (class 2606 OID 16428)
-- Name: waitlist waitlist_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: MyUser
--

ALTER TABLE ONLY public.waitlist
    ADD CONSTRAINT waitlist_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customer(customer_id);


--
-- TOC entry 3286 (class 2606 OID 16433)
-- Name: waitlist waitlist_status_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: MyUser
--

ALTER TABLE ONLY public.waitlist
    ADD CONSTRAINT waitlist_status_id_fkey FOREIGN KEY (status_id) REFERENCES public.status_type(status_id);


-- Completed on 2026-04-13 16:05:25 UTC

--
-- PostgreSQL database dump complete
--

\unrestrict z7wL4fpf4Y8Put2VvKBgHRxVJS2MwOppyXF7Xb6UKVtaLWZTwpMnZx3wYtTwubf

