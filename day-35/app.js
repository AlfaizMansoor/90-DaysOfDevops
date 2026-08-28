const express = require("express");
const app = express();

app.get("/", (req, res) => {
  res.send(`
    <!DOCTYPE html>
    <html lang="en">
    <head>
      <meta charset="UTF-8">
      <title>Hello World</title>
      <style>
        body {
          margin: 0;
          font-family: 'Segoe UI', sans-serif;
          background: linear-gradient(120deg, #84fab0 0%, #8fd3f4 100%);
          display: flex;
          justify-content: center;
          align-items: center;
          height: 100vh;
        }
        .card {
          background: white;
          padding: 50px;
          border-radius: 16px;
          box-shadow: 0 8px 25px rgba(0,0,0,0.2);
          text-align: center;
          animation: fadeIn 1.5s ease-in-out;
        }
        h1 {
          color: #2c3e50;
          font-size: 2.5em;
          margin-bottom: 0.5em;
        }
        p {
          color: #34495e;
          font-size: 1.2em;
        }
        @keyframes fadeIn {
          from { opacity: 0; transform: translateY(20px); }
          to { opacity: 1; transform: translateY(0); }
        }
      </style>
    </head>
    <body>
      <div class="card">
        <h1>Hello, World! 🌍</h1>
        <p>Welcome to a beautifully enhanced Node.js app ✨</p>
      </div>
    </body>
    </html>
  `);
});

app.listen(3000, () => console.log("🚀 App running at http://localhost:3000"));

