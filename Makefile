SRCDIR = .
BUILDDIR = ./build
BINDIR = ./bin
TARGET = $(BINDIR)/main

###### extra variables #######


###### complier set-up ######
CC = gcc
CFLAGS = -Wextra
CXX = g++
CXXFLAGS = $(CFLAGS)
LD = g++
LDFLAGS = $(CXXFLAGS)
DEBUGGER = gdb


MKDIR = mkdir -p

ifdef RELEASE
	CFLAGS += -O3 -march=native
	LDFLAGS += -flto=full
else 
	CFLAGS += -O0
endif


ifdef DEBUG
	CFLAGS += -g
endif

OUTPUT_OPTION = -MMD -MP -o $(BUILDDIR)/$*.o  -MF $(BUILDDIR)/$*.d

CPPSRCS := $(wildcard $(SRCDIR)/**/*.cpp)
CPPSRCS += $(wildcard $(SRCDIR)/*.cpp)
DEPS = $(patsubst $(SRCDIR)/%.cpp,$(BUILDDIR)/%.d,$(CPPSRCS))
OBJS = $(patsubst $(SRCDIR)/%.cpp,$(BUILDDIR)/%.o,$(CPPSRCS))


all : $(TARGET)

build: $(TARGET)

run : $(TARGET)
	$(TARGET)


$(TARGET): $(OBJS)
	@if ! [ -d $(dir $@) ]; then  \
	  echo MKDIR $(dir $@) && mkdir -p $(dir $@); \
	fi;
	-@echo LD $@ && $(LD) $(OBJS) -o $@

$(BUILDDIR)/%.o: $(SRCDIR)/%.cpp
	@if ! [ -d $(dir $@) ]; then  \
	  echo MKDIR $(dir $@) && mkdir -p $(dir $@); \
	fi;
	-@echo CXX $@ && $(CXX) $(CXXFLAGS) -c $< $(OUTPUT_OPTION)

$(BUILDDIR)/%.o: $(SRCDIR)/%.c 
	@if ! [ -d $(dir $@) ]; then  \
	  echo MKDIR $(dir $@) && mkdir -p $(dir $@); \
	fi;
	-@echo CC $@ && $(CC) $(CFLAGS) -c $< $(OUTPUT_OPTION)

.PHONY: clean
clean: 
	-$(RM) $(OBJS) $(DEPS) $(TARGET)

.PHONY: debug
debug: $(TARGET)
	$(DEBUGGER) $(TARGET)
