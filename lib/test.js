var LCD, lcd;

LCD = require("./lcd");

lcd = new LCD("/dev/i2c-1", 0x27);

lcd.init().then(function() {
  return lcd.createChar(0, [0x1b, 0x15, 0x0e, 0x1b, 0x15, 0x1b, 0x15, 0x0e]);
}).then(function() {
  return lcd.createChar(1, [0x0c, 0x12, 0x12, 0x0c, 0x00, 0x00, 0x00, 0x00]);
}).then(function() {
  return lcd.home();
}).then(function() {
  return lcd.print("Raspberry Pi " + (String.fromCharCode(0)));
}).then(function() {
  return lcd.setCursor(0, 1);
}).then(function() {
  return lcd.cursorUnder();
}).delay(4000).then(function() {
  var d, s;
  d = new Date();
  s = d.toString();
  return lcd.setCursor(0, 0).then(function() {
    return lcd.print(s);
  }).then(function() {
    return lcd.setCursor(0, 1);
  }).then(function() {
    return lcd.print(s.substring(16));
  });
}).delay(4000).then(function() {
  return lcd.off();
}).done();
