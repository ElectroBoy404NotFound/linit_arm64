INIT_NAME = Linit

SRCDIR := src
INCDIR := inc
OBJDIR := bin
BUILDDIR = out

rwildcard=$(foreach d,$(wildcard $(1:=/*)),$(call rwildcard,$d,$2) $(filter $(subst *,%,$2),$d))

SRC = $(call rwildcard,$(SRCDIR),*.c)
OBJS = $(patsubst $(SRCDIR)/%.c, $(OBJDIR)/%.o, $(SRC))
DIRS = $(wildcard $(SRCDIR)/*)

CROSS_COMPILE ?= arm-linux-gnueabi-

CC := $(CROSS_COMPILE)gcc
LD := $(CROSS_COMPILE)gcc

CFLAGS = -I$(INCDIR) -static -c
LDFLAGS = -lc

all: build

build: clean $(OBJS) link

$(OBJDIR)/%.o: $(SRCDIR)/%.c
	@echo "[CC]\t$@"
	@$(CC) $(CFLAGS) $^ -o $@
link:
	@echo "[LD]\t$(BUILDDIR)/$(INIT_NAME)-init"
	@$(LD) $(LDFLAGS) $(OBJS) -o $(BUILDDIR)/$(INIT_NAME)-init
clean:
	@echo "Cleaning project $(INIT_NAME)..."
	@rm -rf bin/*
	@rm -rf out/*
	@echo "Clean complete!"
