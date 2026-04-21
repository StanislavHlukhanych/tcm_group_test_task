SELECT u.url, COUNT(DISTINCT p.user_id) AS unique_users
FROM pv p JOIN urls u ON p.url_id = u.id
WHERE p.country = 'UA'
AND p.created_at BETWEEN '2025-09-15 00:00:00' AND '2025-09-17 23:59:59'
GROUP BY p.url_id
ORDER BY unique_users DESC
LIMIT 5;