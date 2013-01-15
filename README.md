akai-ewi-usb-tool
=================

A small utility to configure the Akai EWI USB.

This program is written in D (http://dlang.org) and uses [GtkD](http://www.dsource.org/projects/gtkd).  I've never used D or GTK before, so suggestions and patches are more than welcome.

At the moment MIDI I/O is a little funny.
   - Linux support is via the amidi program from the alsa-utils package.  If amidi is in your path, it should work well.
   - Windows support is done via the standard MMSYSTEM.H API, but I haven't yet compiled the code on Windows, so it's ... iffy at best.
   - I don't have a Mac at my disposal, so porting to CoreMIDI would require some help or donated hardware.
   - OSS should be easy to do, but I don't have OSS set up currently.  If anybody wants this, please send me an email via Gmail at greglyons50.

Product information about the EWI USB can be found at https://www.akaipro.com/ewiusb

Technical information about the EWI USB can be found at Jason M. Knight's site, http://www.ewiusb.com, without which this little utility would have required unreasonable amounts of effort.  Thanks Mr. Knight!
