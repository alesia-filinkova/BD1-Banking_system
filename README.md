Opis:

Projekt "Obsługa banku" ma na celu stworzenie aplikacji wspierającej zarządzanie kontami klientów, transakcjami bankowymi oraz administrację pracowników banku. Projekt zostanie napisany w języku Java, z wykorzystaniem frameworków Spring Boot oraz JPA, zostały wybrane ze względu na łatwość tworzenia aplikacji oraz  integrację z relacyjnymi bazami danych.
Dane będą przechowywane w relacyjnej bazie danych Oracle, co umożliwi wykorzystanie zaawansowanych funkcji bazy danych, takich jak procedury składowane, funkcje, wyzwalacze i kursory, w celu usprawnienia operacji na danych.

Aplikacja będzie podzielona na trzy główne warstwy:

Controller Layer –  obsługująca użytkownika i komunikująca się z warstwą logiki biznesowej za pośrednictwem API REST
Service Layer – implementująca logikę biznesową aplikacji oraz przetwarzanie żądań użytkowników.
Repository Layer – odpowiadająca za interakcję z bazą danych za pomocą interfejsów JPA
