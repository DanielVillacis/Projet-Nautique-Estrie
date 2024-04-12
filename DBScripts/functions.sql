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
    photo VARCHAR,
    nom VARCHAR,
    id_embarcation embarcation_id,
    id_embarcation_utilisateur pne_id
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        E.photo,
        EU.nom,
        E.id_embarcation,
        EU.id_embarcation_utilisateur
    FROM
        EmbarcationUtilisateur EU
    INNER JOIN
        Embarcation E ON EU.id_embarcation = E.id_embarcation
    WHERE
        EU.sub = in_sub;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION voir_details_embarcationUtilisateur(embarcation_utilisateur_id VARCHAR)
RETURNS TABLE (
    nom VARCHAR,
    description VARCHAR,
    marque VARCHAR,
    longueur INT,
    photo VARCHAR
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        eu.nom,
        e.description,
        e.marque,
        e.longueur,
        e.photo
    FROM
        EmbarcationUtilisateur eu
    INNER JOIN
        Embarcation e ON eu.id_embarcation = e.id_embarcation
    WHERE
        eu.id_embarcation_utilisateur = embarcation_utilisateur_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION voir_details_embarcation(p_id_embarcation varchar)
RETURNS Embarcation AS $$
DECLARE
    embarcation_record Embarcation%ROWTYPE;
BEGIN
    SELECT * INTO embarcation_record FROM Embarcation WHERE id_embarcation = p_id_embarcation;
    RETURN embarcation_record;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION login(
    in_sub VARCHAR,
    in_display_name VARCHAR
) RETURNS TABLE(role VARCHAR) AS $$
BEGIN
    -- Check if the user already exists
    IF EXISTS (SELECT 1 FROM Utilisateur WHERE sub = in_sub) THEN
        -- User exists, update display_name if different
        UPDATE Utilisateur SET display_name = in_display_name WHERE sub = in_sub;
    ELSE
        -- User doesn't exist, create it
        INSERT INTO Utilisateur (sub, display_name, date_creation)
        VALUES (in_sub, in_display_name, NOW());

        -- Add role "plaisancier" to the user
        INSERT INTO UtilisateurRole (nom_role, sub)
        VALUES ('Plaisancier', in_sub);
    END IF;

    -- Return all roles for the user
    RETURN QUERY SELECT nom_role FROM UtilisateurRole WHERE sub = in_sub;
END;
$$ LANGUAGE plpgsql;


