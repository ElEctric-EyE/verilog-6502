#!/usr/bin/env python
# test program for i2c testing of robotelectronics i2c adapter
#
# on windows, need unbuffered tty output so invoke with
#    /cygdrive/c/Python26/python -u usb.i2c.py
#
# talking to a GOP24 with fpga4fun slave (like an 8574)

import serial
import sys
import time
import select

# some assistance from http://code.activestate.com/recipes/134892/
#    - there's more there for OS X too
#    - also used http://effbot.org/pyfaq/how-do-i-get-a-single-keypress-at-a-time.htm
class _Getch:
    """Gets a single character from standard input.  Does not echo to the screen."""
    def __init__(self):
        try:
            self.impl = _GetchWindows()
        except ImportError:
            self.impl = _GetchUnix()

    def __call__(self): return self.impl()

class _GetchUnix:
    def __init__(self):
        import tty, sys

    def __call__(self):
        import sys, tty, termios
        fd = sys.stdin.fileno()
        old_settings = termios.tcgetattr(fd)
        try:
            tty.setraw(sys.stdin.fileno())
            timeout = 0.1
            ch='X'
            r, w, e = select.select([fd], [], [], timeout)
            if r:
               ch = sys.stdin.read(1)
        finally:
            termios.tcsetattr(fd, termios.TCSADRAIN, old_settings)
        return ch, r

class _GetchWindows:
    # don't know how to do a timeout in Windows
    def __init__(self):
        import msvcrt

    def __call__(self):
        import msvcrt
        return msvcrt.getch(), True

getchWithTimeout = _Getch()

def readback(n):
    return ser.read(n)

    print "about to read back"

    bytes=ser.read(n)
    if len(bytes)>0 :
      print "%d bytes read" % len(bytes)
      for i in range(len(bytes)):
        print "byte was: %1x\n" % ord(bytes[i])
    else:
      print "no bytes read (timeout)"

def writebyteoverI2C(x):
  # 53 is the single-byte simple device command
  # byte1 is the address and read bit (we are 4E to write, 4F to read)
  ser.write("\x53\x4E"+x)
  if ord(readback(1))==0:
    print "failed to write a byte"
    exit(1)

def readbyte():
  ser.write("\x53\x4F")
  return readback(1)

def anythingtoread():
  # status reg tells us if there is data pending to be read
  ser.write("\x53\x4D")
  return ord(ser.read(1)[0])==1

def readchar():
  if anythingtoread():
    print 'one char from FPGA: 0x%02x' % ord(readbyte())
    time.sleep(1)
  else:
    print 'nothing to read, sleeping'
    time.sleep(1)

def readanycharsfromUART():
  while anythingtoread():
    # print readbyte()
    ch=readbyte()
    # print "\r\nch: 0x%02x\n\r" % ord(ch)
    sys.stdout.write(ch)
    if ch=='\n':
      sys.stdout.write('\r')
    if ch=='\r':
      sys.stdout.write('\n')
    if ord(ch)<32:
      sys.stdout.flush()

port_linux="/dev/ttyUSB0"
port_windows="COM4"

try:
  ser = serial.Serial(port_windows, 19200, timeout=2, stopbits=serial.STOPBITS_TWO)
except:
  ser = serial.Serial(port_linux, 19200, timeout=2, stopbits=serial.STOPBITS_TWO)

import sys, tty, termios
fd = sys.stdin.fileno()
old_settings = termios.tcgetattr(fd)
try:
    tty.setraw(sys.stdin.fileno())
    timeout = 0.1    # we will be polling the FPGA frequently
    ch='X'
    while 1:
      readanycharsfromUART()
      r, w, e = select.select([fd], [], [], timeout)
      if r:
         ch = sys.stdin.read(1)
         if ch == "\x03":  # handle ^C as we're in raw mode
           break
         writebyteoverI2C(ch)
         # print "\n\r>>", "0x%02x" % ord(ch), "\n\r"

finally:
    termios.tcsetattr(fd, termios.TCSADRAIN, old_settings)

print "done"
exit(0)

#
# various historial efforts or tests
#

while 1:
  char, gotit = getchWithTimeout()
  if gotit:
     print ">>", char,
  readchar()

while 1:
  readchar()
  print "trying a write of 0x60"
  writebyte("\x60")
  readchar()
  readchar()
  print "trying a write of 0x55"
  writebyte("\x55")
  readchar()
  print "trying a write of 0xaa"
  writebyte("\xaa")
  readchar()

while 1:
  raw_input('Press Enter to read a byte')
  print 'status byte before read: %d' % readstatus()

while 1:
  readbyte()
  print 'status byte after read:'
  readstatus()
  print 'about to write'
  writebyte("\xf0")
  print 'status byte after write:'
  readstatus()
  print 'another read:'
  readbyte()

raw_input('Press Enter to read status')
while 1:
  readstatus()

while 1:
  writebyte("\x01")
  writebyte("\x02")
  writebyte("\x04")
  writebyte("\x08")
  writebyte("\x10")
  writebyte("\x20")
  writebyte("\x40")
  writebyte("\x80")

ser.close()
