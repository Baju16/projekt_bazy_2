const express = require('express');
const router = express.Router();
const pool = require('../db');

// Strona główna - lista klientów
router.get('/', async (req, res) => {
    try {
        const result = await pool.query('SELECT * FROM klienci.get_klienci()');
        res.render('clients', { clients: result.rows, error: null }); // error ustawione na null
    } catch (err) {
        console.error(err.message);
        res.status(500).render('clients', { clients: [], error: 'Coś poszło nie tak przy ładowaniu klientów!' });
    }
});

// Dodanie nowego klienta
router.post('/add', async (req, res) => {
    const { imie, nazwisko, nr_prawa_jazdy, email, telefon } = req.body;
    try {
        await pool.query('CALL klienci.dodajklienta($1, $2, $3, $4, $5)', 
            [imie, nazwisko, nr_prawa_jazdy, email, telefon]);
        res.redirect('/clients'); // Powrót do listy klientów
    } catch (err) {
        console.error(err.message);

        // Jeśli błąd wynika z duplikatu (np. unikalnego e-maila)
        let errorMsg = 'Coś poszło nie tak!';
        if (err.constraint === 'klienci_email_key') {
            errorMsg = 'Podany adres email jest już zajęty!';
        } else if (err.constraint === 'klienci_nr_prawa_jazdy_key') {
            errorMsg = 'Podany numer prawa jazdy jest już zajęty!';
        }

        const result = await pool.query('SELECT * FROM klienci.get_klienci()'); // Załaduj ponownie klientów
        res.render('clients', { clients: result.rows, error: errorMsg });
    }
});

// Edytowanie klienta
router.post('/edit/:id', async (req, res) => {
    const { id } = req.params;
    const { imie, nazwisko, nr_prawa_jazdy, email, telefon } = req.body;
    try {
        await pool.query('CALL klienci.edytujklienta($1, $2, $3, $4, $5, $6)', 
            [id, imie, nazwisko, nr_prawa_jazdy, email, telefon]);
        res.redirect('/clients'); // Powrót do listy klientów
    } catch (err) {
        console.error(err.message);

        const result = await pool.query('SELECT * FROM klienci.get_klienci()');
        res.render('clients', { clients: result.rows, error: 'Błąd podczas edytowania klienta!' });
    }
});

// Usunięcie klienta
router.get('/delete/:id', async (req, res) => {
    const { id } = req.params;
    try {
        await pool.query('CALL klienci."usuńklienta"($1)', [id]);
        res.redirect('/clients');
    } catch (err) {
        console.error(err.message);

        if (err.constraint === 'wypożyczenia_id_klienta_fkey') {
            const result = await pool.query('SELECT * FROM klienci.get_klienci()'); // Załaduj ponownie klientów
            res.render('clients', {
                clients: result.rows,
                error: 'Nie można usunąć użytkownika, ponieważ istnieją powiązane wypożyczenia.'
            });
        } else {
            res.status(500).render('clients', {
                clients: [],
                error: 'Coś poszło nie tak przy usuwaniu klienta!'
            });
        }
    }
});

// Wyświetlenie średniego kosztu wynajmu dla klienta
router.get('/average-rental-cost/:id', async (req, res) => {
    const { id } = req.params;
    try {
        const result = await pool.query('SELECT public.sredni_koszt_wynajmu_klienta($1) AS sredni_koszt', [id]);
        res.json({ sredni_koszt: result.rows[0].sredni_koszt });
    } catch (err) {
        console.error(err.message);
        res.status(500).json({ error: 'Nie udało się pobrać średniego kosztu wynajmu dla tego klienta.' });
    }
});


// Wyświetlenie liczby wypożyczeń dla konkretnego klienta
router.get('/rental-count/:id', async (req, res) => {
    const { id } = req.params;
    try {
        const result = await pool.query('SELECT public.liczba_wypozyczen_dla_klienta($1) AS liczba_wypozyczen', [id]);
        res.json({ liczba_wypozyczen: result.rows[0].liczba_wypozyczen });
    } catch (err) {
        console.error(err.message);
        res.status(500).json({ error: 'Nie udało się pobrać liczby wypożyczeń dla tego klienta.' });
    }
});

// Wyświetlenie średniej liczby dni wypożyczenia dla klienta
router.get('/average-rental-days/:id', async (req, res) => {
    const { id } = req.params;
    try {
        const result = await pool.query('SELECT public.srednia_ilosc_dni_wypozyczenia_klienta($1) AS srednia_dni', [id]);
        res.json({ srednia_dni: result.rows[0].srednia_dni });
    } catch (err) {
        console.error(err.message);
        res.status(500).json({ error: 'Nie udało się pobrać średniej liczby dni wypożyczenia dla tego klienta.' });
    }
});


module.exports = router;