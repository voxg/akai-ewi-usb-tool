import gtk.Main, us.voxg.ewiusb.gui;

void main(string args[]) {
  Main.init(args);
  AkaiEwiUsbMain m = new AkaiEwiUsbMain();
  m.showAll();
  Main.run();
}
