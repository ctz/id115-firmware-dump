Dumping ID115 firmware
======================

This repo contains a HOWTO on dumping firmware from a Nordic
nRF51822-based ID115 fitness band.

See [Raphael Baron's blog post](https://rbaron.net/blog/2018/05/27/Hacking-a-cheap-fitness-tracker-bracelet.html)
which gives lots of hardware-level detail and shows how to get at the
SWD pads.  This is what mine ended up looking like:

![An ID115 connected to SWD](https://raw.githubusercontent.com/ctz/id115-firmware-dump/master/id115-swd.jpg)

These are shipped with flash readback protection on (`UICR.RBPCONF.PALL`
= `0x00`) which means directly reading out the flash isn't possible over
SWD.  However, you can still otherwise control execution.

See [Kris Brosch's blog post at Include Security](http://blog.includesecurity.com/2015/11/NordicSemi-ARM-SoC-Firmware-dumping-technique.html)
which is the source of this technique.

But briefly it works like this:

1. Find a suitable register-register load instruction.
2. Execute that instruction with an address in flash.
3. Read the target register, which now contains one word of flash.

(1) sounds tricky, but ARM is a load-store architecture and the Thumb
instruction encoding can't encode a 32-bit address in a single instruction, so
these instructions are abundant.

On the ID115 I found a suitable instruction at address `0x6de`, which was just
`ldr r3, [r3]`.  

Files in this repo:

*  `dump.rb` reads out all of flash using the gadget at 0x6de.  It's otherwise
   identical to the script from Include Security.  This takes about 30 minutes.
*  `dump.bin` is the original flash on my ID115.
*  `uicr.bin` is the original UICR area on my ID115.
*  `openocd-stlink.cfg` is an openocd configuration file if you use an STLinkV2
   debugger.

