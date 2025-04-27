-- Analyse des ventes au détail SQL
CREATE DATABASE bdd_projet_vente_detail;


-- Création Table TABLE
DROP TABLE IF EXISTS ventes_détaillants;
CREATE TABLE ventes_détaillants
(
    id_transaction INT PRIMARY KEY,
    date_vente DATE,	
    temps_vente TIME,
    id_client INT,	
    sexe VARCHAR(10),
    age INT,
    categorie VARCHAR(35),
    quantite INT,
    prix_par_unite FLOAT,	
    cout_marchise_vendu FLOAT,
    vente_total FLOAT
);

SELECT * FROM ventes_détaillants
LIMIT 10


    

SELECT 
    COUNT(*) 
FROM ventes_détaillants

-- Netoyage des données
SELECT COUNT(*) FROM ventes_détaillants;
SELECT COUNT(DISTINCT id_client) FROM ventes_détaillants;
SELECT DISTINCT categorie FROM ventes_détaillants;

SELECT * FROM ventes_détaillants
WHERE 
    date_vente IS NULL OR temps_vente IS NULL OR id_client IS NULL OR 
    sexe IS NULL OR age IS NULL OR categorie IS NULL OR 
    quantite IS NULL OR prix_par_unite IS NULL OR cout_marchise_vendu IS NULL;

   
-- 
DELETE FROM ventes_détaillants
WHERE 
    date_vente IS NULL OR temps_vente IS NULL OR id_client IS NULL OR 
    sexe IS NULL OR age IS NULL OR categorie IS NULL OR 
    quantite IS NULL OR prix_par_unite IS NULL OR cout_marchise_vendu IS NULL;
    
-- Exploration de donnée

-- Combien de ventes avons-nous
SELECT COUNT(*) as ventes_totales FROM ventes_détaillants

-- Combien de clients uniques avons-nous ?

SELECT COUNT(DISTINCT id_client) as total_sale FROM ventes_détaillants



SELECT DISTINCT categorie FROM ventes_détaillants


-- Analyse de données et problèmes clés commerciaux et réponses

-- Mon analyse et mes conclusions
-- Q.1 Écrire une requête SQL pour récupérer toutes les colonnes des ventes réalisées le '2022-11-05'
-- Q.2 Écrire une requête SQL pour récupérer toutes les transactions de catégorie « Vêtements » et dont la quantité vendue est supérieure à 4 articles au mois de novembre 2022
-- Q.3 Écrire une requête SQL pour calculer le total des ventes (total_sale) pour chaque catégorie.
-- Q.4 Écrire une requête SQL pour connaître l'âge moyen des clients ayant acheté des articles de la catégorie « Beauté ».
-- Q.5 Écrire une requête SQL pour connaître toutes les transactions dont le total_sale est supérieur à 1 000.
-- Q.6 Écrire une requête SQL pour connaître le nombre total de transactions (transaction_id) effectuées par sexe dans chaque catégorie.
-- Q.7 Écrire une requête SQL pour calculer le chiffre d'affaires moyen pour chaque mois. Déterminer le mois le plus vendu de chaque année
-- Q.8 Écrire une requête SQL pour trouver les 5 meilleurs clients en fonction du total des ventes le plus élevé
-- Q.9 Écrire une requête SQL pour trouver le nombre de clients uniques ayant acheté des articles de chaque catégorie.
-- Q.10 Écrire une requête SQL pour créer chaque équipe et le nombre de commandes (exemple : matin <= 12, après-midi entre 12 et 17, soir > 17)


-- Q.1 Écrire une requête SQL pour récupérer toutes les colonnes des ventes réalisées le '2022-11-05'

SELECT *
FROM ventes_détaillants
WHERE temps_vente = '2022-11-05';


-- Q.2 Écrire une requête SQL pour récupérer toutes les transactions de catégorie « Vêtements » et dont la quantité vendue est supérieure à 10 articles au mois de novembre 2022

SELECT * 
FROM ventes_détaillants
WHERE 
    categorie = 'Vetements' 
    AND quantite >= 4 
    AND DATE_FORMAT(date_vente, '%Y-%m') = '2022-11';


-- Q.3 Écrire une requête SQL pour calculer le total des ventes pour chaque catégorie.

SELECT 
    categorie,
    SUM(vente_total) as vente_nette,
    COUNT(*) as total_orders
FROM ventes_détaillants
GROUP BY 1

-- Q.4 Écrire une requête SQL pour connaître l'âge moyen des clients ayant acheté des articles de la catégorie « Beauté ».

SELECT
    ROUND(AVG(age), 2) as avg_age
FROM ventes_détaillants
WHERE categorie = 'Beauté'


-- Q.5 Écrire une requête SQL pour connaître toutes les transactions dont le total_sale est supérieur à 1 000.

SELECT * FROM ventes_détaillants
WHERE vente_total > 1000


-- Q.6 Écrire une requête SQL pour connaître le nombre total de transactions (transaction_id) effectuées par sexe dans chaque catégorie.

SELECT 
    categorie,
    sexe,
    COUNT(*) as total_trans
FROM ventes_détaillants
GROUP 
    BY 
    categorie,
    sexe
ORDER BY 1


-- Q.7 Écrire une requête SQL pour calculer le chiffre d'affaires moyen pour chaque mois. Déterminer le mois le plus vendu de chaque année

SELECT 
       année,
       année,
       vente_moyenne
FROM 
(    
SELECT 
    EXTRACT(YEAR FROM date_vente) as année,
    EXTRACT(MONTH FROM date_vente) as mois,
    AVG(vente_total) as vente_moyenne,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM date_vente) ORDER BY AVG(vente_total) DESC) as rang
FROM ventes_détaillants
GROUP BY 1, 2
) as t1
WHERE rang = 1
    
-- ORDER BY 1, 3 DESC

-- Q.8 Écrire une requête SQL pour trouver les 5 meilleurs clients en fonction du total des ventes le plus élevé

SELECT 
    id_client,
    SUM(vente_total) as vente_totals
FROM ventes_détaillants
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

-- Q.9 Écrire une requête SQL pour trouver le nombre de clients uniques ayant acheté des articles de chaque catégorie.


SELECT 
    categorie,    
    COUNT(DISTINCT id_client) as cnt_unique_client
FROM ventes_détaillants
GROUP BY categorie



-- Q.10 Écrire une requête SQL pour créer chaque équipe et le nombre de commandes (exemple : matin <= 12, après-midi entre 12 et 17, soir > 17)

WITH heure_vente
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM temps_vente) < 12 THEN 'Matin'
        WHEN EXTRACT(HOUR FROM temps_vente) BETWEEN 12 AND 17 THEN 'Après-midi'
        ELSE 'Soir'
    END as shift
FROM ventes_détaillants
)
SELECT 
    shift,
    COUNT(*) as totales_commandes    
FROM heure_vente
GROUP BY shift

-- Find du projet
