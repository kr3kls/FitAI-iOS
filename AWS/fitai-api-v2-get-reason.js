import AWS from 'aws-sdk';
import OpenAI from 'openai';

const dynamoDb = new AWS.DynamoDB.DocumentClient();
const openAiApiKey = process.env.OPENAI_API_KEY;

export const handler = async (event) => {
    const { restaurant_id, item_id, item_category, fitness_goal } = event.pathParameters;
    const fitnessGoals = ['lose weight', 'maintain weight', 'gain weight', 'build muscle', 'improve fitness'];
    const itemCategory = ['good', 'moderate', 'poor'];

    const params = {
        TableName: 'fitai.api-v2.public.fooditems',
        KeyConditionExpression: 'restaurant_id = :restaurant_id and id = :id',
        ExpressionAttributeValues: { 
            ':restaurant_id': parseInt(restaurant_id),
            ':id': parseInt(item_id) 
        }
    };

    try {
        const data = await dynamoDb.query(params).promise();
        if (data.Items.length === 0) {
            throw new Error('Item not found');
        }
        const item = data.Items[0]; 

        const prompt = `Given that ${item.menu_item}, calories: ${item.Calories}, fat: ${item.Fat}, carbs: ${item.Carbs}, protein: ${item.Protein} is categorized as ${itemCategory[item_category - 1]} for the user's goal to ${fitnessGoals[fitness_goal]}, why is this item a ${itemCategory[item_category - 1]} choice.`;
        const openai = new OpenAI({
            apiKey: process.env.OPENAI_API_KEY,
        });
        
        const openAiResponse = await openai.chat.completions.create({
            model: "gpt-4",
            messages: [{role: "system", content: "You are a professional dietician. Please respond to user questions with short, educational responses no more than 2 sentences long."},
            {role: "user", content: prompt}],
            max_tokens: 100,
            temperature: 0.7
        });

        const responseMessage = openAiResponse.choices[0].message;

        return {
            statusCode: 200,
            body: JSON.stringify({ response: responseMessage })
        };
    } catch (error) {
        console.error(error);
        return {
            statusCode: 500,
            body: JSON.stringify({ message: 'Failed to process your request', error: error.message })
        };
    }
};
