# Project descriptor
NAME = MyProject
VERSION = 0
PATCHLEVEL = 1
SUBLEVEL = 0
EXTRAVERSION = -dev

# Setup compilation binaries
CC = g++
CFLAGS = -O2
LNFLAGS = 

# Setup the make utility
MAKEFLAGS += -rR --no-print-directory
unexport LC_ALL
LC_COLLATE = C
LC_NUMERIC = C
export LC_COLLATE LC_NUMERIC

# Project informations
SOURCES = main.cpp
EXECUTABLE = myproject

# Implicit rules
build/%.o: src/%.cpp
	mkdir -p build
	$(CC) $(CCFLAGS) -o $(<:src/%.cpp=build/%.o) $<

# Explicit rules
clean:
	rm -rf build

OBJECTS = $(SOURCES:%.cpp=build/%.o)
compile: $(OBJECTS)
	mkdir -p build/bin
	$(CC) -o build/bin/$(EXECUTABLE) $(OBJECTS) $(LNFLAGS)

build: clean compile

run: compile
	./$(EXECUTABLE)
