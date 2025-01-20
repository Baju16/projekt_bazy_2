const express = require('express');
const router = express.Router();
const pool = require('../db');

// Strona główna - lista napraw
router.get('/', async (req, res) => {
    try {
        const result = await pool.query('SELECT * FROM naprawy.get_naprawy()');
        res.render('repairs', { repairs: result.rows });
    } catch (err) {
        console.error(err.message);
        res.status(500).json({ error: 'Coś poszło nie tak!' });
    }
});

// Dodanie nowej naprawy
router.post('/add', async (req, res) => {
    const { car_id, rodzaj_naprawy, data_naprawy, koszt } = req.body;
    try {
        await pool.query('CALL naprawy.dodajnaprawę($1, $2, $3, $4)', 
            [car_id, rodzaj_naprawy, data_naprawy, koszt]);
        res.redirect('/repairs');  // Pozostaje na tej samej stronie
    } catch (err) {
        console.error(err.message);
        res.status(500).json({ error: 'Coś poszło nie tak!' });
    }
});


// Edytowanie naprawy
router.post('/edit/:id', async (req, res) => {
    const { id } = req.params;
    const { car_id, rodzaj_naprawy, data_naprawy, koszt } = req.body;

    try {
        // Sprawdzanie formatu daty
        const dataNaprawy = new Date(data_naprawy);
        if (isNaN(dataNaprawy)) {
            return res.status(400).json({ error: 'Niepoprawny format daty' });
        }

        // Sprawdzanie formatu kosztu
        const kosztNaprawy = parseFloat(koszt);
        if (isNaN(kosztNaprawy)) {
            return res.status(400).json({ error: 'Koszt naprawy musi być liczbą' });
        }

        // Wywołanie procedury edytującej naprawę
        await pool.query('CALL naprawy.edytujnaprawę($1, $2, $3, $4, $5)', 
            [id, car_id, dataNaprawy, rodzaj_naprawy, kosztNaprawy]);
        res.redirect('/repairs');  // Pozostaje na tej samej stronie
    } catch (err) {
        console.error(err.message);
        res.status(500).json({ error: 'Coś poszło nie tak!' });
    }
});


// Usunięcie naprawy
router.get('/delete/:id', async (req, res) => {
    const { id } = req.params;
    try {
        await pool.query('CALL naprawy.usuńnaprawę($1)', [id]);
        res.redirect('/repairs');  // Pozostaje na tej samej stronie
    } catch (err) {
        console.error(err.message);
        res.status(500).json({ error: 'Coś poszło nie tak!' });
    }
});

module.exports = router;
