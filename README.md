Opis:

Projekt "Obsługa banku" ma na celu stworzenie aplikacji wspierającej zarządzanie kontami klientów, transakcjami bankowymi oraz administrację pracowników banku. Projekt zostanie napisany w języku Java, z wykorzystaniem frameworków Spring Boot oraz JPA, zostały wybrane ze względu na łatwość tworzenia aplikacji oraz  integrację z relacyjnymi bazami danych.
Dane będą przechowywane w relacyjnej bazie danych Oracle, co umożliwi wykorzystanie zaawansowanych funkcji bazy danych, takich jak procedury składowane, funkcje, wyzwalacze i kursory, w celu usprawnienia operacji na danych.

Aplikacja będzie podzielona na trzy główne warstwy:

Controller Layer –  obsługująca użytkownika i komunikująca się z warstwą logiki biznesowej za pośrednictwem API REST
Service Layer – implementująca logikę biznesową aplikacji oraz przetwarzanie żądań użytkowników.
Repository Layer – odpowiadająca za interakcję z bazą danych za pomocą interfejsów JPA

Techniczne aspekty projektu obejmują:

-- Backend: Kod źródłowy napisany w języku Java 
-- Frontend: Użycie Spring Boot z Thymeleaf oraz CSS i HTML
-- Baza danych: Wykorzystanie Oracle Database. Struktura bazy danych została zaprojektowana z użyciem poleceń DDL, a relacje między tabelami są stworzone za pomocą kluczy obcych i ograniczeń.
-- Operacje na danych: Korzystanie z natywnych funkcji bazy danych Oracle, takich jak:
    Procedury do realizacji operacji biznesowych (np. zamrażanie kont z ujemnym saldem).
    Funkcje do przetwarzania danych (np. obliczanie salda klienta).
    Wyzwalacze do automatyzacji pewnych działań, takich jak aktualizacja stanu konta po transakcji.
    Kursory jawne i niejawne do iteracji przez zbiory danych.

Aplikacja będzie obsługiwać trzy typy użytkowników:
-- Klient: Będzie miał dostęp do funkcji zarządzania swoimi kontami i transakcjami.
-- Pracownik banku: Otrzyma bardziej zaawansowane narzędzia do zarządzania danymi klientów i operacjami w systemie.
-- Administrator: Będzie mógł zarządzać strukturą organizacyjną banku, w tym dodawać pracowników i analizować statystyki bankowe.

Ograniczenia projektu:
-- Projekt koncentruje się na podstawowych operacjach bankowych i nie obejmuje bardziej zaawansowanych funkcji
-- Wymaga dostępu do zasobów technicznych, takich jak serwery Oracle Database

