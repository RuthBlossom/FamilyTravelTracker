import express from "express"; // Importing Express framework
import bodyParser from "body-parser"; // Middleware for parsing request bodies
import pg from "pg"; // PostgreSQL client library

const app = express(); // Creating an Express application
const port = 3000; // Port number for the server to listen on

const db = {
  connect: () => {
    console.log("Connected to the database successfully!");
  }
};

// Dummy code for database connection
db.connect();


app.use(bodyParser.urlencoded({ extended: true })); // Using body-parser middleware to parse URL-encoded bodies
app.use(express.static("public")); // Serving static files from the "public" directory

let currentUserId = 1; // Variable to store the ID of the current user

let users = [ // Initial array of users (temporary)
  { id: 1, name: "Ruth", color: "teal" },
  { id: 2, name: "Byron", color: "powderblue" },
];

// Function to check visited countries for the current user from the database
async function checkVisited() {
  const result = await db.query(
    "SELECT country_code FROM visited_countries JOIN users ON users.id = user_id WHERE user_id = $1; ",
    [currentUserId]
  );
  let countries = [];
  result.rows.forEach((country) => {
    countries.push(country.country_code);
  });
  return countries;
}

// Function to get the current user from the database
async function getCurrentUser() {
  const result = await db.query("SELECT * FROM users");
  users = result.rows;
  return users.find((user) => user.id == currentUserId);
}

// Route to handle the homepage
app.get("/", async (req, res) => {
  const countries = await checkVisited(); // Get visited countries for the current user
  const currentUser = await getCurrentUser(); // Get the current user
  res.render("index.ejs", { // Render the index.ejs template with data
    countries: countries, // Visited countries
    total: countries.length, // Total number of visited countries
    users: users, // All users
    color: currentUser.color, // Current user's favorite color
  });
});

// Route to handle adding a new visited country
app.post("/add", async (req, res) => {
  const input = req.body["country"]; // Get the country input from the request body
  const currentUser = await getCurrentUser(); // Get the current user

  try {
    const result = await db.query(
      "SELECT country_code FROM countries WHERE LOWER(country_name) LIKE '%' || $1 || '%';",
      [input.toLowerCase()]
    );

    const data = result.rows[0];
    const countryCode = data.country_code;
    try {
      await db.query(
        "INSERT INTO visited_countries (country_code, user_id) VALUES ($1, $2)",
        [countryCode, currentUserId]
      );
      res.redirect("/"); // Redirect to the homepage after adding the country
    } catch (err) {
      console.log(err);
    }
  } catch (err) {
    console.log(err);
  }
});

// Route to handle selecting a user
app.post("/user", async (req, res) => {
  if (req.body.add === "new") { // If user wants to add a new user
    res.render("new.ejs"); // Render the new.ejs template
  } else {
    currentUserId = req.body.user; // Set the current user ID to the selected user
    res.redirect("/"); // Redirect to the homepage
  }
});

// Route to handle adding a new user
app.post("/new", async (req, res) => {
  const name = req.body.name; // Get the name from the request body
  const color = req.body.color; // Get the color from the request body

  const result = await db.query(
    "INSERT INTO users (name, color) VALUES($1, $2) RETURNING *;",
    [name, color]
  );

  const id = result.rows[0].id; // Get the ID of the newly added user
  currentUserId = id; // Set the current user ID to the newly added user

  res.redirect("/"); // Redirect to the homepage
});

// Start the server
app.listen(port, () => {
  console.log(`Server running on http://localhost:${port}`);
});

