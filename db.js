const { Pool } = require('pg');

// Konfiguracja połączenia z bazą danych
const pool = new Pool({
    user: 'postgres',       // Użytkownik bazy danych
    host: 'localhost',       // Adres serwera bazy danych
    database: 'baza',     // Nazwa bazy danych
    password: '1526wer', // Hasło do bazy danych
    port: 5432,              // Domyślny port PostgreSQL
});

module.exports = pool;
