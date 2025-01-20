const express = require('express');
const router = express.Router();
const pool = require('../db');

// Strona główna - lista przeglądów
router.get('/', async (req, res) => {
    try {
        const resultInspections = await pool.query('SELECT * FROM przeglądy.get_przeglądy()');
        const resultCars = await pool.query('SELECT * FROM public.samochody_nastepny_przeglad()');
        res.render('inspections', { 
            inspections: resultInspections.rows, 
            carsNextInspection: resultCars.rows, 
            error: null 
        });
    } catch (err) {
        console.error(err.message);
        res.status(500).render('inspections', { 
            inspections: [], 
            carsNextInspection: [], 
            error: 'Nie udało się załadować danych!' 
        });
    }
});

// Dodanie nowego przeglądu
router.post('/add', async (req, res) => {
    const { id_samochodu, data_przeglądu, data_nastepnego_przegladu, koszt } = req.body;
    try {
        await pool.query('CALL przeglądy.dodajprzegląd($1, $2, $3, $4)', 
            [id_samochodu, data_przeglądu, data_nastepnego_przegladu, koszt]);
        res.redirect('/inspections');  // Pozostaje na tej samej stronie
    } catch (err) {
        console.error(err.message);
        let errorMsg = 'Nie udało się dodać przeglądu!';
        const result = await pool.query('SELECT * FROM przeglądy.get_przeglądy()');
        res.render('inspections', { inspections: result.rows, error: errorMsg });
    }
});

// Edytowanie przeglądu
router.post('/edit/:id', async (req, res) => {
    const { id } = req.params;
    const { id_samochodu, data_przeglądu, data_nastepnego_przegladu, koszt } = req.body;
    try {
        await pool.query('CALL przeglądy.edytujprzegląd($1, $2, $3, $4, $5)', 
            [id, id_samochodu, data_przeglądu, data_nastepnego_przegladu, koszt]);
        res.redirect('/inspections');  // Pozostaje na tej samej stronie
    } catch (err) {
        console.error(err.message);
        let errorMsg = 'Nie udało się edytować przeglądu!';
        const result = await pool.query('SELECT * FROM przeglądy.get_przeglądy()');
        res.render('inspections', { inspections: result.rows, error: errorMsg });
    }
});

// Usunięcie przeglądu
router.get('/delete/:id', async (req, res) => {
    const { id } = req.params;
    try {
        await pool.query('CALL przeglądy.usuńprzegląd($1)', [id]);
        res.redirect('/inspections');  // Pozostaje na tej samej stronie
    } catch (err) {
        console.error(err.message);
        let errorMsg = 'Nie udało się usunąć przeglądu!';
        const result = await pool.query('SELECT * FROM przeglądy.get_przeglądy()');
        res.render('inspections', { inspections: result.rows, error: errorMsg });
    }
});

module.exports = router;
