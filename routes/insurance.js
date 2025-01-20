const express = require('express');
const router = express.Router();
const pool = require('../db');

// Strona główna - lista ubezpieczeń
router.get('/', async (req, res) => {
    try {
        const resultInsurance = await pool.query('SELECT * FROM ubezpieczenia.get_ubezpieczenia()');
        const resultCars = await pool.query('SELECT * FROM public.samochody_koniec_ubezpieczenia()');
        res.render('insurance', { 
            insurance: resultInsurance.rows, 
            carsEndInsurance: resultCars.rows, 
            error: null 
        });
    } catch (err) {
        console.error(err.message);
        res.status(500).render('insurance', { 
            insurance: [], 
            carsEndInsurance: [], 
            error: 'Nie udało się załadować danych!' 
        });
    }
});


// Dodanie nowego ubezpieczenia
router.post('/add', async (req, res) => {
    const { ubezpieczyciel, data_poczatku, data_konca, koszt_ubezpieczenia } = req.body;
    try {
        const resultCars = await pool.query('SELECT * FROM public.samochody_koniec_ubezpieczenia()');
        await pool.query('CALL ubezpieczenia.dodajubezpieczenie($1, $2, $3, $4)', 
            [ubezpieczyciel, data_poczatku, data_konca, koszt_ubezpieczenia]);
        res.redirect('/insurance');  // Pozostaje na tej samej stronie
    } catch (err) {
        console.error(err.message);
        let errorMsg = 'Nie udało się dodać ubezpieczenia!';
        if (err.constraint === 'ubezpieczenia_ubezpieczyciel_key') {
            errorMsg = 'Ubezpieczyciel jest już zapisany!';
        }
        const result = await pool.query('SELECT * FROM ubezpieczenia.get_ubezpieczenia()');
        res.render('insurance', { insurance: result.rows, error: errorMsg });
    }
});

// Edytowanie ubezpieczenia
router.post('/edit/:id', async (req, res) => {
    const { id } = req.params;
    const { ubezpieczyciel, data_poczatku, data_konca, koszt_ubezpieczenia } = req.body;
    try {
        await pool.query('CALL ubezpieczenia.edytujubezpieczenie($1, $2, $3, $4, $5)', 
            [id, ubezpieczyciel, data_poczatku, data_konca, koszt_ubezpieczenia]);
        res.redirect('/insurance');  // Pozostaje na tej samej stronie
    } catch (err) {
        console.error(err.message);
        let errorMsg = 'Nie udało się edytować ubezpieczenia!';
        const result = await pool.query('SELECT * FROM ubezpieczenia.get_ubezpieczenia()');
        res.render('insurance', { insurance: result.rows, error: errorMsg });
    }
});

// Usunięcie ubezpieczenia
router.get('/delete/:id', async (req, res) => {
    const { id } = req.params;
    try {
        await pool.query('CALL ubezpieczenia."usuńubezpieczenie"($1)', [id]);
        res.redirect('/insurance');  // Pozostaje na tej samej stronie
    } catch (err) {
        console.error(err.message);
        let errorMsg = 'Nie udało się usunąć ubezpieczenia!';
        if (err.constraint === 'samochody_id_ubezpieczenia_fkey') {
            errorMsg = 'Nie można usunąć ubezpieczenia, ponieważ jest powiązane z samochodami.';
        }

        // Pobierz dane ubezpieczeń oraz dane samochodów w przypadku błędu
        const resultInsurance = await pool.query('SELECT * FROM ubezpieczenia.get_ubezpieczenia()');
        const resultCars = await pool.query('SELECT * FROM public.samochody_koniec_ubezpieczenia()');

        // Renderuj widok z danymi i komunikatem o błędzie
        res.render('insurance', { 
            insurance: resultInsurance.rows, 
            carsEndInsurance: resultCars.rows, 
            error: errorMsg 
        });
    }
});



module.exports = router;