const express = require('express');
const bodyParser = require('body-parser');
const path = require('path');
const pool = require('./db');  // Zakładając, że masz już plik db.js
const clientRoutes = require('./routes/clients');
const carsRoutes = require('./routes/cars');
const insuranceRoutes = require('./routes/insurance');
const paymentsRoutes = require('./routes/payments');
const inspectionsRoutes = require('./routes/inspections');
const rentalsRoutes = require('./routes/rentals');
const repairsRoutes = require('./routes/repairs');
const revenuesRoutes = require('./routes/revenues');

const app = express();
const port = 3000;

// Middleware
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.use(express.static(path.join(__dirname, 'public')));

// EJS - silnik szablonów
app.set('view engine', 'ejs');

// Strona główna
app.get('/', (req, res) => {
    res.redirect('/home'); // Przekierowanie na stronę główną
});

// Strona główna (home)
app.get('/home', (req, res) => {
    res.render('index'); // Renderujemy stronę główną
});

// Użyj tras z pliku routes/clients.js
app.use('/clients', clientRoutes);
app.use('/cars', carsRoutes);
app.use('/insurance', insuranceRoutes);
app.use('/payments', paymentsRoutes);
app.use('/inspections', inspectionsRoutes);
app.use('/rentals', rentalsRoutes);
app.use('/repairs', repairsRoutes);
app.use('/revenues', revenuesRoutes);


// Uruchomienie serwera
app.listen(port, () => {
    console.log(`Aplikacja działa na http://localhost:${port}`);
});
