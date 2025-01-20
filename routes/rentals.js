const express = require('express');
const router = express.Router();
const pool = require('../db');

// Strona główna - lista wypożyczeń
router.get('/', async (req, res) => {
    try {
        const result = await pool.query('SELECT * FROM wypożyczenia.get_wypożyczenia()');
        res.render('rentals', { rentals: result.rows, error: null }); // Dodajemy error: null
    } catch (err) {
        console.error(err.message);
        res.status(500).render('rentals', { rentals: [], error: 'Coś poszło nie tak!' });
    }
});


// Dodanie nowego wypożyczenia
// router.post('/add', async (req, res) => {
//     const { id_samochodu, id_klienta, data_wypozyczenia, data_zwrotu } = req.body;
//     try {
//         await pool.query('CALL wypożyczenia.dodajwypożyczenie($1, $2, $3, $4)', 
//             [id_samochodu, id_klienta, data_wypozyczenia, data_zwrotu]);
//         res.redirect('/rentals'); // Pozostaje na tej samej stronie
//     } catch (err) {
//         console.error(err.message);
//         res.status(500).json({ error: 'Coś poszło nie tak!' });
//     }
// });
// Dodanie nowego wypożyczenia
router.post('/add', async (req, res) => {
    const { id_samochodu, id_klienta, data_wypozyczenia, data_zwrotu } = req.body;
    try {
        // Sprawdzenie, czy samochód jest dostępny
        const isAvailableQuery = 'SELECT czy_wypozyczony FROM public.samochody WHERE id = $1';
        const result = await pool.query(isAvailableQuery, [id_samochodu]);

        if (result.rows.length === 0) {
            // Jeśli nie znaleziono samochodu, zwracamy błąd
            const rentals = await pool.query('SELECT * FROM wypożyczenia.get_wypożyczenia()');
            return res.render('rentals', {
                rentals: rentals.rows,
                error: 'Samochód o podanym ID nie istnieje.',
            });
        }

        if (result.rows[0].czy_wypozyczony) {
            // Jeśli samochód jest wypożyczony, zwracamy błąd
            const rentals = await pool.query('SELECT * FROM wypożyczenia.get_wypożyczenia()');
            return res.render('rentals', {
                rentals: rentals.rows,
                error: 'Samochód jest już wypożyczony. Wybierz inny samochód.',
            });
        }

        // Aktualizacja statusu samochodu na "wypożyczony"
        const updateCarStatusQuery = 'UPDATE public.samochody SET czy_wypozyczony = true WHERE id = $1';
        await pool.query(updateCarStatusQuery, [id_samochodu]);

        // Dodanie nowego wypożyczenia
        await pool.query(
            'CALL wypożyczenia.dodajwypożyczenie($1, $2, $3, $4)',
            [id_samochodu, id_klienta, data_wypozyczenia, data_zwrotu]
        );

        res.redirect('/rentals'); // Powrót do strony głównej
    } catch (err) {
        console.error(err.message);
        res.status(500).json({ error: 'Coś poszło nie tak!' });
    }
});


// Edytowanie wypożyczenia
router.post('/edit/:id', async (req, res) => {
    const { id } = req.params;
    const { id_samochodu, id_klienta, data_wypozyczenia, data_zwrotu } = req.body;
    console.log('Data zwrotu:', data_zwrotu);
    try {
        await pool.query('CALL wypożyczenia.edytujwypożyczenie($1, $2, $3, $4, $5)', 
            [id, id_samochodu, id_klienta, data_wypozyczenia, data_zwrotu]);
        res.redirect('/rentals'); // Pozostaje na tej samej stronie
    } catch (err) {
        console.error(err.message);
        res.status(500).json({ error: 'Coś poszło nie tak!' });
    }
});

// Usunięcie wypożyczenia
router.get('/delete/:id', async (req, res) => {
    const { id } = req.params;
    try {
        // Próbujemy usunąć wypożyczenie
        await pool.query('CALL wypożyczenia."usuńwypożyczenie"($1)', [id]);
        res.redirect('/rentals'); // Przekierowanie do listy wypożyczeń
    } catch (err) {
        console.error(err.message);

        let errorMsg = 'Coś poszło nie tak przy usuwaniu wypożyczenia!';
        
        // Obsługuje błąd powiązania z ubezpieczeniem
        if (err.constraint === 'ubezpieczenia_id_wypozyczenia_fkey') {
            const result = await pool.query('SELECT * FROM wypożyczenia.get_wypożyczenia()');
            res.render('rentals', {
                rentals: result.rows,
                error: 'Nie można usunąć wypożyczenia, ponieważ jest powiązane z ubezpieczeniem.'
            });
        } else {
            // Inny błąd (np. baza danych)
            const result = await pool.query('SELECT * FROM wypożyczenia.get_wypożyczenia()');
            res.render('rentals', {
                rentals: result.rows,
                error: errorMsg
            });
        }
    }
});

// Dodanie nowego endpointu do obsługi funkcji średniej liczby dni wypożyczenia
router.get('/average-rental-days', async (req, res) => {
    try {
        const result = await pool.query('SELECT public.sredni_liczba_dni_wypozyczenia() AS average_days');
        res.json(result.rows[0]);
    } catch (err) {
        console.error(err.message);
        res.status(500).json({ error: 'Coś poszło nie tak!' });
    }
});

module.exports = router;