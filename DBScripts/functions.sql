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

CREATE OR REPLACE FUNCTION login2(
    in_sub VARCHAR,
    in_display_name VARCHAR
) RETURNS TABLE(role VARCHAR, dernier_lavage VARCHAR[][]) AS $$
DECLARE
    v_embarcations VARCHAR[][] := '{}';
    v_embarcation_utilisateur pne_id;
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

    -- Fetch all roles for the user
    SELECT ARRAY(SELECT nom_role FROM UtilisateurRole WHERE sub = in_sub) INTO role;

    -- Get the id_embarcation_utilisateur
    SELECT id_embarcation_utilisateur INTO v_embarcation_utilisateur
    FROM EmbarcationUtilisateur
    WHERE sub = in_sub;

    -- Fetch the last lavage for each embarcation
    SELECT ARRAY_AGG(ARRAY[E.id_embarcation, L.date]::VARCHAR[])
    INTO v_embarcations
    FROM EmbarcationUtilisateur EU
    INNER JOIN Lavage L ON EU.id_embarcation = L.id_embarcation
    INNER JOIN Embarcation E ON EU.id_embarcation = E.id_embarcation
    WHERE EU.sub = in_sub
    GROUP BY E.id_embarcation;

    RETURN NEXT;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION add_lavage(
    p_type_lavage type_lavage,
    p_id_embarcation_utilisateur pne_id,
    p_code_unique character varying,
    p_self_serve boolean
) RETURNS text
LANGUAGE plpgsql
AS $$
DECLARE
    v_id_embarcation VARCHAR;
BEGIN
    -- Fetch the corresponding id_embarcation from EmbarcationUtilisateur
    SELECT id_embarcation INTO v_id_embarcation
    FROM EmbarcationUtilisateur
    WHERE id_embarcation_utilisateur = p_id_embarcation_utilisateur;

    IF NOT FOUND THEN
        RETURN 'EmbarcationUtilisateur non trouvé';
    END IF;

    -- Check if the code_unique exists in the CodeUnique table
    IF NOT EXISTS (SELECT 1 FROM CodeUnique WHERE code_unique = p_code_unique) THEN
        RETURN 'Pas de code unique correspondant';
    END IF;

    -- Check if the code_unique has already been used for lavage
    IF EXISTS (SELECT 1 FROM CodeUnique WHERE code_unique = p_code_unique AND utilisePourLavage = TRUE) THEN
        RETURN 'Code déjà utilisé pour lavage';
    END IF;

    -- Update utilisepourmiseeau to true
    UPDATE CodeUnique SET utilisepourlavage = TRUE WHERE code_unique = p_code_unique;

    -- Add a new lavage
    INSERT INTO Lavage(id_lavage, type_lavage, id_embarcation, date, self_serve)
    VALUES (creer_pne_id('serial_lavage'), p_type_lavage, v_id_embarcation, NOW(), p_self_serve);

    -- Return the id_embarcation
    RETURN v_id_embarcation;
END;
$$;



CREATE OR REPLACE FUNCTION add_lavage_no_remove(
    p_type_lavage type_lavage,
    p_id_embarcation_utilisateur pne_id,
    p_code_unique character varying,
    p_self_serve boolean
) RETURNS text
LANGUAGE plpgsql
AS $$
DECLARE
    v_id_embarcation VARCHAR;
BEGIN
    -- Fetch the corresponding id_embarcation from EmbarcationUtilisateur
    SELECT id_embarcation INTO v_id_embarcation
    FROM EmbarcationUtilisateur
    WHERE id_embarcation_utilisateur = p_id_embarcation_utilisateur;

    IF NOT FOUND THEN
        RETURN 'EmbarcationUtilisateur non trouvé';
    END IF;

    -- Check if the code_unique exists in the CodeUnique table
    IF NOT EXISTS (SELECT 1 FROM CodeUnique WHERE code_unique = p_code_unique) THEN
        RETURN 'Pas de code unique correspondant';
    END IF;

    -- Check if the code_unique has already been used for lavage
    IF EXISTS (SELECT 1 FROM CodeUnique WHERE code_unique = p_code_unique AND utilisePourLavage = TRUE) THEN
        RETURN 'Code déjà utilisé pour lavage';
    END IF;

    -- Add a new lavage
    INSERT INTO Lavage(id_lavage, type_lavage, id_embarcation, date, self_serve)
    VALUES (creer_pne_id('serial_lavage'), p_type_lavage, v_id_embarcation, NOW(), p_self_serve);

    -- Return the id_embarcation
    RETURN v_id_embarcation;
END;
$$;


CREATE FUNCTION add_mise_eau(p_plan_eau pne_id, p_id_embarcationutilisateur pne_id, p_code_unique character varying)
RETURNS TEXT
LANGUAGE plpgsql
AS $$
DECLARE
    v_id_embarcation VARCHAR;
BEGIN
    -- Check if the code_unique exists in the CodeUnique table
    IF NOT EXISTS (SELECT 1 FROM CodeUnique WHERE code_unique = p_code_unique) THEN
        RETURN 'Pas de code unique correspondant';
    END IF;

    -- Check if the code_unique has already been used for mise eau
    IF EXISTS (SELECT 1 FROM CodeUnique WHERE code_unique = p_code_unique AND utilisepourmiseeau = TRUE) THEN
        RETURN 'Code déjà utilisé pour une mise a l''eau';
    END IF;

    -- Update utilisepourmiseeau to true
    UPDATE CodeUnique SET utilisepourmiseeau = TRUE WHERE code_unique = p_code_unique;

    -- Get the id_embarcation from EmbarcationUtilisateur
    SELECT id_embarcation INTO v_id_embarcation
    FROM EmbarcationUtilisateur
    WHERE id_embarcation_utilisateur = p_id_embarcationutilisateur;

    -- Add a new Miseaeau
    INSERT INTO miseaeau(id_mise_eau, date, id_plan_eau, id_embarcation_utilisateur, id_embarcation)
    VALUES (creer_pne_id('serial_mise_eau'), NOW(), p_plan_eau, p_id_embarcationUtilisateur, v_id_embarcation);

    -- Return success message
    RETURN 'Mise a l''eau ajouté avec succès';
END;
$$;



CREATE FUNCTION add_mise_eau_no_remove(p_plan_eau pne_id, p_id_embarcationutilisateur pne_id, p_code_unique character varying)
RETURNS TEXT
LANGUAGE plpgsql
AS $$
DECLARE
    v_id_embarcation VARCHAR;
BEGIN
    -- Check if the code_unique exists in the CodeUnique table
    IF NOT EXISTS (SELECT 1 FROM CodeUnique WHERE code_unique = p_code_unique) THEN
        RETURN 'Pas de code unique correspondant';
    END IF;

    -- Check if the code_unique has already been used for mise eau
    IF EXISTS (SELECT 1 FROM CodeUnique WHERE code_unique = p_code_unique AND utilisepourmiseeau = TRUE) THEN
        RETURN 'Code déjà utilisé pour une mise a l''eau';
    END IF;

    -- Get the id_embarcation from EmbarcationUtilisateur
    SELECT id_embarcation INTO v_id_embarcation
    FROM EmbarcationUtilisateur
    WHERE id_embarcation_utilisateur = p_id_embarcationutilisateur;

    -- Add a new Miseaeau
    INSERT INTO miseaeau(id_mise_eau, date, id_plan_eau, id_embarcation_utilisateur, id_embarcation)
    VALUES (creer_pne_id('serial_mise_eau'), NOW(), p_plan_eau, p_id_embarcationUtilisateur, v_id_embarcation);

    -- Return success message
    RETURN 'Mise a l''eau ajouté avec succès';
END;
$$;

CREATE OR REPLACE FUNCTION get_last_lavage(
    in_sub VARCHAR
) RETURNS VARCHAR[][] AS $$
DECLARE
    v_id_embarcation_utilisateurs VARCHAR[];
    v_id_embarcation_utilisateur VARCHAR;
    v_result VARCHAR[][] := '{}'; -- Initialize as two-dimensional array
    v_embarcation_id VARCHAR;
    v_last_lavage TIMESTAMP;
BEGIN
    -- Get all id_embarcation_utilisateur for the given sub
    SELECT ARRAY_AGG(id_embarcation_utilisateur) INTO v_id_embarcation_utilisateurs
    FROM EmbarcationUtilisateur
    WHERE sub = in_sub;

    -- Loop through each id_embarcation_utilisateur
    FOREACH v_id_embarcation_utilisateur IN ARRAY v_id_embarcation_utilisateurs
    LOOP
        -- Fetch the last lavage for each embarcation associated with the utilisateur
        FOR v_embarcation_id, v_last_lavage IN
            SELECT CAST(E.id_embarcation AS VARCHAR), MAX(L.date)::TIMESTAMP
            FROM Embarcation E
            LEFT JOIN Lavage L ON E.id_embarcation = L.id_embarcation
            WHERE E.id_embarcation IN (
                SELECT EU.id_embarcation
                FROM EmbarcationUtilisateur EU
                WHERE EU.id_embarcation_utilisateur = v_id_embarcation_utilisateur
            )
            GROUP BY E.id_embarcation
        LOOP
            -- Append each row as an element of the two-dimensional array
            v_result := v_result || ARRAY[ARRAY[v_embarcation_id, v_last_lavage::VARCHAR]];
        END LOOP;
    END LOOP;

    RETURN v_result;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION get_last_mise_a_eau(
    in_sub VARCHAR
) RETURNS VARCHAR[][] AS $$
DECLARE
    v_id_embarcation_utilisateurs VARCHAR[];
    v_id_embarcation_utilisateur VARCHAR;
    v_result VARCHAR[][] := '{}'; -- Initialize as two-dimensional array
    v_embarcation_id VARCHAR;
    v_last_mise_a_eau TIMESTAMP;
BEGIN
    -- Get all id_embarcation_utilisateur for the given sub
    SELECT ARRAY_AGG(id_embarcation_utilisateur) INTO v_id_embarcation_utilisateurs
    FROM EmbarcationUtilisateur
    WHERE sub = in_sub;

    -- Loop through each id_embarcation_utilisateur
    FOREACH v_id_embarcation_utilisateur IN ARRAY v_id_embarcation_utilisateurs
    LOOP
        -- Fetch the last mise a l'eau for each embarcation associated with the utilisateur
        FOR v_embarcation_id, v_last_mise_a_eau IN
            SELECT E.id_embarcation, MAX(M.date)::TIMESTAMP
            FROM Embarcation E
            LEFT JOIN miseaeau M ON E.id_embarcation = M.id_embarcation
            WHERE E.id_embarcation IN (
                SELECT EU.id_embarcation
                FROM EmbarcationUtilisateur EU
                WHERE EU.id_embarcation_utilisateur = v_id_embarcation_utilisateur
            )
            GROUP BY E.id_embarcation
        LOOP
            -- Append each row as an element of the two-dimensional array
            v_result := v_result || ARRAY[ARRAY[v_embarcation_id, v_last_mise_a_eau::VARCHAR]];
        END LOOP;
    END LOOP;

    RETURN v_result;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION login2(
    in_sub VARCHAR,
    in_display_name VARCHAR
) RETURNS TABLE(role VARCHAR, last_lavage VARCHAR[][]) AS $$
DECLARE
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

    -- Get the last lavage for the user
    RETURN QUERY SELECT * FROM get_last_lavage(in_sub);
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION login3(
    in_sub VARCHAR,
    in_display_name VARCHAR
) RETURNS TABLE(roles VARCHAR[], last_lavage VARCHAR[][], last_mise_a_eau VARCHAR[][]) AS $$
DECLARE
    v_roles VARCHAR[];
    v_last_lavage_result VARCHAR[][];
    v_last_mise_a_eau_result VARCHAR[][];
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

    -- Fetch all roles for the user and store them in an array
    SELECT ARRAY_AGG(nom_role) INTO v_roles
    FROM UtilisateurRole
    WHERE sub = in_sub;

    -- Execute the get_last_lavage function and store the result
    SELECT get_last_lavage(in_sub) INTO v_last_lavage_result;

    -- Execute the get_last_mise_a_eau function and store the result
    SELECT get_last_mise_a_eau(in_sub) INTO v_last_mise_a_eau_result;

    -- Return the array of roles and the result of get_last_lavage and get_last_mise_a_eau functions
    RETURN QUERY SELECT v_roles, v_last_lavage_result, v_last_mise_a_eau_result;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_last_lavage2(
    in_sub VARCHAR
) RETURNS TABLE(
    id_embarcation VARCHAR,
    last_lavage TIMESTAMP
) AS $$
DECLARE
    v_id_embarcation_utilisateurs VARCHAR[];
    v_id_embarcation_utilisateur VARCHAR;
BEGIN
    -- Get all id_embarcation_utilisateur for the given sub
    SELECT ARRAY_AGG(id_embarcation_utilisateur) INTO v_id_embarcation_utilisateurs
    FROM EmbarcationUtilisateur
    WHERE sub = in_sub;

    -- Loop through each id_embarcation_utilisateur
    FOREACH v_id_embarcation_utilisateur IN ARRAY v_id_embarcation_utilisateurs
    LOOP
        -- Return the last lavage for each embarcation associated with the utilisateur
        RETURN QUERY
        SELECT CAST(E.id_embarcation AS VARCHAR), MAX(L.date) AS last_lavage
        FROM Embarcation E
        LEFT JOIN Lavage L ON E.id_embarcation = L.id_embarcation
        WHERE E.id_embarcation IN (
            SELECT EU.id_embarcation
            FROM EmbarcationUtilisateur EU
            WHERE EU.id_embarcation_utilisateur = v_id_embarcation_utilisateur
        )
        GROUP BY E.id_embarcation;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_last_mise_a_eau2(
    in_sub VARCHAR
) RETURNS TABLE(
    id_embarcation VARCHAR,
    last_mise_a_eau TIMESTAMP
) AS $$
DECLARE
    v_id_embarcation_utilisateurs VARCHAR[];
    v_id_embarcation_utilisateur VARCHAR;
BEGIN
    -- Get all id_embarcation_utilisateur for the given sub
    SELECT ARRAY_AGG(id_embarcation_utilisateur) INTO v_id_embarcation_utilisateurs
    FROM EmbarcationUtilisateur
    WHERE sub = in_sub;

    -- Loop through each id_embarcation_utilisateur
    FOREACH v_id_embarcation_utilisateur IN ARRAY v_id_embarcation_utilisateurs
    LOOP
        -- Return the last mise a l'eau for each embarcation associated with the utilisateur
        RETURN QUERY
        SELECT CAST(E.id_embarcation AS VARCHAR), MAX(M.date)::TIMESTAMP AS last_mise_a_eau
        FROM Embarcation E
        LEFT JOIN MiseAEau M ON E.id_embarcation = M.id_embarcation
        WHERE E.id_embarcation IN (
            SELECT EU.id_embarcation
            FROM EmbarcationUtilisateur EU
            WHERE EU.id_embarcation_utilisateur = v_id_embarcation_utilisateur
        )
        GROUP BY E.id_embarcation;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

