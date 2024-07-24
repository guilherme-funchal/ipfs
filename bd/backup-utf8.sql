--
-- PostgreSQL database dump
--

-- Dumped from database version 16.3 (Debian 16.3-1.pgdg120+1)
-- Dumped by pg_dump version 16.3 (Ubuntu 16.3-1.pgdg24.04+1)

-- Started on 2024-07-23 11:30:07 -03

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
-- TOC entry 222 (class 1259 OID 16424)
-- Name: contracts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.contracts (
    id integer NOT NULL,
    contract text,
    wallet text,
    date timestamp with time zone
);


ALTER TABLE public.contracts OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16423)
-- Name: contracts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.contracts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.contracts_id_seq OWNER TO postgres;

--
-- TOC entry 3390 (class 0 OID 0)
-- Dependencies: 221
-- Name: contracts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.contracts_id_seq OWNED BY public.contracts.id;


--
-- TOC entry 216 (class 1259 OID 16390)
-- Name: file_metadata; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.file_metadata (
    id integer NOT NULL,
    hash character varying(255) NOT NULL,
    metadata jsonb,
    filecid text NOT NULL
);


ALTER TABLE public.file_metadata OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 16389)
-- Name: file_metadata_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.file_metadata_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.file_metadata_id_seq OWNER TO postgres;

--
-- TOC entry 3391 (class 0 OID 0)
-- Dependencies: 215
-- Name: file_metadata_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.file_metadata_id_seq OWNED BY public.file_metadata.id;


--
-- TOC entry 217 (class 1259 OID 16402)
-- Name: tokens; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tokens (
    id integer NOT NULL,
    token text,
    pk text
);


ALTER TABLE public.tokens OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 16405)
-- Name: tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tokens_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tokens_id_seq OWNER TO postgres;

--
-- TOC entry 3392 (class 0 OID 0)
-- Dependencies: 218
-- Name: tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tokens_id_seq OWNED BY public.tokens.id;


--
-- TOC entry 220 (class 1259 OID 16415)
-- Name: transactions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.transactions (
    id integer NOT NULL,
    type text,
    value text,
    fromwallet text,
    hash text,
    date timestamp with time zone,
    towallet text,
    tokenuri text,
    tokenid text
);


ALTER TABLE public.transactions OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16414)
-- Name: transactions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.transactions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.transactions_id_seq OWNER TO postgres;

--
-- TOC entry 3393 (class 0 OID 0)
-- Dependencies: 219
-- Name: transactions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.transactions_id_seq OWNED BY public.transactions.id;


--
-- TOC entry 3221 (class 2604 OID 16427)
-- Name: contracts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contracts ALTER COLUMN id SET DEFAULT nextval('public.contracts_id_seq'::regclass);


--
-- TOC entry 3218 (class 2604 OID 16393)
-- Name: file_metadata id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.file_metadata ALTER COLUMN id SET DEFAULT nextval('public.file_metadata_id_seq'::regclass);


--
-- TOC entry 3219 (class 2604 OID 16406)
-- Name: tokens id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tokens ALTER COLUMN id SET DEFAULT nextval('public.tokens_id_seq'::regclass);


--
-- TOC entry 3220 (class 2604 OID 16418)
-- Name: transactions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions ALTER COLUMN id SET DEFAULT nextval('public.transactions_id_seq'::regclass);


--
-- TOC entry 3384 (class 0 OID 16424)
-- Dependencies: 222
-- Data for Name: contracts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.contracts (id, contract, wallet, date) FROM stdin;
1	0x5FbDB2315678afecb367f032d93F642f64180aa3	0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266	2024-07-23 14:27:19+00
\.


--
-- TOC entry 3378 (class 0 OID 16390)
-- Dependencies: 216
-- Data for Name: file_metadata; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.file_metadata (id, hash, metadata, filecid) FROM stdin;
7	QmNduv8d2JLimzfXeD6itCMbfa5n8wDazjrEFgK4RXWPPV	{"name": "My TESTE", "image": "ipfs://QmNduv8d2JLimzfXeD6itCMbfa5n8wDazjrEFgK4RXWPPV", "attributes": [], "description": "Teste"}	QmVy3LLW6KM1RT1ECf29RB9dTFRQAShmYjJopTwuu1wkuw
\.


--
-- TOC entry 3379 (class 0 OID 16402)
-- Dependencies: 217
-- Data for Name: tokens; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tokens (id, token, pk) FROM stdin;
1	0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266	0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
2	0x70997970C51812dc3A010C7d01b50e0d17dc79C8	0x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d
3	0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC	0x5de4111afa1a4b94908f83103eb1f1706367c2e68ca870fc3fb9a804cdab365a
4	0x90F79bf6EB2c4f870365E785982E1f101E93b906	0x7c852118294e51e653712a81e05800f419141751be58f605c371e15141b007a6
5	0x15d34AAf54267DB7D7c367839AAf71A00a2C6A65	0x47e179ec197488593b187f80a00eb0da91f1b9d0b13f8733639f19c30a34926a
\.


--
-- TOC entry 3382 (class 0 OID 16415)
-- Dependencies: 220
-- Data for Name: transactions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.transactions (id, type, value, fromwallet, hash, date, towallet, tokenuri, tokenid) FROM stdin;
1	Mint	1000000000000000000000	0x90F79bf6EB2c4f870365E785982E1f101E93b906	0x891c7cf2356b417beaecc4f28d9110557f76f58ee461fbf22af6b12845a59ed4	2024-07-23 14:28:36+00	0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266	-	-
2	Mint	1000000000000000000000	0x90F79bf6EB2c4f870365E785982E1f101E93b906	0xb44c3ab6b60585f246daa377e784118da0fbc13a33609e2ba9b4f1ab67240cf8	2024-07-23 14:28:41+00	0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266	-	-
3	Burn	100000000000000000000	0x90F79bf6EB2c4f870365E785982E1f101E93b906	0x8f0b965fd913f3342885cc054f2879ba6ab93aa1936a779220631794d07637c5	2024-07-23 14:29:09+00	0x90F79bf6EB2c4f870365E785982E1f101E93b906	-	-
4	Burn	100000000000000000000	0x90F79bf6EB2c4f870365E785982E1f101E93b906	0x50bbfc5992d3be1c72e70a37c8bb4ce2c22d800b153a44dcad5657d69457636f	2024-07-23 14:29:12+00	0x90F79bf6EB2c4f870365E785982E1f101E93b906	-	-
\.


--
-- TOC entry 3394 (class 0 OID 0)
-- Dependencies: 221
-- Name: contracts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.contracts_id_seq', 1, true);


--
-- TOC entry 3395 (class 0 OID 0)
-- Dependencies: 215
-- Name: file_metadata_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.file_metadata_id_seq', 7, true);


--
-- TOC entry 3396 (class 0 OID 0)
-- Dependencies: 218
-- Name: tokens_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tokens_id_seq', 5, true);


--
-- TOC entry 3397 (class 0 OID 0)
-- Dependencies: 219
-- Name: transactions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.transactions_id_seq', 4, true);


--
-- TOC entry 3233 (class 2606 OID 16431)
-- Name: contracts contracts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contracts
    ADD CONSTRAINT contracts_pkey PRIMARY KEY (id);


--
-- TOC entry 3223 (class 2606 OID 16401)
-- Name: file_metadata file_metadata_filecid_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.file_metadata
    ADD CONSTRAINT file_metadata_filecid_key UNIQUE (filecid);


--
-- TOC entry 3225 (class 2606 OID 16399)
-- Name: file_metadata file_metadata_hash_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.file_metadata
    ADD CONSTRAINT file_metadata_hash_key UNIQUE (hash);


--
-- TOC entry 3227 (class 2606 OID 16397)
-- Name: file_metadata file_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.file_metadata
    ADD CONSTRAINT file_metadata_pkey PRIMARY KEY (id);


--
-- TOC entry 3229 (class 2606 OID 16413)
-- Name: tokens tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tokens
    ADD CONSTRAINT tokens_pkey PRIMARY KEY (id);


--
-- TOC entry 3231 (class 2606 OID 16422)
-- Name: transactions transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_pkey PRIMARY KEY (id);


-- Completed on 2024-07-23 11:30:07 -03

--
-- PostgreSQL database dump complete
--

