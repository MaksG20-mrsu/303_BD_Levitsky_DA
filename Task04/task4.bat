D:\sqlite\sqlite3.exe movies_rating.db < db_init.sql
@echo off

echo 1. User pairs who rated the same movie (first 100)
echo ----------------------------------------
D:\sqlite\sqlite3.exe movies_rating.db -box "SELECT u1.name AS user1, u2.name AS user2, m.title FROM ratings r1 JOIN ratings r2 ON r1.movieId = r2.movieId AND r1.userId < r2.userId JOIN users u1 ON r1.userId = u1.userId JOIN users u2 ON r2.userId = u2.userId JOIN movies m ON r1.movieId = m.movieId LIMIT 100;"
echo.

echo 2. 10 most recent ratings from different users
echo ----------------------------------------
D:\sqlite\sqlite3.exe movies_rating.db -box "SELECT m.title, u.name, r.rating, date(r.timestamp, 'unixepoch') AS rating_date FROM ratings r JOIN users u ON r.userId = u.userId JOIN movies m ON r.movieId = m.movieId GROUP BY r.userId ORDER BY r.timestamp DESC LIMIT 10;"
echo.

echo 3. Movies with max and min average ratings
echo ----------------------------------------
D:\sqlite\sqlite3.exe movies_rating.db -box "WITH avg_ratings AS (SELECT m.movieId, m.title, AVG(r.rating) AS avg_r FROM movies m JOIN ratings r ON m.movieId = r.movieId GROUP BY m.movieId), max_min AS (SELECT MAX(avg_r) AS max_r, MIN(avg_r) AS min_r FROM avg_ratings) SELECT a.title, substr(a.title, -5, 4) AS year, CASE WHEN a.avg_r = (SELECT max_r FROM max_min) THEN 'Yes' ELSE 'No' END AS recommended FROM avg_ratings a, max_min WHERE a.avg_r = max_min.max_r OR a.avg_r = max_min.min_r ORDER BY year ASC, a.title ASC;"
echo.

echo 4. Rating count and average from female users in 2010-2012
echo ----------------------------------------
D:\sqlite\sqlite3.exe movies_rating.db -box "SELECT COUNT(*) AS rating_count, AVG(r.rating) AS avg_rating FROM ratings r JOIN users u ON r.userId = u.userId WHERE u.gender = 'F' AND strftime('%Y', date(r.timestamp, 'unixepoch')) BETWEEN '2010' AND '2012';"
echo.

echo 5. Movies with average rating and rank (first 20)
echo ----------------------------------------
D:\sqlite\sqlite3.exe movies_rating.db -box "SELECT title, avg_r, RANK() OVER (ORDER BY avg_r DESC) AS rank FROM (SELECT m.movieId, m.title, AVG(r.rating) AS avg_r FROM movies m JOIN ratings r ON m.movieId = r.movieId GROUP BY m.movieId) ORDER BY substr(title, -5, 4) ASC, title ASC LIMIT 20;"
echo.

echo 6. 10 most recently registered users
echo ----------------------------------------
D:\sqlite\sqlite3.exe movies_rating.db -box "SELECT substr(name, instr(name, ' ') + 1) || ' ' || substr(name, 1, instr(name, ' ') - 1) || '|' || register_date AS user_info FROM users ORDER BY register_date DESC LIMIT 10;"
echo.

echo 7. Multiplication table 1-10 using recursive CTE
echo ----------------------------------------
D:\sqlite\sqlite3.exe movies_rating.db -box "WITH RECURSIVE nums(n) AS (SELECT 1 UNION ALL SELECT n+1 FROM nums WHERE n < 10) SELECT a.n || 'x' || b.n || '=' || (a.n * b.n) AS multiplication FROM nums a, nums b ORDER BY a.n, b.n;"
echo.

echo 8. All genres from movies using recursive CTE
echo ----------------------------------------
D:\sqlite\sqlite3.exe movies_rating.db -box "WITH RECURSIVE split(genres, genre) AS (SELECT genres || '|', '' FROM movies UNION ALL SELECT substr(genres, instr(genres, '|') + 1), substr(genres, 1, instr(genres, '|') - 1) FROM split WHERE genres != '') SELECT DISTINCT genre FROM split WHERE genre != '' ORDER BY genre;"
echo.

pause