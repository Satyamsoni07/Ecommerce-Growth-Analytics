from pathlib import Path

import pandas as pd
from scipy.stats import chisquare


# -----------------------------
# Project paths
# -----------------------------
PROJECT_ROOT = Path(__file__).resolve().parents[1]
DATA_DIR = PROJECT_ROOT / "data" / "synthetic"

experiment_path = DATA_DIR / "experiment_checkout.csv"


# -----------------------------
# Load experiment data
# -----------------------------
experiment = pd.read_csv(experiment_path)


# -----------------------------
# Observed group counts
# -----------------------------
observed = (
    experiment["variant"]
    .value_counts()
    .reindex(["control", "treatment"])
    .values
)


# -----------------------------
# Expected 50/50 counts
# -----------------------------
total_users = len(experiment)

expected = [
    total_users / 2,
    total_users / 2
]


# -----------------------------
# Chi-square SRM test
# -----------------------------
chi2_stat, p_value = chisquare(
    f_obs=observed,
    f_exp=expected
)


# -----------------------------
# Results
# -----------------------------
print("Observed counts:", observed)
print("Expected counts:", expected)
print(f"Chi-square statistic: {chi2_stat:.4f}")
print(f"SRM p-value: {p_value:.4f}")

if p_value < 0.05:
    print("SRM detected: investigate experiment allocation.")
else:
    print("No evidence of SRM.")