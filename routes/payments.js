const express = require('express');
const router = express.Router();
const pool = require('../db');

// Strona główna - lista płatności
router.get('/', async (req, res) => {
    try {
        const result = await pool.query('SELECT * FROM płatności.get_płatności()');
        res.render('payments', { payments: result.rows });
    } catch (err) {
        console.error(err.message);
        res.status(500).json({ error: 'Coś poszło nie tak!' });
    }
});

// Dodanie nowej płatności
router.post('/add', async (req, res) => {
    const { id_wypożyczenia, kwota, data, metoda_płatności } = req.body;
    try {
        await pool.query('CALL płatności.dodajpłatność($1, $2, $3, $4)', 
            [id_wypożyczenia, kwota, data, metoda_płatności]);
        res.redirect('/payments');  // Pozostaje na tej samej stronie
    } catch (err) {
        console.error(err.message);
        res.status(500).json({ error: 'Coś poszło nie tak!' });
    }
});

// Edytowanie płatności
router.post('/edit/:id', async (req, res) => {
    const { id } = req.params;
    const { id_wypożyczenia, kwota, data, metoda_płatności } = req.body;
    try {
        await pool.query('CALL płatności.edytujpłatność($1, $2, $3, $4, $5)', 
            [id, id_wypożyczenia, kwota, data, metoda_płatności]);
        res.redirect('/payments');  // Pozostaje na tej samej stronie
    } catch (err) {
        console.error(err.message);
        res.status(500).json({ error: 'Coś poszło nie tak!' });
    }
});

// Usunięcie płatności
router.get('/delete/:id', async (req, res) => {
    const { id } = req.params;
    try {
        await pool.query('CALL płatności.usuńpłatność($1)', [id]);
        res.redirect('/payments');  // Pozostaje na tej samej stronie
    } catch (err) {
        console.error(err.message);
        res.status(500).json({ error: 'Coś poszło nie tak!' });
    }
});

module.exports = router;
