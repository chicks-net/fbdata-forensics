PRAGMA foreign_keys=OFF;
BEGIN TRANSACTION;
CREATE TABLE fb_items (id INTEGER PRIMARY KEY ASC, type TEXT, participant TEXT, timestamp TEXT, content TEXT, redact INT);
COMMIT;
