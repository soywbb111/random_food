const sql = require('mssql');

const config = {
  user: 'SA',
  password: '1223HNthiecla',
  server: 'localhost',
  database: 'RANDOM_FOOD',
  options: {
    encrypt: true,       
    trustServerCertificate: true
  }
};

async function connectMSSQL() {
  try {
    const pool = await sql.connect(config);
    console.log('mssql_Connected');
    return pool;
  } catch (err) {
    console.error('mssql_Inconnected', err);
    throw err;
  }
}

module.exports = connectMSSQL;