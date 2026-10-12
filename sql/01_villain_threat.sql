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

-- Question 2:
-- Which event types produce the largest financial exposure?
-- Includes incident frequency and average damage to assess severity.

SELECT
    villaineventtype.eventtype,
    COUNT(villainmissions.missionid) AS incident_count,
    SUM(villainmissions.actualdamage) AS total_actual_damage,
    AVG(villainmissions.actualdamage) AS average_actual_damage,
    SUM(mission.operatingcost) AS total_operating_cost,
    SUM(mission.repaircost) AS total_repair_cost
FROM villaineventtype
JOIN villainmissions USING (eventtypeid)
JOIN mission USING (missionid)
GROUP BY villaineventtype.eventtype
ORDER BY total_actual_damage DESC;
