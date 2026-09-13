from pathlib import Path

import numpy as np
import pandas as pd
from scipy.stats import norm, chisquare


# -----------------------------
# Project paths
# -----------------------------
PROJECT_ROOT = Path(__file__).resolve().parents[1]
DATA_DIR = PROJECT_ROOT / "data" / "synthetic"

experiment_path = DATA_DIR / "experiment_checkout.csv"
results_path = DATA_DIR / "experiment_results.csv"


# -----------------------------
# Load experiment data
# -----------------------------
experiment = pd.read_csv(experiment_path)


# -----------------------------
# Separate experiment groups
# -----------------------------
control = experiment[
    experiment["variant"] == "control"
]

treatment = experiment[
    experiment["variant"] == "treatment"
]


# -----------------------------
# Sample sizes
# -----------------------------
n_control = len(control)
n_treatment = len(treatment)


# -----------------------------
# Number of conversions
# -----------------------------
conv_control = control["converted"].sum()
conv_treatment = treatment["converted"].sum()


# -----------------------------
# Conversion rates
# -----------------------------
rate_control = conv_control / n_control
rate_treatment = conv_treatment / n_treatment


# -----------------------------
# SRM check
# -----------------------------
observed_counts = [
    n_control,
    n_treatment
]

total_users = (
    n_control + n_treatment
)

expected_counts = [
    total_users / 2,
    total_users / 2
]

srm_chi2_stat, srm_p_value = chisquare(
    f_obs=observed_counts,
    f_exp=expected_counts
)

srm_detected = (
    srm_p_value < 0.05
)


# -----------------------------
# Pooled conversion rate
# Used for hypothesis test
# -----------------------------
pooled_rate = (
    conv_control + conv_treatment
) / (
    n_control + n_treatment
)


# -----------------------------
# Standard error under H0
# Used for the z-test
# -----------------------------
standard_error = np.sqrt(
    pooled_rate
    * (1 - pooled_rate)
    * (
        (1 / n_control)
        + (1 / n_treatment)
    )
)


# -----------------------------
# Z-statistic
# -----------------------------
z_stat = (
    rate_treatment - rate_control
) / standard_error


# -----------------------------
# Two-sided p-value
# -----------------------------
p_value = 2 * (
    1 - norm.cdf(abs(z_stat))
)

is_statistically_significant = (
    p_value < 0.05
)


# -----------------------------
# Uplift
# -----------------------------
absolute_uplift = (
    rate_treatment - rate_control
)

relative_uplift = (
    absolute_uplift / rate_control
)


# -----------------------------
# Standard error for uplift
# Used for confidence interval
# -----------------------------
uplift_standard_error = np.sqrt(
    (
        rate_control
        * (1 - rate_control)
        / n_control
    )
    +
    (
        rate_treatment
        * (1 - rate_treatment)
        / n_treatment
    )
)


# -----------------------------
# 95% confidence interval
# -----------------------------
z_critical = norm.ppf(0.975)

ci_lower = (
    absolute_uplift
    - z_critical * uplift_standard_error
)

ci_upper = (
    absolute_uplift
    + z_critical * uplift_standard_error
)


# -----------------------------
# Projected business impact
# -----------------------------
projected_checkout_visitors = 100_000

expected_control_purchases = (
    projected_checkout_visitors
    * rate_control
)

expected_treatment_purchases = (
    projected_checkout_visitors
    * rate_treatment
)

incremental_purchases = (
    projected_checkout_visitors
    * absolute_uplift
)

incremental_purchases_lower = (
    projected_checkout_visitors
    * ci_lower
)

incremental_purchases_upper = (
    projected_checkout_visitors
    * ci_upper
)


# -----------------------------
# Create experiment results dataset
# -----------------------------
results = pd.DataFrame(
    [
        {
            "experiment_id": "checkout_redesign_v1",

            "control_visitors": n_control,
            "treatment_visitors": n_treatment,

            "control_conversions": conv_control,
            "treatment_conversions": conv_treatment,

            "control_conversion_rate": rate_control,
            "treatment_conversion_rate": rate_treatment,

            "absolute_uplift": absolute_uplift,
            "relative_uplift": relative_uplift,

            "z_statistic": z_stat,
            "p_value": p_value,

            "ci_lower": ci_lower,
            "ci_upper": ci_upper,

            "srm_chi2_statistic": srm_chi2_stat,
            "srm_p_value": srm_p_value,
            "srm_detected": srm_detected,

            "is_statistically_significant":
                is_statistically_significant,

            "projected_checkout_visitors":
                projected_checkout_visitors,

            "estimated_incremental_purchases":
                incremental_purchases,

            "incremental_purchases_ci_lower":
                incremental_purchases_lower,

            "incremental_purchases_ci_upper":
                incremental_purchases_upper,
        }
    ]
)

results.to_csv(
    results_path,
    index=False
)


# -----------------------------
# Results
# -----------------------------
print("Control users:", n_control)
print("Control conversions:", conv_control)
print(
    f"Control conversion rate: "
    f"{rate_control:.4%}"
)

print()

print("Treatment users:", n_treatment)
print("Treatment conversions:", conv_treatment)
print(
    f"Treatment conversion rate: "
    f"{rate_treatment:.4%}"
)

print()

print(
    f"Absolute uplift: "
    f"{absolute_uplift * 100:.2f} percentage points"
)

print(
    f"Relative uplift: "
    f"{relative_uplift:.2%}"
)

print()

print(f"Z-statistic: {z_stat:.4f}")
print(f"P-value: {p_value:.6f}")

print()

print(
    f"95% confidence interval: "
    f"{ci_lower * 100:.2f} to "
    f"{ci_upper * 100:.2f} percentage points"
)

print()

print("SRM check:")
print(f"SRM chi-square statistic: {srm_chi2_stat:.4f}")
print(f"SRM p-value: {srm_p_value:.4f}")
print(f"SRM detected: {srm_detected}")

print()

print(
    "Projected impact for "
    f"{projected_checkout_visitors:,} checkout visitors:"
)

print(
    f"Expected Control purchases: "
    f"{expected_control_purchases:,.0f}"
)

print(
    f"Expected Treatment purchases: "
    f"{expected_treatment_purchases:,.0f}"
)

print(
    f"Estimated incremental purchases: "
    f"{incremental_purchases:,.0f}"
)

print(
    f"95% CI for incremental purchases: "
    f"{incremental_purchases_lower:,.0f} to "
    f"{incremental_purchases_upper:,.0f}"
)

print()

print(
    "Statistically significant:",
    is_statistically_significant
)

print()

print(
    f"Experiment results saved to: "
    f"{results_path}"
)