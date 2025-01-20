const express = require('express');
const router = express.Router();
const pool = require('../db');

// Strona główna - lista samochodów
router.get('/', async (req, res) => {
    try {
        const result = await pool.query('SELECT * FROM samochody.get_samochody()');
        res.render('cars', { cars: result.rows, error: null }); // error ustawione na null
    } catch (err) {
        console.error(err.message);
        res.status(500).render('cars', { cars: [], error: 'Nie udało się załadować listy samochodów!' });
    }
});

// Dodanie nowego samochodu
router.post('/add', async (req, res) => {
    const { marka, model, rok, numer, cena, id_ubezpieczenia, czy_wypozyczony } = req.body;
    try {
        await pool.query('CALL samochody.dodajsamochód($1, $2, $3, $4, $5, $6, $7)', 
            [marka, model, rok, numer, cena, id_ubezpieczenia, czy_wypozyczony]);
        res.redirect('/cars');
    } catch (err) {
        console.error(err.message);

        let errorMsg = 'Nie udało się dodać samochodu!';
        if (err.constraint === 'samochody_numer_rejestracyjny_key') {
            errorMsg = 'Numer rejestracyjny jest już zajęty!';
        }

        const result = await pool.query('SELECT * FROM samochody.get_samochody()');
        res.render('cars', { cars: result.rows, error: errorMsg });
    }
});

// Edytowanie samochodu
router.post('/edit/:id', async (req, res) => {
    const { id } = req.params;
    const { marka, model, rok, numer, cena, id_ubezpieczenia, czy_wypozyczony } = req.body;
    try {
        await pool.query('CALL samochody.edytujsamochód($1, $2, $3, $4, $5, $6, $7, $8)', 
            [id, marka, model, rok, numer, cena, id_ubezpieczenia, czy_wypozyczony]);
        res.redirect('/cars');
    } catch (err) {
        console.error(err.message);

        let errorMsg = 'Nie udało się edytować samochodu!';
        const result = await pool.query('SELECT * FROM samochody.get_samochody()');
        res.render('cars', { cars: result.rows, error: errorMsg });
    }
});

// Usunięcie samochodu
router.get('/delete/:id', async (req, res) => {
    const { id } = req.params;
    try {
        await pool.query('CALL samochody."usuńsamochód"($1)', [id]);
        res.redirect('/cars');
    } catch (err) {
        console.error(err.message);

        let errorMsg = 'Nie udało się usunąć samochodu!';
        if (err.constraint === 'wypożyczenia_id_samochodu_fkey') {
            errorMsg = 'Nie można usunąć samochodu, ponieważ jest powiązany z wypożyczeniami.';
        }

        const result = await pool.query('SELECT * FROM samochody.get_samochody()');
        res.render('cars', { cars: result.rows, error: errorMsg });
    }
});

// Lista samochodów z liczbą wypożyczeń
router.get('/rental-stats', async (req, res) => {
    try {
        const result = await pool.query('SELECT * FROM public.liczba_wypozyczen()');
        res.render('rentalStats', { stats: result.rows, error: null });
    } catch (err) {
        console.error(err.message);
        res.status(500).render('rentalStats', { stats: [], error: 'Coś poszło nie tak przy ładowaniu statystyk!' });
    }
});

module.exports = router;
