import { 
    DynamoDBClient,
    QueryCommand,
  } from "@aws-sdk/client-dynamodb";
  import {
    DynamoDBDocumentClient,
    ScanCommand,
  } from "@aws-sdk/lib-dynamodb";
  
  const client = new DynamoDBClient({});
  
  const dynamo = DynamoDBDocumentClient.from(client);
  
  const tableName = "fitai.api-v2.public.restaurants";
  
  export const handler = async (event, context) => {
  
    let body;
    let restaurants;
    let statusCode = 200;
    const headers = {
      "Content-Type": "application/json",
    };
  
    try {
      if (event.rawPath === '/v2/restaurants') {
        const restaurantsResponse = await dynamo.send(
          new ScanCommand({ TableName: tableName })
        );
  
        restaurants = restaurantsResponse.Items;
        body = restaurants;
      } else {
        throw new Error(`Unsupported route: ${event.httpMethod} ${event.rawPath}`);
      }
    } catch (err) {
      statusCode = 400;
      body = err.message;
    } finally {
      body = JSON.stringify(body);
    }
  
    return {
      statusCode,
      body,
      headers,
    };
  };
  