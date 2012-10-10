module us.voxg.ewiusb.sysexfile;

import gtkc.giotypes, std.file, std.array, std.algorithm;
static import gio.File;

/*** Using GtkD's gio.File, convenient from the FileChooser. ***/
void writeSysexFile(ubyte[][] messages, gio.File.File file) {
  auto outstream = file.replace(null, 1, GFileCreateFlags.NONE, null);
  scope(exit) { outstream.close(null); }
  foreach (m; messages) {
    ulong bytesWritten;
    outstream.writeAll(cast(void *)&m, m.length, &bytesWritten, null);
  }
}

ubyte[][] readSysexFile(gio.File.File file) {
  auto inputStream = file.read(null);
  scope(exit) { inputStream.close(null); }
  ulong bytesRead;
  long size = file.queryInfo("*", GFileQueryInfoFlags.NONE, null).getSize();
  ubyte[] buffer = new ubyte[size];
  inputStream.readAll(cast(void *)buffer, cast(ulong)size, bytesRead, null);
  return sysexesFromBytes(buffer);
}

/*** Using std.file, convenient from non-GtkD code. ***/
/**  Note: tested this method, output looked exactly right in hex editor. **/
void writeSysexFile(ubyte[][] messages, string file) {
  write(file, join(messages));
}

ubyte[][] sysexesFromBytes(ubyte[] bytes) {
  ubyte[][] messages;
  bool midsysex = false;
  ubyte[] message;
  foreach (b; bytes) {
    if (midsysex) {
      if (b == 0xf7) { // End of sysex, push current message to output, start over
        message ~= b;
        messages ~= message;
        midsysex = false;
      } else if (b < 128) { // Good data byte
        message ~= b;
      } else { // Indicates interrupted sysex message, start over
        midsysex = false;
      }
    } else if (b == 0xf0) { // New sysex, initialize current message
      message.length = 0;
      message ~= b;
      midsysex = true;
    }
  }
  return messages;
}

ubyte[][] readSysexFile(string file) {
  return sysexesFromBytes(cast(ubyte[]) read(file, getSize(file)));
}
