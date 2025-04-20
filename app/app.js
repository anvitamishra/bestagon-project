const express = require('express')
const { Pool } = require('pg')

const app = express()

app.use(express.json())

const pool = new Pool({
  host:     process.env.PGHOST     || 'postgres',
  port:     parseInt(process.env.PGPORT, 10) || 5432,
  database: process.env.PGDATABASE || 'bestagon',
  user:     process.env.PGUSER     || 'bestagonuser',
  password: process.env.PGPASSWORD || 'bestagonpass',
})

pool
  .query('SELECT 1')
  .then(() => console.log('✅ Connected to Postgres'))
  .catch(err => {
    console.error('❌ Postgres connection error', err)
    process.exit(1)
  })

app.get('/hello', (req, res) => {
  res.send('Hello!')
})

app.post('/bananas', async (req, res) => {
  const { name, ripe } = req.body
  if (!name) return res.status(400).json({ error: 'name is required' })

  try {
    const { rows } = await pool.query(
      `INSERT INTO bananas (name,ripe) VALUES($1,$2) RETURNING *`,
      [name, ripe || null]
    )
    res.status(201).json(rows[0])
  } catch (err) {
    console.error(err)
    res.status(500).json({ error: 'DB error' })
  }
})

const port = process.env.PORT || 3000

app.listen(port, () => {
  console.log(`Server running on port ${port}`)
})
