-- auto-generated definition
CREATE TABLE context_branch (
    id                SERIAL                                          NOT NULL
        CONSTRAINT index_instance_branch_pkey
            PRIMARY KEY,
    code_name         VARCHAR(64)                                     NOT NULL
        CONSTRAINT unique_instance_branch_code_name
            UNIQUE,
    pl_name           TEXT                                            NOT NULL,
    token_id          INTEGER       DEFAULT 0                         NOT NULL
        CONSTRAINT context_branch_token2_key
            UNIQUE
        CONSTRAINT context_branch_token2_fkey
            REFERENCES search_main.token_for_context
            ON UPDATE CASCADE ON DELETE RESTRICT,
    sap_branch_id     INTEGER
        CONSTRAINT context_branch_sap_branch_id_fkey
            REFERENCES context_branch_sap
            ON UPDATE CASCADE ON DELETE RESTRICT,
    traffic_branch_id INTEGER       DEFAULT '-3424'::INTEGER          NOT NULL
        CONSTRAINT context_branch_traffic_branch_id_fkey
            REFERENCES context_traffic_destination
            ON UPDATE CASCADE ON DELETE RESTRICT,
    hana_suffix       VARCHAR(16)   DEFAULT 'prod'::CHARACTER VARYING NOT NULL,
    db4_suffix        VARCHAR(16)   DEFAULT 'prod'::CHARACTER VARYING NOT NULL,
    mixed_suffix      VARCHAR(16)   DEFAULT 'prod'::CHARACTER VARYING NOT NULL,
    overlord_shortcut VARCHAR(5),
    ruleset_suffix    VARCHAR(16)   DEFAULT 'prod'::CHARACTER VARYING NOT NULL,
    api_synonyms      VARCHAR(64)[] DEFAULT '{}'::CHARACTER VARYING[] NOT NULL
);

COMMENT ON COLUMN context_branch.code_name IS 'Można zawrzeć po tej nazwie w zmiennej wejściowej';

COMMENT ON COLUMN context_branch.sap_branch_id IS 'Ten branch używa sapa w wersji...';

COMMENT ON COLUMN context_branch.traffic_branch_id IS 'Gdzie zapisywać logi, null - nie zapisuj';

COMMENT ON COLUMN context_branch.mixed_suffix IS 'Sufix schematu computed';

COMMENT ON COLUMN context_branch.ruleset_suffix IS 'Domyślny ruleset. Używany w overlord.';

COMMENT ON COLUMN context_branch.api_synonyms IS 'Synonimy dla wartości wejściowych API';

ALTER TABLE context_branch
    OWNER TO my_search_user_devel;

