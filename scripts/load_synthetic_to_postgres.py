from pathlib import Path
import os

import pandas as pd
from dotenv import load_dotenv
from sqlalchemy import create_engine, URL, inspect, text


# -----------------------------
# Project paths
# -----------------------------
PROJECT_ROOT = Path(__file__).resolve().parents[1]

DATA_DIR = PROJECT_ROOT / "data" / "synthetic"


# -----------------------------
# Load database credentials
# -----------------------------
load_dotenv(PROJECT_ROOT / ".env", override=True)


# -----------------------------
# Create PostgreSQL connection
# -----------------------------
db_url = URL.create(
    drivername="postgresql+psycopg2",
    username=os.getenv("DB_USER"),
    password=os.getenv("DB_PASSWORD"),
    host=os.getenv("DB_HOST"),
    port=int(os.getenv("DB_PORT")),
    database=os.getenv("DB_NAME"),
)

engine = create_engine(db_url)


# -----------------------------
# Load CSV files
# -----------------------------
sessions = pd.read_csv(
    DATA_DIR / "website_sessions.csv"
)

events = pd.read_csv(
    DATA_DIR / "website_events.csv"
)

marketing = pd.read_csv(
    DATA_DIR / "marketing_spend.csv"
)

purchases = pd.read_csv(
    DATA_DIR / "website_purchases.csv"
)

experiment = pd.read_csv(
    DATA_DIR / "experiment_checkout.csv"
)

experiment_results = pd.read_csv(
    DATA_DIR / "experiment_results.csv"
)


# -----------------------------
# Safe table loader
# -----------------------------
def load_table(df, table_name):
    inspector = inspect(engine)

    table_exists = inspector.has_table(
        table_name,
        schema="raw"
    )

    if table_exists:
        with engine.begin() as connection:
            connection.execute(
                text(f'TRUNCATE TABLE raw."{table_name}"')
            )

    df.to_sql(
        table_name,
        engine,
        schema="raw",
        if_exists="append",
        index=False,
        chunksize=10_000
    )


# -----------------------------
# Write to PostgreSQL
# -----------------------------
load_table(
    sessions,
    "website_sessions"
)

load_table(
    events,
    "website_events"
)

load_table(
    marketing,
    "marketing_spend"
)

load_table(
    purchases,
    "website_purchases"
)

load_table(
    experiment,
    "experiment_checkout"
)

load_table(
    experiment_results,
    "experiment_results"
)


# -----------------------------
# Confirmation
# -----------------------------
print("Synthetic data loaded successfully.")
print("website_sessions rows:", len(sessions))
print("website_events rows:", len(events))
print("marketing_spend rows:", len(marketing))
print("website_purchases rows:", len(purchases))
print("experiment_checkout rows:", len(experiment))
print("experiment_results rows:", len(experiment_results))