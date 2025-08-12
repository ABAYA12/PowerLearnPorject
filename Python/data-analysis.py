#  Data Analysis Project

# Import required libraries
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns


# Task 1: Load & Explore Dataset

# Load the dataset (Iris dataset from seaborn for example)
df = sns.load_dataset("iris")

# Display first few rows
print("First 5 rows of the dataset:")
print(df.head())

# Check data types and missing values
print("\nDataset Info:")
print(df.info())

print("\nMissing Values:")
print(df.isnull().sum())

# Clean dataset (if missing values exist, fill with mean for numerical columns)
df.fillna(df.mean(numeric_only=True), inplace=True)

# Task 2: Basic Data Analysis


# Basic statistics
print("\nBasic Statistics:")
print(df.describe())

# Group by species and get mean petal length
grouped = df.groupby("species")["petal_length"].mean()
print("\nAverage Petal Length per Species:")
print(grouped)

# Interesting finding example
print("\nObservation: Virginica flowers tend to have the longest petals on average.")


# Task 3: Data Visualization


plt.style.use("seaborn-v0_8")

# 1️⃣ Line Chart (Dummy Example: cumulative petal length to simulate trend)
df_sorted = df.sort_values(by="petal_length")
plt.figure(figsize=(8,5))
plt.plot(df_sorted.index, df_sorted["petal_length"].cumsum(), marker="o", color="purple")
plt.title("Cumulative Petal Length Trend")
plt.xlabel("Index")
plt.ylabel("Cumulative Petal Length")
plt.grid(True)
plt.show()

# 2️Bar Chart: Average petal length per species
plt.figure(figsize=(6,4))
sns.barplot(x="species", y="petal_length", data=df, ci=None, palette="viridis")
plt.title("Average Petal Length per Species")
plt.xlabel("Species")
plt.ylabel("Petal Length (cm)")
plt.show()

# 3️ Histogram: Distribution of Sepal Length
plt.figure(figsize=(6,4))
plt.hist(df["sepal_length"], bins=10, color="skyblue", edgecolor="black")
plt.title("Sepal Length Distribution")
plt.xlabel("Sepal Length (cm)")
plt.ylabel("Frequency")
plt.show()

# 4️ Scatter Plot: Sepal length vs Petal length
plt.figure(figsize=(6,4))
sns.scatterplot(x="sepal_length", y="petal_length", hue="species", data=df, palette="Set1")
plt.title("Sepal Length vs Petal Length")
plt.xlabel("Sepal Length (cm)")
plt.ylabel("Petal Length (cm)")
plt.legend(title="Species")
plt.show()
