const express = require("express");
const router = express.Router();

var folder = [];
var count = 0;

router.get("/", function (req, res) {
  res.json({
    data: folder,
  });
  console.log("Get data success");
});
router.post("/test", function (req, res) {
  let text = req.body.text;
  let count = 0;
  let length = folder.length;

  if (length != 0) {
    let hasmsg;
    for (let index = 0; index < folder.length; index++) {
      let textArray = folder[index].data;
      if (textArray == text) {
        count = count + folder[index].count;
        count++;
        folder[index].count = count;
        hasmsg = true;
        break;
      } else {
        hasmsg = false;
      }
    }
    if (!hasmsg) {
      count++;
      folder.push({
        data: text,
        count: count,
      });
    }
    return res.send({
      data: folder,
    });
  } else {
    count++;
    folder.push({
      data: text,
      count: count,
    });
    return res.send({
      data: folder,
    });
  }
});

module.exports = router;
