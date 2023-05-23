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