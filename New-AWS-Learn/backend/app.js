const express = require('express');
const { Pool } = require('pg');
const cors = require('cors');

const app = express();
app.use(express.json());
app.use(cors());

const port = process.env.PORT || 3000;

const pool = new Pool({
  host: process.env.DB_HOST,          // RDS endpoint DNS
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  port: 5432,
  ssl: { rejectUnauthorized: false }
});

// Create table if not exists
pool.query(`
  CREATE TABLE IF NOT EXISTS tasks (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    status VARCHAR(50) DEFAULT 'pending'
  )
`);

app.get('/health', (req, res) => {
  res.json({ status: "Backend healthy" });
});

app.get('/tasks', async (req, res) => {
  const result = await pool.query("SELECT * FROM tasks ORDER BY id DESC");
  res.json(result.rows);
});

app.post('/tasks', async (req, res) => {
  const { title } = req.body;
  const result = await pool.query(
    "INSERT INTO tasks(title) VALUES($1) RETURNING *",
    [title]
  );
  res.json(result.rows[0]);
});

app.put('/tasks/:id', async (req, res) => {
  const { status } = req.body;
  const { id } = req.params;
  const result = await pool.query(
    "UPDATE tasks SET status=$1 WHERE id=$2 RETURNING *",
    [status, id]
  );
  res.json(result.rows[0]);
});

app.delete('/tasks/:id', async (req, res) => {
  const { id } = req.params;
  await pool.query("DELETE FROM tasks WHERE id=$1", [id]);
  res.json({ message: "Task deleted" });
});

app.listen(port, () => {
  console.log(`Backend running on port ${port}`);
});