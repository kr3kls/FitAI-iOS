"""
    This program is for data classification using OpenAI's GPT-3 API
    File created on 21 Feb 2024
"""

import os
import csv
import json
from openai import OpenAI
from dotenv import load_dotenv

# # Load environment variables from .env file
load_dotenv()

def main():

    file_path = "stateCollegeMenus-no_price_address.csv"

    # Read the CSV file
    data = read_csv(file_path)

    # Classify each item in the CSV file
    for item in data:
        raw_item = classify(json.dumps(item))
        item["Calories"] = raw_item["calories"]
        item["Carbs"] = raw_item["carbohydrates"]
        item["Protein"] = raw_item["protein"]
        item["Fat"] = raw_item["fat"]

    # Write the classified data to a new CSV file
    write_csv(data, "stateCollegeMenus-classified.csv")
   

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

def classify(item):
    """
        This function is for data classification using OpenAI's GPT-3 API
        It takes an item as input and returns a JSON object with the macronutrient values
    """
    print(f"Classifying {item}")
    # Instantiate Client
    client = OpenAI(
        api_key=os.environ.get("OPENAI_API_KEY"),
        # base_url="http://localhost:1234/v1", 
        # api_key="not-needed"
    )

    # Define the completion
    chat_completion = client.chat.completions.create(
        messages=[
            {
                "role": "system", "content": "You are a professional dietitian. For each item, estimate the macronutrient values. The macronutrients are calories, carbohydrates, protein, and fat. Reply with a JSON object in the following format: {\"calories\": integer, \"carbohydrates\": integer, \"protein\": integer, \"fat\": integer} Ensure property names are in double quotes. Do not return anything except the JSON object. Do not return any preceding or trailing text."
            },
            {
                "role": "user", "content": f"{item}",
            }
        ],
        model="gpt-4-turbo-preview",
    )

    response = chat_completion.choices[0].message.content
    print(f"Response: {response}")
    return json.loads(response)

if __name__ == "__main__":
    main()