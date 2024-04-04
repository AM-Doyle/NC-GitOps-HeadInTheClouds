const express = require("express");
const { postAlert } = require("./controller");
const cors = require("cors");
require("dotenv").config({
  path: "./.env.local",
});
const app = express();

app.use(cors());
app.use(express.json());

app.post("/api/v1/alerts", postAlert);

app.get("/health", (req, res) => {
  res.status(200).send({ health: "OK" });
});

app.use((err, req, res, next) => {
  console.error(err);
  res.status(500).send({ msg: "Internal Server Error" });
});

module.exports = app;
