module us.voxg.ewiusb.gui;

import
us.voxg.ewiusb.configuration,
us.voxg.ewiusb.sysexfile,
gtk.AboutDialog,
gtk.Button,
gtk.ComboBoxText,
gtk.FileChooserDialog,
gtk.Grid,
gtk.HBox,
gtk.HScale,
gtk.ImageMenuItem,
gtk.Label,
gtk.Main,
gtk.MainWindow,
gtk.Menu,
gtk.MenuBar,
gtk.MenuItem,
gtk.MountOperation,
gtk.Notebook,
gtk.Range,
gtk.SeparatorMenuItem,
gtk.Statusbar,
gtk.StockItem,
gtk.VBox,
gtkc.gtktypes,
std.conv,
std.file,
std.process,
std.regex,
std.string,
std.stdio;

public class Slider : HScale {
  this(double min, double max, double step) {
    super(min,max,step);
    setDigits(0);
    setValuePos(GtkPositionType.RIGHT);
  }

  ubyte get() {
    return cast(ubyte)getValue();
  }

  void set(ubyte x) {
    setValue(cast(double)x);
  }
}

public class SetupRow : HBox {
  this(string name, Slider s) {
    super(false, 10);
    Label l = new Label(name);
    l.setWidthChars(20);
    add(l);
    add(s);
  }
}

public class SetupGrid : VBox {
  Slider breath;
  Slider bite;
  Slider biteAc;
  Slider pitch;
  Slider delay;
  Slider unknown;
  
  this() {
    super(false, 10);
    breath = new Slider(0.0, 127.0, 1.0);
    bite   = new Slider(0.0, 127.0, 1.0);
    biteAc = new Slider(0.0, 127.0, 1.0);
    pitch  = new Slider(0.0, 127.0, 1.0);
    delay  = new Slider(0.0,  15.0, 1.0);
    unknown= new Slider(0.0, 127.0, 1.0);
    unknown.setSensitive(0);

    add(new SetupRow("Breath Gain",     breath));
    add(new SetupRow("Bite Gain",       bite));
    add(new SetupRow("Bite AC Gain",    biteAc));
    add(new SetupRow("Pitch Bend Gain", pitch));
    add(new SetupRow("Key Delay",       delay));
    add(new SetupRow("Unknown",         unknown));
  }

  void reflect(Configuration c) {
    breath.set(c.getValue(Values.BREATH_GAIN));
    bite.set(c.getValue(Values.BITE_GAIN));
    biteAc.set(c.getValue(Values.BITE_AC_GAIN));
    pitch.set(c.getValue(Values.PITCH_BEND_GAIN));
    delay.set(c.getValue(Values.KEY_DELAY));
    unknown.set(c.getValue(Values.UNKNOWN));
  }
}

public class PerformanceGrid : Grid {
  ComboBoxText midiChannel;
  ComboBoxText fingering;
  ComboBoxText transpose;
  ComboBoxText velocity;

  this() {
    midiChannel = new ComboBoxText(false);
    for (int i = 0; i < 16; i++) {
      midiChannel.append(text(i), text(i+1));
    }
    fingering = new ComboBoxText(false);
    fingering.append("0", "0 - EWI");
    fingering.append("1", "1 - Saxophone");
    fingering.append("2", "2 - Flute");
    fingering.append("3", "3 - Oboe");
    fingering.append("4", "4 - EVI Valve 1");
    fingering.append("5", "4 - EVI Valve 2");

    transpose = new ComboBoxText(false);
    string note(int transpose) {
      string[] names = ["C",  "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"];
      return names[(transpose - 16) % 12] ~ text((transpose - 16) / 12);
    }
    for (int i = 34; i < 94; i++) {
      transpose.append(text(i), note(i));
    }

    velocity = new ComboBoxText(false);
    velocity.append("0", "0 (Dynamic)");
    for (int i = 1; i < 128; i++) {
      velocity.append(text(i), text(i) ~ " (Fixed)");
    }
    //                               Lft Tp Wd Ht
    attach(new Label("MIDI Channel"), 0, 0, 1, 1);
    attach(midiChannel,               1, 0, 1, 1);
    attach(new Label("Fingering"),    0, 1, 1, 1);
    attach(fingering,                 1, 1, 1, 1);
    attach(new Label("Transpose"),    0, 2, 1, 1);
    attach(transpose,                 1, 2, 1, 1);
    attach(new Label("Velocity"),     0, 3, 1, 1);
    attach(velocity,                  1, 3, 1, 1);
  }

  void reflect(Configuration c) {
    midiChannel.setActive(cast(int)c.getValue(Values.MIDI_CHANNEL));
    fingering.setActive(cast(int)c.getValue(Values.FINGERING));
    transpose.setActive(cast(int)c.getValue(Values.TRANSPOSE) - 34);
    velocity.setActive(cast(int)c.getValue(Values.VELOCITY));
  }
}

public class ControllerGrid : Grid {
  ComboBoxText breathCC1;
  ComboBoxText breathCC2;
  ComboBoxText unknown2;
  ComboBoxText biteCC1;
  ComboBoxText biteCC2;
  ComboBoxText pitchBendUp;
  ComboBoxText pitchBendDown;

  static string[] controllers = [
        "Bank Select", "Modulation Wheel or Lever", "Breath Controller", "",
        "Foot Controller", "Portamento Time", "Data Entry MSB", "Channel Volume",
        "Balance", "", "Pan", "Expression Controller", "Effect Control 1",
        "Effect Control 2", "", "", "General Purpose Controller 1",
        "General Purpose Controller 2", "General Purpose Controller 3",
        "General Purpose Controller 4", "", "", "", "", "", "", "", "", "", "",
        "", "", "LSB for Control 0 (Bank Select)",
        "LSB for Control 1 (Modulation Wheel or Lever)",
        "LSB for Control 2 (Breath Controller)", "",
        "LSB for Control 4 (Foot Controller)",
        "LSB for Control 5 (Portamento Time)",
        "LSB for Control 6 (Data Entry)",
        "LSB for Control 7 (Channel Volume)",
        "LSB for Control 8 (Balance)", "",
        "LSB for Control 10 (Pan)",
        "LSB for Control 11 (Expression Controller)",
        "LSB for Control 12 (Effect control 1)",
        "LSB for Control 13 (Effect control 2)", "", "",
        "LSB for Control 16 (General Purpose Controller 1)",
        "LSB for Control 17 (General Purpose Controller 2)",
        "LSB for Control 18 (General Purpose Controller 3)",
        "LSB for Control 19 (General Purpose Controller 4)", "", "", "", "", "", "",
        "", "", "", "", "", "", "Damper Pedal on/off (Sustain)", "Portamento On/Off",
        "Sostenuto On/Off", "Soft Pedal On/Off", "Legato Footswitch", "Hold 2",
        "Sound Controller 1 (default: Sound Variation)",
        "Sound Controller 2 (default: Timbre/Harmonic Intens.)",
        "Sound Controller 3 (default: Release Time)",
        "Sound Controller 4 (default: Attack Time)",
        "Sound Controller 5 (default: Brightness)",
        "Sound Controller 6 (default: Decay Time - see MMA RP-021)",
        "Sound Controller 7 (default: Vibrato Rate - see MMA RP-021)",
        "Sound Controller 8 (default: Vibrato Depth - see MMA RP-021)",
        "Sound Controller 9 (default: Vibrato Delay - see MMA RP-021)",
        "Sound Controller 10 (default undefined - see MMA RP-021)",
        "General Purpose Controller 5", "General Purpose Controller 6",
        "General Purpose Controller 7", "General Purpose Controller 8",
        "Portamento Control", "", "", "", "", "", "",
        "Effects 1 Depth (default: Reverb Send Level - see MMA RP-023)",
        "Effects 2 Depth",
        "Effects 3 Depth (default: Chorus Send Level - see MMA RP-023)",
        "Effects 4 Depth", "Effects 5 Depth",
        "Data Increment (Data Entry +1) (see MMA RP-018)",
        "Data Decrement (Data Entry -1) (see MMA RP-018)",
        "Non-Registered Parameter Number (NRPN) - LSB",
        "Non-Registered Parameter Number (NRPN) - MSB",
        "Registered Parameter Number (RPN) - LSB*",
        "Registered Parameter Number (RPN) - MSB*", "", "", "", "", "", "", "", "", "",
        "", "", "", "", "", "", "", "", "", "[Channel Mode Message] All Sound Off",
        "[Channel Mode Message] Reset All Controllers (See MMA RP-015)",
        "[Channel Mode Message] Local Control On/Off",
        "[Channel Mode Message] All Notes Off",
        "[Channel Mode Message] Omni Mode Off (+ all notes off)",
        "[Channel Mode Message] Omni Mode On (+ all notes off)",
        "[Channel Mode Message] Mono Mode On (+ poly off +all notes off)",
        "[Channel Mode Message] Poly Mode On (+ mono off +all notes off)"
  ];

  this() {
    breathCC1 = new ComboBoxText(false);
    breathCC2 = new ComboBoxText(false);
    unknown2 = new ComboBoxText(false);
    biteCC1 = new ComboBoxText(false);
    biteCC2 = new ComboBoxText(false);
    pitchBendUp = new ComboBoxText(false);
    pitchBendDown = new ComboBoxText(false);
    unknown2.setSensitive(0);

    string special127(int n, string s) {
      switch (n) {
        case 0: return "Off";
        case 127: return s;
        default: return text(n) ~ " - " ~ controllers[n];
      }
    }

    string biteCC1lst(int n) {
      switch (n) {
        case 0: return "Off";
        case 124: return "Pitch bend up";
        case 125: return "Pitch bend down";
        case 126: return "Pitch bend up-down";
        case 127: return "Pitch bend down-up";
        default: return text(n) ~ " - " ~ controllers[n];
      }
    }

    for (int i = 0; i < 128; i++) {
      breathCC1.append(text(i), special127(i, "Aftertouch"));
      breathCC2.append(text(i), special127(i, "Aftertouch"));
      unknown2.append(text(i), text(i));
      biteCC1.append(text(i), biteCC1lst(i));
      biteCC2.append(text(i), special127(i, "Aftertouch"));
      pitchBendUp.append(text(i), special127(i, "Pitch bend up"));
      pitchBendDown.append(text(i), special127(i, "Pitch bend down"));
    }

    //                                 Lft Tp Wd Ht
    attach(new Label("Breath CC1"),      0, 0, 1, 1);
    attach(breathCC1,                    1, 0, 1, 1);
    attach(new Label("Breath CC2"),      0, 1, 1, 1);
    attach(breathCC2,                    1, 1, 1, 1);
    attach(new Label("Unknown 2"),       0, 2, 1, 1);
    attach(unknown2,                     1, 2, 1, 1);
    attach(new Label("Bite CC1"),        0, 3, 1, 1);
    attach(biteCC1,                      1, 3, 1, 1);
    attach(new Label("Bite CC2"),        0, 4, 1, 1);
    attach(biteCC2,                      1, 4, 1, 1);
    attach(new Label("Pitch Bend Up"),   0, 5, 1, 1);
    attach(pitchBendUp,                  1, 5, 1, 1);
    attach(new Label("Pitch Bend Down"), 0, 6, 1, 1);
    attach(pitchBendDown,                1, 6, 1, 1);
  }

  void reflect(Configuration c) {
    breathCC1.setActive(c.getValue(Values.BREATH_CC1));
    breathCC2.setActive(c.getValue(Values.BREATH_CC2));
    unknown2.setActive(c.getValue(Values.UNKNOWN2));
    biteCC1.setActive(c.getValue(Values.BITE_CC1));
    biteCC2.setActive(c.getValue(Values.BITE_CC2));
    pitchBendUp.setActive(c.getValue(Values.PITCH_BEND_UP));
    pitchBendDown.setActive(c.getValue(Values.PITCH_BEND_DOWN));
  }
}

class MidiDeviceCombo : ComboBoxText {
  this() {
    refresh();
  }

  void refresh() {
    string current = getActiveId();
    bool found = false;
    removeAll();
    string[] devices = splitLines(shell("amidi -l"));
    auto r = regex(`^IO +([^ ]+) +(.*)$`);
    foreach (string s; devices) {
      foreach (m; match(s, r)) {
        auto c = m.captures;
        append(c[1], c[2] ~ " (" ~ c[1] ~ ")");
        if (current == c[1]) found = true;
      }
    }
    if (found) setActiveId(current); else setActive(-1);
  }
}

class AkaiEwiUsbMain : MainWindow {
  Configuration config;
  MenuBar mb;
  SetupGrid sg;
  PerformanceGrid pg;
  ControllerGrid cg;
  Statusbar status;
  MidiDeviceCombo devices;
  Button refresh;
  uint statusContext;
  bool listening = true;

  this() {
    super("AKAI EWI USB Configuration Tool");
    config = new Configuration();

    VBox outerBox = new VBox(false, 10);
    add(outerBox);
    mb = new MenuBar();
    Menu fileMenu = mb.append("_File");
    ImageMenuItem open = new ImageMenuItem(StockID.OPEN, null);
    ImageMenuItem save = new ImageMenuItem(StockID.SAVE_AS, null);
    ImageMenuItem quit = new ImageMenuItem(StockID.QUIT, null);
    open.addOnActivate(&openFile);
    save.addOnActivate(&saveFile);
    quit.addOnActivate((MenuItem m){ Main.quit(); });
    fileMenu.append(open);
    fileMenu.append(save);
    fileMenu.append(new SeparatorMenuItem());
    fileMenu.append(quit);
    Menu midiMenu = mb.append("_MIDI");
    MenuItem send = new MenuItem(&transferMidi, "Send to EWI");
    MenuItem recv = new MenuItem(&receiveMidi, "Receive from EWI");
    midiMenu.append(send);
    midiMenu.append(recv);
    Menu helpMenu = mb.append("_Help", true);
    ImageMenuItem help = new ImageMenuItem(StockID.HELP, null);
    ImageMenuItem about = new ImageMenuItem(StockID.ABOUT, null);
    help.addOnActivate((MenuItem m){ MountOperation.showUri(null, "http://w.voxg.us/projects/akai-ewi-usb/help", 0); });
    about.addOnActivate(&showAbout);
    helpMenu.append(help);
    helpMenu.append(about);
    outerBox.add(mb);

    HBox midiDeviceRow = new HBox(0, 10);
    midiDeviceRow.add(new Label("Select MIDI device for I/O:"));
    devices = new MidiDeviceCombo();
    midiDeviceRow.add(devices);
    refresh = new Button("Refresh devices", (Button b){devices.refresh();});
    midiDeviceRow.add(refresh);
    outerBox.add(midiDeviceRow);

    Notebook tabs = new Notebook();
    sg = new SetupGrid();
    pg = new PerformanceGrid();
    cg = new ControllerGrid();
    tabs.appendPage(sg, new Label("Setup", false));
    tabs.appendPage(pg, new Label("Performance", false));
    tabs.appendPage(cg, new Label("Controller", false));
    outerBox.add(tabs);

    sg.breath .addOnValueChanged((Range r) { update(Values.BREATH_GAIN,     sg.breath.get()); });
    sg.bite   .addOnValueChanged((Range r) { update(Values.BITE_GAIN,       sg.bite.get()); });
    sg.biteAc .addOnValueChanged((Range r) { update(Values.BITE_AC_GAIN,    sg.biteAc.get()); });
    sg.pitch  .addOnValueChanged((Range r) { update(Values.PITCH_BEND_GAIN, sg.pitch.get()); });
    sg.delay  .addOnValueChanged((Range r) { update(Values.KEY_DELAY,       sg.delay.get()); });
    sg.unknown.addOnValueChanged((Range r) { update(Values.UNKNOWN,         sg.unknown.get()); });

    pg.midiChannel.addOnChanged((ComboBoxText c) { update(Values.MIDI_CHANNEL, c.getActive()   ); });
    pg.fingering  .addOnChanged((ComboBoxText c) { update(Values.FINGERING,    c.getActive()   ); });
    pg.transpose  .addOnChanged((ComboBoxText c) { update(Values.TRANSPOSE,    c.getActive()+34); });
    pg.velocity   .addOnChanged((ComboBoxText c) { update(Values.VELOCITY,     c.getActive()   ); });

    cg.breathCC1    .addOnChanged((ComboBoxText c) { update(Values.BREATH_CC1,      c.getActive()); });
    cg.breathCC2    .addOnChanged((ComboBoxText c) { update(Values.BREATH_CC2,      c.getActive()); });
    cg.unknown2     .addOnChanged((ComboBoxText c) { update(Values.UNKNOWN2,        c.getActive()); });
    cg.biteCC1      .addOnChanged((ComboBoxText c) { update(Values.BITE_CC1,        c.getActive()); });
    cg.biteCC2      .addOnChanged((ComboBoxText c) { update(Values.BITE_CC1,        c.getActive()); });
    cg.pitchBendUp  .addOnChanged((ComboBoxText c) { update(Values.PITCH_BEND_UP,   c.getActive()); });
    cg.pitchBendDown.addOnChanged((ComboBoxText c) { update(Values.PITCH_BEND_DOWN, c.getActive()); });


    status = new Statusbar();
    statusContext = status.getContextId("generic");
    outerBox.add(status);

    reflectAll();
  }

  void update(Values v, ubyte b) { if (listening) config.setValue(v, b); }
  void update(Values v, int b) { if (listening) config.setValue(v, cast(ubyte)b); }

  void openFile(MenuItem m) {
    FileChooserDialog chooser = new FileChooserDialog("Open sysex file", this, GtkFileChooserAction.OPEN);
    chooser.setLocalOnly(1);
    chooser.setSelectMultiple(0);
    auto r = chooser.run();
    int total = 0;
    int success = 0;
    if (r == ResponseType.OK) {
      try {
        foreach ( message; readSysexFile(chooser.getFilename()) ) {
          total++;
          if (config.applySysex(message)) success++;
        }
      } catch (FileException e) {
        // ???
      }
    }
    chooser.destroy();
    reflectAll();
    status.push(statusContext, format("%d sysex messages processed, %d fully successful", total, success));
  }

  void saveFile(MenuItem m) {
    FileChooserDialog chooser = new FileChooserDialog("Open sysex file", this, GtkFileChooserAction.SAVE);
    chooser.setDoOverwriteConfirmation(1);
    chooser.setCreateFolders(1);
    auto r = chooser.run();
    bool okay = true;
    if (r == ResponseType.OK) {
      try {
        writeSysexFile(config.toSysex(), chooser.getFilename());
      } catch (FileException e) {
        okay = false;
      }
    }
    chooser.destroy();
    status.push(statusContext, (okay) ? "File saved" : "Error saving file");
  }

  void transferMidi(MenuItem m) {
    string dev = getSelectedDevice();
    if (dev is null) {
      status.push(statusContext, "Select a device for I/O first.  Use drop-down near top.");
      return;
    }
    status.push(statusContext, "Sending MIDI to " ~ dev);
    string command = "amidi -p \"" ~ dev ~ "\" -S ";
    foreach (message; config.toSysex()) {
      command ~= "B0 63 01 B0 62 04 B0 06 20 "; // NRPN, turns on sysex mode
      foreach (b; message) {
        command ~= format("%02X ", cast(uint)b); // sysex to string
      }
    }
    command ~= "B0 63 01 B0 62 04 B0 06 10"; // NRPN, turn off sysex mode
    try {
      shell(command);
      //status.pop(statusContext);
      status.push(statusContext, "MIDI data sent to " ~ dev);
    } catch (Exception e) {
      status.push(statusContext, "MIDI I/O failed: " ~ e.toString());
    }
  }

  ubyte[] parseSysex(string s) {
    ubyte[] r;
    while (s.length > 1) {
      s.munch(" \t\r\n");
      r ~= parse!ubyte(s, 16);
    }
    return r;
  }

  void receiveMidi(MenuItem m) {
    string dev = getSelectedDevice();
    if (dev is null) {
      status.push(statusContext, "Select a device for I/O first.  Use drop-down near top.");
      return;
    }
    try {
      // First call is for bank 0
      status.push(statusContext, "Beginning MIDI transfer");
      config.applySysex(parseSysex(shell("amidi -p " ~ dev ~ " -S B06301B06204B00620F0477F6D400000F7 -d -t 1")));
      status.push(statusContext, "Setup parameters received");
      config.applySysex(parseSysex(shell("amidi -p " ~ dev ~ " -S B06301B06204B00620F0477F6D420000F7 -d -t 1")));
      status.push(statusContext, "Performance/Controller parameters received");
      shell("amidi -p " ~ dev ~ " -S B06301B06204B00610");
      status.push(statusContext, "Received complete configuration via MIDI");
    } catch (Exception e) {
      status.push(statusContext, "MIDI I/O failed: " ~ e.toString());
    }
    reflectAll();
  }

  void reflectAll() {
    listening = false;
    sg.reflect(config);
    pg.reflect(config);
    cg.reflect(config);
    listening = true;
  }

  void showAbout(MenuItem m) {
    AboutDialog a = new AboutDialog();
    a.setProgramName("AKAI EWI USB Configuration Tool");
    a.setVersion("0.1a");
    a.setCopyright("Copyright 2012 by Greg Lyons, all rights reserved");
    a.setComments("This is a small utility for configuring the AKAI EWI USB.  Use at your own risk.");
    a.setLicenseType(GtkLicense.GPL_3_0);
    a.setAuthors(["Greg Lyons <greglyons50@gmail.com>"]);
    a.run();
    a.destroy();
  }

  string getSelectedDevice() {
    return devices.getActiveId();
  }
}

