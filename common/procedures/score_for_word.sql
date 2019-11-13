CREATE FUNCTION score_for_word(base_score INTEGER, position_in_customer_symbols INTEGER,
                               position_in_prepared_symbols INTEGER, prepared_description TSVECTOR,
                               description_query TSQUERY, prepared_symbol_factor NUMERIC,
                               customer_symbol_factor NUMERIC, customers_symbols_only BOOLEAN) RETURNS INTEGER
    LANGUAGE plpgsql
AS
$$
DECLARE
    score_cs INTEGER;
    score_ps INTEGER;
    score_pd INTEGER;
BEGIN
    score_ps := 0;
    score_pd := 0;

    score_cs := COALESCE(
                        NULLIF(base_score + 1 - position_in_customer_symbols, base_score + 1),
                        0
                    ) * customer_symbol_factor;

    IF NOT customers_symbols_only
    THEN
        score_ps := COALESCE(
                            NULLIF(base_score + 1 - position_in_prepared_symbols, base_score + 1),
                            0
                        ) * prepared_symbol_factor;
    END IF;

    IF NOT customers_symbols_only
    THEN
        score_pd := CASE
                        WHEN score_ps = 0
                            THEN tme_rank(prepared_description, description_query, base_score, 1)
                        ELSE 0
            END;
    END IF;

    RETURN score_cs + score_ps + score_pd;
END
$$;

ALTER FUNCTION score_for_word(INTEGER, INTEGER, INTEGER, TSVECTOR, TSQUERY, NUMERIC, NUMERIC, BOOLEAN) OWNER TO "m.lepek";

