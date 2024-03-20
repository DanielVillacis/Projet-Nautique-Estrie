CREATE OR REPLACE FUNCTION creer_pne_id(type_pne_id type_pne_id) RETURNS VARCHAR AS $$
DECLARE
    timestamp_micros VARCHAR;
    pne_id VARCHAR(10);
BEGIN
    -- Get the current timestamp microseconds (10 digits)
    SELECT EXTRACT(MICROSECONDS FROM clock_timestamp())::TEXT INTO timestamp_micros;

    -- Concatenate the serial number and timestamp microseconds
    pne_id := LPAD(nextval(type_pne_id::text)::TEXT, 7, '0') || LPAD(RIGHT(TO_CHAR(clock_timestamp(), 'MS'), 3), 3, '0');

    RETURN pne_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION voir_embarcation_utilisateur(in_sub VARCHAR)
RETURNS TABLE (
    id_embarcation_utilisateur pne_id,
    id_embarcation embarcation_id,
    description VARCHAR,
    marque VARCHAR,
    longueur INT,
    photo VARCHAR,
    nom VARCHAR
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        EU.id_embarcation_utilisateur,
        E.id_embarcation,
        E.description,
        E.marque,
        E.longueur,
        E.photo,
        EU.nom
    FROM
        EmbarcationUtilisateur EU
    INNER JOIN
        Embarcation E ON EU.id_embarcation = E.id_embarcation
    WHERE
        EU.sub = in_sub;
END;
$$ LANGUAGE plpgsql;