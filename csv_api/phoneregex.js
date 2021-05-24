/*
var re = new RegExp('(([\+]90?)|([0]?))([ ]?)((\([0-9]{3}\))|([0-9]{3}))([ ]?)([0-9]{3})(\s*[\-]?)([0-9]{2})(\s*[\-]?)([0-9]{2})');
var r  = '0505 799 39 86'.match(re);
if (r)
    console.log(r); //=> "Mipm1LMKVqJ"

*/

const regex = /(([\+]90?)|([0]?))([ ]?)((\([0-9]{3}\))|([0-9]{3}))([ ]?)([0-9]{3})(\s*[\-]?)([0-9]{2})(\s*[\-]?)([0-9]{2})/im;
const str = `tel: 505 799 39 86 0505 650-2397 `;
let m;

if ((m = regex.exec(str)) !== null) {
  // The result can be accessed through the `m`-variable.
  m.forEach((match, groupIndex) => {

    console.log(`Found match, group ${groupIndex}: ${match}`);
  });
}

/**
 * 
 0505 799 39 86
 354 217 4531
 505 799 39 86
 (0212) 213 00 21
 (0533) 413 32 76
 0354 217 4531
 */