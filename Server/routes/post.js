const express = require("express");
const Post = require("../models/post.model");
const router = express.Router();
const path = require("path");
const multer = require("multer");
const storage = multer.diskStorage({
    destination: (req, file, cb) => {
      cb(null, "./uploads");
    },
    filename: (req, file, cb) => {
      cb(null, 'author' + ".mp4");
    },
  });

// router.route("/:author").get((req, res)=> {
//     Post.findOne({author: req.params.author}, (err, result)=> {
//         if(err) return res.status(500).json({msg:err});
//         return res.json({
//             data: result,
//             author: req.params.author
//         });
//     });
// });

router.route("/create").post((req, res)=> {
    console.log("Inside create");
    console.log(req.body);
    const post = new Post({
        author: req.body.author,
        description: req.body.description,
        imageUrl: req.body.imageUrl,
        views: req.body.views,
        hearts: req.body.hearts,
    });
    post.save().then(()=>{
        console.log("Post created");
        res.status(200).json("Post created");
    }).catch((err)=>{
        res.status(403).json({msg: err});
    });
});

router.route("/update/:author").patch((req, res)=>{
    Post.findOneAndUpdate(
        {author : req.params.author},
        {$set : {hearts : req.body.hearts}},
        (err, result)=> {
            if(err) return res.status(500).json({msg: err});
            const msg = {
                msg : "Post successfully updated",
                author: req.params.author,
            };
            return res.json(msg);
        }
    )
});

// const fileFilter = (req, file, cb) => {
//     if (file.mimetype == "image/jpeg" || file.mimetype == "image/png") {
//       cb(null, true);
//     } else {
//       cb(null, false);
//     }
//   };

const upload = multer({
    storage: storage,
    // limits: {
    //   fileSize: 1024 * 1024 * 6,
    // },
    // fileFilter: fileFilter,
  });
  
  //adding and update profile image
  router
    .route("/add/video")
    .patch(upload.single("vid"), (req, res) => {
        console.log("inside vid upload");
      Post.findOneAndUpdate(
        { author: "author" },
        {
          $set: {
            imageUrl: req.file.path,
          },
        },
        { new: true },
        (err, post) => {
          if (err) return res.status(500).send(err);
          const response = {
            message: "image added successfully updated",
            data: post,
          };
          return res.status(200).send(response);
        }
      );
    });

    router.route("/getData").get((req, res) => {
        console.log("inside get data");
        Post.findOne({ author: "author" }, (err, result) => {
          if (err) return res.json({ err: err });
          if (result == null) return res.json({ data: [] });
          else return res.json({ data: result });
        });
      });

 

// router.route("/delete/:userName").delete(middleware.checkToken, (req, res)=>{
//     User.findOneAndDelete(
//         {userName : req.params.userName},
//         (err, result)=> {
//             if(err) return res.status(500).json({msg: err});
//             const msg = {
//                 msg : "user deleted",
//                 userName: req.params.userName,
//             };
//             return res.json(msg);
//         }
//     )
// });

// router.route("/login").post((req, res)=> {
//     User.findOne({userName : req.body.userName }, (err, result) => {
//         if(err) return res.status(500).json({msg : err});
//         if(result === null){
//             return res.status(403).json("Username incorrect");
//         }
//         if(result.password === req.body.password){
//             let token = jwt.sign({userName: req.body.userName}, config.key, {
//                 expiresIn: "24h",
//             })
//             res.json({
//                 token : token,
//                 msg : "success",
//             });
//         }else{
//             res.status(403).json("Incorrect password");
//         }
//     });
// });

module.exports = router;