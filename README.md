# Welcome to Fit.AI!
Fit.Ai is a personalized diet planning app that optimizes the user’s nutritional needs wherever they are on campus. 
The app combines individual fitness goals with local food menus to categorize the user’s food options from green, 
yellow, and red according to their needs. The Fit.AI team trained a gradient-boosted decision-tree multiclass 
classification model to classify the menu items based on the macronutrients and the user’s chosen fitness goal. 
This includes calories, fat, carbohydrates, and protein. We also leverage the power of generative AI to provide 
educational explanations of each item's classification. While also providing a locational service to users, Fit.AI 
guides students to make better meal choices aligned with their fitness goals.

## AWS Backend
The backend of Fit.AI includes an API Gateway with three endpoints. The endpoints pass path parameters to AWS Lambda
functions written in Javascript.

|                Name                  |                                Purpose                              |
|--------------------------------------|---------------------------------------------------------------------|
| AWS/fitai-api-v2-get-reason.js       | Call OpenAI API to generate rationale for classification decisions. |
| AWS/fitai-api-v2-list-fooditems.js   | Return a list of food items from the DynamoDB tables.               |
| AWS/fitai-api-v2-list-restaurants.js | Return a list of restaurants from the DynamoDB tables.              |


## iOS Application
The application is written in Swift and incorporates functionality from SwiftUI, Swift Data, HealthKit, and CoreML.

### Views
The views are nested and follow this functional architecture:

```
FitAIApp.swift
└── ContentView.swift
    ├── HeaderView.swift
    ├── BodyView.Swift
    │   ├── ProfileView.swift
    │   │   └── HealthCardView.swift
    │   ├── EditUserView.swift
    │   ├── RestaurantListView.swift
    │   ├── MenuDetailView.swift
    │   │   ├── MapView.swift
    │   │   └── MenuItemView.swift
    │   └── FeedbackView.swift
    └── Footerview.Swift
```

### Data Models

|         Name            |                       Purpose                               |
|--------------------------------------|------------------------------------------------|
| MenuItemModel.swift     | Used to decode and store the JSON response for menu items.  |
| RestaurantModel.swift   | Used to decode and store the JSON response for restaurants. |
| UserModel.swift         | Used to store the local user profile.                       |


### Services

|                 Name                 |                                  Purpose                                         |
|--------------------------------------|----------------------------------------------------------------------------------|
| FitAI/Services/AWSService.swift      | Provides functionality to send and recieve data between the application and AWS  |
| FitAI/Services/HealthService.swift   | Loads user data from Apple Health.                                               |
