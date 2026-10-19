@echo off

echo 1. Movies with at least one rating (first 10)
echo ----------------------------------------
D:\sqlite\sqlite3.exe movies_rating.db  "SELECT m.title, substr(m.title, -5, 4) AS year FROM movies m JOIN ratings r ON m.movieId = r.movieId GROUP BY m.movieId ORDER BY year ASC, m.title ASC LIMIT 10;"
echo.

echo 2. Users with last name starting with 'A' (first 5)
echo ----------------------------------------
D:\sqlite\sqlite3.exe movies_rating.db  "SELECT name, register_date FROM users WHERE substr(name, instr(name, ' ') + 1, 1) = 'A' ORDER BY register_date ASC LIMIT 5;"
echo.

echo 3. Reviews in readable format (first 50)
echo ----------------------------------------
D:\sqlite\sqlite3.exe movies_rating.db  "SELECT u.name, m.title, substr(m.title, -5, 4) AS year, r.rating, date(r.timestamp, 'unixepoch') AS rating_date FROM ratings r JOIN users u ON r.userId = u.userId JOIN movies m ON r.movieId = m.movieId ORDER BY u.name ASC, m.title ASC, r.rating ASC LIMIT 50;"
echo.

echo 4. Movies with tags (first 40)
echo ----------------------------------------
D:\sqlite\sqlite3.exe movies_rating.db  "SELECT m.title, substr(m.title, -5, 4) AS year, t.tag FROM tags t JOIN movies m ON t.movieId = m.movieId ORDER BY year ASC, m.title ASC, t.tag ASC LIMIT 40;"
echo.

echo 5. Latest movies (newest year in the database)
echo ----------------------------------------
D:\sqlite\sqlite3.exe movies_rating.db  "SELECT title, substr(title, -5, 4) AS year FROM movies WHERE substr(title, -5, 4) = (SELECT MAX(substr(title, -5, 4)) FROM movies) ORDER BY title ASC;"
echo.

echo 6. Comedies after 2000 with rating >= 4.5
echo ----------------------------------------
D:\sqlite\sqlite3.exe movies_rating.db  "SELECT m.title, substr(m.title, -5, 4) AS year, COUNT(r.rating) AS rating_count FROM movies m JOIN ratings r ON m.movieId = r.movieId WHERE m.genres LIKE '%Comedy%' AND substr(m.title, -5, 4) > '2000' AND r.rating >= 4.5 GROUP BY m.movieId ORDER BY year ASC, m.title ASC;"
echo.

echo 7. Most common and rarest occupation
echo ----------------------------------------
D:\sqlite\sqlite3.exe movies_rating.db  "SELECT occupation, COUNT(*) AS cnt FROM users GROUP BY occupation ORDER BY cnt DESC LIMIT 1;"
D:\sqlite\sqlite3.exe movies_rating.db  "SELECT occupation, COUNT(*) AS cnt FROM users GROUP BY occupation ORDER BY cnt ASC LIMIT 1;"
echo.

pause