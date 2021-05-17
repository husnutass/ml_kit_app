var http = require('http');
var express = require('express');
const ObjectsToCsv = require('objects-to-csv')

var app = express();

app.use(express.urlencoded({ extended: true }));
app.use(express.json());

app.listen(4444, function () {
  console.log("Port dinleniyor 4444...");
});

async function writeToCsv(ocrData) {
  const csv = new ObjectsToCsv(ocrData);
  await csv.toDisk('./dataset.csv', { append: true });
}


app.get('/api/cities', function (request, response) {
  response.send("hello");
  // writeToCsv();
});

app.post('/api/dataset', function (request, response) {
  var ocrData = request.body;
  console.log(ocrData);
  writeToCsv(ocrData);
  response.status(200).send({ message: "kayit basarili" });
});