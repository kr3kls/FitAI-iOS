import os
import csv

def main():
    restaurants = []
    final_menu_path = "stateCollegeMenus-4.csv"
    restaurants_path = "stateCollegeMenus-restaurants.csv"

    # Read the CSV file
    final_menu_data = read_csv(final_menu_path)

    # Classify each item in the CSV file
    for item in data:
        print(item["id"])
        if not item["restaurant_name"] in restaurants:
            restaurants.append(item["restaurant_name"])
            
        item["restaurant_id"] = restaurants.index(item["restaurant_name"])

    # Write the classified data to a new CSV file
    write_csv(data, "stateCollegeMenus-final.csv")
   

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