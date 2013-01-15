version (linux) {
  //import us.voxg.ewiusb.alsa;
  import std.process, std.regex;
}
version (Windows) {
  import us.voxg.midi.winmidi;
  import core.thread;
}

import std.array, std.conv, std.string;

class MidiDevice {
  string address;
  string name;
  this(string addr, string desc) {
    address = addr;
    name = desc;
  }
}

class MidiIO {

version (Windows) {

private static void sendShorty(HMIDIOUT hmo, ubyte status, ubyte data1, ubyte data2) {
  union Shorty {
    uint packed;
    ubyte data[4];
  }
  Shorty s;
  s.data[0] = status;
  s.data[1] = data1;
  s.data[2] = data2;
  s.data[3] = 0;
  if (midiOutShortMsg(hmo, s.packed))
    throw new Exception(
        format("Error sending message: %02x %02x %02x", status, data1, data2));
}

private static void sendSysex(HMIDIOUT hmo, ubyte[] sysex) {
  MIDIHDR header;
  // Prepare the header for the message
  header.lpData = sysex;
  header.dwBufferLength = sysex.length;
  err = midiOutPrepareHeader(handle, &header, header.sizeof);
  if (err) throw new Exception("Error preparing MIDI header");

  // Send the message
  err = midiOutLongMsg(handle, &header, header.sizeof);
  if (err) {
    char errMsg[120];
    midiOutGetErrorTextA(err, errMsg, 120);
    throw new Exception(errMsg);
  }
  while (MIDIERR_STILLPLAYING == midiOutUnprepareHeader(handle, &header, header.sizeof)) {
    Thread.sleep(dur!("msecs")(10)); // sleep a bit until sent
  }
}

private static void enterSysexMode(HMIDIOUT hmo) {
  sendShorty(hmo, 0xB0, 0x63, 0x01);
  sendShorty(hmo, 0xB0, 0x62, 0x04);
  sendShorty(hmo, 0xB0, 0x06, 0x20);
}

private static void leaveSysexMode(HMIDIOUT hmo) {
  sendShorty(hmo, 0xB0, 0x63, 0x01);
  sendShorty(hmo, 0xB0, 0x62, 0x04);
  sendShorty(hmo, 0xB0, 0x06, 0x10);
}

static MidiDevice[] getDevices() {
  MidiDevice[] devs;
  int[string] devices;
  uint inputs = midiIntGetNumDevs();
  for (uint i = 0; i < inputs; i++) {
    MIDIINCAPS incap;
    uint r = midiInGetDevCapsA(i, &incap, incap.sizeof);
    if (r == 0) {
      string name = incap.szPname[0..incap.szPname.indexOf('\0')];
      devices[name] = i;
    }
  }
  uint outputs = midiOutGetNumDevs();
  for (uint i = 0; i < outputs; i++) {
    MIDIOUTCAPS outcap;
    uint r = midiOutGetDevCapsA(i, &outcap, outcap.sizeof);
    if (r == 0) {
      string name = outcap.szPname[0..outcap.szPname.indexOf('\0')];
      if (devices.get(name, -1) >= 0) {
        devs ~= new MidiDevice(format("%d,%d", devices[name], i), name);
      }
    }
  }
  return devs;
}

static void configure(string dev, ubyte[][] sysex) {
  HMIDIOUT handle;
  MIDIHDR header;
  uint err = midiOutOpen(&handle, parse!uint(split(dev, ",")[1]), 0, 0, CALLBACK_NULL);
  if (err) throw new Exception("Could not open output device");
  scope(exit) midiOutClose(handle);
  foreach (m; sysex) {
    enterSysexMode(handle);
    sendSysex(handle, m);
  }
  leaveSysexMode(handle);
}

shared uint received = -1;
shared ubyte sysex_input[128];

extern (Windows) {
  private void sysex_listener(HMIDIIN hdl, uint msg, void *inst, void *param1, void *param2) {
    if (msg == MIM_LONGDATA) {
      MIDIHDR *hdr = cast(MIDIHDR*)param1;
      ubyte *sysex = cast(ubyte*)hdr.lpData;
      for (int i = 0; i < hdr.dwBytesRecorded && i < sysex_input.length; i++) {
        sysex_input[i] = sysex[i];
      }
      received = hdr.dwBytesRecorded;
    }
  }
}

static ubyte[] receiveConfig(string dev, uint bank) {
  ubyte bnk = 0x40;
  if (bank != 0) bnk = 0x42;
  ubyte[] sysex = [ 0xf0, 0x47, 0x7f, 0x6d, bnk, 0x00, 0x00, 0xf7 ];

  // open the input and set up some callback
  HMIDIIN inhdl;
  uint err = midiInOpen(&inhdl, parse!uint(split(dev, ",")[0]),
      cast(void*)&sysex_listener, 0, CALLBACK_FUNCTION);
  if (err) throw new Exception("Could not open input device");
  scope(exit) {
    midiInReset(inhdl);
    while (midiInClose(inhdl) == MIDIERR_STILLPLAYING) {
      Thread.sleep(dur!("msecs")(100));
    }
  }
  MIDIHDR inhdr;
  ubyte[128] buffer;
  inhdr.lpData = buffer;
  inhdr.dwBufferLength = buffer.sizeof;
  err = midiInPrepareHeader(inhdl, &inhdr, inhdr.sizeof);
  if (err) throw new Exception("Could not initialize MIDI input buffer");
  err = midiInAddBuffer(inhdl, &inhdr, inhdr.sizeof);
  if (err) throw new Exception("Error initializing MIDI input buffer");
  err = midiInStart(inhdl);
  if (err) throw new Exception("Error starting MIDI input");

  // open the output
  HMIDIOUT handle;
  MIDIHDR header;
  err = midiOutOpen(&handle, parse!uint(split(dev, ",")[1]), 0, 0, CALLBACK_NULL);
  if (err) throw new Exception("Could not open output device");
  scope(exit) midiOutClose(handle); // Auto-close when we leave this function

  // send the sysex
  enterSysexMode(handle);
  sendSysex(handle, sysex);

  // wait for the input
  while (received < 1) {
    Thread.sleep(dur!("msecs")(25));
  }
  // send the post_messages
  leaveSysexMode(handle);

  // return the sysex from input
  uint sysex_end = sysex_input.length;
  if (sysex_end > received) sysex_end = received;
  return sysex_input[0..sysex_end];
}

} // version(Windows)

version (linux) {

static MidiDevice[] getDevices() {
  MidiDevice[] devs;
  string[] devices = splitLines(shell("amidi -l"));
  auto r = regex(`^IO +([^ ]+) +(.*)$`);
  foreach (string s; devices) {
    foreach (m; match(s, r)) {
      auto c = m.captures;
      devs ~= new MidiDevice(c[1], c[2]);
    }
  }
  return devs;
}

private static ubyte[] parseSysex(string s) {
  ubyte[] r;
  while (s.length > 1) {
    s.munch(" \t\r\n");
    r ~= parse!ubyte(s, 16);
  }
  return r;
}

static void configure(string dev, ubyte[][] sysex) {
    string command = "amidi -p \"" ~ dev ~ "\" -S ";
    foreach (message; sysex) {
      command ~= "B06301B06204B00620"; // NRPN, turns on sysex mode
      foreach (b; message) {
        command ~= format("%02X ", cast(uint)b);
      }
    }
    command ~= "B06301B06204B00610"; // NRPN, turn off sysex mode
    shell(command);
}

static ubyte[] receiveConfig(string dev, uint bank) {
  string bnk = "0";
  if (bank != 0) bnk = "2";
  ubyte[] sysex = parseSysex(shell("amidi -p " ~ dev ~
            " -S B06301B06204B00620F0477F6D4" ~ bnk ~ "0000F7 -d -t 1"));
  shell("amidi -p " ~ dev ~ " -S B06301B06204B00610");
  return sysex;
}

} // version (linux)

} // class MidiIO
