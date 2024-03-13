DROP DOMAIN IF EXISTS noPermis;

CREATE DOMAIN noPermis AS VARCHAR(9)
  CHECK (length(VALUE) = 9);

CREATE TABLE IF NOT EXISTS Utilisateur (
   	sub VARCHAR PRIMARY KEY,
   	prenom VARCHAR,
   	nom VARCHAR,
   	dateCreation TIMESTAMP NOT NULL
);

CREATE TABLE IF NOT EXISTS Embarcation (
   	idEmbarcation serial PRIMARY KEY,
	numeroPermis noPermis,
	description VARCHAR NOT NULL,
	marque VARCHAR(255) NOT NULL,
	longueur INT NOT NULL,
	photo VARCHAR(255) NOT NULL
);
CREATE TABLE IF NOT EXISTS EmbarcationUtilisateur (
   	idEmbarcation serial REFERENCES Embarcation(idEmbarcation),
   	sub VARCHAR REFERENCES Utilisateur(sub),
	idEmbarcationUtilisteur serial PRIMARY KEY
);
CREATE TABLE IF NOT EXISTS Lavage (
   	idEmbarcation serial REFERENCES Embarcation(idEmbarcation),
   	typeLavage typeLavage NOT NULL,
   	date TIMESTAMP NOT NULL,
   	selfServe boolean NOT NULL,
	idLavage serial PRIMARY KEY
);
CREATE TABLE IF NOT EXISTS PlanEau (
   	niveauCouleur niveau NOT NULL,
   	emplacement geometry(POINT) NOT NULL,
	idPlanEau serial PRIMARY KEY
);
CREATE TABLE IF NOT EXISTS NoteDossier (
   	idEmbarcationUtilisateur serial references EmbarcationUtilisateur(idEmbarcationUtilisteur),
	idPlanEau serial REFERENCES PlanEau(idPlanEau),
   	date TIMESTAMP NOT NULL,
	note varchar NOT NULL,
	idNote serial PRIMARY KEY
);
CREATE TABLE IF NOT EXISTS CodeUnique (
   	codeUnique varchar PRIMARY KEY,
   	idPlanEau serial REFERENCES PlanEau(idPlanEau)
);

CREATE TABLE IF NOT EXISTS Certification (
   	idCertification serial PRIMARY KEY,
   	nomFormation varchar NOT NULL
);
CREATE TABLE IF NOT EXISTS EmployeCertification (
   	idCertification serial REFERENCES Certification(idCertification),
   	sub VARCHAR REFERENCES Utilisateur(sub),
	CONSTRAINT employeCerticication_pk PRIMARY KEY (sub, idCertification)
);
CREATE TABLE IF NOT EXISTS Role (
   	nomRole VARCHAR PRIMARY KEY,
   	description VARCHAR NOT NULL
);
CREATE TABLE IF NOT EXISTS UtilisateurRole (
   	nomRole VARCHAR REFERENCES Role(nomRole),
   	sub VARCHAR REFERENCES Utilisateur(sub),
	CONSTRAINT utilisateurRole_pk PRIMARY KEY (sub, nomRole)
);
CREATE TABLE IF NOT EXISTS MiseAEau (
    idMiseAEau serial PRIMARY KEY,
    date DATE,
    idPlanEau serial REFERENCES PlanEau(idPlanEau),
    idEmbarcationUtilisateur serial references EmbarcationUtilisateur(idEmbarcationUtilisteur)
);


