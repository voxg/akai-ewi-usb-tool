module us.voxg.ewiusb.configuration;

import std.string, std.array, std.algorithm, std.stdio;

/**
 * Represents an individual configuration parameter of the AKAI EWI USB.
 * Each parameter is a single byte and lives at a two-byte (msb, lsb)
 * memory address.
 */
class Parameter {
  /** A natural-language name for the parameter */
  string name;
  /** The most significant byte of the memory address of the parameter. */
  ubyte msb;
  /** The least significant byte of the memory address of the parameter. */
  ubyte lsb;
  /** The default value for the parameter. */
  ubyte defaultValue;
  /** Function to ensure that a configuration value is legal and proper. */
  bool delegate(ubyte v) checker;

  /** Primary constructor. */
  this(string n, int m, int l, int d, bool delegate(ubyte v) dg) {
    name = n;
    msb = cast(ubyte)m;
    lsb = cast(ubyte)l;
    defaultValue = cast(ubyte)d;
    checker = dg;
  }

  /** Sets the default checker, which ensures 7-bit values. */
  this(string n, int m, int l, int d) {
    this(n, m, l, d, (ubyte v) { return (v >= 0 && v <= 127); } );
  }

  /** Sets a checker that requires values between min and max. */
  this(string n, int m, int l, int d, int min, int max) {
    ubyte minb = cast(ubyte)min;
    ubyte maxb = cast(ubyte)max;
    this(n, m, l, d, (ubyte v) { return (v >= minb && v <= maxb); } );
  }
}

/** All of the individual parameters. */
enum Values : int {
  BREATH_GAIN,
  BITE_GAIN,
  BITE_AC_GAIN,
  PITCH_BEND_GAIN,
  KEY_DELAY,
  UNKNOWN,
  MIDI_CHANNEL,
  FINGERING,
  TRANSPOSE,
  VELOCITY,
  BREATH_CC1,
  BREATH_CC2,
  UNKNOWN2,
  BITE_CC1,
  BITE_CC2,
  PITCH_BEND_UP,
  PITCH_BEND_DOWN
};

/** Represents a complete configuration of the AKAI EWI USB. */
class Configuration {

  /** An array of configuration parameters, in order */
  private static Parameter[17] items;

  /** An array of configuration values, one per parameter (in order). */
  private ubyte[17] values;

  // NOTE:  The order of parameters within each bank (MSB) is important
  static this() {
    items[Values.BREATH_GAIN]     = new Parameter("Breath Gain",     0, 0, 0x40);
    items[Values.BITE_GAIN]       = new Parameter("Bite Gain",       0, 1, 0x40);
    items[Values.BITE_AC_GAIN]    = new Parameter("Bite AC Gain",    0, 2, 0x40);
    items[Values.PITCH_BEND_GAIN] = new Parameter("Pitch Bend Gain", 0, 3, 0x40);
    items[Values.KEY_DELAY]       = new Parameter("Key Delay",       0, 4, 0x08, 0, 0xf);
    items[Values.UNKNOWN]         = new Parameter("Unknown",         0, 5, 0x7f);
    items[Values.MIDI_CHANNEL]    = new Parameter("MIDI Channel",    2, 0, 0,    0, 0xf);
    items[Values.FINGERING]       = new Parameter("Fingering",       2, 1, 0,    0, 5);
    items[Values.TRANSPOSE]       = new Parameter("Transpose",       2, 2, 0x40, 40, 88);
    items[Values.VELOCITY]        = new Parameter("Velocity",        2, 3, 0x20);
    items[Values.BREATH_CC1]      = new Parameter("Breath CC1",      2, 4, 0x02);
    items[Values.BREATH_CC2]      = new Parameter("Breath CC2",      2, 5, 0);
    items[Values.UNKNOWN2]        = new Parameter("Unknown2",        2, 6, 0);
    items[Values.BITE_CC1]        = new Parameter("Bite CC1",        2, 7, 0x7f);
    items[Values.BITE_CC2]        = new Parameter("Bite CC2",        2, 8, 0);
    items[Values.PITCH_BEND_UP]   = new Parameter("Pitch Bend Up",   2, 9, 0x7f);
    items[Values.PITCH_BEND_DOWN] = new Parameter("Pitch Bend Down", 2, 0xA, 0x7f);
  }

  this () {
    foreach (int i, Parameter p; items) values[i] = p.defaultValue;
  }

  /**
   * Look up the values/items array location for a given memory address.
   * Returns -1 if the address doesn't exist, or >=0, <=Values.max.
   */
  int getIndex(ubyte msb, ubyte lsb) {
    foreach (int i, Parameter p; items) {
      if (p.msb == msb && p.lsb == lsb) {
        return i;
      }
    }
    return -1;
  }

  /**
   * Attempts to set the value at the given location in the values/items
   * array.  Returns true of the value passed the checker.
   */
  private bool setValue(int i, ubyte b) {
    if (items[i].checker(b)) {
      values[i] = b;
      return true;
    } else {
      return false;
    }
  }

  /**
   * Attempts to set the value at the given Value.  Returns true if the 
   * value passed the checker.
   */
  bool setValue(Values v, ubyte b) {
    return setValue(cast(int)v, b);
  }

  /**
   * Attempts to set the value at the given memory address.  Returns true if
   * the value passed the checker;
   */
  bool setValue(ubyte msb, ubyte lsb, ubyte b) {
    int i = getIndex(msb, lsb);
    if (i < 0) return false;
    if (items[i].checker(b)) {
      values[i] = b;
      return true;
    } else {
      return false;
    }
    return false;
  }

  /** Retrieves the configuration value at the given memory address. */
  ubyte getValue(ubyte msb, ubyte lsb) {
    return values[getIndex(msb, lsb)];
  }

  /** Retrieves the value of the given configuration item. */
  ubyte getValue(Values v) { return getValue(cast(int)v); }

  private ubyte getValue(int i) { return values[i]; }

  /**
   * Returns an array of ubytes that forms a Sysex message representing the
   * requested bank (0 or 2).
   */
  ubyte[] toSysex(int bank) {
    ubyte bnk = cast(ubyte)bank;
    if (bank != 0 && bank != 2) { return new ubyte[0]; }

    int start = 0;
    while (start < items.length && items[start].msb != bnk) { start++; }

    int end = items.length;
    while (end > 0 && items[end - 1].msb != bnk) { end--; }

    ubyte len = cast(ubyte)(end - start);
    ubyte[] r = new ubyte[len + 8];
    r = [ cast(ubyte)0xF0, // Start of sysex
          cast(ubyte)0x47, // AKAI manufacturer ID
          cast(ubyte)0x7F, // Any device
          cast(ubyte)0x6D, // EWI-USB model ID
          bnk,             // MSB of start address
          cast(ubyte)0,    // LSB of start address
          len ] ~          // Number of data bytes to write
        values[start .. end] ~
	[ cast(ubyte)0xf7 ];//End of sysex
    return r;
  }

  /**
   * Returns an array of sysex MIDI messages (each an array of ubytes) that
   * represents the complete configuration.
   */
  ubyte[][] toSysex() {
    return [ toSysex(0), toSysex(2) ];
  }

  /**
   * Parses the provided sysex, which should start with 0xF0 and end with 0xF7
   * and contain a valid sysex message as produced by the AKAI EWI USB.
   */
  bool applySysex(ubyte[] sysex) {
    ubyte msb, lsb, len;
    if (sysex[0] == 0xF0 && sysex[1] == 0x47 && sysex[3] == 0x6D) {
      msb = sysex[4];
      lsb = sysex[5];
      len = sysex[6];
    }
    int index = getIndex(msb, lsb);
    if ((index + len) > values.length) return false;
    bool rval = true;
    for (int i = 0; i < len; i++) {
      if (!setValue(i + index, sysex[7+i])) rval = false;
    }
    return rval;
  }
}

/*
module main;
void main() {
  Configuration c = new Configuration();
  writeln(Values.BITE_GAIN, " / ", cast(int)Values.BITE_GAIN);
  writeln(c.getValue(Values.BITE_GAIN));
  auto sysexes = c.toSysex();
  foreach (ubyte[] sysex; sysexes) {
    foreach (ubyte b; sysex) writef("%02x ", b);
    writeln();
  }
}
*/
