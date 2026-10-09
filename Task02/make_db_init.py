import csv

SQL_FILE = "db_init.sql"

CREATE_TABLES = """
DROP TABLE IF EXISTS movies;
DROP TABLE IF EXISTS ratings;
DROP TABLE IF EXISTS tags;
DROP TABLE IF EXISTS users;

CREATE TABLE movies (
    movieId INTEGER PRIMARY KEY,
    title TEXT,
    genres TEXT
);

CREATE TABLE ratings (
    userId INTEGER,
    movieId INTEGER,
    rating REAL,
    timestamp INTEGER,
    PRIMARY KEY (userId, movieId)
);

CREATE TABLE tags (
    userId INTEGER,
    movieId INTEGER,
    tag TEXT,
    timestamp INTEGER,
    PRIMARY KEY (userId, movieId, tag)
);

CREATE TABLE users (
    userId INTEGER PRIMARY KEY,
    name TEXT,
    email TEXT,
    gender TEXT,
    register_date TEXT,
    occupation TEXT
);
"""

def escape_sql(value):
    return value.replace("'", "''")

def generate_sql():
    with open(SQL_FILE, "w", encoding="utf-8") as f:
        f.write(CREATE_TABLES)
        f.write("\n")
        f.write("BEGIN TRANSACTION;\n")

        with open("movies.csv", "r", encoding="utf-8") as csvfile:
            reader = csv.DictReader(csvfile)
            for row in reader:
                movie_id = row["movieId"]
                title = escape_sql(row["title"])
                genres = escape_sql(row["genres"])
                f.write(f"INSERT INTO movies (movieId, title, genres) VALUES ({movie_id}, '{title}', '{genres}');\n")

        with open("ratings.csv", "r", encoding="utf-8") as csvfile:
            reader = csv.DictReader(csvfile)
            for row in reader:
                f.write(f"INSERT INTO ratings (userId, movieId, rating, timestamp) VALUES ({row['userId']}, {row['movieId']}, {row['rating']}, {row['timestamp']});\n")

        with open("tags.csv", "r", encoding="utf-8") as csvfile:
            reader = csv.DictReader(csvfile)
            for row in reader:
                tag = escape_sql(row["tag"])
                f.write(f"INSERT INTO tags (userId, movieId, tag, timestamp) VALUES ({row['userId']}, {row['movieId']}, '{tag}', {row['timestamp']});\n")

        with open("users.txt", "r", encoding="utf-8") as userfile:
            for line in userfile:
                line = line.strip()
                if not line:
                    continue
                parts = line.split("|")
                if len(parts) != 6:
                    continue
                user_id, name, email, gender, reg_date, occupation = parts
                name = escape_sql(name)
                email = escape_sql(email)
                reg_date = escape_sql(reg_date)
                occupation = escape_sql(occupation)
                f.write(f"INSERT INTO users (userId, name, email, gender, register_date, occupation) VALUES ({user_id}, '{name}', '{email}', '{gender}', '{reg_date}', '{occupation}');\n")

        f.write("COMMIT;\n")
    print(f"Файл {SQL_FILE} успешно создан!")

if __name__ == "__main__":
    generate_sql()