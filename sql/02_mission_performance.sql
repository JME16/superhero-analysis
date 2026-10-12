-- MISSION PERFORMANCE ANALYSIS
-- PostgreSQL. All queries are read-only.
-- Success means outcome = 'Success'; Partial Success is counted separately.

-- Question 3: Which mission types have the highest full-success rates?
SELECT
    missiontype,
    COUNT(missionid) AS total_missions,
    SUM(CASE WHEN outcome = 'Success' THEN 1 ELSE 0 END) AS successful_missions,
    ROUND(
        100.0 * SUM(CASE WHEN outcome = 'Success' THEN 1 ELSE 0 END)
        / COUNT(missionid), 1
    ) AS success_rate
FROM mission
GROUP BY missiontype
ORDER BY success_rate DESC, missiontype;

-- Question 3A: Examine Combat and Containment mission outcomes.
SELECT
    missionid, missiontype, team, threatlevel, outcome,
    operatingcost, infrastructuredamage, repaircost
FROM mission
WHERE missiontype IN ('Combat', 'Containment')
ORDER BY missiontype, missionid;

-- Question 3B: Foxtrot's complete mission history.
SELECT
    missionid, missiondate, missiontype, team, threatlevel, outcome,
    operatingcost, infrastructuredamage, repaircost
FROM mission
WHERE team = 'Foxtrot'
ORDER BY missiondate;

-- Question 3C: Did other teams have recorded missions on Foxtrot's dates?
-- No overlap does NOT prove another team was available.
SELECT
    foxtrot.missionid,
    foxtrot.missiondate,
    foxtrot.missiontype,
    foxtrot.outcome,
    CASE WHEN COUNT(other.missionid) > 0 THEN TRUE ELSE FALSE END
        AS other_teams_deployed,
    COUNT(other.missionid) AS other_mission_count
FROM mission AS foxtrot
LEFT JOIN mission AS other
    ON foxtrot.missiondate = other.missiondate
   AND foxtrot.team <> other.team
WHERE foxtrot.team = 'Foxtrot'
GROUP BY
    foxtrot.missionid, foxtrot.missiondate,
    foxtrot.missiontype, foxtrot.outcome
ORDER BY foxtrot.missiondate;

-- Question 4: Expected vs. actual hero-attributed damage by team.
-- Join the cost profile on BOTH agent and mission type to avoid duplicate rows.
-- Hero-attributed damage is distinct from mission infrastructure damage.
SELECT
    mission.team,
    COUNT(DISTINCT mission.missionid) AS total_missions,
    SUM(agentmissioncostprofile.expecteddamage) AS total_expected_damage,
    SUM(missionagents.actualdamage) AS total_actual_damage,
    SUM(missionagents.actualdamage)
        - SUM(agentmissioncostprofile.expecteddamage) AS damage_variance
FROM mission
JOIN missionagents USING (missionid)
JOIN agentmissioncostprofile
    ON missionagents.agent = agentmissioncostprofile.agent
   AND mission.missiontype = agentmissioncostprofile.missiontype
GROUP BY mission.team
ORDER BY damage_variance DESC;

-- Question 4: Investigate Delta and Foxtrot mission-level damage variance.
SELECT
    mission.team,
    mission.missionid,
    mission.missiontype,
    mission.threatlevel,
    mission.outcome,
    SUM(agentmissioncostprofile.expecteddamage) AS total_expected_damage,
    SUM(missionagents.actualdamage) AS total_actual_damage,
    SUM(missionagents.actualdamage)
        - SUM(agentmissioncostprofile.expecteddamage) AS damage_variance
FROM mission
JOIN missionagents USING (missionid)
JOIN agentmissioncostprofile
    ON missionagents.agent = agentmissioncostprofile.agent
   AND mission.missiontype = agentmissioncostprofile.missiontype
WHERE mission.team IN ('Delta', 'Foxtrot')
GROUP BY
    mission.team, mission.missionid, mission.missiontype,
    mission.threatlevel, mission.outcome
ORDER BY mission.team, damage_variance DESC;

-- Question 4: Individual hero variance on Foxtrot's Combat missions.
SELECT
    mission.missionid,
    missionagents.agent,
    agentmissioncostprofile.expecteddamage,
    missionagents.actualdamage,
    missionagents.actualdamage
        - agentmissioncostprofile.expecteddamage AS damage_variance
FROM missionagents
JOIN mission USING (missionid)
JOIN agentmissioncostprofile
    ON missionagents.agent = agentmissioncostprofile.agent
   AND mission.missiontype = agentmissioncostprofile.missiontype
WHERE mission.missionid IN (20, 27)
ORDER BY mission.missionid, damage_variance DESC;

-- Question 4: Adversaries on Foxtrot's two Combat missions.
SELECT
    villainmissions.missionid,
    villains.villainname,
    villains.threatlevel,
    villainmissions.actualdamage
FROM villainmissions
JOIN villains USING (villainid)
WHERE villainmissions.missionid IN (20, 27)
ORDER BY villainmissions.missionid;

-- Question 4: Operational context for Foxtrot Combat missions.
SELECT
    missionid, missiondate, location, missiontype, threatlevel,
    durationhours, teamsdeployed, outcome,
    operatingcost, infrastructuredamage, repaircost
FROM mission
WHERE missionid IN (20, 27)
ORDER BY missionid;

-- Question 4A: Team-level mission success and operating cost.
-- This is descriptive; mission mix and threat levels differ by team.
SELECT
    team,
    COUNT(DISTINCT missionid) AS total_missions,
    SUM(CASE WHEN outcome = 'Success' THEN 1 ELSE 0 END)
        AS successful_missions,
    SUM(operatingcost) AS total_operating_cost,
    ROUND(AVG(operatingcost), 2) AS avg_operating_cost
FROM mission
GROUP BY team
ORDER BY avg_operating_cost DESC;

-- Question 4A: Echo's mission mix and costs.
SELECT
    missionid, missiontype, threatlevel, outcome, operatingcost
FROM mission
WHERE team = 'Echo'
ORDER BY operatingcost DESC;

-- Question 4A: Containment missions, including outcomes and costs.
SELECT
    missionid, team, missiontype, threatlevel, outcome,
    durationhours, operatingcost, infrastructuredamage, repaircost
FROM mission
WHERE missiontype = 'Containment'
ORDER BY team;

-- Question 4A: Villains involved in Containment missions.
SELECT
    mission.missionid,
    mission.team,
    mission.outcome,
    villains.villainname,
    villains.threatlevel
FROM mission
JOIN villainmissions USING (missionid)
JOIN villains USING (villainid)
WHERE mission.missiontype = 'Containment'
ORDER BY mission.team;

-- Question 4A: Compare heroes on Echo and Foxtrot Containment missions.
SELECT
    mission.missionid,
    mission.team,
    missionagents.agent,
    missionagents.actualdamage
FROM mission
JOIN missionagents USING (missionid)
WHERE mission.missionid IN (6, 26)
ORDER BY mission.missionid, missionagents.actualdamage DESC;

-- LIMITATIONS:
-- Resource distribution was standardized in this dataset.
-- Mission planning, team readiness, and deployment rationale are not recorded.
-- Do not infer causal explanations from outcome or cost comparisons alone.
-- Do not sum villain, hero, and infrastructure damage without checking overlap.
