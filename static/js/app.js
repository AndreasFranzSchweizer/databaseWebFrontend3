function start() {
    const app = {
        data(){return {
            antwort: null,
            sql: 'SELECT * FROM verein',
            lastsql: null,
            limit: 20,
            tables: [],
            databases: [],
            actualDatabase: null,
            username: null
        }}//data
        ,
        methods: {
            getJson: async function(url){
                return  (await fetch(url)).json();
            },
            postJson: async function (url, sql) {
                let data = {
                     sql: sql
                };
                let par = {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify(data)
                };

                return (await fetch(url, par)).json();
            },
            fetchTables: async function () {
                this.getJson(this.actualDatabase+'/tables')
                .then(json => this.tables = json)
            },
            sendSql: function () {
                this.lastsql = this.sql;
                this.postJson(this.actualDatabase+'/sql', this.sql).
                    then(json => this.antwort = json)
            },
            viewData: function (tablename) {
                this.sql = "SELECT * FROM " + tablename;
                this.sendSql();
            },
            getDatabaseNames: function(){
                this.getJson('databases')
                .then(json => {
                    this.databases = json;
                    if (this.databases && this.databases.length>0)
                    {
                        let found = this.databases.find(database => 
                            database === this.$refs.get_database.innerHTML);
                        if(found)
                        {
                            this.actualDatabase = found;
                        }
                        else
                        {
                            this.actualDatabase = this.databases[0];
                        }
                    }
                })
            },           
        } // methods
        ,
        mounted: function () {
            this.sql = this.$refs.get_sql.innerHTML;
        }
        ,
        beforeMount:  function () {
            this.getDatabaseNames();
        }
        ,
        watch: {
            actualDatabase: function () {
                this.antwort = null;
                this.fetchTables();
            }
        }
        ,
        
        delimiters: ['[[', ']]']
    };
    Vue.createApp(app).mount("#app")
} // start

