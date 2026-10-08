@echo off
python make_db_init.py
if exist movies_rating.db del movies_rating.db
D:\sqlite\sqlite3.exe movies_rating.db < db_init.sql
echo Database created successfully!
pause