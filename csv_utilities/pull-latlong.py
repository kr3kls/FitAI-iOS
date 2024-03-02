import pandas as pd

# Read the first CSV file
df1 = pd.read_csv('stateCollegeMenus.csv')

# Read the second CSV file
df2 = pd.read_csv('stateCollegeMenus-restaurants.csv')

# Merge the two dataframes based on the 'restaurant_name' column
merged_df = pd.merge(df1, df2, on='restaurant_name', how='inner')

# Select the desired columns
result_df = merged_df[['id_x', 'restaurant_name', 'address', 'latitude', 'longitude']]

# Rename columns to match original headings
result_df.columns = ['id', 'restaurant_name', 'address', 'latitude', 'longitude']

# Write the combined data to a new CSV file
result_df.to_csv('stateCollegeMenus-restaurants-expanded.csv', index=False)