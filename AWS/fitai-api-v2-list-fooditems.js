import { DynamoDBClient } from "@aws-sdk/client-dynamodb";
import { DynamoDBDocumentClient, QueryCommand } from "@aws-sdk/lib-dynamodb";

const client = new DynamoDBClient({});
const ddbDocClient = DynamoDBDocumentClient.from(client);

const tableName = "fitai.api-v2.public.fooditems";

export const handler = async (event) => {
  console.log("Received event:", JSON.stringify(event));
  
  const restaurantId = parseInt(event.pathParameters.RestaurantId, 10);

  if (isNaN(restaurantId)) {
    return {
      statusCode: 400,
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ message: "Invalid RestaurantId" }),
    };
  }

  const params = {
    TableName: tableName,
    KeyConditionExpression: "restaurant_id = :restaurant_id",
    ExpressionAttributeValues: {
      ":restaurant_id": restaurantId,
    },
  };

  try {
    const data = await ddbDocClient.send(new QueryCommand(params));
    console.log("Query succeeded:", data);

    const responseBody = {
      MenuItems: data.Items
    };

    return {
      statusCode: 200,
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(responseBody),
    };
  } catch (err) {
    console.error("Unable to query. Error:", JSON.stringify(err, null, 2));
    return {
      statusCode: 500,
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ message: "Failed to query items from DynamoDB", error: err }),
    };
  }
};
