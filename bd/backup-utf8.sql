PGDMP  $    $    
            |            srv    16.3 (Debian 16.3-1.pgdg120+1)     16.3 (Ubuntu 16.3-1.pgdg24.04+1)     1           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            2           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            3           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            4           1262    16388    srv    DATABASE     n   CREATE DATABASE srv WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.utf8';
    DROP DATABASE srv;
                postgres    false            �            1259    16390    file_metadata    TABLE     �   CREATE TABLE public.file_metadata (
    id integer NOT NULL,
    hash character varying(255) NOT NULL,
    metadata jsonb,
    filecid text NOT NULL
);
 !   DROP TABLE public.file_metadata;
       public         heap    postgres    false            �            1259    16389    file_metadata_id_seq    SEQUENCE     �   CREATE SEQUENCE public.file_metadata_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.file_metadata_id_seq;
       public          postgres    false    216            5           0    0    file_metadata_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE public.file_metadata_id_seq OWNED BY public.file_metadata.id;
          public          postgres    false    215            �            1259    16402    tokens    TABLE     U   CREATE TABLE public.tokens (
    id integer NOT NULL,
    token text,
    pk text
);
    DROP TABLE public.tokens;
       public         heap    postgres    false            �            1259    16405    tokens_id_seq    SEQUENCE     �   CREATE SEQUENCE public.tokens_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.tokens_id_seq;
       public          postgres    false    217            6           0    0    tokens_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.tokens_id_seq OWNED BY public.tokens.id;
          public          postgres    false    218            �            1259    16415    transactions    TABLE     �   CREATE TABLE public.transactions (
    id integer NOT NULL,
    type text,
    value text,
    fromwallet text,
    hash text,
    date timestamp with time zone,
    towallet text,
    "tokenURI" text,
    tokenid text
);
     DROP TABLE public.transactions;
       public         heap    postgres    false            �            1259    16414    transactions_id_seq    SEQUENCE     �   CREATE SEQUENCE public.transactions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.transactions_id_seq;
       public          postgres    false    220            7           0    0    transactions_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE public.transactions_id_seq OWNED BY public.transactions.id;
          public          postgres    false    219            �           2604    16393    file_metadata id    DEFAULT     t   ALTER TABLE ONLY public.file_metadata ALTER COLUMN id SET DEFAULT nextval('public.file_metadata_id_seq'::regclass);
 ?   ALTER TABLE public.file_metadata ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    216    215    216            �           2604    16406 	   tokens id    DEFAULT     f   ALTER TABLE ONLY public.tokens ALTER COLUMN id SET DEFAULT nextval('public.tokens_id_seq'::regclass);
 8   ALTER TABLE public.tokens ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    218    217            �           2604    16418    transactions id    DEFAULT     r   ALTER TABLE ONLY public.transactions ALTER COLUMN id SET DEFAULT nextval('public.transactions_id_seq'::regclass);
 >   ALTER TABLE public.transactions ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    219    220    220            *          0    16390    file_metadata 
   TABLE DATA           D   COPY public.file_metadata (id, hash, metadata, filecid) FROM stdin;
    public          postgres    false    216   �       +          0    16402    tokens 
   TABLE DATA           /   COPY public.tokens (id, token, pk) FROM stdin;
    public          postgres    false    217   �       .          0    16415    transactions 
   TABLE DATA           n   COPY public.transactions (id, type, value, fromwallet, hash, date, towallet, "tokenURI", tokenid) FROM stdin;
    public          postgres    false    220          8           0    0    file_metadata_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.file_metadata_id_seq', 7, true);
          public          postgres    false    215            9           0    0    tokens_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.tokens_id_seq', 5, true);
          public          postgres    false    218            :           0    0    transactions_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('public.transactions_id_seq', 1, false);
          public          postgres    false    219            �           2606    16401 '   file_metadata file_metadata_filecid_key 
   CONSTRAINT     e   ALTER TABLE ONLY public.file_metadata
    ADD CONSTRAINT file_metadata_filecid_key UNIQUE (filecid);
 Q   ALTER TABLE ONLY public.file_metadata DROP CONSTRAINT file_metadata_filecid_key;
       public            postgres    false    216            �           2606    16399 $   file_metadata file_metadata_hash_key 
   CONSTRAINT     _   ALTER TABLE ONLY public.file_metadata
    ADD CONSTRAINT file_metadata_hash_key UNIQUE (hash);
 N   ALTER TABLE ONLY public.file_metadata DROP CONSTRAINT file_metadata_hash_key;
       public            postgres    false    216            �           2606    16397     file_metadata file_metadata_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.file_metadata
    ADD CONSTRAINT file_metadata_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.file_metadata DROP CONSTRAINT file_metadata_pkey;
       public            postgres    false    216            �           2606    16413    tokens tokens_pkey 
   CONSTRAINT     P   ALTER TABLE ONLY public.tokens
    ADD CONSTRAINT tokens_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.tokens DROP CONSTRAINT tokens_pkey;
       public            postgres    false    217            �           2606    16422    transactions transactions_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_pkey PRIMARY KEY (id);
 H   ALTER TABLE ONLY public.transactions DROP CONSTRAINT transactions_pkey;
       public            postgres    false    220            *   �   x�����0 ����K�B6��ՁM��	���t[�ւxw�\�×`�䂚�O�Y$䓧,��'�ܯC�Vhz���t�\n�̉dph��ac���l($9��(�v:��_�h]��h�fl
e�T�R�"�ʘ)����<�Q��汓`M�$��i��/rw�%��qꛩ�� � `�Ii      +   ^  x��K�1׮�8@����]��H�>�5[x�d<��k�g��\�><���}ذ��O��'�¸��H�MZɩ�k�ws�,6���잹�yY5��v�ƁDX܂�cMz�m�6,�5-n?Q���#��R�9T��<֌��r�OKg�
TZ��.:����Yo� �%.k���p</A����ڌ�ى���@���@Im��>�zRW�ϕE*y�<��}��}rg�5���=�oP��i�e �>�o2�A��22�`m�V�y���R/9�E�z��P���c�h:ř� r����(�F�=�|я����^w��8~
�)EcL�$��y�����?�	�      .      x������ � �     