--
-- PostgreSQL database dump
--

-- Dumped from database version 17.0
-- Dumped by pg_dump version 17.0

-- Started on 2025-01-21 10:07:57 CET

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 6 (class 2615 OID 17169)
-- Name: klienci; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA klienci;


ALTER SCHEMA klienci OWNER TO postgres;

--
-- TOC entry 7 (class 2615 OID 17170)
-- Name: naprawy; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA naprawy;


ALTER SCHEMA naprawy OWNER TO postgres;

--
-- TOC entry 8 (class 2615 OID 17171)
-- Name: przeglądy; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA "przeglądy";


ALTER SCHEMA "przeglądy" OWNER TO postgres;

--
-- TOC entry 9 (class 2615 OID 17172)
-- Name: płatności; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA "płatności";


ALTER SCHEMA "płatności" OWNER TO postgres;

--
-- TOC entry 10 (class 2615 OID 17173)
-- Name: samochody; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA samochody;


ALTER SCHEMA samochody OWNER TO postgres;

--
-- TOC entry 11 (class 2615 OID 17174)
-- Name: ubezpieczenia; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA ubezpieczenia;


ALTER SCHEMA ubezpieczenia OWNER TO postgres;

--
-- TOC entry 12 (class 2615 OID 17175)
-- Name: wypożyczenia; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA "wypożyczenia";


ALTER SCHEMA "wypożyczenia" OWNER TO postgres;

--
-- TOC entry 238 (class 1255 OID 17176)
-- Name: dodajklienta(character varying, character varying, character varying, character varying, character varying); Type: PROCEDURE; Schema: klienci; Owner: postgres
--

CREATE PROCEDURE klienci.dodajklienta(IN p_imie character varying, IN p_nazwisko character varying, IN p_nr_prawa_jazdy character varying, IN p_email character varying, IN p_telefon character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO Klienci (Imię, Nazwisko, Nr_prawa_jazdy, Email, Telefon)
    VALUES (p_imie, p_nazwisko, p_nr_prawa_jazdy, p_email, p_telefon);
END;
$$;


ALTER PROCEDURE klienci.dodajklienta(IN p_imie character varying, IN p_nazwisko character varying, IN p_nr_prawa_jazdy character varying, IN p_email character varying, IN p_telefon character varying) OWNER TO postgres;

--
-- TOC entry 239 (class 1255 OID 17177)
-- Name: edytujklienta(integer, character varying, character varying, character varying, character varying, character varying); Type: PROCEDURE; Schema: klienci; Owner: postgres
--

CREATE PROCEDURE klienci.edytujklienta(IN p_id integer, IN p_imie character varying, IN p_nazwisko character varying, IN p_nr_prawa_jazdy character varying, IN p_email character varying, IN p_telefon character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Sprawdzenie, czy klient o podanym ID istnieje
    IF NOT EXISTS (
        SELECT 1
        FROM Klienci
        WHERE ID = p_id
    ) THEN
        RAISE EXCEPTION 'Klient o ID % nie istnieje.', p_id;
    END IF;

    -- Aktualizacja danych klienta
    UPDATE Klienci
    SET
        Imię = p_imie,
        Nazwisko = p_nazwisko,
        Nr_prawa_jazdy = p_nr_prawa_jazdy,
        Email = p_email,
        Telefon = p_telefon
    WHERE ID = p_id;
END;
$$;


ALTER PROCEDURE klienci.edytujklienta(IN p_id integer, IN p_imie character varying, IN p_nazwisko character varying, IN p_nr_prawa_jazdy character varying, IN p_email character varying, IN p_telefon character varying) OWNER TO postgres;

--
-- TOC entry 240 (class 1255 OID 17178)
-- Name: get_klienci(); Type: FUNCTION; Schema: klienci; Owner: postgres
--

CREATE FUNCTION klienci.get_klienci() RETURNS TABLE(id integer, imie character varying, nazwisko character varying, nr_prawa_jazdy character varying, email character varying, telefon character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
    cur CURSOR FOR SELECT * FROM public.klienci;
    rec RECORD;
BEGIN
    FOR rec IN cur LOOP
        id := rec.id;
        imie := rec.imię;
        nazwisko := rec.nazwisko;
        nr_prawa_jazdy := rec.nr_prawa_jazdy;
        email := rec.email;
        telefon := rec.telefon;
        RETURN NEXT;
    END LOOP;
END;
$$;


ALTER FUNCTION klienci.get_klienci() OWNER TO postgres;

--
-- TOC entry 241 (class 1255 OID 17179)
-- Name: usuńklienta(integer); Type: PROCEDURE; Schema: klienci; Owner: postgres
--

CREATE PROCEDURE klienci."usuńklienta"(IN p_id integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    DELETE FROM Klienci WHERE ID = p_id;
END;
$$;


ALTER PROCEDURE klienci."usuńklienta"(IN p_id integer) OWNER TO postgres;

--
-- TOC entry 242 (class 1255 OID 17180)
-- Name: dodajnaprawę(integer, text, date, numeric); Type: PROCEDURE; Schema: naprawy; Owner: postgres
--

CREATE PROCEDURE naprawy."dodajnaprawę"(IN p_id_samochodu integer, IN p_rodzaj_naprawy text, IN p_data_naprawy date, IN p_koszt numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Sprawdzenie, czy samochód istnieje w tabeli Samochody
    IF NOT EXISTS (SELECT 1 FROM Samochody WHERE ID = p_id_samochodu) THEN
        RAISE EXCEPTION 'Samochód o ID % nie istnieje.', p_id_samochodu;
    END IF;

    -- Dodanie nowej naprawy do tabeli Naprawy
    INSERT INTO Naprawy (id_samochodu, rodzaj_naprawy, data_naprawy, koszt)
    VALUES (p_id_samochodu, p_rodzaj_naprawy, p_data_naprawy, p_koszt);

    -- Można dodać również zwrócenie informacji o udanej operacji (opcjonalne)
    RAISE NOTICE 'Naprawa dla samochodu ID % została dodana.', p_id_samochodu;

END;
$$;


ALTER PROCEDURE naprawy."dodajnaprawę"(IN p_id_samochodu integer, IN p_rodzaj_naprawy text, IN p_data_naprawy date, IN p_koszt numeric) OWNER TO postgres;

--
-- TOC entry 244 (class 1255 OID 17181)
-- Name: edytujnaprawę(integer, integer, date, text, numeric); Type: PROCEDURE; Schema: naprawy; Owner: postgres
--

CREATE PROCEDURE naprawy."edytujnaprawę"(IN p_id integer, IN p_id_samochodu integer, IN p_data_naprawy date, IN p_rodzaj_naprawy text, IN p_koszt numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Sprawdzenie, czy naprawa istnieje w tabeli Naprawy
    IF NOT EXISTS (SELECT 1 FROM Naprawy WHERE id_naprawy = p_id) THEN
        RAISE EXCEPTION 'Naprawa o ID % nie istnieje.', p_id;
    END IF;

    -- Sprawdzenie, czy samochód istnieje w tabeli Samochody
    IF NOT EXISTS (SELECT 1 FROM Samochody WHERE ID = p_id_samochodu) THEN
        RAISE EXCEPTION 'Samochód o ID % nie istnieje.', p_id_samochodu;
    END IF;

    -- Aktualizacja naprawy w tabeli Naprawy
    UPDATE Naprawy
    SET id_samochodu = p_id_samochodu,
        rodzaj_naprawy = p_rodzaj_naprawy,
        data_naprawy = p_data_naprawy,
        koszt = p_koszt
    WHERE id_naprawy = p_id;

    RAISE NOTICE 'Naprawa o ID % została zaktualizowana.', p_id;

END;
$$;


ALTER PROCEDURE naprawy."edytujnaprawę"(IN p_id integer, IN p_id_samochodu integer, IN p_data_naprawy date, IN p_rodzaj_naprawy text, IN p_koszt numeric) OWNER TO postgres;

--
-- TOC entry 247 (class 1255 OID 17182)
-- Name: get_naprawy(); Type: FUNCTION; Schema: naprawy; Owner: postgres
--

CREATE FUNCTION naprawy.get_naprawy() RETURNS TABLE(id_naprawy integer, id_samochodu integer, rodzaj_naprawy text, data_naprawy text, koszt numeric)
    LANGUAGE plpgsql
    AS $$
DECLARE
    -- Deklaracja kursora
    cur CURSOR FOR 
        SELECT n.id_naprawy, n.id_samochodu, n.rodzaj_naprawy, n.data_naprawy, n.koszt
        FROM public.naprawy n;  -- Alias tabeli "naprawy" jako "n"
BEGIN
    -- Otwieramy kursor
    OPEN cur;

    -- Iterujemy po wynikach kursora i zwracamy je
    LOOP
        FETCH cur INTO id_naprawy, id_samochodu, rodzaj_naprawy, data_naprawy, koszt;
        EXIT WHEN NOT FOUND;  -- Zakończenie pętli, gdy nie ma więcej wyników

        -- Jeśli data_naprawy jest typu 'timestamp' lub 'date', możemy użyć TO_CHAR
        data_naprawy := TO_CHAR(data_naprawy::date, 'YYYY-MM-DD');
        
        RETURN NEXT;  -- Zwracanie pojedynczego wiersza
    END LOOP;

    -- Zamknięcie kursora
    CLOSE cur;

    RETURN;
END;
$$;


ALTER FUNCTION naprawy.get_naprawy() OWNER TO postgres;

--
-- TOC entry 248 (class 1255 OID 17183)
-- Name: usuńnaprawę(integer); Type: PROCEDURE; Schema: naprawy; Owner: postgres
--

CREATE PROCEDURE naprawy."usuńnaprawę"(IN p_id_naprawy integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Sprawdzenie, czy naprawa istnieje
    IF NOT EXISTS (SELECT 1 FROM Naprawy WHERE id_naprawy = p_id_naprawy) THEN
        RAISE EXCEPTION 'Naprawa o ID % nie istnieje.', p_id_naprawy;
    END IF;

    -- Usunięcie naprawy z tabeli Naprawy
    DELETE FROM Naprawy WHERE id_naprawy = p_id_naprawy;

    RAISE NOTICE 'Naprawa o ID % została usunięta.', p_id_naprawy;
END;
$$;


ALTER PROCEDURE naprawy."usuńnaprawę"(IN p_id_naprawy integer) OWNER TO postgres;

--
-- TOC entry 260 (class 1255 OID 17184)
-- Name: dodajprzegląd(integer, date, date, numeric); Type: PROCEDURE; Schema: przeglądy; Owner: postgres
--

CREATE PROCEDURE "przeglądy"."dodajprzegląd"(IN p_id_samochodu integer, IN "p_data_przeglądu" date, IN p_data_nastepnego_przegladu date DEFAULT NULL::date, IN p_koszt numeric DEFAULT NULL::numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Sprawdzenie, czy samochód istnieje w tabeli 'samochody'
    IF NOT EXISTS (
        SELECT 1 
        FROM public.samochody 
        WHERE id = p_id_samochodu
    ) THEN
        RAISE EXCEPTION 'Samochód o podanym ID (%) nie istnieje.', p_id_samochodu;
    END IF;

    -- Dodanie nowego przeglądu
    INSERT INTO public."przeglądy" (id_samochodu, "data_przeglądu", data_nastepnego_przegladu, koszt)
    VALUES (p_id_samochodu, p_data_przeglądu, p_data_nastepnego_przegladu, p_koszt);

    -- Zgłoszenie informacji o dodaniu przeglądu
    RAISE NOTICE 'Przegląd dodany pomyślnie dla samochodu o ID %.', p_id_samochodu;
END;
$$;


ALTER PROCEDURE "przeglądy"."dodajprzegląd"(IN p_id_samochodu integer, IN "p_data_przeglądu" date, IN p_data_nastepnego_przegladu date, IN p_koszt numeric) OWNER TO postgres;

--
-- TOC entry 261 (class 1255 OID 17185)
-- Name: edytujprzegląd(integer, integer, date, date, numeric); Type: PROCEDURE; Schema: przeglądy; Owner: postgres
--

CREATE PROCEDURE "przeglądy"."edytujprzegląd"(IN p_id integer, IN p_id_samochodu integer, IN "p_data_przeglądu" date, IN p_data_nastepnego_przegladu date, IN p_koszt numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Sprawdzenie, czy przegląd o podanym ID istnieje
    IF NOT EXISTS (SELECT 1 FROM public."przeglądy" WHERE "id" = p_id) THEN
        RAISE EXCEPTION 'Przegląd o podanym ID % nie istnieje.', p_id;
    END IF;

    -- Sprawdzenie, czy samochód o podanym ID istnieje
    IF NOT EXISTS (SELECT 1 FROM public.samochody WHERE id = p_id_samochodu) THEN
        RAISE EXCEPTION 'Samochód o podanym ID % nie istnieje.', p_id_samochodu;
    END IF;

    -- Aktualizacja przeglądu
    UPDATE public."przeglądy"
    SET id_samochodu = p_id_samochodu,
        "data_przeglądu" = p_data_przeglądu,
        data_nastepnego_przegladu = p_data_nastepnego_przegladu,
        koszt = p_koszt
    WHERE "id" = p_id;

    RAISE NOTICE 'Przegląd o ID % został zaktualizowany.', p_id;
END;
$$;


ALTER PROCEDURE "przeglądy"."edytujprzegląd"(IN p_id integer, IN p_id_samochodu integer, IN "p_data_przeglądu" date, IN p_data_nastepnego_przegladu date, IN p_koszt numeric) OWNER TO postgres;

--
-- TOC entry 262 (class 1255 OID 17186)
-- Name: get_przeglądy(); Type: FUNCTION; Schema: przeglądy; Owner: postgres
--

CREATE FUNCTION "przeglądy"."get_przeglądy"() RETURNS TABLE(id integer, id_samochodu integer, "data_przeglądu" text, data_nastepnego_przegladu text, koszt numeric)
    LANGUAGE plpgsql
    AS $$
DECLARE
    cur CURSOR FOR SELECT * FROM public."przeglądy";
    rec RECORD;
BEGIN
    FOR rec IN cur LOOP
        id := rec."id";
        id_samochodu := rec.id_samochodu;
        -- Formatowanie daty do postaci 'DD-MM-YYYY'
        data_przeglądu := TO_CHAR(rec."data_przeglądu", 'DD-MM-YYYY');
        data_nastepnego_przegladu := TO_CHAR(rec.data_nastepnego_przegladu, 'DD-MM-YYYY');
        koszt := rec.koszt;
        RETURN NEXT;
    END LOOP;
END;
$$;


ALTER FUNCTION "przeglądy"."get_przeglądy"() OWNER TO postgres;

--
-- TOC entry 263 (class 1255 OID 17187)
-- Name: usuńprzegląd(integer); Type: PROCEDURE; Schema: przeglądy; Owner: postgres
--

CREATE PROCEDURE "przeglądy"."usuńprzegląd"(IN p_id integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    DELETE FROM public."przeglądy" WHERE "id" = p_id;
    RAISE NOTICE 'Przegląd o ID % został usunięty.', p_id;
END;
$$;


ALTER PROCEDURE "przeglądy"."usuńprzegląd"(IN p_id integer) OWNER TO postgres;

--
-- TOC entry 264 (class 1255 OID 17188)
-- Name: aktualizuj_czy_wypozyczony(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.aktualizuj_czy_wypozyczony() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Sprawdzanie, czy istnieje aktywne wypożyczenie samochodu (niezwrócony)
    IF EXISTS (SELECT 1 FROM public.wypozyczenia 
               WHERE id_samochodu = NEW.id_samochodu
               AND (data_zwrotu IS NULL OR data_zwrotu > CURRENT_DATE)) THEN
        -- Jeśli istnieje aktywne wypożyczenie, ustawiamy 'czy_wypozyczony' na true
        UPDATE public.samochody
        SET "czy_wypozyczony" = true
        WHERE id = NEW.id_samochodu;
    ELSE
        -- Jeśli brak aktywnego wypożyczenia, ustawiamy 'czy_wypozyczony' na false
        UPDATE public.samochody
        SET "czy_wypozyczony" = false
        WHERE id = NEW.id_samochodu;
    END IF;
    
    RETURN NULL;
END;
$$;


ALTER FUNCTION public.aktualizuj_czy_wypozyczony() OWNER TO postgres;

--
-- TOC entry 265 (class 1255 OID 17189)
-- Name: liczba_wypozyczen(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.liczba_wypozyczen() RETURNS TABLE(samochod_id integer, marka character varying, model character varying, numer_rejestracyjny character varying, liczba_wypozyczen integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        s.ID AS Samochod_ID,
        s.Marka,
        s.Model,
        s.Numer_rejestracyjny,
        COUNT(w.ID)::INT AS Liczba_wypozyczen
    FROM 
        Samochody s
    LEFT JOIN 
        Wypozyczenia w ON s.ID = w.ID_samochodu
    GROUP BY 
        s.ID, s.Marka, s.Model, s.Numer_rejestracyjny
    ORDER BY 
        Liczba_wypozyczen DESC;
END;
$$;


ALTER FUNCTION public.liczba_wypozyczen() OWNER TO postgres;

--
-- TOC entry 266 (class 1255 OID 17190)
-- Name: liczba_wypozyczen_dla_klienta(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.liczba_wypozyczen_dla_klienta(client_id integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_liczba_wypozyczen INTEGER;
BEGIN
    -- Zliczamy liczbę wypożyczeń danego klienta na podstawie jego ID
    SELECT COUNT(*) INTO v_liczba_wypozyczen
    FROM Wypozyczenia
    WHERE ID_klienta = client_id;

    -- Zwracamy liczbę wypożyczeń
    RETURN v_liczba_wypozyczen;
END;
$$;


ALTER FUNCTION public.liczba_wypozyczen_dla_klienta(client_id integer) OWNER TO postgres;

--
-- TOC entry 267 (class 1255 OID 17191)
-- Name: oblicz_kwote_platnosci(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.oblicz_kwote_platnosci() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_data_wypozyczenia DATE;  -- Zmienna na potrzeby funkcji
    v_data_zwrotu DATE;  -- Zmienna na potrzeby funkcji
    v_id_samochodu INT;  -- Zmienna na potrzeby funkcji
    liczba_dni INT;
    v_cena_za_dzien NUMERIC(10, 2);  -- Zmienna na cenę za dzień
    koszt_calkowity NUMERIC(10, 2);
BEGIN
    -- Pobierz dane wypożyczenia
    SELECT w.data_wypozyczenia, COALESCE(w.data_zwrotu, CURRENT_DATE), w.id_samochodu
    INTO v_data_wypozyczenia, v_data_zwrotu, v_id_samochodu
    FROM public.wypozyczenia w
    WHERE w.id = NEW.ID_wypożyczenia;  -- NEW.ID_wypożyczenia to ID wypożyczenia z tabeli Płatności

    -- Sprawdź, czy wypożyczenie istnieje
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Wypożyczenie o id % nie istnieje', NEW.ID_wypożyczenia;
    END IF;

    -- Oblicz liczbę dni wypożyczenia
    liczba_dni := v_data_zwrotu - v_data_wypozyczenia + 1;
    IF liczba_dni <= 0 THEN
        RAISE EXCEPTION 'Nieprawidłowy zakres dat: data zwrotu (%), data wypożyczenia (%)', v_data_zwrotu, v_data_wypozyczenia;
    END IF;

    -- Pobierz cenę za dzień dla samochodu
    SELECT s.cena_za_dzien
    INTO v_cena_za_dzien
    FROM public.samochody s
    WHERE s.id = v_id_samochodu;

    -- Sprawdź, czy samochód istnieje
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Samochód o id % nie istnieje', v_id_samochodu;
    END IF;

    -- Oblicz całkowity koszt
    koszt_calkowity := v_cena_za_dzien * liczba_dni;

    -- Zwróć wynik
    NEW.Kwota := koszt_calkowity;

    RETURN NEW;
END;
$$;


ALTER FUNCTION public.oblicz_kwote_platnosci() OWNER TO postgres;

--
-- TOC entry 268 (class 1255 OID 17192)
-- Name: samochody_koniec_ubezpieczenia(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.samochody_koniec_ubezpieczenia() RETURNS TABLE(id_samochodu integer, marka character varying, model character varying, numer_rejestracyjny character varying, data_konca text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        s.ID AS ID_samochodu,
        s.Marka,
        s.Model,
        s.Numer_rejestracyjny,
        TO_CHAR(u.Data_końca, 'YYYY-MM-DD') AS Data_konca
    FROM 
        Samochody s
    JOIN 
        Ubezpieczenia u
    ON 
        s.ID_ubezpieczenia = u.ID
    WHERE 
        u.Data_końca BETWEEN CURRENT_DATE AND CURRENT_DATE + INTERVAL '30 days';
END;
$$;


ALTER FUNCTION public.samochody_koniec_ubezpieczenia() OWNER TO postgres;

--
-- TOC entry 269 (class 1255 OID 17193)
-- Name: samochody_nastepny_przeglad(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.samochody_nastepny_przeglad() RETURNS TABLE(id_samochodu integer, marka character varying, model character varying, numer_rejestracyjny character varying, data_nastepnego_przegladu date)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        s.ID AS ID_samochodu,
        s.Marka,
        s.Model,
        s.Numer_rejestracyjny,
        p.data_nastepnego_przegladu
    FROM 
        Samochody s
    JOIN 
        przeglądy p
    ON 
        s.ID = p.id_samochodu
    WHERE 
        p.data_nastepnego_przegladu BETWEEN CURRENT_DATE AND CURRENT_DATE + INTERVAL '30 days';
END;
$$;


ALTER FUNCTION public.samochody_nastepny_przeglad() OWNER TO postgres;

--
-- TOC entry 270 (class 1255 OID 17194)
-- Name: sprawdz_przeglad(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sprawdz_przeglad() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Sprawdzanie, czy samochód ma ważny przegląd
    IF (SELECT data_nastepnego_przegladu FROM public."przeglądy" WHERE id_samochodu = NEW.id_samochodu ORDER BY data_przeglądu DESC LIMIT 1) < CURRENT_DATE THEN
        RAISE EXCEPTION 'Samochód nie ma ważnego przeglądu';
    END IF;

    RETURN NEW;
END;
$$;


ALTER FUNCTION public.sprawdz_przeglad() OWNER TO postgres;

--
-- TOC entry 271 (class 1255 OID 17195)
-- Name: sprawdz_ubezpieczenie(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sprawdz_ubezpieczenie() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF (SELECT Data_końca FROM Ubezpieczenia WHERE ID = (SELECT ID_ubezpieczenia FROM Samochody WHERE ID = NEW.ID_samochodu)) < CURRENT_DATE THEN
        RAISE EXCEPTION 'Samochód nie ma ważnego ubezpieczenia';
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.sprawdz_ubezpieczenie() OWNER TO postgres;

--
-- TOC entry 272 (class 1255 OID 17196)
-- Name: sredni_koszt_wynajmu_klienta(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sredni_koszt_wynajmu_klienta(p_id_klienta integer) RETURNS numeric
    LANGUAGE plpgsql
    AS $$
DECLARE
    wynik numeric;
BEGIN
    -- Obliczamy średnią kwotę płatności dla danego klienta
    SELECT AVG(p.kwota)
    INTO wynik
    FROM public."płatności" p
    JOIN public."wypozyczenia" w ON p."id_wypożyczenia" = w.id
    WHERE w."id_klienta" = p_id_klienta;
    
    -- Zaokrąglamy wynik do 2 miejsc po przecinku
    RETURN ROUND(wynik, 2);
END;
$$;


ALTER FUNCTION public.sredni_koszt_wynajmu_klienta(p_id_klienta integer) OWNER TO postgres;

--
-- TOC entry 273 (class 1255 OID 17197)
-- Name: sredni_liczba_dni_wypozyczenia(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.sredni_liczba_dni_wypozyczenia() RETURNS numeric
    LANGUAGE plpgsql
    AS $$
DECLARE
    srednia_dni DECIMAL(10, 2);
BEGIN
    SELECT 
        COALESCE(AVG((w.Data_zwrotu - w.Data_wypozyczenia)::DOUBLE PRECISION), 0)
    INTO 
        srednia_dni
    FROM 
        Wypozyczenia w
    WHERE 
        w.Data_zwrotu IS NOT NULL;

    RETURN srednia_dni;
END;
$$;


ALTER FUNCTION public.sredni_liczba_dni_wypozyczenia() OWNER TO postgres;

--
-- TOC entry 274 (class 1255 OID 17198)
-- Name: srednia_ilosc_dni_wypozyczenia_klienta(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.srednia_ilosc_dni_wypozyczenia_klienta(p_id_klienta integer) RETURNS numeric
    LANGUAGE plpgsql
    AS $$
DECLARE
    wynik numeric;
BEGIN
    -- Obliczamy średnią liczbę dni wypożyczenia dla danego klienta
    SELECT AVG(w."data_zwrotu" - w."data_wypozyczenia")
    INTO wynik
    FROM public."wypozyczenia" w
    WHERE w."id_klienta" = p_id_klienta AND w."data_zwrotu" IS NOT NULL;

    -- Jeśli brak wyników (np. klient nie ma żadnych zwróconych wypożyczeń), ustawiamy wynik na 0
    IF wynik IS NULL THEN
        RETURN 0;
    END IF;

    -- Zwracamy wynik zaokrąglony do dwóch miejsc po przecinku
    RETURN ROUND(wynik, 2);
END;
$$;


ALTER FUNCTION public.srednia_ilosc_dni_wypozyczenia_klienta(p_id_klienta integer) OWNER TO postgres;

--
-- TOC entry 275 (class 1255 OID 17199)
-- Name: suma_przychodow(date, date); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.suma_przychodow(start_date date, end_date date) RETURNS numeric
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN (
        SELECT SUM(wp.Kwota)
        FROM Płatności wp
        WHERE wp.Data BETWEEN start_date AND end_date
    );
END;
$$;


ALTER FUNCTION public.suma_przychodow(start_date date, end_date date) OWNER TO postgres;

--
-- TOC entry 276 (class 1255 OID 17200)
-- Name: dodajpłatność(integer, numeric, date, character varying); Type: PROCEDURE; Schema: płatności; Owner: postgres
--

CREATE PROCEDURE "płatności"."dodajpłatność"(IN "p_id_wypożyczenia" integer, IN p_kwota numeric, IN p_data date, IN "p_metoda_płatności" character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Wypozyczenia WHERE ID = p_id_wypożyczenia) THEN
        RAISE EXCEPTION 'Wypożyczenie o ID % nie istnieje.', p_id_wypożyczenia;
    END IF;

    INSERT INTO Płatności (ID_wypożyczenia, Kwota, Data, Metoda_Płatności)
    VALUES (p_id_wypożyczenia, p_kwota, p_data, p_metoda_płatności);
END;
$$;


ALTER PROCEDURE "płatności"."dodajpłatność"(IN "p_id_wypożyczenia" integer, IN p_kwota numeric, IN p_data date, IN "p_metoda_płatności" character varying) OWNER TO postgres;

--
-- TOC entry 277 (class 1255 OID 17201)
-- Name: edytujpłatność(integer, integer, numeric, date, character varying); Type: PROCEDURE; Schema: płatności; Owner: postgres
--

CREATE PROCEDURE "płatności"."edytujpłatność"(IN p_id integer, IN "p_id_wypożyczenia" integer, IN p_kwota numeric, IN p_data date, IN "p_metoda_płatności" character varying)
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Płatności WHERE ID = p_id) THEN
        RAISE EXCEPTION 'Płatność o ID % nie istnieje.', p_id;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM Wypozyczenia WHERE ID = p_id_wypożyczenia) THEN
        RAISE EXCEPTION 'Wypożyczenie o ID % nie istnieje.', p_id_wypożyczenia;
    END IF;

    UPDATE Płatności
    SET ID_wypożyczenia = p_id_wypożyczenia, Kwota = p_kwota, Data = p_data, Metoda_Płatności = p_metoda_płatności
    WHERE ID = p_id;
END;
$$;


ALTER PROCEDURE "płatności"."edytujpłatność"(IN p_id integer, IN "p_id_wypożyczenia" integer, IN p_kwota numeric, IN p_data date, IN "p_metoda_płatności" character varying) OWNER TO postgres;

--
-- TOC entry 243 (class 1255 OID 17202)
-- Name: get_płatności(); Type: FUNCTION; Schema: płatności; Owner: postgres
--

CREATE FUNCTION "płatności"."get_płatności"() RETURNS TABLE(id integer, "id_wypożyczenia" integer, kwota numeric, data character varying, "metoda_płatności" character varying)
    LANGUAGE plpgsql
    AS $$
DECLARE
    cur CURSOR FOR SELECT * FROM public."płatności";
    rec RECORD;
BEGIN
    FOR rec IN cur LOOP
        -- Przypisanie wartości do zmiennych
        id := rec.id;
        id_wypożyczenia := rec."id_wypożyczenia";  -- Upewnij się, że nie ma błędu w nazwie kolumny
        kwota := rec.kwota;
        
        -- Formatowanie daty na 'dd-mm-yyyy'
        data := TO_CHAR(rec.data, 'DD-MM-YYYY');
        
        metoda_płatności := rec."metoda_płatności";  -- Upewnij się, że nazwa kolumny jest poprawna

        -- Zwrócenie wiersza
        RETURN NEXT;
    END LOOP;
END;
$$;


ALTER FUNCTION "płatności"."get_płatności"() OWNER TO postgres;

--
-- TOC entry 245 (class 1255 OID 17203)
-- Name: usuńpłatność(integer); Type: PROCEDURE; Schema: płatności; Owner: postgres
--

CREATE PROCEDURE "płatności"."usuńpłatność"(IN p_id integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    DELETE FROM Płatności WHERE ID = p_id;
END;
$$;


ALTER PROCEDURE "płatności"."usuńpłatność"(IN p_id integer) OWNER TO postgres;

--
-- TOC entry 246 (class 1255 OID 17204)
-- Name: dodajsamochód(character varying, character varying, integer, character varying, numeric, integer); Type: PROCEDURE; Schema: samochody; Owner: postgres
--

CREATE PROCEDURE samochody."dodajsamochód"(IN p_marka character varying, IN p_model character varying, IN p_rok_produkcji integer, IN p_numer_rejestracyjny character varying, IN p_cena_za_dzien numeric, IN p_id_ubezpieczenia integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Sprawdzenie, czy podane ID ubezpieczenia istnieje
    IF NOT EXISTS (
        SELECT 1
        FROM Ubezpieczenia
        WHERE ID = p_id_ubezpieczenia
    ) THEN
        RAISE EXCEPTION 'Ubezpieczenie o ID % nie istnieje.', p_id_ubezpieczenia;
    END IF;

    -- Wstawienie danych do tabeli Samochody
    INSERT INTO Samochody (Marka, Model, Rok_produkcji, Numer_rejestracyjny, Cena_za_dzień, ID_ubezpieczenia)
    VALUES (p_marka, p_model, p_rok_produkcji, p_numer_rejestracyjny, p_cena_za_dzien, p_id_ubezpieczenia);
END;
$$;


ALTER PROCEDURE samochody."dodajsamochód"(IN p_marka character varying, IN p_model character varying, IN p_rok_produkcji integer, IN p_numer_rejestracyjny character varying, IN p_cena_za_dzien numeric, IN p_id_ubezpieczenia integer) OWNER TO postgres;

--
-- TOC entry 278 (class 1255 OID 17205)
-- Name: dodajsamochód(character varying, character varying, integer, character varying, numeric, integer, boolean); Type: PROCEDURE; Schema: samochody; Owner: postgres
--

CREATE PROCEDURE samochody."dodajsamochód"(IN p_marka character varying, IN p_model character varying, IN p_rok_produkcji integer, IN p_numer_rejestracyjny character varying, IN p_cena_za_dzien numeric, IN p_id_ubezpieczenia integer, IN p_czy_wypozyczony boolean)
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Sprawdzenie, czy podane ID ubezpieczenia istnieje
    IF NOT EXISTS (
        SELECT 1
        FROM Ubezpieczenia
        WHERE ID = p_id_ubezpieczenia
    ) THEN
        RAISE EXCEPTION 'Ubezpieczenie o ID % nie istnieje.', p_id_ubezpieczenia;
    END IF;

    -- Wstawienie danych do tabeli Samochody
    INSERT INTO Samochody (marka, model, rok_produkcji, numer_rejestracyjny, cena_za_dzien, id_ubezpieczenia, czy_wypozyczony)
    VALUES (p_marka, p_model, p_rok_produkcji, p_numer_rejestracyjny, p_cena_za_dzien, p_id_ubezpieczenia, p_czy_wypozyczony);
END;
$$;


ALTER PROCEDURE samochody."dodajsamochód"(IN p_marka character varying, IN p_model character varying, IN p_rok_produkcji integer, IN p_numer_rejestracyjny character varying, IN p_cena_za_dzien numeric, IN p_id_ubezpieczenia integer, IN p_czy_wypozyczony boolean) OWNER TO postgres;

--
-- TOC entry 279 (class 1255 OID 17206)
-- Name: edytujsamochód(integer, character varying, character varying, integer, character varying, numeric, integer); Type: PROCEDURE; Schema: samochody; Owner: postgres
--

CREATE PROCEDURE samochody."edytujsamochód"(IN p_id integer, IN p_marka character varying, IN p_model character varying, IN p_rok_produkcji integer, IN p_numer_rejestracyjny character varying, IN p_cena_za_dzien numeric, IN p_id_ubezpieczenia integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Sprawdzenie, czy samochód o podanym ID istnieje
    IF NOT EXISTS (
        SELECT 1
        FROM Samochody
        WHERE ID = p_id
    ) THEN
        RAISE EXCEPTION 'Samochód o ID % nie istnieje.', p_id;
    END IF;

    -- Sprawdzenie, czy podane ID ubezpieczenia istnieje
    IF NOT EXISTS (
        SELECT 1
        FROM Ubezpieczenia
        WHERE ID = p_id_ubezpieczenia
    ) THEN
        RAISE EXCEPTION 'Ubezpieczenie o ID % nie istnieje.', p_id_ubezpieczenia;
    END IF;

    -- Aktualizacja danych w tabeli samochody
    UPDATE Samochody
    SET
        Marka = p_marka,
        Model = p_model,
        Rok_produkcji = p_rok_produkcji,
        Numer_rejestracyjny = p_numer_rejestracyjny,
        Cena_za_dzień = p_cena_za_dzien,
        ID_ubezpieczenia = p_id_ubezpieczenia
    WHERE ID = p_id;
END;
$$;


ALTER PROCEDURE samochody."edytujsamochód"(IN p_id integer, IN p_marka character varying, IN p_model character varying, IN p_rok_produkcji integer, IN p_numer_rejestracyjny character varying, IN p_cena_za_dzien numeric, IN p_id_ubezpieczenia integer) OWNER TO postgres;

--
-- TOC entry 280 (class 1255 OID 17207)
-- Name: edytujsamochód(integer, character varying, character varying, integer, character varying, numeric, integer, boolean); Type: PROCEDURE; Schema: samochody; Owner: postgres
--

CREATE PROCEDURE samochody."edytujsamochód"(IN p_id integer, IN p_marka character varying, IN p_model character varying, IN p_rok_produkcji integer, IN p_numer_rejestracyjny character varying, IN p_cena_za_dzien numeric, IN p_id_ubezpieczenia integer, IN p_czy_wypozyczony boolean)
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Sprawdzenie, czy samochód o podanym ID istnieje
    IF NOT EXISTS (
        SELECT 1
        FROM samochody
        WHERE ID = p_id
    ) THEN
        RAISE EXCEPTION 'Samochód o ID % nie istnieje.', p_id;
    END IF;

    -- Sprawdzenie, czy podane ID ubezpieczenia istnieje
    IF NOT EXISTS (
        SELECT 1
        FROM ubezpieczenia
        WHERE ID = p_id_ubezpieczenia
    ) THEN
        RAISE EXCEPTION 'Ubezpieczenie o ID % nie istnieje.', p_id_ubezpieczenia;
    END IF;

    -- Aktualizacja danych w tabeli samochody
    UPDATE Samochody
    SET
        marka = p_marka,
        model = p_model,
        rok_produkcji = p_rok_produkcji,
        numer_rejestracyjny = p_numer_rejestracyjny,
        cena_za_dzien = p_cena_za_dzien,
        id_ubezpieczenia = p_id_ubezpieczenia,
        czy_wypozyczony = p_czy_wypozyczony
    WHERE ID = p_id;
END;
$$;


ALTER PROCEDURE samochody."edytujsamochód"(IN p_id integer, IN p_marka character varying, IN p_model character varying, IN p_rok_produkcji integer, IN p_numer_rejestracyjny character varying, IN p_cena_za_dzien numeric, IN p_id_ubezpieczenia integer, IN p_czy_wypozyczony boolean) OWNER TO postgres;

--
-- TOC entry 281 (class 1255 OID 17208)
-- Name: get_samochody(); Type: FUNCTION; Schema: samochody; Owner: postgres
--

CREATE FUNCTION samochody.get_samochody() RETURNS TABLE(id integer, marka character varying, model character varying, rok_produkcji integer, numer_rejestracyjny character varying, cena_za_dzien numeric, id_ubezpieczenia integer, czy_wypozyczony boolean)
    LANGUAGE plpgsql
    AS $$
DECLARE
    cur CURSOR FOR SELECT * FROM public.samochody;
    rec RECORD;
BEGIN
    FOR rec IN cur LOOP
        id := rec.id;
        marka := rec.marka;
        model := rec.model;
        rok_produkcji := rec.rok_produkcji;
        numer_rejestracyjny := rec.numer_rejestracyjny;
        cena_za_dzien := rec.cena_za_dzien;
        id_ubezpieczenia := rec.id_ubezpieczenia;
        czy_wypozyczony := rec.czy_wypozyczony; -- Dodanie kolumny czy_wypozyczony
        RETURN NEXT;
    END LOOP;
END;
$$;


ALTER FUNCTION samochody.get_samochody() OWNER TO postgres;

--
-- TOC entry 282 (class 1255 OID 17209)
-- Name: usuńsamochód(integer); Type: PROCEDURE; Schema: samochody; Owner: postgres
--

CREATE PROCEDURE samochody."usuńsamochód"(IN p_id integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    DELETE FROM Samochody WHERE ID = p_id;
END;
$$;


ALTER PROCEDURE samochody."usuńsamochód"(IN p_id integer) OWNER TO postgres;

--
-- TOC entry 283 (class 1255 OID 17210)
-- Name: dodajubezpieczenie(character varying, date, date, numeric); Type: PROCEDURE; Schema: ubezpieczenia; Owner: postgres
--

CREATE PROCEDURE ubezpieczenia.dodajubezpieczenie(IN p_ubezpieczyciel character varying, IN p_data_poczatku date, IN p_data_konca date, IN p_koszt numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO Ubezpieczenia (Ubezpieczyciel, Data_początku, Data_końca, Koszt_ubezpieczenia)
    VALUES (p_ubezpieczyciel, p_data_poczatku, p_data_konca, p_koszt);
END;
$$;


ALTER PROCEDURE ubezpieczenia.dodajubezpieczenie(IN p_ubezpieczyciel character varying, IN p_data_poczatku date, IN p_data_konca date, IN p_koszt numeric) OWNER TO postgres;

--
-- TOC entry 284 (class 1255 OID 17211)
-- Name: edytujubezpieczenie(integer, character varying, date, date, numeric); Type: PROCEDURE; Schema: ubezpieczenia; Owner: postgres
--

CREATE PROCEDURE ubezpieczenia.edytujubezpieczenie(IN p_id integer, IN p_ubezpieczyciel character varying, IN p_data_poczatku date, IN p_data_konca date, IN p_koszt numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Sprawdzenie, czy ubezpieczenie o podanym ID istnieje
    IF NOT EXISTS (
        SELECT 1
        FROM Ubezpieczenia
        WHERE ID = p_id
    ) THEN
        RAISE EXCEPTION 'Ubezpieczenie o ID % nie istnieje.', p_id;
    END IF;

    -- Aktualizacja danych ubezpieczenia
    UPDATE Ubezpieczenia
    SET
        Ubezpieczyciel = p_ubezpieczyciel,
        Data_początku = p_data_poczatku,
        Data_końca = p_data_konca,
        Koszt_ubezpieczenia = p_koszt
    WHERE ID = p_id;
END;
$$;


ALTER PROCEDURE ubezpieczenia.edytujubezpieczenie(IN p_id integer, IN p_ubezpieczyciel character varying, IN p_data_poczatku date, IN p_data_konca date, IN p_koszt numeric) OWNER TO postgres;

--
-- TOC entry 285 (class 1255 OID 17212)
-- Name: get_ubezpieczenia(); Type: FUNCTION; Schema: ubezpieczenia; Owner: postgres
--

CREATE FUNCTION ubezpieczenia.get_ubezpieczenia() RETURNS TABLE(id integer, ubezpieczyciel character varying, data_poczatku character varying, data_konca character varying, koszt_ubezpieczenia numeric)
    LANGUAGE plpgsql
    AS $$
DECLARE
    cur CURSOR FOR SELECT u.id, u.ubezpieczyciel, TO_CHAR(u."data_początku", 'DD-MM-YYYY') AS data_poczatku, TO_CHAR(u."data_końca", 'DD-MM-YYYY') AS data_konca, u.koszt_ubezpieczenia
                  FROM public.ubezpieczenia u;  -- Alias 'u' dla tabeli
    rec RECORD;
BEGIN
    FOR rec IN cur LOOP
        id := rec.id;
        ubezpieczyciel := rec.ubezpieczyciel;
        data_poczatku := rec.data_poczatku;
        data_konca := rec.data_konca;
        koszt_ubezpieczenia := rec.koszt_ubezpieczenia;
        RETURN NEXT;
    END LOOP;
END;
$$;


ALTER FUNCTION ubezpieczenia.get_ubezpieczenia() OWNER TO postgres;

--
-- TOC entry 286 (class 1255 OID 17213)
-- Name: usuńubezpieczenie(integer); Type: PROCEDURE; Schema: ubezpieczenia; Owner: postgres
--

CREATE PROCEDURE ubezpieczenia."usuńubezpieczenie"(IN p_id integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    DELETE FROM Ubezpieczenia WHERE ID = p_id;
END;
$$;


ALTER PROCEDURE ubezpieczenia."usuńubezpieczenie"(IN p_id integer) OWNER TO postgres;

--
-- TOC entry 287 (class 1255 OID 17214)
-- Name: dodajwypożyczenie(integer, integer, date, date); Type: PROCEDURE; Schema: wypożyczenia; Owner: postgres
--

CREATE PROCEDURE "wypożyczenia"."dodajwypożyczenie"(IN p_id_samochodu integer, IN p_id_klienta integer, IN "p_data_wypożyczenia" date, IN p_data_zwrotu date)
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Sprawdzanie, czy samochód istnieje
    IF NOT EXISTS (SELECT 1 FROM Samochody WHERE ID = p_id_samochodu) THEN
        RAISE EXCEPTION 'Samochód o ID % nie istnieje.', p_id_samochodu;
    END IF;

    -- Sprawdzanie, czy klient istnieje
    IF NOT EXISTS (SELECT 1 FROM Klienci WHERE ID = p_id_klienta) THEN
        RAISE EXCEPTION 'Klient o ID % nie istnieje.', p_id_klienta;
    END IF;

    -- Sprawdzanie, czy samochód jest już wypożyczony
    IF EXISTS (SELECT 1 FROM Samochody WHERE ID = p_id_samochodu AND Czy_wypozyczony = TRUE) THEN
        RAISE EXCEPTION 'Samochód o ID % jest już wypożyczony.', p_id_samochodu;
    END IF;

    -- Dodanie wypożyczenia
    INSERT INTO wypozyczenia (ID_samochodu, ID_klienta, Data_wypozyczenia, Data_zwrotu)
    VALUES (p_id_samochodu, p_id_klienta, p_data_wypożyczenia, p_data_zwrotu);

    -- Zaktualizowanie flagi Czy_wypozyczony na TRUE
    UPDATE Samochody
    SET Czy_wypozyczony = TRUE
    WHERE ID = p_id_samochodu;
    
    RAISE NOTICE 'Samochód o ID % został pomyślnie wypożyczony przez klienta o ID %.', p_id_samochodu, p_id_klienta;
END;
$$;


ALTER PROCEDURE "wypożyczenia"."dodajwypożyczenie"(IN p_id_samochodu integer, IN p_id_klienta integer, IN "p_data_wypożyczenia" date, IN p_data_zwrotu date) OWNER TO postgres;

--
-- TOC entry 288 (class 1255 OID 17215)
-- Name: edytujwypożyczenie(integer, integer, integer, date, date); Type: PROCEDURE; Schema: wypożyczenia; Owner: postgres
--

CREATE PROCEDURE "wypożyczenia"."edytujwypożyczenie"(IN p_id integer, IN p_id_samochodu integer, IN p_id_klienta integer, IN "p_data_wypożyczenia" date, IN p_data_zwrotu date)
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Wypozyczenia WHERE ID = p_id) THEN
        RAISE EXCEPTION 'Wypożyczenie o ID % nie istnieje.', p_id;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM Samochody WHERE ID = p_id_samochodu) THEN
        RAISE EXCEPTION 'Samochód o ID % nie istnieje.', p_id_samochodu;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM Klienci WHERE ID = p_id_klienta) THEN
        RAISE EXCEPTION 'Klient o ID % nie istnieje.', p_id_klienta;
    END IF;

    UPDATE Wypozyczenia
    SET ID_samochodu = p_id_samochodu, ID_klienta = p_id_klienta,
        Data_wypozyczenia = p_data_wypożyczenia, Data_zwrotu = p_data_zwrotu
    WHERE ID = p_id;
END;
$$;


ALTER PROCEDURE "wypożyczenia"."edytujwypożyczenie"(IN p_id integer, IN p_id_samochodu integer, IN p_id_klienta integer, IN "p_data_wypożyczenia" date, IN p_data_zwrotu date) OWNER TO postgres;

--
-- TOC entry 289 (class 1255 OID 17216)
-- Name: get_wypożyczenia(); Type: FUNCTION; Schema: wypożyczenia; Owner: postgres
--

CREATE FUNCTION "wypożyczenia"."get_wypożyczenia"() RETURNS TABLE(id integer, id_samochodu integer, id_klienta integer, data_wypozyczenia text, data_zwrotu text)
    LANGUAGE plpgsql
    AS $$
DECLARE
    cur CURSOR FOR SELECT * FROM public.wypozyczenia;
    rec RECORD;
BEGIN
    FOR rec IN cur LOOP
        id := rec.id;
        id_samochodu := rec.id_samochodu;
        id_klienta := rec.id_klienta;
        data_wypozyczenia := TO_CHAR(rec.data_wypozyczenia, 'YYYY-MM-DD');
        data_zwrotu := TO_CHAR(rec.data_zwrotu, 'YYYY-MM-DD');
        RETURN NEXT;
    END LOOP;
END;
$$;


ALTER FUNCTION "wypożyczenia"."get_wypożyczenia"() OWNER TO postgres;

--
-- TOC entry 290 (class 1255 OID 17217)
-- Name: usuńwypożyczenie(integer); Type: PROCEDURE; Schema: wypożyczenia; Owner: postgres
--

CREATE PROCEDURE "wypożyczenia"."usuńwypożyczenie"(IN p_id integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    DELETE FROM Wypozyczenia WHERE ID = p_id;
END;
$$;


ALTER PROCEDURE "wypożyczenia"."usuńwypożyczenie"(IN p_id integer) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 224 (class 1259 OID 17218)
-- Name: klienci; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.klienci (
    id integer NOT NULL,
    "imię" character varying(50) NOT NULL,
    nazwisko character varying(50) NOT NULL,
    nr_prawa_jazdy character varying(20) NOT NULL,
    email character varying(100) NOT NULL,
    telefon character varying(15)
);


ALTER TABLE public.klienci OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 17221)
-- Name: klienci_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.klienci_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.klienci_id_seq OWNER TO postgres;

--
-- TOC entry 3733 (class 0 OID 0)
-- Dependencies: 225
-- Name: klienci_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.klienci_id_seq OWNED BY public.klienci.id;


--
-- TOC entry 226 (class 1259 OID 17222)
-- Name: naprawy; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.naprawy (
    id_naprawy integer NOT NULL,
    id_samochodu integer,
    rodzaj_naprawy text,
    data_naprawy date,
    koszt numeric(10,2)
);


ALTER TABLE public.naprawy OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 17227)
-- Name: naprawy_id_naprawy_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.naprawy_id_naprawy_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.naprawy_id_naprawy_seq OWNER TO postgres;

--
-- TOC entry 3734 (class 0 OID 0)
-- Dependencies: 227
-- Name: naprawy_id_naprawy_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.naprawy_id_naprawy_seq OWNED BY public.naprawy.id_naprawy;


--
-- TOC entry 228 (class 1259 OID 17228)
-- Name: przeglądy; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."przeglądy" (
    id integer NOT NULL,
    id_samochodu integer NOT NULL,
    "data_przeglądu" date NOT NULL,
    data_nastepnego_przegladu date,
    koszt numeric
);


ALTER TABLE public."przeglądy" OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 17233)
-- Name: przeglądy_id_przeglądu_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."przeglądy_id_przeglądu_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."przeglądy_id_przeglądu_seq" OWNER TO postgres;

--
-- TOC entry 3735 (class 0 OID 0)
-- Dependencies: 229
-- Name: przeglądy_id_przeglądu_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."przeglądy_id_przeglądu_seq" OWNED BY public."przeglądy".id;


--
-- TOC entry 230 (class 1259 OID 17234)
-- Name: płatności; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."płatności" (
    id integer NOT NULL,
    "id_wypożyczenia" integer NOT NULL,
    kwota numeric(10,2) NOT NULL,
    data date NOT NULL,
    "metoda_płatności" character varying(50) NOT NULL
);


ALTER TABLE public."płatności" OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 17237)
-- Name: płatności_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."płatności_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."płatności_id_seq" OWNER TO postgres;

--
-- TOC entry 3736 (class 0 OID 0)
-- Dependencies: 231
-- Name: płatności_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."płatności_id_seq" OWNED BY public."płatności".id;


--
-- TOC entry 232 (class 1259 OID 17238)
-- Name: samochody; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.samochody (
    id integer NOT NULL,
    marka character varying(50) NOT NULL,
    model character varying(50) NOT NULL,
    rok_produkcji integer NOT NULL,
    numer_rejestracyjny character varying(15) NOT NULL,
    cena_za_dzien numeric(10,2) NOT NULL,
    id_ubezpieczenia integer,
    czy_wypozyczony boolean DEFAULT false
);


ALTER TABLE public.samochody OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 17242)
-- Name: samochody_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.samochody_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.samochody_id_seq OWNER TO postgres;

--
-- TOC entry 3737 (class 0 OID 0)
-- Dependencies: 233
-- Name: samochody_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.samochody_id_seq OWNED BY public.samochody.id;


--
-- TOC entry 234 (class 1259 OID 17243)
-- Name: ubezpieczenia; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ubezpieczenia (
    id integer NOT NULL,
    ubezpieczyciel character varying(100) NOT NULL,
    "data_początku" date NOT NULL,
    "data_końca" date NOT NULL,
    koszt_ubezpieczenia numeric(10,2) NOT NULL
);


ALTER TABLE public.ubezpieczenia OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 17246)
-- Name: ubezpieczenia_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ubezpieczenia_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ubezpieczenia_id_seq OWNER TO postgres;

--
-- TOC entry 3738 (class 0 OID 0)
-- Dependencies: 235
-- Name: ubezpieczenia_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ubezpieczenia_id_seq OWNED BY public.ubezpieczenia.id;


--
-- TOC entry 236 (class 1259 OID 17247)
-- Name: wypozyczenia; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.wypozyczenia (
    id integer NOT NULL,
    id_samochodu integer NOT NULL,
    id_klienta integer NOT NULL,
    data_wypozyczenia date NOT NULL,
    data_zwrotu date NOT NULL
);


ALTER TABLE public.wypozyczenia OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 17250)
-- Name: wypożyczenia_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."wypożyczenia_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."wypożyczenia_id_seq" OWNER TO postgres;

--
-- TOC entry 3739 (class 0 OID 0)
-- Dependencies: 237
-- Name: wypożyczenia_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."wypożyczenia_id_seq" OWNED BY public.wypozyczenia.id;


--
-- TOC entry 3529 (class 2604 OID 17251)
-- Name: klienci id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.klienci ALTER COLUMN id SET DEFAULT nextval('public.klienci_id_seq'::regclass);


--
-- TOC entry 3530 (class 2604 OID 17252)
-- Name: naprawy id_naprawy; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.naprawy ALTER COLUMN id_naprawy SET DEFAULT nextval('public.naprawy_id_naprawy_seq'::regclass);


--
-- TOC entry 3531 (class 2604 OID 17253)
-- Name: przeglądy id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."przeglądy" ALTER COLUMN id SET DEFAULT nextval('public."przeglądy_id_przeglądu_seq"'::regclass);


--
-- TOC entry 3532 (class 2604 OID 17254)
-- Name: płatności id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."płatności" ALTER COLUMN id SET DEFAULT nextval('public."płatności_id_seq"'::regclass);


--
-- TOC entry 3533 (class 2604 OID 17255)
-- Name: samochody id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.samochody ALTER COLUMN id SET DEFAULT nextval('public.samochody_id_seq'::regclass);


--
-- TOC entry 3535 (class 2604 OID 17256)
-- Name: ubezpieczenia id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ubezpieczenia ALTER COLUMN id SET DEFAULT nextval('public.ubezpieczenia_id_seq'::regclass);


--
-- TOC entry 3536 (class 2604 OID 17257)
-- Name: wypozyczenia id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wypozyczenia ALTER COLUMN id SET DEFAULT nextval('public."wypożyczenia_id_seq"'::regclass);


--
-- TOC entry 3714 (class 0 OID 17218)
-- Dependencies: 224
-- Data for Name: klienci; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.klienci (id, "imię", nazwisko, nr_prawa_jazdy, email, telefon) FROM stdin;
1	Jan	Kowalski	ABC123456	jan.kowalski@example.com	123456789
2	Anna	Nowak	XYZ654321	anna.nowak@example.com	987654321
3	Piotr	Zieliński	LMN456789	piotr.zielinski@example.com	456123789
4	Maria	Wójcik	OPQ987654	maria.wojcik@example.com	654987321
5	Krzysztof	Wiśniewski	RST234567	krzysztof.wisniewski@example.com	321654987
6	Ewa	Krawczyk	UVW112233	ewa.krawczyk@example.com	111223344
7	Tomasz	Lewandowski	XYZ345678	tomasz.lewandowski@example.com	222334455
8	Monika	Adamska	ABC876543	monika.adamska@example.com	333445566
9	Andrzej	Mazur	DEF987654	andrzej.mazur@example.com	444556677
10	Katarzyna	Kaczmarek	GHI876543	katarzyna.kaczmarek@example.com	555667788
11	Jacek	Pawlak	JKL234567	jacek.pawlak@example.com	666778899
12	Małgorzata	Dąbrowska	MNO654321	malgorzata.dabrowska@example.com	777889900
13	Bartłomiej	Wasilewski	PQR123456	bartlomiej.wasilewski@example.com	888990011
14	Natalia	Sienkiewicz	STU234567	natalia.sienkiewicz@example.com	999001122
15	Michał	Chmielowski	VWX345678	michal.chmielowski@example.com	100110022
16	Zofia	Pietrzak	YZA456789	zofia.pietrzak@example.com	200220033
17	Adrian	Król	BCD567890	adrian.krol@example.com	300330044
18	Dominika	Olszewska	EFG678901	dominika.olszewska@example.com	400440055
19	Filip	Sikora	HIJ789012	filip.sikora@example.com	500550066
20	Agnieszka	Wierzbicka	KLM890123	agnieszka.wierzbicka@example.com	600660078
\.


--
-- TOC entry 3716 (class 0 OID 17222)
-- Dependencies: 226
-- Data for Name: naprawy; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.naprawy (id_naprawy, id_samochodu, rodzaj_naprawy, data_naprawy, koszt) FROM stdin;
21	1	Wymiana oleju	2025-01-01	150.00
22	2	Naprawa hamulców	2025-01-02	250.00
23	3	Wymiana opon	2025-01-03	300.00
24	4	Naprawa silnika	2025-01-04	1200.00
25	5	Wymiana akumulatora	2025-01-05	350.00
26	6	Naprawa układu wydechowego	2025-01-06	400.00
27	7	Wymiana klocków hamulcowych	2025-01-07	180.00
28	8	Naprawa skrzyni biegów	2025-01-08	800.00
29	9	Wymiana rozrządu	2025-01-09	700.00
30	10	Naprawa klimatyzacji	2025-01-10	500.00
31	11	Wymiana płynów eksploatacyjnych	2025-01-11	200.00
33	13	Wymiana filtrów	2025-01-13	120.00
34	14	Naprawa elektryki	2025-01-14	600.00
35	15	Wymiana łańcucha rozrządu	2025-01-15	850.00
36	16	Naprawa układu kierowniczego	2025-01-16	300.00
37	17	Wymiana paska klinowego	2025-01-17	100.00
38	18	Naprawa alternatora	2025-01-18	450.00
39	19	Wymiana pompy paliwowej	2025-01-19	250.00
41	20	Wymiana akumulatora	2025-01-04	300.00
\.


--
-- TOC entry 3718 (class 0 OID 17228)
-- Dependencies: 228
-- Data for Name: przeglądy; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."przeglądy" (id, id_samochodu, "data_przeglądu", data_nastepnego_przegladu, koszt) FROM stdin;
41	1	2025-01-01	2025-07-01	120.00
42	2	2025-01-02	2025-07-02	130.00
43	3	2025-01-03	2025-07-03	140.00
44	4	2025-01-04	2025-07-04	150.00
45	5	2025-01-05	2025-07-05	160.00
46	6	2025-01-06	2025-07-06	170.00
47	7	2025-01-07	2025-07-07	180.00
48	8	2025-01-08	2025-07-08	190.00
49	9	2025-01-09	2025-07-09	200.00
50	10	2025-01-10	2025-07-10	210.00
51	11	2025-01-11	2025-07-11	220.00
52	12	2025-01-12	2025-07-12	230.00
53	13	2025-01-13	2025-07-13	240.00
55	15	2025-01-15	2025-07-15	260.00
57	17	2025-01-17	2025-07-17	280.00
58	18	2025-01-18	2025-07-18	290.00
59	19	2025-01-19	2025-07-19	300.00
\.


--
-- TOC entry 3720 (class 0 OID 17234)
-- Dependencies: 230
-- Data for Name: płatności; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."płatności" (id, "id_wypożyczenia", kwota, data, "metoda_płatności") FROM stdin;
1	1	1050.00	2025-01-01	Przelew
2	2	1260.00	2025-01-02	Gotówka
3	3	1540.00	2025-01-03	Karta kredytowa
4	4	1750.00	2025-01-04	Gotówka
5	5	1400.00	2025-01-05	Przelew
6	6	840.00	2025-01-06	Karta debetowa
7	7	980.00	2025-01-07	Gotówka
8	8	1120.00	2025-01-08	Karta kredytowa
9	9	910.00	2025-01-09	Przelew
10	10	1190.00	2025-01-10	Gotówka
11	11	700.00	2025-01-11	Karta kredytowa
12	12	980.00	2025-01-12	Przelew
13	13	1120.00	2025-01-13	Gotówka
14	14	1050.00	2025-01-14	Karta debetowa
15	15	1260.00	2025-01-15	Karta kredytowa
16	16	1400.00	2025-01-16	Przelew
17	17	1470.00	2025-01-17	Gotówka
18	18	1540.00	2025-01-18	Karta kredytowa
19	19	1680.00	2025-01-19	Gotówka
21	20	1750.00	2025-01-23	Gotówka
22	1	1050.00	2025-01-21	blik
\.


--
-- TOC entry 3722 (class 0 OID 17238)
-- Dependencies: 232
-- Data for Name: samochody; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.samochody (id, marka, model, rok_produkcji, numer_rejestracyjny, cena_za_dzien, id_ubezpieczenia, czy_wypozyczony) FROM stdin;
2	Volkswagen	Golf	2021	ABC5678	180.00	2	f
3	BMW	3 Series	2019	DEF8765	220.00	3	f
4	Mercedes	A-Class	2022	GHI2345	250.00	4	f
5	Audi	A4	2020	JKL3456	200.00	5	f
6	Ford	Focus	2018	MNO6789	120.00	6	f
7	Renault	Clio	2021	PQR1234	140.00	7	f
8	Skoda	Octavia	2020	STU9876	160.00	8	f
9	Opel	Astra	2019	VWX5432	130.00	9	f
11	Fiat	Panda	2021	CAB8765	100.00	11	f
12	Hyundai	i30	2020	DBC4321	140.00	12	f
13	Kia	Ceed	2022	ECB7890	160.00	13	f
14	Seat	Leon	2019	FGB5678	150.00	14	f
15	Mazda	Mazda 3	2020	HJI6789	180.00	15	t
16	Nissan	Qashqai	2021	KLM4321	200.00	16	t
17	Honda	Civic	2022	LMN1234	210.00	17	t
18	Subaru	Impreza	2021	NOP5678	220.00	18	t
19	Jaguar	XE	2020	QRS6789	240.00	19	t
20	Volvo	S60	2022	TUV4321	250.00	20	f
10	Peugeot	308	2022	YZB6543	170.00	10	t
1	Toyota	Corolla	2020	XYZ1234	150.00	1	t
\.


--
-- TOC entry 3724 (class 0 OID 17243)
-- Dependencies: 234
-- Data for Name: ubezpieczenia; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ubezpieczenia (id, ubezpieczyciel, "data_początku", "data_końca", koszt_ubezpieczenia) FROM stdin;
1	PZU	2025-01-01	2026-01-01	500.00
2	Warta	2025-01-01	2026-01-01	450.00
3	Allianz	2025-01-01	2026-01-01	600.00
4	AXA	2025-01-01	2026-01-01	550.00
5	Generali	2025-01-01	2026-01-01	520.00
6	Ergo Hestia	2025-01-01	2026-01-01	530.00
7	MetLife	2025-01-01	2026-01-01	540.00
8	Prudential	2025-01-01	2026-01-01	600.00
9	Lloyds	2025-01-01	2026-01-01	560.00
10	Aviva	2025-01-01	2026-01-01	580.00
11	Uniqa	2025-01-01	2026-01-01	590.00
12	Compensa	2025-01-01	2026-01-01	610.00
13	Proama	2025-01-01	2026-01-01	500.00
14	TUZ	2025-01-01	2026-01-01	520.00
15	AIG	2025-01-01	2026-01-01	530.00
16	Direct	2025-01-01	2026-01-01	510.00
17	Lukoil	2025-01-01	2026-01-01	530.00
18	HDI	2025-01-01	2026-01-01	570.00
19	AXA Direct	2025-01-01	2026-01-01	590.00
20	TU InterRisk	2025-01-01	2026-01-01	600.00
22	Generali	2025-01-21	2025-01-31	120.00
23	Generali	2025-01-20	2025-01-31	120.00
\.


--
-- TOC entry 3726 (class 0 OID 17247)
-- Dependencies: 236
-- Data for Name: wypozyczenia; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.wypozyczenia (id, id_samochodu, id_klienta, data_wypozyczenia, data_zwrotu) FROM stdin;
1	1	1	2025-01-01	2025-01-07
2	2	2	2025-01-02	2025-01-08
3	3	3	2025-01-03	2025-01-09
4	4	4	2025-01-04	2025-01-10
5	5	5	2025-01-05	2025-01-11
6	6	6	2025-01-06	2025-01-12
7	7	7	2025-01-07	2025-01-13
8	8	8	2025-01-08	2025-01-14
9	9	9	2025-01-09	2025-01-15
10	10	10	2025-01-10	2025-01-16
11	11	11	2025-01-11	2025-01-17
12	12	12	2025-01-12	2025-01-18
13	13	13	2025-01-13	2025-01-19
14	14	14	2025-01-14	2025-01-20
15	15	15	2025-01-15	2025-01-21
16	16	16	2025-01-16	2025-01-22
17	17	17	2025-01-17	2025-01-23
18	18	18	2025-01-18	2025-01-24
19	19	19	2025-01-19	2025-01-25
20	20	20	2025-01-01	2025-01-05
\.


--
-- TOC entry 3740 (class 0 OID 0)
-- Dependencies: 225
-- Name: klienci_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.klienci_id_seq', 21, true);


--
-- TOC entry 3741 (class 0 OID 0)
-- Dependencies: 227
-- Name: naprawy_id_naprawy_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.naprawy_id_naprawy_seq', 42, true);


--
-- TOC entry 3742 (class 0 OID 0)
-- Dependencies: 229
-- Name: przeglądy_id_przeglądu_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."przeglądy_id_przeglądu_seq"', 62, true);


--
-- TOC entry 3743 (class 0 OID 0)
-- Dependencies: 231
-- Name: płatności_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."płatności_id_seq"', 26, true);


--
-- TOC entry 3744 (class 0 OID 0)
-- Dependencies: 233
-- Name: samochody_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.samochody_id_seq', 21, true);


--
-- TOC entry 3745 (class 0 OID 0)
-- Dependencies: 235
-- Name: ubezpieczenia_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ubezpieczenia_id_seq', 23, true);


--
-- TOC entry 3746 (class 0 OID 0)
-- Dependencies: 237
-- Name: wypożyczenia_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."wypożyczenia_id_seq"', 23, true);


--
-- TOC entry 3538 (class 2606 OID 17259)
-- Name: klienci klienci_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.klienci
    ADD CONSTRAINT klienci_email_key UNIQUE (email);


--
-- TOC entry 3540 (class 2606 OID 17261)
-- Name: klienci klienci_nr_prawa_jazdy_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.klienci
    ADD CONSTRAINT klienci_nr_prawa_jazdy_key UNIQUE (nr_prawa_jazdy);


--
-- TOC entry 3542 (class 2606 OID 17263)
-- Name: klienci klienci_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.klienci
    ADD CONSTRAINT klienci_pkey PRIMARY KEY (id);


--
-- TOC entry 3544 (class 2606 OID 17265)
-- Name: klienci klienci_telefon_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.klienci
    ADD CONSTRAINT klienci_telefon_key UNIQUE (telefon);


--
-- TOC entry 3546 (class 2606 OID 17267)
-- Name: naprawy naprawy_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.naprawy
    ADD CONSTRAINT naprawy_pkey PRIMARY KEY (id_naprawy);


--
-- TOC entry 3548 (class 2606 OID 17269)
-- Name: przeglądy przeglądy_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."przeglądy"
    ADD CONSTRAINT "przeglądy_pkey" PRIMARY KEY (id);


--
-- TOC entry 3550 (class 2606 OID 17271)
-- Name: płatności płatności_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."płatności"
    ADD CONSTRAINT "płatności_pkey" PRIMARY KEY (id);


--
-- TOC entry 3552 (class 2606 OID 17273)
-- Name: samochody samochody_numer_rejestracyjny_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.samochody
    ADD CONSTRAINT samochody_numer_rejestracyjny_key UNIQUE (numer_rejestracyjny);


--
-- TOC entry 3554 (class 2606 OID 17275)
-- Name: samochody samochody_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.samochody
    ADD CONSTRAINT samochody_pkey PRIMARY KEY (id);


--
-- TOC entry 3556 (class 2606 OID 17277)
-- Name: ubezpieczenia ubezpieczenia_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ubezpieczenia
    ADD CONSTRAINT ubezpieczenia_pkey PRIMARY KEY (id);


--
-- TOC entry 3558 (class 2606 OID 17279)
-- Name: wypozyczenia wypożyczenia_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wypozyczenia
    ADD CONSTRAINT "wypożyczenia_pkey" PRIMARY KEY (id);


--
-- TOC entry 3566 (class 2620 OID 17280)
-- Name: płatności oblicz_kwote_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER oblicz_kwote_trigger BEFORE INSERT ON public."płatności" FOR EACH ROW EXECUTE FUNCTION public.oblicz_kwote_platnosci();


--
-- TOC entry 3565 (class 2620 OID 17281)
-- Name: przeglądy trg_sprawdz_przeglad; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_sprawdz_przeglad BEFORE INSERT OR UPDATE ON public."przeglądy" FOR EACH ROW EXECUTE FUNCTION public.sprawdz_przeglad();


--
-- TOC entry 3567 (class 2620 OID 17282)
-- Name: wypozyczenia trigger_aktualizuj_czy_wypozyczony; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_aktualizuj_czy_wypozyczony AFTER INSERT OR DELETE OR UPDATE ON public.wypozyczenia FOR EACH ROW EXECUTE FUNCTION public.aktualizuj_czy_wypozyczony();


--
-- TOC entry 3568 (class 2620 OID 17283)
-- Name: wypozyczenia trigger_sprawdz_ubezpieczenie; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trigger_sprawdz_ubezpieczenie BEFORE INSERT ON public.wypozyczenia FOR EACH ROW EXECUTE FUNCTION public.sprawdz_ubezpieczenie();


--
-- TOC entry 3559 (class 2606 OID 17284)
-- Name: naprawy naprawy_id_samochodu_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.naprawy
    ADD CONSTRAINT naprawy_id_samochodu_fkey FOREIGN KEY (id_samochodu) REFERENCES public.samochody(id) ON DELETE CASCADE;


--
-- TOC entry 3560 (class 2606 OID 17289)
-- Name: przeglądy przeglądy_id_samochodu_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."przeglądy"
    ADD CONSTRAINT "przeglądy_id_samochodu_fkey" FOREIGN KEY (id_samochodu) REFERENCES public.samochody(id);


--
-- TOC entry 3561 (class 2606 OID 17294)
-- Name: płatności płatności_id_wypożyczenia_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."płatności"
    ADD CONSTRAINT "płatności_id_wypożyczenia_fkey" FOREIGN KEY ("id_wypożyczenia") REFERENCES public.wypozyczenia(id);


--
-- TOC entry 3562 (class 2606 OID 17299)
-- Name: samochody samochody_id_ubezpieczenia_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.samochody
    ADD CONSTRAINT samochody_id_ubezpieczenia_fkey FOREIGN KEY (id_ubezpieczenia) REFERENCES public.ubezpieczenia(id);


--
-- TOC entry 3563 (class 2606 OID 17304)
-- Name: wypozyczenia wypożyczenia_id_klienta_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wypozyczenia
    ADD CONSTRAINT "wypożyczenia_id_klienta_fkey" FOREIGN KEY (id_klienta) REFERENCES public.klienci(id);


--
-- TOC entry 3564 (class 2606 OID 17309)
-- Name: wypozyczenia wypożyczenia_id_samochodu_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.wypozyczenia
    ADD CONSTRAINT "wypożyczenia_id_samochodu_fkey" FOREIGN KEY (id_samochodu) REFERENCES public.samochody(id);


-- Completed on 2025-01-21 10:07:58 CET

--
-- PostgreSQL database dump complete
--

