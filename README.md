# Тестове завдання для TCM Group Ukraine

## Схема бази даних (`schema.sql`)

Цей скрипт створює базу даних `analytics_optimized` та дві таблиці: `urls` та `pv`.

```sql
CREATE DATABASE IF NOT EXISTS analytics_optimized;
USE analytics_optimized;

CREATE TABLE IF NOT EXISTS `urls` (
    `id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `url` VARCHAR(255) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `pv` (
    `id` BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `user_id` INT UNSIGNED NOT NULL,
    `url_id` INT UNSIGNED NOT NULL,
    `country` CHAR(2) NOT NULL,
    `device` TINYINT UNSIGNED NOT NULL,
    `created_at` DATETIME NOT NULL,
    `duration_ms` INT UNSIGNED NOT NULL,
    INDEX `idx_report_lookup` (`created_at`, `country`, `url_id`)
) ENGINE=InnoDB;
```

**Пояснення:**
*   **`urls`**: Таблиця для зберігання унікальних URL-адрес.
    *   `id`: Первинний ключ.
    *   `url`: Унікальна URL-адреса.
*   **`pv`** (Page Views): Таблиця для зберігання даних про перегляди сторінок.
    *   `id`: Первинний ключ.
    *   `user_id`: Ідентифікатор користувача.
    *   `url_id`: Зовнішній ключ, що посилається на `urls.id`.
    *   `country`: Дволітерний код країни.
    *   `device`: Тип пристрою (числове значення).
    *   `created_at`: Дата та час перегляду.
    *   `duration_ms`: Тривалість перегляду в мілісекундах.
*   **Індекс `idx_report_lookup`**: Створено для оптимізації запитів, які фільтрують дані за `created_at`, `country` та `url_id`. Це значно прискорює вибірку даних для звітів.

## Наповнення бази даних (`seed.sql`)

Цей скрипт наповнює таблиці початковими даними для тестування.

```sql
INSERT INTO urls (url) VALUES
('/product/42'),
('/home'),
('/product/7'),
('/contact');

INSERT INTO pv (user_id, url_id, country, device, created_at, duration_ms)
VALUES
(1, (SELECT id FROM urls WHERE url = '/product/42'), 'UA', 1, '2025-09-15 10:11:12', 350),
(2, (SELECT id FROM urls WHERE url = '/product/42'), 'UA', 2, '2025-09-15 11:01:02', 900),
(1, (SELECT id FROM urls WHERE url = '/home'), 'PL', 2, '2025-09-16 08:21:00', 120),
(3, (SELECT id FROM urls WHERE url = '/product/7'), 'UA', 1, '2025-09-16 09:01:00', 220),
(4, (SELECT id FROM urls WHERE url = '/product/42'), 'DE', 3, '2025-09-17 12:00:00', 460);
```

## Запит A1 (`queryA1.sql`)

Цей запит вибирає 5 найпопулярніших URL-адрес за кількістю унікальних користувачів з України за певний період.

```sql
SELECT u.url, COUNT(DISTINCT p.user_id) AS unique_users
FROM pv p JOIN urls u ON p.url_id = u.id
WHERE p.country = 'UA'
AND p.created_at BETWEEN '2025-09-15 00:00:00' AND '2025-09-17 23:59:59'
GROUP BY p.url_id
ORDER BY unique_users DESC
LIMIT 5;
```

**Пояснення:**
1.  `SELECT u.url, COUNT(DISTINCT p.user_id) AS unique_users`: Вибираємо URL та кількість унікальних `user_id`. `COUNT(DISTINCT ...)` гарантує, що кожен користувач буде врахований лише один раз для кожного URL.
2.  `FROM pv p JOIN urls u ON p.url_id = u.id`: Об'єднуємо таблиці `pv` та `urls` для отримання URL-адрес.
3.  `WHERE p.country = 'UA' AND p.created_at BETWEEN ...`: Фільтруємо записи за країною (Україна) та періодом часу.
4.  `GROUP BY p.url_id`: Групуємо результати за `url_id`, щоб агрегатна функція `COUNT` працювала для кожної URL-адреси окремо.
5.  `ORDER BY unique_users DESC`: Сортуємо результати за кількістю унікальних користувачів у спадному порядку.
6.  `LIMIT 5`: Обмежуємо вивід першими 5 записами.

## Запит A2 (`queryA2.sql`)

Цей запит демонструє вставку нових даних про перегляди сторінок у транзакції.

```sql
START TRANSACTION;

INSERT INTO pv (user_id, url_id, country, device, created_at, duration_ms)
VALUES
    (10, 1, 'UA', 1, '2026-04-21 22:00:00', 450),
    (11, 2, 'PL', 2, '2026-04-21 22:05:00', 120),
    (12, 1, 'UA', 1, '2026-04-21 22:10:00', 300),
    (99, 3, 'DE', 2, '2026-04-21 22:15:00', 150);
COMMIT;
```

**Пояснення:**
*   `START TRANSACTION; ... COMMIT;`: Використання транзакції гарантує, що всі операції вставки будуть виконані атомарно. Якщо будь-яка з операцій `INSERT` зазнає невдачі, всі зміни, зроблені в межах транзакції, будуть скасовані. Це забезпечує цілісність даних.

