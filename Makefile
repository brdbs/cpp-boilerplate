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

# Implicit rules
BUILDDIR = build/$(NAME)-$(VERSION).$(PATCHLEVEL).$(SUBLEVEL)-$(EXTRAVERSION)
$(BUILDDIR)/%.o: src/%.cpp
	mkdir -p $(BUILDDIR)
	$(CC) $(CFLAGS) -o $(<:src/%.cpp=$(BUILDDIR)/%.o) $<

# Explicit rules
clean:
	rm -rf $(BUILDDIR)

OBJECTS = $(SOURCES:%.cpp=$(BUILDDIR)/%.o)
compile: $(OBJECTS)
	mkdir -p $(BUILDDIR)/bin
	$(CC) -o $(BUILDDIR)/bin/$(EXECUTABLE) $(OBJECTS) $(LNFLAGS)

build: clean compile

run: compile
	./$(BUILDDIR)/bin/$(EXECUTABLE)
