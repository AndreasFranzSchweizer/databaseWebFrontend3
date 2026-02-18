from flask import Flask, render_template, jsonify, request, abort
from flask.json.provider import DefaultJSONProvider
from postgres import Postgres
from datetime import date, time, datetime
from decimal import Decimal
import re

class CustomJSONEncoder(DefaultJSONProvider):
    def default(self, obj):
        try:
            if isinstance(obj, (date, time, datetime)):
                return obj.isoformat()
            elif isinstance(obj, Decimal):
                return str(obj)
            iterable = iter(obj)
        except TypeError:
            pass
        else:
            return list(iterable)
        return super().default(obj)

app = Flask(
    __name__,
    static_url_path="",
    static_folder="static",
    template_folder="templates",
)

app.json = CustomJSONEncoder(app)
postgres = Postgres()

# -------------------------------
# SQL Schutz (nur SELECT / WITH)
# -------------------------------
FORBIDDEN = re.compile(
    r"\b(insert|update|delete|alter|drop|create|copy|call|do|grant|revoke|truncate|vacuum|analyze)\b",
    re.IGNORECASE,
)

def is_allowed_sql(sql: str) -> bool:
    if not sql:
        return False
    s = sql.strip()

    if ";" in s:  # kein Multi-Statement
        return False

    if not (s.lower().startswith("select") or s.lower().startswith("with")):
        return False

    if FORBIDDEN.search(s):
        return False

    return True

# -------------------------------
# Datenbanken Whitelist
# -------------------------------
ALLOWED_DBS = [
    "bundesliga",
    "fahrradverleih",
    "hotel",
    "streamingdienst",
    "solar",
    "worldoffisicraft",
]

DBNAME_RE = re.compile(r"^[A-Za-z0-9_]+$")

def ensure_valid_dbname(dbname: str):
    if not DBNAME_RE.match(dbname):
        abort(400, description="Invalid database name.")
    if dbname not in ALLOWED_DBS:
        abort(404, description="Unknown database.")

@app.route("/", methods=["GET"])
def index():
    sql = request.args.get("sql", "")
    database = request.args.get("database", "")
    return render_template("index.html", get_sql=sql, get_database=database)

@app.route("/databases")
def getDatabaseNames():
    return jsonify(ALLOWED_DBS)

@app.route("/<dbname>/tables")
def getTableNames(dbname):
    ensure_valid_dbname(dbname)
    return jsonify(postgres.getTables(dbname))

@app.route("/<dbname>/sql", methods=["POST"])
def executeSql(dbname):
    ensure_valid_dbname(dbname)

    payload = request.get_json(silent=True) or {}
    sql = (payload.get("sql") or "").strip()

    if not is_allowed_sql(sql):
        abort(400, description="Only single SELECT statements allowed.")

    limit = payload.get("limit", 200)
    try:
        limit = int(limit)
    except Exception:
        limit = 200

    limit = max(1, min(limit, 1000))

    result = postgres.query(sql, dbname, max_rows=limit)
    return jsonify(result)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
