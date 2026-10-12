-- VILLAIN THREAT ANALYSIS

-- Question 1:
-- Which villains are associated with the greatest actual damage?

SELECT
    villains.villainname,
    SUM(villainmissions.actualdamage) AS total_actual_damage
FROM villains
JOIN villainmissions USING (villainid)
GROUP BY villains.villainname
ORDER BY SUM(villainmissions.actualdamage) DESC;
