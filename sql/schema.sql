-- ============================================================
--  Projet 1 : Gestion des Questionnaires
--  Base de données MySQL
-- ============================================================

CREATE DATABASE IF NOT EXISTS gestion_qcm CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE gestion_qcm;

-- ─── Table ETUDIANT ───────────────────────────────────────────
CREATE TABLE IF NOT EXISTS ETUDIANT (
    num_etudiant VARCHAR(20)  NOT NULL PRIMARY KEY,
    Nom          VARCHAR(100) NOT NULL,
    Prenoms      VARCHAR(100) NOT NULL,
    Niveau       ENUM('L1','L2','L3','M1','M2') NOT NULL,
    adr_email    VARCHAR(150) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ─── Table QCM ────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS QCM (
    num_quest INT          NOT NULL AUTO_INCREMENT PRIMARY KEY,
    question  TEXT         NOT NULL,
    reponse1  VARCHAR(255) NOT NULL,
    reponse2  VARCHAR(255) NOT NULL,
    reponse3  VARCHAR(255) NOT NULL,
    reponse4  VARCHAR(255) NOT NULL,
    bonne     ENUM('reponse1','reponse2','reponse3','reponse4') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ─── Table EXAMEN ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS EXAMEN (
    num_exam     INT         NOT NULL AUTO_INCREMENT PRIMARY KEY,
    num_etudiant VARCHAR(20) NOT NULL,
    Annee_univ   VARCHAR(10) NOT NULL,
    note         INT         NOT NULL DEFAULT 0,
    FOREIGN KEY (num_etudiant) REFERENCES ETUDIANT(num_etudiant) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ─── Données de test ─────────────────────────────────────────
INSERT INTO ETUDIANT VALUES
('E001','Rakoto','Jean','L2','jean.rakoto@univ.mg'),
('E002','Rabe','Marie','M1','marie.rabe@univ.mg'),
('E003','Andry','Paul','L1','paul.andry@univ.mg'),
('E004','Solo','Haja','L2','haja.solo@univ.mg'),
('E005','Tiana','Luc','M2','luc.tiana@univ.mg');

INSERT INTO QCM (question,reponse1,reponse2,reponse3,reponse4,bonne) VALUES
("Qu'est-ce qu'une variable ?","Un mot-clé","Un espace mémoire nommé","Une fonction","Un opérateur","reponse2"),
("Quelle structure permet la répétition ?","if","switch","for","return","reponse3"),
("HTML signifie ?","Hyper Text Markup Language","High Tech Modern Language","Hyper Transfer Method Link","Home Tool Markup Language","reponse1"),
("Un tableau en Java est ?","Un objet","Une primitive","Une interface","Un fichier","reponse1"),
("SQL est utilisé pour ?","Dessiner","Gérer des bases de données","Créer des images","Compiler du code","reponse2"),
("Que signifie CSS ?","Computer Style Sheets","Creative Style System","Cascading Style Sheets","Coded Style Syntax","reponse3"),
("Que signifie SGBD ?","Système de Gestion de Base de Données","Service Global de Bases","Système Général de Bases","Structure de Gestion","reponse1"),
("Un algorithme est ?","Un programme compilé","Une séquence d instructions","Un type de donnée","Un fichier exécutable","reponse2"),
("Le protocole HTTP sert à ?","Envoyer des emails","Transférer des fichiers FTP","Transférer des pages web","Gérer les DNS","reponse3"),
("L héritage en POO c est ?","Copier une classe","Une classe qui hérite d une autre","Effacer une classe","Instancier un objet","reponse2"),
("Qu est-ce qu une clé primaire ?","Un mot de passe","Un identifiant unique dans une table","Un index optionnel","Un type de jointure","reponse2"),
("Qu est-ce que le polymorphisme ?","Plusieurs classes sans relation","Un objet pouvant prendre plusieurs formes","Une variable de type mixte","Un tableau multidimensionnel","reponse2");

INSERT INTO EXAMEN (num_etudiant,Annee_univ,note) VALUES
('E001','2023-2024',7),
('E002','2023-2024',9),
('E003','2023-2024',5),
('E004','2023-2024',8),
('E005','2023-2024',10);
