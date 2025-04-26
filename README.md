# Projet SQL d'analyse des ventes au détail

## Présentation du projet

**Titre du projet** : Analyse des ventes au détail
**Niveau** : Débutant
**Base de données** : `projet_vente_detail`

Ce projet vise à démontrer les compétences et techniques SQL généralement utilisées par les analystes de données pour explorer, nettoyer et analyser les données de vente au détail. Il comprend la création d'une base de données de vente au détail, la réalisation d'analyses exploratoires de données (EDA) et la réponse à des questions métier spécifiques via des requêtes SQL. Ce projet est idéal pour ceux qui débutent dans l'analyse de données et souhaitent acquérir des bases solides en SQL.

## Objectifs

1. **Configurer une base de données de ventes au détail** : Créez et remplissez une base de données de ventes au détail avec les données de ventes fournies.
2. **Nettoyage des données** : Identifiez et supprimez tous les enregistrements contenant des valeurs manquantes ou nulles.
3. **Analyse exploratoire des données (EDA)** : Effectuer une analyse exploratoire des données de base pour comprendre l'ensemble de données.
4. **Analyse commerciale** : utilisez SQL pour répondre à des questions commerciales spécifiques et tirer des informations des données de vente.

## Structure du projet

### 1. Configuration de la base de données

- **Création de la base de données** : Le projet commence par créer une base de données nommée `bdd_projet_vente_detail`.
- **Création de table** : Une table nommée `ventes_détaillants` est créée pour stocker les données de vente. Sa structure comprend des colonnes pour : id_transaction	date_vente	temps_vente	id_client	genre	age	categorie	quantite	prix_par_unite	cout_marchise_vendu	vente_total et l'ID de transaction, la date et l'heure de la vente, l'ID client, le sexe, l'âge, la catégorie de produit, la quantité vendue, le prix unitaire, le coût des marchandises vendues et le montant total des ventes.


```sql
CREATE DATABASE bdd_projet_vente_detail;

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
```

### 2. Exploration et nettoyage des données

- **Nombre d'enregistrements** : Déterminez le nombre total d'enregistrements dans l'ensemble de données.
- **Nombre de clients** : découvrez combien de clients uniques se trouvent dans l'ensemble de données.
- **Nombre de catégories** : identifiez toutes les catégories de produits uniques dans l'ensemble de données.
- **Vérification des valeurs nulles** : vérifiez les valeurs nulles dans l'ensemble de données et supprimez les enregistrements contenant des données manquantes.

```sql
SELECT COUNT(*) FROM ventes_détaillants;
SELECT COUNT(DISTINCT id_client) FROM ventes_détaillants;
SELECT DISTINCT categorie FROM ventes_détaillants;

SELECT * FROM ventes_détaillants
WHERE 
    date_vente IS NULL OR temps_vente IS NULL OR id_client IS NULL OR 
    sexe IS NULL OR age IS NULL OR categorie IS NULL OR 
    quantite IS NULL OR prix_par_unite IS NULL OR cout_marchise_vendu IS NULL;

DELETE FROM ventes_détaillants
WHERE 
    date_vente IS NULL OR temps_vente IS NULL OR id_client IS NULL OR 
    sexe IS NULL OR age IS NULL OR categorie IS NULL OR 
    quantite IS NULL OR prix_par_unite IS NULL OR cout_marchise_vendu IS NULL;
```

### 3. Analyse des données et résultats

Les requêtes SQL suivantes ont été développées pour répondre à des questions commerciales spécifiques :

1. **Écrivez une requête SQL pour récupérer toutes les colonnes des ventes réalisées le '2022-11-05** :
```sql
SELECT *
FROM ventes_détaillants
WHERE date_vente = '2022-11-05';
```

2. **Écrivez une requête SQL pour récupérer toutes les transactions où la catégorie est « Vêtements » et la quantité vendue est supérieure à 4 au mois de novembre 2022** :
```sql
SELECT 
  *
FROM ventes_détaillants
WHERE 
    categorie = 'Vêtements'
    AND 
    TO_CHAR(date_vente, 'YYYY-MM') = '2022-11'
    AND
    quantite >= 4
```

3. **Écrivez une requête SQL pour calculer le total des ventes (vente_total) pour chaque catégorie.** :
```sql
SELECT 
    categorie,
    SUM(vente_total) as vente_nette,
    COUNT(*) as total_orders
FROM ventes_détaillants
GROUP BY 1
```

4. **Écrivez une requête SQL pour trouver l'âge moyen des clients qui ont acheté des articles de la catégorie « Beauté ».** :
```sql
SELECT
    ROUND(AVG(age), 2) as moyenne_age
FROM ventes_détaillants
WHERE categorie = 'Beauté'
```

5. **Écrivez une requête SQL pour trouver toutes les transactions où le vente_total est supérieur à 1000.** :
```sql
SELECT * FROM ventes_détaillants
WHERE vente_total > 1000
```

6. **Écrivez une requête SQL pour trouver le nombre total de transactions (transaction_id) effectuées par chaque sexe dans chaque catégorie.** :
```sql
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
```

7. **Écrivez une requête SQL pour calculer la vente moyenne mensuelle. Découvrez le mois le plus vendu chaque année** :
```sql
SELECT 
       year,
       month,
    vente_moyenne
FROM 
(    
SELECT 
    EXTRACT(YEAR FROM date_vente) as year,
    EXTRACT(MONTH FROM date_vente) as month,
    AVG(vente_total) as vente_moyenne,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM date_vente) ORDER BY AVG(vente_total) DESC) as rang
FROM ventes_détaillants
GROUP BY 1, 2
) as t1
WHERE rang = 1
```

8. **Écrivez une requête SQL pour trouver les 5 meilleurs clients en fonction des ventes totales les plus élevées** :
```sql
SELECT 
    id_client,
    SUM(vente_total) as vente_totals
FROM ventes_détaillants
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5
```

9. **Écrivez une requête SQL pour trouver le nombre de clients uniques qui ont acheté des articles de chaque catégorie.** :
```sql
SELECT 
    categorie,    
    COUNT(DISTINCT id_client) as cnt_unique_client
FROM ventes_détaillants
GROUP BY categorie
```

10. **Écrivez une requête SQL pour créer chaque quart de travail et le nombre de commandes (exemple matin < 12, après-midi entre 12 et 17, soir > 17)** :
```sql
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
```

## Résultats

- **Données démographiques des clients** : L'ensemble de données comprend des clients de différentes tranches d'âge, avec des ventes réparties dans différentes catégories telles que les vêtements et la beauté.
- **Transactions de grande valeur** : Plusieurs transactions avaient un montant de vente total supérieur à 1 000, indiquant des achats premium.
- **Tendances des ventes** : L'analyse mensuelle montre les variations des ventes, aidant à identifier les périodes de pointe.
- **Informations clients** : L'analyse identifie les clients les plus dépensiers et les catégories de produits les plus populaires.

## Rapports

- **Résumé des ventes** : Un rapport détaillé résumant les ventes totales, les données démographiques des clients et les performances de la catégorie.
- **Analyse des tendances** : Aperçu des tendances des ventes sur différents mois et périodes de travail.
- **Informations client** : Rapports sur les meilleurs clients et le nombre de clients uniques par catégorie.

## Conclusion

Ce projet constitue une introduction complète à SQL pour les analystes de données, couvrant la configuration des bases de données, le nettoyage des données, l'analyse exploratoire des données et les requêtes SQL orientées métier. Les résultats de ce projet peuvent contribuer à la prise de décisions commerciales en comprenant les tendances de vente, le comportement des clients et les performances des produits.


## Auteur - Oscar Aksanti

Ce projet fait partie de mon portfolio et met en avant les compétences SQL essentielles aux postes d'analyste de données. Pour toute question, commentaire ou souhait de collaboration, n'hésitez pas à me contacter !

### Restez informé et rejoignez la communauté

Pour plus de contenu sur SQL, l'analyse de données et d'autres sujets liés aux données, assurez-vous de me suivre sur les réseaux sociaux et de rejoindre notre communauté :

- **YouTube** : [Abonnez-vous à ma chaîne pour des tutoriels et des informations]( https://www.youtube.com/@oscaraksanti )
- **LinkedIn** : [Connectez-vous avec moi professionnellement]( [https://www.linkedin.com/in/oscar-aksanti/] )
- **Telegram** : [Rejoignez notre communauté pour apprendre et grandir ensemble]( https://t.me/ExcelPowerBiPourEntreprises )

Merci pour votre soutien et j'ai hâte de vous rencontrer !


