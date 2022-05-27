const mongoose = require("mongoose");

const Schema = mongoose.Schema;

const Post = Schema({
    author: {
        type: String,
        required : true,
        unique : true,
    },
    description: {
        type: String,
        required : true,
    },
    imageUrl: {
        type: String,
        required : true,
    },
    views: {
        type: Number,
        required : true,
    },
    hearts: {
        type: Number,
        required : true,
    },
})

module.exports = mongoose.model("Post", Post);