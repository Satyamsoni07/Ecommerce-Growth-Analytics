from pathlib import Path

import numpy as np
import pandas as pd


# -----------------------------
# Project paths
# -----------------------------
PROJECT_ROOT = Path(__file__).resolve().parents[1]
DATA_DIR = PROJECT_ROOT / "data" / "synthetic"

events_path = DATA_DIR / "website_events.csv"
output_path = DATA_DIR / "website_purchases.csv"


# -----------------------------
# Load website events
# -----------------------------
events = pd.read_csv(events_path)


# -----------------------------
# Keep purchase events only
# -----------------------------
purchases = events[
    events["event_type"] == "purchase"
].copy()


# -----------------------------
# Generate synthetic order value
# -----------------------------
rng = np.random.default_rng(42)

purchase_values = rng.gamma(
    shape=3.0,
    scale=50.0,
    size=len(purchases)
)

purchases["purchase_value"] = np.round(
    np.clip(purchase_values, 20, 1000),
    2
)


# -----------------------------
# Create transaction ID
# -----------------------------
purchases["transaction_id"] = [
    f"txn_{i:06d}"
    for i in range(1, len(purchases) + 1)
]


# -----------------------------
# Keep transaction columns
# -----------------------------
purchases = purchases[
    [
        "transaction_id",
        "session_id",
        "visitor_id",
        "event_timestamp",
        "purchase_value",
    ]
].rename(
    columns={
        "event_timestamp": "purchase_timestamp"
    }
)


# -----------------------------
# Save
# -----------------------------
purchases.to_csv(
    output_path,
    index=False
)

print(f"Website purchases: {len(purchases):,}")
print(purchases.head())