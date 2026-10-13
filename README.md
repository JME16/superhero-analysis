# The Cost of Being Super
### A PostgreSQL Operations Performance & Risk Analysis

**Portfolio case study | Operations analytics · SQL · Decision support**

## Executive Summary

A fictional superhero organization faces a familiar operational challenge: missions must succeed, but success has a financial and operational cost. This project examines 30 recorded missions to identify concentrated damage exposure, evaluate mission outcomes, investigate team-performance discrepancies, and develop defensible management recommendations.

**Central question:** How can the League evaluate mission effectiveness and damage exposure without mistaking raw cost or success rankings for operational efficiency?

The emphasis is on **investigation, interpretation, and decision support**, not simply producing query results.

## Three Findings Worth Investigating

| Question | Evidence | Operational interpretation |
| --- | --- | --- |
| Where is the greatest recorded villain damage? | Planetary Threat events: **$7.1B across 2 incidents**; City-Scale Assault: **$2.215B across 3** | Prioritize exposure assessment by **severity and frequency**. Villain damage is not automatically additive to infrastructure or repair costs. |
| Which mission outcomes warrant review? | Combat and Containment each had **1 full success in 3 missions**. Foxtrot achieved **1 full success in 4 missions**, with weaker outcomes on higher-threat assignments. | Review Foxtrot's readiness for high-threat missions. Small samples, different adversaries, and unknown mission conditions prevent causal conclusions. |
| Does higher damage or lower cost prove worse or better performance? | Delta's hero-attributed damage exceeded expectations by **$1.61M (+20.1%)** despite **4/4 mission successes**. Echo achieved **4/4 successes** with an average **$185K operating cost**, but its mission mix differed. | Evaluate **outcomes, threat, mission type, and damage together**; do not use variance or average cost as standalone performance rankings. |

A deeper Containment comparison found three High-threat missions with **$125K operating costs** but outcomes of **Success, Partial Success, and Failure**. Equal recorded spending does not establish equal difficulty or equal effectiveness.

## Recommendations for League Leadership

1. **Review high-threat mission readiness**, beginning with Foxtrot's Combat and Containment assignments. Assess training and capability before permanent team or deployment changes.
2. **Compare like with like.** Segment performance by mission type, threat classification, outcome, and relevant damage measures rather than ranking teams by overall averages alone.
3. **Separate data-supported findings from operational hypotheses.** Examine planning rationale, staffing availability, and assignment decisions in a separate review; those records are not present here.

These recommendations are **investigative and conditional**, not proof that any particular deployment choice caused failure.

## SQL Evidence and Detailed Findings

- [Villain threats and event-type exposure](sql/01_villain_threat.sql): multi-table `JOIN`, `GROUP BY`, `SUM`, `AVG`, and incident counts.
- [Mission performance and variance investigations](sql/02_mission_performance.sql): success-rate `CASE` expressions, comparisons by team and mission, a scheduling self-`JOIN`, and hero-level expected-versus-actual damage analysis.
- [Findings, investigation trail, recommendations, and limitations](results/key_findings.md): detailed evidence, competing explanations, and the boundaries of each conclusion.

- [Inspect the actual PostgreSQL schema](sql/01_database_schema.sql): read-only queries for table columns, primary and foreign keys, and core table row counts. This file does **not** create the tables.

The SQL scripts are **read-only analysis and inspection queries** written for the project's PostgreSQL tables. The `data/` directory provides source CSV examples, but the repository does not currently provide the complete DDL, every input dataset, or a one-command database rebuild.

## Supporting Learning Materials

The `docs/` directory contains a project dossier, analysis workbook, question set, and SQL study guides. These are **supplementary working and learning resources**, not additional completed investigations or evidence of SQL results. The main assessment trail is the linked SQL analysis and `results/key_findings.md`.

## Method and Analytical Decisions

The work moves from broad questions to targeted checks: calculate baseline metrics, inspect unusual results, compare relevant mission context, and then propose an action. An observed discrepancy is a reason to investigate, **not evidence of causation**.

Examples include examining why Delta's high damage variance coincided with mission success and why Foxtrot's aggregate variance concealed opposing agent-level differences. Partial Success is **not counted as full Success** in the reported success-rate calculations.

## Dataset Provenance, AI Collaboration, and Limitations

**This is a fictional, AI-generated synthetic dataset, not actual organizational records.** AI assisted with dataset creation and analytical collaboration. The analyst directed the investigation, ran and reviewed SQL results, challenged assumptions, and takes responsibility for the interpretations presented. No figures represent verified real-world savings or business performance.

Operating costs are frequently repeated within mission categories, indicating a likely standardized dataset design rather than independently observed expenditure. Recorded resource distribution was also standardized. Team averages are affected by mission mix, and the records do not establish mission-planning rationale, personnel availability, tactical conditions, or optimal allocation. Damage categories may overlap and are not summed indiscriminately.

**Future investigation identified, not claimed as complete:** Mission readiness, planning, and resource allocation would require additional operational data.

## Tools

**PostgreSQL · SQL · Linux · Git / GitHub · Excel / CSV**

---

*This case study demonstrates an operations-oriented analytical workflow: framing a question, validating the evidence, investigating anomalies, acknowledging uncertainty, and communicating a defensible recommendation.*
