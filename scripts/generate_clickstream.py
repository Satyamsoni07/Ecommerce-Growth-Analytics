from pathlib import Path

import numpy as np
import pandas as pd


# -----------------------------
# Reproducibility
# -----------------------------
RANDOM_SEED = 42
rng = np.random.default_rng(RANDOM_SEED)


# -----------------------------
# Project paths
# -----------------------------
PROJECT_ROOT = Path(__file__).resolve().parents[1]
OUTPUT_DIR = PROJECT_ROOT / "data" / "synthetic"

OUTPUT_DIR.mkdir(parents=True, exist_ok=True)


# -----------------------------
# Session configuration
# -----------------------------
N_SESSIONS = 120_000
N_VISITORS = 75_000

START_DATE = pd.Timestamp("2017-01-01")
END_DATE = pd.Timestamp("2018-08-31 23:59:59")


# -----------------------------
# Generate IDs
# -----------------------------
session_ids = [
    f"session_{i:06d}"
    for i in range(1, N_SESSIONS + 1)
]

visitor_ids = rng.choice(
    [f"visitor_{i:06d}" for i in range(1, N_VISITORS + 1)],
    size=N_SESSIONS,
    replace=True
)


# -----------------------------
# Generate session timestamps
# -----------------------------
total_seconds = int(
    (END_DATE - START_DATE).total_seconds()
)

random_seconds = rng.integers(
    0,
    total_seconds,
    size=N_SESSIONS
)

session_start = (
    START_DATE
    + pd.to_timedelta(random_seconds, unit="s")
)


# -----------------------------
# Generate session attributes
# -----------------------------
device_type = rng.choice(
    ["mobile", "desktop", "tablet"],
    size=N_SESSIONS,
    p=[0.62, 0.33, 0.05]
)

acquisition_channel = rng.choice(
    [
        "organic_search",
        "paid_search",
        "social",
        "email",
        "direct",
        "referral"
    ],
    size=N_SESSIONS,
    p=[0.30, 0.22, 0.16, 0.08, 0.18, 0.06]
)


# -----------------------------
# Create sessions DataFrame
# -----------------------------
sessions = pd.DataFrame({
    "session_id": session_ids,
    "visitor_id": visitor_ids,
    "session_start": session_start,
    "device_type": device_type,
    "acquisition_channel": acquisition_channel
})


sessions = sessions.sort_values(
    "session_start"
).reset_index(drop=True)


# -----------------------------
# Save sessions file
# -----------------------------
sessions_file = OUTPUT_DIR / "website_sessions.csv"

sessions.to_csv(
    sessions_file,
    index=False
)


print("Website sessions generated successfully.")
print("Rows:", len(sessions))
print("Unique sessions:", sessions["session_id"].nunique())
print("Unique visitors:", sessions["visitor_id"].nunique())
print("Saved to:", sessions_file)


# -----------------------------
# Generate funnel events
# -----------------------------
events = []

for row in sessions.itertuples(index=False):

    # Every session begins with a session_start event.
    current_time = row.session_start

    events.append({
        "session_id": row.session_id,
        "visitor_id": row.visitor_id,
        "event_timestamp": current_time,
        "event_type": "session_start"
    })


    # -------------------------
    # Stage 1: Product View
    # -------------------------
    viewed_product = rng.random() < 0.78

    if not viewed_product:
        continue

    current_time += pd.Timedelta(
        seconds=int(rng.integers(10, 180))
    )

    events.append({
        "session_id": row.session_id,
        "visitor_id": row.visitor_id,
        "event_timestamp": current_time,
        "event_type": "product_view"
    })


    # -------------------------
    # Stage 2: Add to Cart
    # -------------------------
    added_to_cart = rng.random() < 0.25

    if not added_to_cart:
        continue

    current_time += pd.Timedelta(
        seconds=int(rng.integers(20, 300))
    )

    events.append({
        "session_id": row.session_id,
        "visitor_id": row.visitor_id,
        "event_timestamp": current_time,
        "event_type": "add_to_cart"
    })


    # -------------------------
    # Stage 3: Checkout
    # -------------------------
    started_checkout = rng.random() < 0.55

    if not started_checkout:
        continue

    current_time += pd.Timedelta(
        seconds=int(rng.integers(20, 240))
    )

    events.append({
        "session_id": row.session_id,
        "visitor_id": row.visitor_id,
        "event_timestamp": current_time,
        "event_type": "checkout"
    })


    # -------------------------
    # Stage 4: Purchase
    # -------------------------
    purchased = rng.random() < 0.62

    if not purchased:
        continue

    current_time += pd.Timedelta(
        seconds=int(rng.integers(20, 180))
    )

    events.append({
        "session_id": row.session_id,
        "visitor_id": row.visitor_id,
        "event_timestamp": current_time,
        "event_type": "purchase"
    })


# -----------------------------
# Create events DataFrame
# -----------------------------
website_events = pd.DataFrame(events)

website_events = website_events.sort_values(
    ["session_id", "event_timestamp"]
).reset_index(drop=True)


# -----------------------------
# Save events file
# -----------------------------
events_file = OUTPUT_DIR / "website_events.csv"

website_events.to_csv(
    events_file,
    index=False
)


print()
print("Website events generated successfully.")
print("Rows:", len(website_events))
print()

print("Event counts:")
print(website_events["event_type"].value_counts())
print()

print("Saved to:", events_file)