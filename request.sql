SELECT nom_personnage
FROM personnage

SELECT nom_personnage, id_personnage
FROM personnage
WHERE id_lieu = 1
ORDER BY nom_personnage

/*Request 1*/
SELECT nom_lieu FROM lieu
WHERE nom_lieu LIKE '%um'

/*Request 2*/
SELECT personnage.id_lieu, lieu.nom_lieu, COUNT(nom_personnage) FROM personnage 
INNER JOIN lieu ON personnage.id_lieu = lieu.id_lieu
GROUP BY personnage.id_lieu
ORDER BY COUNT(nom_personnage) DESC

/*Request 3*/
SELECT nom_personnage, specialite.nom_specialite , adresse_personnage, lieu.nom_lieu FROM personnage 
INNER JOIN specialite ON personnage.id_specialite = specialite.id_specialite
INNER JOIN lieu ON personnage.id_lieu = lieu.id_lieu
GROUP BY lieu.nom_lieu
ORDER BY lieu.nom_lieu

SELECT nom_personnage, specialite.nom_specialite , adresse_personnage, lieu.nom_lieu FROM personnage 
INNER JOIN specialite ON personnage.id_specialite = specialite.id_specialite
INNER JOIN lieu ON personnage.id_lieu = lieu.id_lieu
GROUP BY nom_personnage
ORDER BY nom_personnage

/*Request 4*/
SELECT nom_specialite, COUNT(personnage.id_personnage) FROM specialite
INNER JOIN personnage ON specialite.id_specialite = personnage.id_specialite
GROUP BY nom_specialite
ORDER BY COUNT(personnage.id_personnage) DESC

/*Request 5*/
SELECT nom_bataille, DATE_FORMAT(date_bataille, "%d %m %Y"), lieu.nom_lieu FROM bataille
INNER JOIN lieu ON bataille.id_lieu = lieu.id_lieu
GROUP BY date_bataille
ORDER BY date_bataille desc

/*Request 6*/
SELECT nom_potion, SUM(ingredient.cout_ingredient*composer.qte) AS cout_potion 
FROM potion
INNER JOIN composer ON potion.id_potion = composer.id_potion
INNER JOIN ingredient ON composer.id_ingredient = ingredient.id_ingredient
GROUP BY nom_potion
ORDER BY cout_potion DESC

/*Request 7*/
SELECT nom_ingredient, cout_ingredient, composer.qte 
FROM ingredient
INNER JOIN composer ON ingredient.id_ingredient = composer.id_ingredient
INNER JOIN potion ON composer.id_potion = potion.id_potion
WHERE potion.id_potion = 3

/*Request 8*/ /*Doute*/
SELECT personnage.nom_personnage, max(qte)
FROM prendre_casque
RIGHT JOIN personnage ON prendre_casque.id_personnage = personnage.id_personnage
WHERE id_bataille = 1
GROUP BY qte
ORDER BY qte DESC

/*Request 9*/ 
SELECT personnage.nom_personnage, potion.nom_potion, dose_boire
FROM boire
INNER JOIN personnage ON boire.id_personnage = personnage.id_personnage
INNER JOIN potion ON boire.id_potion = potion.id_potion
GROUP BY dose_boire
ORDER BY dose_boire DESC
