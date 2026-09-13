import pandas as pd
import numpy as np
from pathlib import Path

# Reproducible synthetic data
np.random.seed(42)

# Project paths
project_root = Path(__file__).resolve().parents[1]
output_path = project_root / "data" / "synthetic" / "marketing_spend.csv"

# Same analysis period as our synthetic website data
dates = pd.date_range(
    start="2017-01-01",
    end="2018-08-31",
    freq="D"
)

# Paid marketing channels
channels = {
    "paid_search": {
        "avg_impressions": 8500,
        "ctr": 0.035,
        "avg_cpc": 1.20
    },
    "social": {
        "avg_impressions": 12000,
        "ctr": 0.018,
        "avg_cpc": 0.85
    },
    "email": {
        "avg_impressions": 5000,
        "ctr": 0.055,
        "avg_cpc": 0.25
    }
}

rows = []

for date in dates:
    for channel, params in channels.items():

        impressions = max(
            1,
            int(np.random.normal(params["avg_impressions"], 1000))
        )

        clicks = np.random.binomial(
            impressions,
            params["ctr"]
        )

        cpc = max(
            0.01,
            np.random.normal(
                params["avg_cpc"],
                params["avg_cpc"] * 0.10
            )
        )

        spend = clicks * cpc

        rows.append({
            "spend_date": date.date(),
            "acquisition_channel": channel,
            "impressions": impressions,
            "ad_clicks": clicks,
            "spend": round(spend, 2)
        })

marketing_df = pd.DataFrame(rows)

marketing_df.to_csv(
    output_path,
    index=False
)

print(f"Marketing rows: {len(marketing_df):,}")
print(marketing_df.head())