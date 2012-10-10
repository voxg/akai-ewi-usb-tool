GTKD_LDFLAGS=/usr/local/lib/libgtkd.a -ldl
GTKD_CFLAGS=-I/usr/local/include/d
DC=gdc
CFLAGS=-c -O2 -frelease $(GTKD_CFLAGS)
LDFLAGS=$(GTKD_LDFLAGS)
SOURCES=main.d us/voxg/ewiusb/configuration.d us/voxg/ewiusb/sysexfile.d us/voxg/ewiusb/gui.d
OBJECTS=$(SOURCES:.d=.o)
EXECUTABLE=ewiusb-tool

all: $(SOURCES) $(EXECUTABLE)

$(EXECUTABLE): $(OBJECTS)
	$(DC) $(OBJECTS) -o $@ $(LDFLAGS)

%.o: %.d
	$(DC) $(CFLAGS) $< -o $@

clean:
	rm -rf $(OBJECTS) $(EXECUTABLE)
