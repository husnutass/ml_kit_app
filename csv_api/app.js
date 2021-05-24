var http = require('http');
var express = require('express');
const ObjectsToCsv = require('objects-to-csv')
const readline = require('readline');
const fs = require('fs');
var app = express();

let dummyJson = [
  {
    text: 'Ziraat Bankası',
    boundingBoxArea: '177000.0',
    cornerPointsDx: '1094.0',
    cornerPointsDy: '1280.0'
  },
  {
    text: 'Hasan Seçgin',
    boundingBoxArea: '63459.0',
    cornerPointsDx: '958.0',
    cornerPointsDy: '1771.0'
  },
  {
    text: 'Bireysel Müşteri lişkileri',
    boundingBoxArea: '73824.0',
    cornerPointsDx: '952.0',
    cornerPointsDy: '1895.0'
  },
  {
    text: 'Asistanı',
    boundingBoxArea: '21335.0',
    cornerPointsDx: '936.0',
    cornerPointsDy: '1987.0'
  },
  {
    text: 'Bozok Subes',
    boundingBoxArea: '30600.0',
    cornerPointsDx: '2302.0',
    cornerPointsDy: '1765.0'
  },
  {
    text: 'Erdoğan Akdağ Mahallesi Sht Mustafa',
    boundingBoxArea: '62370.0',
    cornerPointsDx: '2308.0',
    cornerPointsDy: '1864.0'
  },
  {
    text: 'Doğan Caddesi No:4/B-1 PK 66100',
    boundingBoxArea: '60456.0',
    cornerPointsDx: '2309.0',
    cornerPointsDy: '1949.0'
  },
  {
    text: 'Merkez, Yozgat',
    boundingBoxArea: '22968.0',
    cornerPointsDx: '2308.0',
    cornerPointsDy: '2043.0'
  },
  {
    text: 'Tel: 0354 217 4531-171',
    boundingBoxArea: '54612.0',
    cornerPointsDx: '2307.0',
    cornerPointsDy: '2134.0'
  },
  {
    text: 'GSM: 0534 519 1112',
    boundingBoxArea: '36300.0',
    cornerPointsDx: '2309.0',
    cornerPointsDy: '2232.0'
  },
  {
    text: 'Faks: 0354 217 6238',
    boundingBoxArea: '36084.0',
    cornerPointsDx: '2311.0',
    cornerPointsDy: '2328.0'
  },
  {
    text: 'hsecgin@ziraatbank.com.tr',
    boundingBoxArea: '46464.0',
    cornerPointsDx: '947.0',
    cornerPointsDy: '2429.0'
  },
  {
    text: 'www.ziraatbank.com.tr',
    boundingBoxArea: '36478.0',
    cornerPointsDx: '2310.0',
    cornerPointsDy: '2421.0'
  }
];

let names = [];

app.use(express.urlencoded({ extended: true }));
app.use(express.json());

app.listen(4444, function () {
  console.log("Port dinleniyor 4444...");
});

async function writeToCsv(ocrData) {
  const csv = new ObjectsToCsv(ocrData);
  await csv.toDisk('./dataset.csv', { append: true });
}

const rl = readline.createInterface({
  input: fs.createReadStream('isimler.txt'),
  output: process.stdout,
  terminal: false
});

fs.readFile('isimler.txt', 'utf8', (err, data) => {
  if (err) {
    console.error(err)
    return
  }
  const splittedNames = data.split("\n");
  splittedNames.forEach(name => {
    names.push(name);
  });
});


app.get('/api/cities', function (request, response) {
  console.log(dummyJson);
  // let matchedItems = [];
  let foundName = '';
  for (const item of dummyJson) {
    let seperatedText = item.text.split(" ");
    for (const word of seperatedText) {
      console.log(word);
      if (names.includes(word)) {
        console.log("kelime:" + word);
        foundName = word;
        break;
      }
    }
    if (foundName) {
      break;
    }
  }
  // matchedItems.sort((a, b) => (a.cornerPointsDy < b.cornerPointsDy) ? 1 : -1);
  console.log('foundName: ' + foundName);
  response.send('foundName: ' + foundName);
});

app.post('/api/findName', function (request, response) {
  var ocrData = request.body;
  console.log(ocrData);

  let foundName = {};
  for (const item of ocrData) {
    let seperatedText = item.text.split(" ");
    for (const word of seperatedText) {
      console.log(word);
      if (names.includes(word)) {
        console.log("kelime:" + word);
        foundName = item;
        break;
      }
    }
    if (Object.keys(foundName).length != 0) {
      break;
    }
  }
  // matchedItems.sort((a, b) => (a.cornerPointsDy > b.cornerPointsDy) ? 1 : -1);
  if (Object.keys(foundName).length != 0) {
    console.log('foundName: ', foundName);
    response.status(200).send(foundName);
  } else {
    console.log('isim bulunamadi');
    response.status(400).send();
  }
});