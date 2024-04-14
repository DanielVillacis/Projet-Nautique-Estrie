DROP DOMAIN IF EXISTS pne_id, embarcation_id cascade;

DROP SEQUENCE IF EXISTS serial_embarcation,serial_lavage,
    serial_embarcation_utilisateur,serial_note,serial_plan_eau cascade;

DROP TYPE IF EXISTS type_lavage,niveau, type_pne_id cascade;

CREATE DOMAIN pne_id AS VARCHAR(10)
   CHECK (VALUE ~ '^[0-9]{10}$');
CREATE DOMAIN embarcation_id as VARCHAR;

CREATE SEQUENCE serial_embarcation START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE serial_lavage START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE serial_embarcation_utilisateur START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE serial_note START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE serial_plan_eau START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE serial_mise_eau START WITH 1 INCREMENT BY 1;

CREATE TYPE type_lavage AS ENUM ('eau chaude avec pression', 'eau froide avec pression', 'eau chaude sans pression, eau froide sans pression');
CREATE TYPE niveau AS ENUM ('vert','jaune','rouge');
CREATE TYPE type_pne_id AS ENUM ('serial_embarcation','serial_lavage',
    'serial_embarcation_utilisateur','serial_note','serial_plan_eau','serial_mise_eau');

CREATE TABLE IF NOT EXISTS Utilisateur (
   	sub VARCHAR PRIMARY KEY,
   	display_name VARCHAR NOT NULL,
   	date_creation TIMESTAMP NOT NULL
);

CREATE TABLE IF NOT EXISTS Embarcation (
   	id_embarcation embarcation_id PRIMARY KEY,
	description VARCHAR NOT NULL,
	marque VARCHAR(255) NOT NULL,
	longueur INT NOT NULL,
	photo VARCHAR(255) NOT NULL
);
CREATE TABLE IF NOT EXISTS EmbarcationUtilisateur (
   	id_embarcation embarcation_id REFERENCES Embarcation(id_embarcation),
   	nom VARCHAR NOT NULL,
   	sub VARCHAR REFERENCES Utilisateur(sub),
	id_embarcation_utilisateur pne_id PRIMARY KEY
);
CREATE TABLE IF NOT EXISTS Lavage (
   	id_embarcation embarcation_id REFERENCES Embarcation(id_embarcation),
   	type_lavage type_lavage NOT NULL,
   	date TIMESTAMP NOT NULL,
   	self_serve boolean NOT NULL,
	id_lavage pne_id PRIMARY KEY
);
CREATE TABLE IF NOT EXISTS PlanEau (
   	niveau_couleur niveau NOT NULL,
   	emplacement geometry(POINT) NOT NULL,
	id_plan_eau pne_id PRIMARY KEY,
	nom VARCHAR NOT NULL
);
CREATE TABLE IF NOT EXISTS NoteDossier (
   	id_embarcation_utilisateur pne_id references EmbarcationUtilisateur(id_embarcation_utilisateur),
	id_plan_eau pne_id REFERENCES PlanEau(id_plan_eau),
   	date TIMESTAMP NOT NULL,
	note varchar NOT NULL,
	idNote pne_id PRIMARY KEY
);
CREATE TABLE IF NOT EXISTS CodeUnique (
   	code_unique varchar PRIMARY KEY,
   	id_plan_eau pne_id REFERENCES PlanEau(id_plan_eau)
);

CREATE TABLE IF NOT EXISTS Certification (
   	code_certification varchar PRIMARY KEY,
   	nom_formation varchar NOT NULL
);
CREATE TABLE IF NOT EXISTS EmployeCertification (
   	code_certification varchar REFERENCES Certification(code_certification),
   	sub VARCHAR REFERENCES Utilisateur(sub),
	CONSTRAINT employeCerticication_pk PRIMARY KEY (sub, code_certification)
);
CREATE TABLE IF NOT EXISTS Role (
   	nom_role VARCHAR PRIMARY KEY,
   	description VARCHAR NOT NULL
);
CREATE TABLE IF NOT EXISTS UtilisateurRole (
   	nom_role VARCHAR REFERENCES Role(nom_role),
   	sub VARCHAR REFERENCES Utilisateur(sub),
	CONSTRAINT utilisateurRole_pk PRIMARY KEY (sub, nom_role)
);
CREATE TABLE IF NOT EXISTS MiseAEau (
    id_mise_eau pne_id PRIMARY KEY,
    date DATE NOT NULL,
    id_plan_eau pne_id REFERENCES PlanEau(id_plan_eau),
    id_embarcation_utilisateur pne_id references EmbarcationUtilisateur(id_embarcation_utilisateur),
    id_embarcation embarcation_id NOT NULL
);
INSERT INTO Role(nom_role, description) VALUES ('Plaisancier','Tout compte par défaut est plaisancier.' ||
                                                              ' Ceci permet de laver une embarcation, faire une mise à l''eau, entre autre');

INSERT INTO Role(nom_role, description) VALUES ('EmployeLavage','Tout employé qui peut faire des lavages d''embarcations.');