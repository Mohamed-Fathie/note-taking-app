const dbName = 'notes.db';
const noteTable = 'note';
const usetTable = 'user';
const idcolom = 'id';
const emailcolom = 'email';
const userIdcolom = 'userId';
const textcolom = 'text';
const creatuserTable = '''CREATE TABLE IF NOT EXISTS "user"(
   "id" INTEGER NOT NULL,
   "email" TEXT NOT NULL,
  PRIMARY KEY("id" AUTOINCREMENT)
) ;''';
const creatnoteTable = '''CREATE TABLE IF NOT EXISTS "note"(
   "id" INTEGER NOT NULL,
   "userId"  INTEGER NOT NULL,
   "text" TEXT,
   PRIMARY KEY("id" AUTOINCREMENT),
  FOREIGN KEY("userId") REFERENCES "user"("id")
) ;''';
