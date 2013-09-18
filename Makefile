# Project descriptor
NAME = MyProject
VERSION = 0
PATCHLEVEL = 1
SUBLEVEL = 0
EXTRAVERSION = dev

# Setup compilation binaries
CC = g++
CFLAGS = -O2 -c
LNFLAGS = -lm

# Project informations
SOURCES = main.cpp
EXECUTABLE = myproject

# Auto-generated-variables
VERSIONNEDNAME = $(NAME)-$(VERSION).$(PATCHLEVEL).$(SUBLEVEL)-$(EXTRAVERSION)
BUILDDIR = build/$(VERSIONNEDNAME)
OBJECTS = $(SOURCES:%.cpp=$(BUILDDIR)/%.o)

# Implicit rules
$(BUILDDIR)/%.o: src/%.cpp
	mkdir -p $(BUILDDIR)
	$(CC) $(CFLAGS) -o $(<:src/%.cpp=$(BUILDDIR)/%.o) $<

# Explicit rules
clean:
	rm -rf $(BUILDDIR)

$(BUILDDIR)/bin/$(EXECUTABLE): $(OBJECTS)
	mkdir -p $(BUILDDIR)/bin
	$(CC) -o $(BUILDDIR)/bin/$(EXECUTABLE) $(OBJECTS) $(LNFLAGS)

compile: $(BUILDDIR)/bin/$(EXECUTABLE)

build: clean compile

run: compile
	./$(BUILDDIR)/bin/$(EXECUTABLE)

compress: compile
	mkdir -p tarballs
	cd build; \
	rm -f $(VERSIONNEDNAME)/*.o; \
	tar -cvzf ../tarballs/$(VERSIONNEDNAME).tar.gz $(VERSIONNEDNAME);
