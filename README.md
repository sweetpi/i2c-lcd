i2c LCD
=======

i2c LCD module using PCF8574P for raspberry pi

Install
-------

```
npm instal i2c-lcd
```

Hardware
--------

Testd with: 
* 2004 LCD Display Module HD44780 (20x4)
* 1602 LCD Display Module HD44780 (16x2)

Usage Example
------------

```coffee
LCD = require("./lcd")

lcd = new LCD("/dev/i2c-1", 0x27)
lcd.init()
.then( ->
  return lcd.createChar(0, [
    0x1b, 0x15, 0x0e, 0x1b,
    0x15, 0x1b, 0x15, 0x0e
  ])
).then( ->
  return lcd.createChar(1, [
    0x0c, 0x12, 0x12, 0x0c
    0x00, 0x00, 0x00, 0x00
  ])
)
.then( -> lcd.home() )
.then( -> lcd.print("Raspberry Pi #{String.fromCharCode(0)}") )
.then( -> lcd.setCursor(0, 1) )
.then( -> lcd.cursorUnder() )
.delay(4000)
.then( ->
  d = new Date()
  s = d.toString()
  return lcd.setCursor(0, 0)
    .then( -> lcd.print(s) )
    .then( -> lcd.setCursor(0, 1) )
    .then( -> lcd.print(s.substring(16)) )
)
.delay(4000)
.then( -> lcd.off() )
.done()
```

This allows you to drive a 1602 LCD module using only 4 pins on the raspberry pi

Based on: https://github.com/wilberforce/lcd-pcf8574
