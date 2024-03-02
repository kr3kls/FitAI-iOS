import os
import csv

def main():
    restaurants = []
    file_path = "stateCollegeMenus-final.csv"

    # Read the CSV file
    data = read_csv(file_path)

    # Classify each item in the CSV file
    for item in data:
        print(item["id"])
        if not item["restaurant_id"] in restaurants:
            restaurants.append({
                'id': item["restaurant_id"],
                'restaurant_name': item["restaurant_name"]})

    # Write the classified data to a new CSV file
    write_csv(restaurants, "stateCollegeMenus-restaurants.csv")
   

def read_csv(file_path):
    """
        This function reads a CSV file and returns its contents as a list of dictionaries
    """
    data = []
    with open(file_path, 'r') as file:
        reader = csv.DictReader(file)
        for row in reader:
            data.append(row)
    return data

def write_csv(data, file_path):
    """
        This function writes a list of dictionaries to a CSV file
    """
    with open(file_path, 'w', newline='') as file:
        writer = csv.DictWriter(file, fieldnames=data[0].keys())
        writer.writeheader()
        writer.writerows(data)
    
    file.close()

if __name__ == "__main__":
    main()