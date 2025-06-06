# Conversion-Funnel & A/B-Test Analysis with GA4 BigQuery

> End-to-end analytics project that turns raw GA4 event data into a clear story of how visitors move through the funnel, and delivers a trustworthy verdict on an A/B test - built with **dbt**, **Python**, and **Looker Studio/Tableau**.

<!---
---

## 📚 What you’ll learn from this repo
- **Modern data-warehouse modeling** with dbt (staging ➜ marts ➜ metrics).
- **Conversion-funnel analytics**: session attribution, step drop-offs, KPI tracking.
- **Experimental design & evaluation**: building variant cohorts and running z-tests in SQL/Python.
- **Cost-efficient querying** on partitioned GA4 export tables in BigQuery.
- **Storytelling deliverables**: notebooks, an interactive BI dashboard, and an executive slide deck.
--->

---

## 🗂 Table of Contents
1. [Project Overview](#project-overview)  
2. [Quick Start](#quick-start)

4. [Repository Structure](#repository-structure)  
5. [Data Architecture](#data-architecture)  
6. [How to Run the Analysis](#how-to-run-the-analysis)  
7. [Dashboards](#dashboards)  
8. [Results & Insights](#results--insights)  
<!--- 9. [Contributing](#contributing) 
10. [License](#license)  
11. [Contact](#contact)
--->

---

## Project Overview
A short problem statement—_“How can we improve purchase conversion while validating product changes via controlled experiments?”_. 
The dataset used: ga4_obfuscated_sample_ecommerce - Google’s public GA4 demo export for a merchandise store. It contains three months of traffic, from 2020-11-01 to 2021-01-31.

---

## Quick Start
```bash
# 1. Clone the repo
git clone https://github.com/marinpet/onboarding_funnel_analysis.git
cd onboarding_funnel_analysis

# 2. Install Python deps
poetry install

# 3. Set BigQuery credentials (service-account JSON)
export GOOGLE_APPLICATION_CREDENTIALS=~/path/key.json

# 4. Run dbt models & tests
poetry run dbt run
poetry run dbt test
