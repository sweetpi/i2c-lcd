i2c = require("i2c")

# LCD i2c interface via PCF8574P
# http://dx.com/p/lcd1602-adapter-board-w-iic-i2c-interface-black-works-with-official-arduino-boards-216865

# https://gist.github.com/chrisnew/6725633
# http://www.espruino.com/HD44780
# http://www.espruino.com/LCD1602
displayPorts =
  RS: 0x01
  E: 0x04
  D4: 0x10
  D5: 0x20
  D6: 0x40
  D7: 0x80
  CHR: 1
  CMD: 0
  backlight: 0x08
  RW: 0x20 # not used

class LCD
  constructor: (device, address) ->
    @i2c = new i2c(address,
      device: device
    )
    @write4 0x30, displayPorts.CMD #initialization
    @write4 0x30, displayPorts.CMD #initialization
    @write4 0x30, displayPorts.CMD #initialization
    @write4 LCD.FUNCTIONSET | LCD._4BITMODE | LCD._2LINE | LCD._5x10DOTS, displayPorts.CMD #4 bit - 2 line 5x7 matrix
    @write LCD.DISPLAYCONTROL | LCD.DISPLAYON, displayPorts.CMD #turn cursor off 0x0E to enable cursor
    @write LCD.ENTRYMODESET | LCD.ENTRYLEFT, displayPorts.CMD #shift cursor right
    @write LCD.CLEARDISPLAY, displayPorts.CMD # LCD clear

  write4: (x, c) ->
    a = (x & 0xf0) # Use upper 4 bit nibble
    @i2c.writeByte a | displayPorts.backlight | c
    @i2c.writeByte a | displayPorts.E | displayPorts.backlight | c
    @i2c.writeByte a | displayPorts.backlight | c
    return

  write: (x, c) ->
    @write4 x, c
    @write4 x << 4, c
    this

  clear: ->
    @write LCD.CLEARDISPLAY, displayPorts.CMD

  print: (str) ->
    if typeof str is "string"
      i = 0
      while i < str.length
        c = str[i].charCodeAt(0)
        @write c, displayPorts.CHR
        i++
    this


  ###*
  flashing block for the current cursor
  ###
  cursorFull: ->
    @write LCD.DISPLAYCONTROL | LCD.DISPLAYON | LCD.CURSORON | LCD.BLINKON, displayPorts.CMD


  ###*
  small line under the current cursor
  ###
  cursorUnder: ->
    @write LCD.DISPLAYCONTROL | LCD.DISPLAYON | LCD.CURSORON | LCD.BLINKOFF, displayPorts.CMD


  ###*
  set cursor pos, top left = 0,0
  ###
  setCursor: (x, y) ->
    l = [
      0x00
      0x40
      0x14
      0x54
    ]
    @write LCD.SETDDRAMADDR | (l[y] + x), displayPorts.CMD


  ###*
  set cursor to 0,0
  ###
  home: ->
    l = [
      0x00
      0x40
      0x14
      0x54
    ]
    @write LCD.SETDDRAMADDR | 0x00, displayPorts.CMD


  ###*
  Turn underline cursor off
  ###
  blink_off: ->
    @write LCD.DISPLAYCONTROL | LCD.DISPLAYON | LCD.CURSOROFF | LCD.BLINKOFF, displayPorts.CMD


  ###*
  Turn underline cursor on
  ###
  blink_on: ->
    @write LCD.DISPLAYCONTROL | LCD.DISPLAYON | LCD.CURSORON | LCD.BLINKOFF, displayPorts.CMD


  ###*
  Turn block cursor off
  ###
  cursor_off: ->
    @write LCD.DISPLAYCONTROL | LCD.DISPLAYON | LCD.CURSOROFF | LCD.BLINKON, displayPorts.CMD


  ###*
  Turn block cursor on
  ###
  cursor_on: ->
    @write LCD.DISPLAYCONTROL | LCD.DISPLAYON | LCD.CURSORON | LCD.BLINKON, displayPorts.CMD


  ###*
  setBacklight
  ###
  setBacklight: (val) ->
    if val > 0
      displayPorts.backlight = 0x08
    else
      displayPorts.backlight = 0x00
    @write LCD.DISPLAYCONTROL, displayPorts.CMD


  ###*
  setContrast stub
  ###
  setContrast: (val) ->
    @write LCD.DISPLAYCONTROL, displayPorts.CMD


  ###*
  Turn display off
  ###
  off: ->
    displayPorts.backlight = 0x00
    @write LCD.DISPLAYCONTROL | LCD.DISPLAYOFF, displayPorts.CMD


  ###*
  Turn display on
  ###
  on: ->
    displayPorts.backlight = 0x08
    @write LCD.DISPLAYCONTROL | LCD.DISPLAYON, displayPorts.CMD


  ###*
  set special character 0..7, data is an array(8) of bytes, and then return to home addr
  ###
  createChar: (ch, data) ->
    @write LCD.SETCGRAMADDR | ((ch & 7) << 3), displayPorts.CMD
    i = 0

    while i < 8
      @write data[i], displayPorts.CHR
      i++
    @write LCD.SETDDRAMADDR, displayPorts.CMD

# commands
LCD.CLEARDISPLAY = 0x01
LCD.RETURNHOME = 0x02
LCD.ENTRYMODESET = 0x04
LCD.DISPLAYCONTROL = 0x08
LCD.CURSORSHIFT = 0x10
LCD.FUNCTIONSET = 0x20
LCD.SETCGRAMADDR = 0x40
LCD.SETDDRAMADDR = 0x80

## flags for display entry mode
LCD.ENTRYRIGHT = 0x00
LCD.ENTRYLEFT = 0x02
LCD.ENTRYSHIFTINCREMENT = 0x01
LCD.ENTRYSHIFTDECREMENT = 0x00

## flags for display on/off control
LCD.DISPLAYON = 0x04
LCD.DISPLAYOFF = 0x00
LCD.CURSORON = 0x02
LCD.CURSOROFF = 0x00
LCD.BLINKON = 0x01
LCD.BLINKOFF = 0x00

## flags for display/cursor shift
LCD.DISPLAYMOVE = 0x08
LCD.CURSORMOVE = 0x00
LCD.MOVERIGHT = 0x04
LCD.MOVELEFT = 0x00

## flags for function set
LCD._8BITMODE = 0x10
LCD._4BITMODE = 0x00
LCD._2LINE = 0x08
LCD._1LINE = 0x00
LCD._5x10DOTS = 0x04
LCD._5x8DOTS = 0x00

module.exports = LCD