from pathlib import Path

import numpy as np
import pandas as pd


# -----------------------------
# Project paths
# -----------------------------
PROJECT_ROOT = Path(__file__).resolve().parents[1]
DATA_DIR = PROJECT_ROOT / "data" / "synthetic"

events_path = DATA_DIR / "website_events.csv"
output_path = DATA_DIR / "experiment_checkout.csv"


# -----------------------------
# Load website events
# -----------------------------
events = pd.read_csv(
    events_path,
    parse_dates=["event_timestamp"]
)


# -----------------------------
# Find eligible visitors
# -----------------------------
checkout_events = events[
    events["event_type"] == "checkout"
].copy()

eligible_visitors = (
    checkout_events
    .groupby("visitor_id", as_index=False)
    ["event_timestamp"]
    .min()
    .rename(
        columns={
            "event_timestamp": "exposure_timestamp"
        }
    )
)


# -----------------------------
# Random number generator
# -----------------------------
rng = np.random.default_rng(42)


# -----------------------------
# Randomly assign variants
# -----------------------------
eligible_visitors["variant"] = rng.choice(
    ["control", "treatment"],
    size=len(eligible_visitors),
    p=[0.50, 0.50]
)


# -----------------------------
# Define true conversion probabilities
# -----------------------------
eligible_visitors["conversion_probability"] = np.where(
    eligible_visitors["variant"] == "control",
    0.62,
    0.65
)


# -----------------------------
# Generate conversion outcome
# -----------------------------
eligible_visitors["converted"] = rng.binomial(
    n=1,
    p=eligible_visitors["conversion_probability"]
)


# -----------------------------
# Add experiment identifier
# -----------------------------
eligible_visitors["experiment_id"] = "checkout_redesign_v1"


# -----------------------------
# Final column order
# -----------------------------
experiment = eligible_visitors[
    [
        "experiment_id",
        "visitor_id",
        "variant",
        "exposure_timestamp",
        "converted",
    ]
]


# -----------------------------
# Save experiment data
# -----------------------------
experiment.to_csv(
    output_path,
    index=False
)


# -----------------------------
# Confirmation
# -----------------------------
print(f"Experiment rows: {len(experiment):,}")
print()
print("Variant counts:")
print(experiment["variant"].value_counts())
print()
print("Observed conversion rates:")
print(
    experiment.groupby("variant")["converted"].mean()
)