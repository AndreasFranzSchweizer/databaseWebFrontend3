Auf dem Server einrichten:
    
    apt -y install postgresql postgresql-contrib python3-venv

    python3 -m venv venv
    ./venv/bin/pip install --upgrade pip
    ./venv/bin/pip install flask gunicorn psycopg2-binary


    cp databasewebfrontend.service /etc/systemd/system/databasewebfrontend.service
    systemctl daemon-reload
    systemctl enable --now databasewebfrontend
    systemctl status databasewebfrontend --no-pager

Anschauen
    journalctl -u databasewebfrontend -f
