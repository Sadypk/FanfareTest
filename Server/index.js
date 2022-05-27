const express = require("express")
const mongoose = require("mongoose")
const app = express()
const Port  = process.env.port || 5000

mongoose.connect('mongodb://localhost:27017/FanFareTest', {
     useNewUrlParser: true,
});

const connection = mongoose.connection;
connection.once('open', function(){console.log('MongoDB connected');}).on('error', function(){console.log(console.error())})


//middleware
app.use("/uploads", express.static("uploads"));
app.use(express.json());
const postRoute = require("./routes/post");
app.use("/post", postRoute);

app.route("/").get((req, res)=> res.json("testing API 2"));

app.listen(5000, ()=> console.log("server running on port " + Port));