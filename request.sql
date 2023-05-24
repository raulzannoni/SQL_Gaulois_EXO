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

/*Request 3*/ /*Doute*/
SELECT nom_personnage, specialite.nom_specialite , adresse_personnage, lieu.nom_lieu 
FROM personnage 
INNER JOIN specialite ON personnage.id_specialite = specialite.id_specialite
INNER JOIN lieu ON personnage.id_lieu = lieu.id_lieu
ORDER BY lieu.nom_lieu, personnage.nom_personnage

/*Request 4*/
SELECT nom_specialite, COUNT(personnage.id_personnage) FROM specialite
INNER JOIN personnage ON specialite.id_specialite = personnage.id_specialite
GROUP BY nom_specialite
ORDER BY COUNT(personnage.id_personnage) DESC

/*Request 5*/
SELECT nom_bataille, DATE_FORMAT(date_bataille, "%d %m %Y"), lieu.nom_lieu FROM bataille
INNER JOIN lieu ON bataille.id_lieu = lieu.id_lieu
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
WHERE potion.id_potion = (	SELECT potion.id_potion
							WHERE potion.nom_potion = 'Santé'				
							)

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
WHERE LOWER(ingredient.nom_ingredient) = "poisson frais"

/*Request 13*/ /*Correction*/
SELECT l.nom_lieu, COUNT(p.id_lieu) AS Habitants
FROM lieu l, personnage p
WHERE l.nom_lieu != 'Village gaulouis' AND l.id_lieu = p.id_lieu
GROUP BY l.nom_lieu
HAVING Habitants >= ALL(
	SELECT COUNT(p.id_lieu)
	FROM lieu l, personnage p
	WHERE l.nom_lieu != 'Village gaulouis' AND l.id_lieu = p.id_lieu
	GROUP BY l.nom_lieu
	)

/*Request 14*/
SELECT nom_personnage, personnage.id_personnage, autoriser_boire.id_potion FROM personnage
LEFT JOIN autoriser_boire ON personnage.id_personnage = autoriser_boire.id_personnage
HAVING ISNULL(autoriser_boire.id_potion)

/*Request 15*/
SELECT nom_personnage, personnage.id_personnage, autoriser_boire.id_potion FROM personnage
LEFT JOIN autoriser_boire ON personnage.id_personnage = autoriser_boire.id_personnage
WHERE autoriser_boire.id_potion != 1 OR ISNULL(autoriser_boire.id_potion)

/*Request A*/ /*Correction*/
INSERT INTO personnage (nom_personnage, 
						adresse_personnage, 
						id_lieu, 
						id_specialite
						)
VALUES ('Champdeblix', 
		'Hentassion', 
		(   SELECT l.id_lieu
		    FROM lieu l
			WHERE l.nom_lieu = 'Rotomagus'
			), 
		(	SELECT s.id_specialite
			FROM specialite s
			WHERE s.nom_specialite = 'Agriculteur'
			)
		)

/*Request B*/ /*Correction*/
INSERT INTO autoriser_boire (id_potion, id_personnage)
VALUES ((	SELECT p.id_potion
			FROM potion p
			WHERE p.nom_potion = 'Magique'
			),
		(	SELECT p.id_personnage
			FROM personnage p
			WHERE p.nom_personnage = 'Bonemine'
			)
        )

/*Request C*/ /*Correction*/
DELETE FROM casque
WHERE casque.id_type_casque IN(	SELECT id_type_casque 
								FROM	type_casque
								WHERE nom_type_casque = 'Grec'
                                )
AND casque.id_casque NOT IN (	SELECT id_casque
								FROM	prendre_casque
                                )



/*Request D*/ /*Correction*/
UPDATE personnage
SET personnage.id_lieu = (
		SELECT l.id_lieu
		FROM lieu l
		WHERE l.nom_lieu = 'Condate'
		) 
WHERE nom_personnage = 'Zérozérosix'

/*Request E*/ /*Correction*/
DELETE FROM composer 
WHERE id_potion = (	SELECT p.id_potion
				    FROM potion p
					WHERE p.nom_potion = 'Soupe' 
					)
AND id_ingredient = (   SELECT i.id_ingredient
					    FROM ingredient i
						WHERE i.nom_ingredient = 'Persil' 
					    )

/*Request F*/ /*Correction*/
UPDATE prendre_casque 
SET prendre_casque.id_casque = (SELECT c.id_casque
								FROM casque c
								WHERE c.nom_casque = 'Weisenau'
								), 
	prendre_casque.qte = 42
WHERE prendre_casque.id_personnage = (	SELECT p.id_personnage
										FROM personnage p
										WHERE p.nom_personnage = 'Obélix'
										)   
AND prendre_casque.id_bataille = (	SELECT b.id_bataille
									FROM bataille b
									WHERE b.nom_bataille = 'Attaque de la banque postale'
									)	
