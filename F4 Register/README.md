# F4 Register for MSX2+

In comparison to older versions, MSX2+ adds a 1-bit IO register at the address `0xF4`
to record whether the computer has already been booted up. If the bit is set,
the boot logo and screen are skipped. This allows faster resets.

The [PLD file](MSXF4REG.pld) is a CUPL implementation of the F4 register for
a GAL22V10 programmable logic IC. The file can be compiled with, e.g., WinCUPL,
but a pre-compiled [JEDEC file](MSXF4REG.jed) is also included.

## Installation

<pre><code>
                ______________
               |   GAL22V10   |
     clock >---|1           24|---< Vcc
        A0 >---|2           23|---> clock
        A1 >---|3           22|--->
        A2 >---|4           21|---> !IO7AB
        A3 >---|5           20|---< !M1
        A4 >---|6           19|---> !F4WE
        A5 >---|7           18|---> !F4REG
        A6 >---|8           17|---> F4REG
        A7 >---|9           16|---> !F4OE
       !WR >---|10          15|---< !IORQ
       !RD >---|11          14|---> D7
       GND >---|12          13|---< D7
               |______________|
</code></pre>

To install the programmed chip, the clock input and output (pins 1 and 23) must first be
shorted together. After that, connections must be made for the eight address
lines `A0`…`A7`, the data bit `D7` (both input and output, i.e., two pins to the
same line), and the control signals `RD#`, `WR#`, `IORQ#` and `M1#`. And
obviously the 5 V power (pin 24) and ground (pin 12) need to be connected. All
of the necessary connections should be available near the Z80 CPU in the MSX
computer.

The other pins are outputs usable for debugging and extra features, but do not
need to be connected.

And since there was still space on the chip, pin 21 is the active-low chip select
signal for a device at the IO addresses `0x7A` and `0x7B`. This can be used to
add a Yamaha OPLL FM audio chip (FM-PAC compatible).
