import pandas as pd
from pathlib import Path
from sklearn.preprocessing import StandardScaler
from sklearn.decomposition import PCA

DATA_PATH = Path("<path to data>")

# Remplace les noms par ceux des variables a mettre dans le calcul du score de difficulte
FEATURE_COLUMNS = ["n_eleves", "p_difficulte", "p_pi"]
df = pd.read_csv(DATA_PATH, usecols=FEATURE_COLUMNS)

scaler = StandardScaler()
X_scaled = scaler.fit_transform(df)

pca = PCA(n_components=1)
pca.fit(X_scaled)

coefficients_pc1 = pd.Series(
    pca.components_[0],
    index=FEATURE_COLUMNS,
    name="coefficients_premier_axes",
)

coefficients_pc1