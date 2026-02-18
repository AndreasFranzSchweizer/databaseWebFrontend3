import os
import psycopg2

class Postgres:

    SQlTABLES = """
        SELECT table_name, array_to_string(array_agg(column_name), ',')
        FROM information_schema.columns
        WHERE table_schema='public'
        GROUP BY table_name;
    """

    def open(self, dbname="postgres"):
        return psycopg2.connect(
            host=os.getenv("PGHOST", "localhost"),
            dbname=dbname,
            user=os.getenv("PGUSER", "webfrontend"),
            password=os.getenv("PGPASSWORD", "web"),
            connect_timeout=3,
        )

    def _apply_safety_settings(self, cursor):
        cursor.execute("SET statement_timeout = '2s'")
        cursor.execute("SET lock_timeout = '1s'")
        cursor.execute("SET idle_in_transaction_session_timeout = '5s'")
        cursor.execute("SET default_transaction_read_only = on")

    def queryToList(self, sql, dbname="postgres"):
        db = self.open(dbname)
        cursor = db.cursor()
        try:
            self._apply_safety_settings(cursor)
            cursor.execute(sql)
            result = [row[0] if len(row) < 2 else row for row in cursor]
            return result
        finally:
            cursor.close()
            db.close()

    def query(self, sql, dbname="postgres", max_rows=200):
        db = self.open(dbname)
        cursor = db.cursor()
        try:
            self._apply_safety_settings(cursor)
            cursor.execute(sql)

            if cursor.description is None:
                return {"sql": sql, "columns": [], "data": []}

            columns = [col.name for col in cursor.description]
            data = cursor.fetchmany(size=max_rows)

            return {
                "sql": sql,
                "columns": columns,
                "data": data,
                "truncated": (cursor.fetchone() is not None),
                "max_rows": max_rows,
            }

        except psycopg2.Error as e:
            return {"sql": sql, "sqlError": e.pgerror}
        finally:
            cursor.close()
            db.close()

    def getTables(self, dbname):
        tables = [
            {"tablename": table[0], "columns": table[1].split(",")}
            for table in self.queryToList(self.SQlTABLES, dbname)
        ]
        return tables
