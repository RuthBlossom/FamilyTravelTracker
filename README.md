# Travel Tracker Web Application

This is a web application built with Node.js and Express.js that allows users to track the countries they have visited. Users can add new countries they have visited and view a list of countries they have already visited. The application also supports user authentication and interacts with a PostgreSQL database to store user data.

## Features

- Add new countries visited.
- View a list of countries visited.
- User authentication for secure access.
- Integration with PostgreSQL database for data storage.

## Getting Started

To get started with this project, follow these steps:

1. Clone this repository to your local machine.
2. Install dependencies using `npm install`.
3. Set up your PostgreSQL database with the provided schema.
4. Configure your database connection 
5. Start the application using `npm start`.
6. Open your web browser and navigate to `http://localhost:3000` to use the application.

## Why Dummy Code Was Used

In the source code, dummy code was included for demonstration purposes in the database connection setup. This dummy code serves to illustrate how the database connection might be established without revealing sensitive information like database credentials. Here's an example of the dummy code used:

```javascript
const db = {
  connect: () => {
    console.log("Connected to the database successfully!");
  }
};

// Dummy code for database connection
db.connect();
```

In a real-world scenario, sensitive information like database credentials should never be exposed in the source code. Instead, secure methods such as environment variables or configuration files should be used to handle such information. The use of dummy code here is to emphasize the importance of handling sensitive data securely.

