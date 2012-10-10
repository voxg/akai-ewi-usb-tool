akai-ewi-usb-tool
=================

A small utility to configure the AKAI EWI USB.

This program is written in D (dlang.org) and uses GtkD (https://github.com/downloads/gtkd-developers/GtkD/GtkD-2.0.zip).  I've never used D or GTK before, so suggestions and patches are more than welcome.

I tried to make this program easy to port, except for one little detail...  I use the amidi program from alsa-utils for all MIDI I/O.  There are a few not-so-bad reasons to do this.
   - It's super easy, so I got the tool written quickly and was back to practicing in no time.
   - It's an easy tool to re-write for other platforms, so there's a quick-and-dirty path forward.
   - The product ships with a configuration tool for Windows and Mac, so the need for portability is questionable.

That said, I would really prefer to re-implement the MIDI I/O code to use OSS, ALSA, Win32, and CoreMIDI APIs so that it could be used on any platform without any additional dependencies or kludgy work-arounds.  I would need help building and testing for OSS and CoreMIDI, so please contact me if you want to help me acheive this goal.

Product information about the EWI USB can be found at https://www.akaipro.com/ewiusb

Technical information about the EWI USB can be found at Jason M. Knight's site, http://www.ewiusb.com, without which this little utility would have required unreasonable amounts of effort.  Thanks Mr. Knight!
