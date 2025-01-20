const express = require('express');
const router = express.Router();
const pool = require('../db');

// Strona główna - lista przychodów
router.get('/', async (req, res) => {
    try {
        const result = await pool.query('SELECT * FROM Płatności');
        res.render('revenues', { revenues: result.rows });
    } catch (err) {
        console.error(err.message);
        res.status(500).json({ error: 'Coś poszło nie tak!' });
    }
});

// Endpoint do obliczenia sumy przychodów w określonym przedziale dat
router.get('/total-revenue', async (req, res) => {
    const { start_date, end_date } = req.query;  // Parametry daty z query

    // Sprawdzenie, czy obie daty zostały przekazane
    if (!start_date || !end_date) {
        return res.status(400).json({ error: 'Podaj poprawny zakres dat' });
    }

    try {
        const result = await pool.query(
            'SELECT public.suma_przychodow($1, $2) AS total_revenue',
            [start_date, end_date]
        );
        res.json(result.rows[0]); // Zwracamy sumę przychodów
    } catch (err) {
        console.error(err.message);
        res.status(500).json({ error: 'Coś poszło nie tak!' });
    }
});



module.exports = router;
