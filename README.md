## Stored Procedures
In PostgreSQL, procedural languages such as PL/pgSQL, C, Perl, Python, and Tcl are referred to as stored procedures. The stored procedures add many procedural elements e.g., control structures, loop, and complex calculation to extend SQL-standard. It allows you to develop complex functions in PostgreSQL that may not be possible using plain SQL statements.

### Run locally
- Setup variables as shown below
- `docker-compose up -d`
- `npm install`
- `npm run migrate up`
- `npm run invoke`

### AWS Deploy
- Setup variables as shown below
- `npm run migrate up`
- `npm run deploy`

### Run tests
- No tests declared :(

### Setup variables
- Create `.env` file from `.env.example` and replace with proper values

### Major Dependencies
- *pg* for Postgres connection
- *serverless* framework
