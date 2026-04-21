START TRANSACTION;

INSERT INTO pv (user_id, url_id, country, device, created_at, duration_ms)
VALUES
    (10, 1, 'UA', 1, '2026-04-21 22:00:00', 450),
    (11, 2, 'PL', 2, '2026-04-21 22:05:00', 120),
    (12, 1, 'UA', 1, '2026-04-21 22:10:00', 300),
    (99, 3, 'DE', 2, '2026-04-21 22:15:00', 150);
COMMIT;