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
GTESTVERSION = 1.6.0

# Project informations
SOURCES = main.cpp
EXECUTABLE = myproject
TESTS = main.cpp

# Auto-generated-variables
VERSIONNEDNAME = $(NAME)-$(VERSION).$(PATCHLEVEL).$(SUBLEVEL)-$(EXTRAVERSION)
BUILDDIR = build/$(VERSIONNEDNAME)
OBJECTS = $(SOURCES:%.cpp=$(BUILDDIR)/%.o)
TESTOBJECTS = $(TESTS:%.cpp=$(BUILDDIR)/tests/%.o)

# Implicit rules
$(BUILDDIR)/%.o: src/%.cpp
	mkdir -p $(BUILDDIR)
	$(CC) $(CFLAGS) -o $(<:src/%.cpp=$(BUILDDIR)/%.o) $<

$(BUILDDIR)/tests/%.o: tests/%.cpp
	mkdir -p $(BUILDDIR)/tests
	$(CC) $(CFLAGS) -o $(<:tests/%.cpp=$(BUILDDIR)/tests/%.o) $<

# Explicit rules
clean:
	rm -rf $(BUILDDIR)
	rm -rf gtest
	rm -f build/libgtest.a
	rm -f build/gtest.o

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

build/libgtest.a:
	wget -O gtest.zip https://googletest.googlecode.com/files/gtest-$(GTESTVERSION).zip
	unzip gtest.zip
	mv gtest-$(GTESTVERSION) gtest
	rm -f gtest.zip
	g++ -I gtest/include -I gtest -c gtest/src/gtest.cc -o build/gtest.o
	ar -rv build/libgtest.a build/gtest.o

test: compile build/libgtest.a $(TESTOBJECTS)
	g++ -I gtest/include $(TESTOBJECTS) build/libgtest.a -o $(BUILDDIR)/bin/$(EXECUTABLE)-test
	$(BUILDDIR)/bin/$(EXECUTABLE)-test
