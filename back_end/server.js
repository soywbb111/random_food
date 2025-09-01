const express = require ("express")

const cors = require("cors");
const web = express()

web.use(express.urlencoded({extended: false}))
web.use(express.json());  // đọc dữ liệu JSON client gửi lên
web.use(express.static("front_end")) //app.use(cors()); 


web.post("/register", (req, res) => {
    console.log("FORM BODY:", req.body);
    return res.send('OK');
})
const PORT = 5500;
web.listen(PORT, () => {
  console.log(`Server running at http://localhost:${PORT}`);
});
