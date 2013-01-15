#DC=gdc
#GTKD_LDFLAGS=/usr/local/lib/libgtkd.a -ldl
#GTKD_CFLAGS=-I/usr/local/include/d
#CFLAGS=-c -O2 -frelease $(GTKD_CFLAGS)
DC=dmd
GTKD_LDFLAGS=$(shell pkg-config --libs gtkd-2)
GTKD_CFLAGS=$(shell pkg-config --cflags gtkd-2)
CFLAGS=-c $(GTKD_CFLAGS)
LDFLAGS=$(GTKD_LDFLAGS)
SOURCES=main.d us/voxg/ewiusb/configuration.d us/voxg/ewiusb/sysexfile.d \
	us/voxg/ewiusb/gui.d us/voxg/ewiusb/icon.d us/voxg/ewiusb/midi.d
OBJECTS=$(SOURCES:.d=.o)
EXECUTABLE=ewi-usb-tool

all: $(SOURCES) $(EXECUTABLE)

$(EXECUTABLE): $(OBJECTS)
	$(DC) $(OBJECTS) -of$@ $(LDFLAGS)

%.o: %.d
	$(DC) $(CFLAGS) $< -of$@

clean:
	rm -rf $(OBJECTS) $(EXECUTABLE)
