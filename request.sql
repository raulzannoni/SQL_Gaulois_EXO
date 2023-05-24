/*-----EXAMPLE----*/
SELECT nom_personnage
FROM personnage

/*-----EXAMPLE----*/
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

/*Request 8*/ /*Quentin correction*/
SELECT p.nom_personnage, SUM(pc.qte) AS nb_casques
FROM personnage p, bataille b, prendre_casque pc
WHERE p.id_personnage = pc.id_personnage AND pc.id_bataille = b.id_bataille AND b.nom_bataille = 'Bataille du village gaulois'
GROUP BY p.id_personnage
HAVING nb_casques >= ALL(
	SELECT SUM(pc.qte)
	FROM prendre_casque pc, bataille b
	WHERE b.id_bataille = pc.id_bataille AND b.nom_bataille = 'Bataille du village gaulois'
	GROUP BY pc.id_personnage
	)

/*Request 9*/ 
SELECT personnage.nom_personnage, potion.nom_potion, dose_boire
FROM boire
INNER JOIN personnage ON boire.id_personnage = personnage.id_personnage
INNER JOIN potion ON boire.id_potion = potion.id_potion
ORDER BY dose_boire DESC

/*Request 10*/ /*Correction*/
SELECT b.nom_bataille , SUM(pc.qte) AS total
FROM prendre_casque pc, bataille b
WHERE pc.id_bataille = b.id_bataille
GROUP BY b.nom_bataille
HAVING total >= ALL (
	SELECT SUM(pc.qte)
	FROM prendre_casque pc, bataille b
	WHERE pc.id_bataille = b.id_bataille
	GROUP BY b.nom_bataille
	)

/*Request 11*/
SELECT nom_type_casque, COUNT(casque.nom_casque) AS Count, SUM(casque.cout_casque) AS Cout
FROM type_casque
INNER JOIN casque ON type_casque.id_type_casque = casque.id_type_casque
GROUP BY nom_type_casque
ORDER BY Count DESC

/*Request 12*/
SELECT nom_potion FROM potion
INNER JOIN composer ON potion.id_potion = composer.id_potion
INNER JOIN ingredient ON composer.id_ingredient = ingredient.id_ingredient
WHERE ingredient.nom_ingredient = "Poisson frais"

/*Request 13*/ /*Incomplet*/
SELECT nom_lieu FROM lieu
WHERE id_lieu != 1

/*Request 14*/
SELECT nom_personnage, personnage.id_personnage, autoriser_boire.id_potion FROM personnage
LEFT JOIN autoriser_boire ON personnage.id_personnage = autoriser_boire.id_personnage
HAVING ISNULL(autoriser_boire.id_potion)

/*Request 15*/
SELECT nom_personnage, personnage.id_personnage, autoriser_boire.id_potion FROM personnage
LEFT JOIN autoriser_boire ON personnage.id_personnage = autoriser_boire.id_personnage
WHERE autoriser_boire.id_potion != 1 OR ISNULL(autoriser_boire.id_potion)

/*Request A*/ /*Doute*/
INSERT INTO personnage (nom_personnage, adresse_personnage, id_lieu, id_specialite)
VALUES ('Champdeblix', 'Hentassion', 6, 12)

/*Request B*/ /*Doute*/
INSERT INTO autoriser_boire (id_potion, id_personnage)
VALUES (1, 12)

/*Request C*/
DELETE FROM casque WHERE nom_casque = 'Grecs'

/*Request D*/
UPDATE personnage
SET id_lieu = 9
WHERE nom_personnage = 'Zérozérosix'

/*Request E*/ /*Doute*/
DELETE FROM composer 
WHERE id_potion = 9 AND id_ingredient = 19

/*Request F*/ /*Doute*/
UPDATE prendre_casque 
SET id_casque = 12, qte = 42
WHERE id_personnage = 5 AND id_bataille = 9
