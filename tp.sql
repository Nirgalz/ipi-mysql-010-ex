#EX01 ====================================================================================================
#1) Créer une base de données nommée 'entreprise'.

CREATE DATABASE entreprise;

#2) Mettre la base entreprise par défaut pour la session

USE entreprise;

#3) Voir quel encodage et collation sont utilisés dans cette base

SELECT @@character_set_database, @@collation_database;

#4) Changer l'encodage et la collation pour qu'ils se basent sur UTF8

ALTER DATABASE entreprise CHARACTER SET = 'utf8' COLLATE = 'utf8_general_ci';



#=========================================================================================================


#EX02 ====================================================================================================
#1) Créer un table Employe avec : 
#une clé primaire nommée 'id' qui s'auto-incrémente
#une date d'embauche 'dateEmbauche' permettant de stocker le jour de l'embauche d'un employé (sans l'heure)
#un matricule 'matricule' permettant de stocker 6 caractères alpha-numériques.
#un nom 'nom' permettant de stocker 50 caractères alpha-numériques.
#un prenom 'prenom' permettant de stocker 10 caractères alpha-numériques.
#un salaire 'salaire' permettant de stocker des salaires jusqu'à 1234567,89 €
#un champ 'test' permettant de stocker 120 caractères.

CREATE TABLE employes (
	id INT NOT NULL AUTO_INCREMENT,
    dateEmbauche DATE NOT NULL,
    matricule VARCHAR(6),
    nom VARCHAR(50),
    prenom VARCHAR(10),
    salaire DECIMAL(9,2),
    test VARCHAR(120),
    PRIMARY KEY (id)
);


#=========================================================================================================


#EX03 ====================================================================================================
#Modifier la table Employe : 
#1) Supprimer le champ 'test'

ALTER TABLE employes
DROP column employes.test;

#2) Ajouter une colonne 'tempsPartiel' de type booléen avec comme valeur par défaut false, après la date d'embauche

ALTER TABLE employes
ADD COLUMN tempsPartiel boolean DEFAULT false AFTER dateEmbauche;

#3) Ajouter une colonne 'sexe' permettant de stocker 'M'ou 'F' avec comme valeur par défaut 'M', après le prénom

ALTER TABLE employes
ADD COLUMN sexe VARCHAR(1) DEFAULT 'M' CHECK (sexe = 'M' || sexe = 'F') AFTER prenom ;

#4) Modifier la colonne 'prenom' pour pouvoir stocker 50 caractères et refuser une valeur nulle

ALTER TABLE employes
MODIFY COLUMN prenom VARCHAR(50) NOT NULL;

#5) Modifier la colonne 'nom' pour refuser une valeur nulle

ALTER TABLE employes
MODIFY COLUMN nom VARCHAR(50) NOT NULL;

#=========================================================================================================


#EX04 ====================================================================================================
#1) Ajouter une contrainte d'unicité nommée matricule_unique sur la colonne matricule

ALTER TABLE employes
ADD CONSTRAINT matricule_unique UNIQUE (matricule);
#=========================================================================================================


#EX05 ====================================================================================================
#1) Insérer Vincent Scheider, matricule C11106, embauché le 1er janvier 2001 à 1180,27 €


INSERT INTO employes (prenom,nom,sexe,matricule,dateEmbauche,salaire)
VALUES ('Vincent', 'Scheinder', 'M', 'C11106', '2001-01-01', 1180.27);

#2) Insérer Victor Gaillard, matricule M11109, embauché à temps partiel le 4 avril 2004 à 1480,30 €

INSERT INTO employes (prenom,nom,sexe,tempsPartiel, matricule,dateEmbauche,salaire)
VALUES ('Victor', 'Gaillard', 'M', true, 'M11109', '2004-04-04', 1480.30);

#3) Insérer Clémence Roussel, matricule T11101, embauchée le 4 avril 2004 à 1680,32 €

INSERT INTO employes (prenom,nom, sexe, matricule,dateEmbauche,salaire)
VALUES ('Clémence', 'Roussel', 'F', 'T11101', '2004-04-04', 1680.32);


#=========================================================================================================


#EX06 ====================================================================================================
#1) Exécuter le script d'import des employés employes.sql
#mysql -u root -proot -D entreprise < employes.sql
#2) Récupérer tous les employés

SELECT * FROM employes;

#3) Compter le nombre d'employés (2503)

SELECT count(*) FROM employes;

#4) Récupérer les employés qui gagnent plus de 1500 € (1665)

SELECT count(*) 
FROM employes
WHERE salaire > 1500;

#5) Récupérer les employés dans l'ordre décroissant de leur matricule (Clémence Roussel en premier)

SELECT * 
FROM employes
ORDER BY matricule DESC;

#6) Récupérer toutes les femmes de l'entreprise (1254)

SELECT *
FROM employes
WHERE sexe = 'F';

#7) Récupérer tous les employés à temps partiel embauchés après le 1er janvier 2007 (1244)

SELECT count(*)
FROM employes
WHERE tempsPartiel = 1 AND dateEmbauche > '2007-01-01';

#8) En une seule requête, compter le nombre de femme et d'homme de l'entreprise. (M : 1249, F : 1254)

SELECT count(*)
FROM employes
GROUP BY sexe;

#9) Récupérer le nombre d'embauche par année : 
#2001:1
#2004:1
#2006:1
#2010:420
#2011:435
#2012:413
#2013:439
#2014:408
#2015:385

SELECT count(year(dateEmbauche))
FROM employes
GROUP BY year(dateEmbauche);

#10) Récupérer le nombre de techniciens (matricule qui commence par T), le nombre de commerciaux (matricule commencant par C) et le nombre de managers (matricule commençant par M)
#C:432
#M:420
#T:1651

SELECT count(*)
FROM employes
GROUP BY substr(matricule,1,1);


#11) Récupérer le nombre de personnes à temps partiel et à temps plein
#0:1259
#1:1244

SELECT count(*)
FROM employes
GROUP BY tempsPartiel;

#12) Récupérer tous les employés dont le prénom contient un M (majuscule ou minuscule) (738)

SELECT count(*) 
FROM employes
WHERE prenom LIKE '%m%';

#13) Récupérer le salaire minimum, maximum et moyen de tous les employés
#1000.00, 2500.00, 1749.790208

SELECT min(salaire), max(salaire), avg(salaire)
FROM employes;
#=========================================================================================================


#EX07 ====================================================================================================
#1) Faire passer le technicien de matricule T00027 à mi-temps (et donc diviser son salaire par 2...)
#Temps partiel : TRUE, salaire : 511.50

UPDATE employes
set tempsPartiel = TRUE, salaire = 511.50
WHERE matricule = 'T00027';

SELECT tempsPartiel, salaire
FROM employes
WHERE matricule = 'T00027';

#=========================================================================================================


#EX08 ====================================================================================================
#1) Licencier l'employé T00115

DELETE FROM employes
WHERE matricule = 'T00115';

#2) Licencier les 5 commerciaux qui gagnent le plus d'argent

DELETE FROM employes
WHERE matricule IN (
SELECT matricule
FROM employes
WHERE matricule LIKE 'C%'
ORDER BY salaire DESC
LIMIT 5);


SELECT matricule
FROM employes
WHERE matricule LIKE 'C%'
ORDER BY salaire DESC
LIMIT 5;

#ID: 1540, 1211, 2359, 1668, 1748
#=========================================================================================================


#EX09 ====================================================================================================
#1) Effectuer une recherche sur une date d'embauche existante, noter le temps d'exécution de la requête

#2) Créer un index sur la table Employe, sur le champ dateEmbauche

#3) Supprimer le cache (RESET QUERY CACHE;) et refaire la recherche et comparer les résultats

#=========================================================================================================


#EX10 ====================================================================================================
#1) Créer la table Commercial avec :
#un champ 'id' qui référence l'identifiant de la table Employe et qui ne peut être nul (et permet la suppression en cascade)
#un champ 'caAnnuel' qui contiendra le chiffre d'affaire annuel du commercial par défaut à 0, max : 99999999,99 €
#un champ 'performance' contenant un entier par défaut à 0

#2) Créer la table Manager avec :
#un champ 'id' qui référence l'identifiant de la table Employe et qui ne peut être nul (et permet la suppression en cascade)
#un champ 'performance' qui permet de stocker un entier

#3) Créer la table Technicien avec
#un champ 'id' qui référence l'identifiant de la table Employe et qui ne peut être nul (et permet la suppression en cascade)
#un champ 'grade' contenant un entier par défaut à 1
#un champ manager_id qui référence Manager

#=========================================================================================================


#EX11 ====================================================================================================
#1) Insérer une ligne dans la table Commercial pour chaque employé dont le matricule correspond à un commercial (427)

#2) Insérer une ligne dans la table Manager pour chaque employé dont le matricule correspond à un manager et avec une performance aléatoire entre 1 et 10 (420)

#3) Insérer une ligne dans la table Technicien pour chaque employé dont le matricule correspond à un technicien, 
#un grade en fonction de son salaire:
#<1100 : 1 (98)
#<1200 : 2 (119)
#<1300 : 3 (110)
#<1400 : 4 (105)
#>=1400 : 5 (1218)

#=========================================================================================================


#EX12 ====================================================================================================
#1) Ecrire de 4 manières différentes une jointure entre Commercial et Employe

#=========================================================================================================


#EX13 ====================================================================================================
#1) Récupérer les employés dont le salaire est supérieur au salaire moyen des employés (1247)

#2) Récupérer les managers sans équipe

#3) Licencier les commerciaux sans équipe

#=========================================================================================================


#EX14 ====================================================================================================
#1) Récupérer les informations générales des employés manager et des employés techniciens de grade 5

#=========================================================================================================

#EX15 ====================================================================================================
#1) Supprimer tous les techniciens, commerciaux et managers et refaire l'exercice 11 en utilisant une procédure stockée 
#et des curseurs. Affecter aux techniciens un manager en répartissant le plus équitablement possible les équipes...

#=========================================================================================================


#EX16 ====================================================================================================
#1) Supprimer les managers sans équipe (6)

#2) Constater la suppression dans la table Employe et Commercial

#C'est fini !