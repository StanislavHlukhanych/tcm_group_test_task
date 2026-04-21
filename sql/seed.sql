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