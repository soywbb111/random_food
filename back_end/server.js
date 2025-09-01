const express = require ("express")
const connectMSSQL = require('./db/connectMSSQL');
const { connectNeo4j } = require('./db/connectNeo4j');
const cors = require("cors");
const web = express()

web.use(express.urlencoded({extended: false}))
web.use(express.json());  // đọc dữ liệu JSON client gửi lên
web.use(express.static("front_end")) //app.use(cors()); 
// Route dang ky
web.post("/register", (req, res) => {
    console.log("FORM BODY:", req.body);
    return res.send('OK');
})

//connect database (mssql)
//Khoi dong server
async function startServer() {
  try {
    await connectMSSQL();
    await connectNeo4j();
    web.get('/', (req, res) => {
      res.send('Connected to SQL Server and Neo4j!');
    });
    web.listen(PORT, () => {
      console.log('Server running at http://localhost:${PORT}');
    });
  } catch (err) {
    console.error('startServer_ERROR', err);
  }
}
startServer();

