-- MISSION PERFORMANCE ANALYSIS

-- Question 3:
-- Which mission types have the highest success rates?

SELECT
    missiontype,
    COUNT(missionid) AS total_missions,
    SUM(
	        CASE
			            WHEN outcome = 'Success' THEN 1
					            ELSE 0
							        END
								    ) AS successful_missions,
								    ROUND(
									        100.0 * SUM(
											            CASE
													                WHEN outcome = 'Success' THEN 1
																                ELSE 0
																			            END
																				        ) / COUNT(missionid),
																					        1
																						    ) AS success_rate
																						FROM mission
																						GROUP BY missiontype
																						ORDER BY success_rate DESC;


																						-- Question 3A:
-- Examine Combat and Containment mission outcomes.

SELECT
    missionid,
    missiontype,
    team,
    threatlevel,
    outcome,
    operatingcost,
    infrastructuredamage,
    repaircost
FROM mission
WHERE missiontype IN ('Combat', 'Containment')
ORDER BY missiontype, missionid;


-- Question 3B:
-- Examine Foxtrot's complete mission history.

SELECT
    missionid,
    missiontype,
    team,
    threatlevel,
    outcome,
    operatingcost,
    infrastructuredamage,
    repaircost
FROM mission
WHERE team = 'Foxtrot'
ORDER BY missionid;

-- Question 3C:
-- Were other teams deployed on Foxtrot's mission dates?

SELECT
    foxtrot.missionid,
    foxtrot.missiondate,
    foxtrot.missiontype,
    foxtrot.outcome,
    CASE
	        WHEN COUNT(other.missionid) > 0 THEN TRUE
			        ELSE FALSE
					    END AS other_teams_deployed,
					    COUNT(other.missionid) AS other_mission_count
					FROM mission AS foxtrot
					LEFT JOIN mission AS other
					    ON foxtrot.missiondate = other.missiondate
					   AND foxtrot.team <> other.team
					WHERE foxtrot.team = 'Foxtrot'
					GROUP BY
					    foxtrot.missionid,
					    foxtrot.missiondate,
					    foxtrot.missiontype,
					    foxtrot.outcome
					ORDER BY foxtrot.missiondate;
