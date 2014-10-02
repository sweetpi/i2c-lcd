LCD = require("./lcd.coffee")
lcd = new LCD("/dev/i2c-1", 0x27)
lcd.createChar(0, [
  0x1b
  0x15
  0x0e
  0x1b
  0x15
  0x1b
  0x15
  0x0e
]).createChar 1, [
  0x0c
  0x12
  0x12
  0x0c
  0x00
  0x00
  0x00
  0x00
]
lcd.print("Raspberry Pi " + String.fromCharCode(0)).setCursor(0, 1).cursorUnder()
os = require("os")

#var interfaces = os.networkInterfaces();
#console.log(interfaces);
#lcd.print(interfaces.wan0[0].address);
setTimeout (->
  d = new Date
  s = d.toString()
  lcd.setCursor(0, 0).print s
  lcd.setCursor(0, 1).print s.substring(16)
  console.log s
  return
), 4000
setTimeout (->
  lcd.clear().setCursor(0, 1).print("ironman").cursorFull()
  lcd.setCursor(0, 0).print "lego " + String.fromCharCode(0) + "22" + String.fromCharCode(1)
  return
), 6000