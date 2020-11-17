#/*======================================================================*/
#   TIMA LABORATORY                                                      
#/*======================================================================*/
#/*======================================================================*/
#   Noureddine Ait Said
#   PhD Student - TIMA Laboratory
#   nouredddine.ait-said@univ-grenoble-alpes.fr
#/*======================================================================*/

include sources.mk

##################################################################
#  SPECIFIC PARAMETERS
##################################################################
PROJi=executable
N_PROC?=1
ISA?=rv64imafd
ABI?=lp64
SPIKE_RBB_PORT=9824
CEMUL_RBB_PORT=9823
#SPIKE_SIMULATION ?= -DSPIKE_SIMULATION
ENABLE_DEBUG?=1
MAX_CYCLES?=500000

##################################################################
#  COMMON PARAMETERS
##################################################################
TARGET=$(BUILD_DIR)/$(PROJi)

LINKER=link.ld
LOG_FILE=$(PROJi)_log.txt
EMU_PATH=../../rocket-chip/emulator
SPIKE_CFG_FILE=./spike.cfg
CEMUL_CFG_FILE=./cemul.cfg
GTKWAVE_VIEW=./gtkwave_view.gtkw

##################################################################
#  GETTING TOOLS
##################################################################
ifndef RISCV
$(error "[ ERROR ] - RISCV variable not set!")
endif

CC = $(RISCV)/bin/riscv64-unknown-elf-gcc
LD = $(RISCV)/bin/riscv64-unknown-elf-ld
DUMPER = $(RISCV)/bin/riscv64-unknown-elf-objdump
SIZE = $(RISCV)/bin/riscv64-unknown-elf-size
GDB = $(RISCV)/bin/riscv64-unknown-elf-gdb
SPIKE = $(RISCV)/bin/spike
OPENOCD = $(RISCV)/bin/openocd
GTKWAVE = gtkwave 

C_EMULATOR = $(EMU_PATH)/emu-LightDefaultConfig
RBB_C_EMULATOR = $(EMU_PATH)/emu-LightDefaultConfigRBB
DEBUG_C_EMULATOR = $(EMU_PATH)/emu-LightDefaultConfig-debug

##################################################################
#  SETTING FLAGS
##################################################################

ifeq ($(ENABLE_DEBUG),0)
CFLAGS=-O3  
else
CFLAGS=-g -Og -ggdb
endif

CFLAGS += -march=$(ISA) -mabi=$(ABI) -mcmodel=medany -ffreestanding -static -nostdlib -nostartfiles $(INCLUDES) 
LDFLAGS = -T $(LINKER)

OBJS = $(SOURCES:.c=.o)
DEPS = $(SOURCES:.c=.d)

%.i : %.c
	#------>>  Preprocessing
	$(CC) -E $(CFLAGS) $(SPIKE_SIMULATION) $< -o $@

%.S : %.c
	#------>>  Generating Assembly files
	$(CC) -S $(CFLAGS) $(SPIKE_SIMULATION) $< -o $@

%.o : %.S %.c
	#------>>  Generating object file
	$(CC) -c $(CFLAGS) $(SPIKE_SIMULATION) $< -o $@
	
%.dump : %.o
	$(DUMPER) -S -D $<

.PHONY: all
all: $(TARGET).out

.PHONY: compile-all
compile-all: $(OBJS)

.PHONY: build
build: all

$(TARGET).out: compile-all
	$(CC) $(OBJS) $(CFLAGS) $(LDFLAGS) $(SPIKE_SIMULATION) -o $@
	$(SIZE) $@

.PHONY: sim
sim:
	@echo "-------------  Starting Spike ISS Simulation  -------------"
	$(SPIKE) -p$(N_PROC) --isa=$(ISA) $(TARGET).out 
	
.PHONY: spike-interactive-debug
spike-interactive-debug:
	@echo "-------------------  Starting Interactive Debugging  -------------------"
	$(SPIKE) -d -p$(N_PROC) --isa=$(ISA) $(TARGET).out

.PHONY: spike-gdb-debug
spike-gdb-debug:
	@echo "-------------------  Starting GDB Debugging  -------------------"
	$(SPIKE) --rbb-port=$(SPIKE_RBB_PORT) -p$(N_PROC) --isa=$(ISA) $(TARGET).out

.PHONY: cemul-gdb-debug
cemul-gdb-debug:
	@echo "-------------------  Starting GDB Debugging  -------------------"
	$(RBB_C_EMULATOR) +jtag_rbb_enable=1 --rbb-port=$(CEMUL_RBB_PORT) $(TARGET).out

.PHONY: log
log:
	@echo "-------------------  Starting Logging Debug Information  -------------------"
	@echo ">> " $(LOG_FILE)
	@$(SPIKE) -p$(N_PROC) --isa=$(ISA) $(TARGET).out 2> $(LOG_FILE)

.PHONY: spike-ocd-launch
spike-ocd-launch:
	@echo "-------------------  Starting OpenOCD -------------------"
	$(OPENOCD) -f $(SPIKE_CFG_FILE)

.PHONY: cemul-ocd-launch
cemul-ocd-launch:
	@echo "-------------------  Starting OpenOCD -------------------"
	$(OPENOCD) -f $(CEMUL_CFG_FILE)

.PHONY: gdb-launch
gdb-launch:
	@echo "-------------------  Starting GNU Debugger -------------------"
	$(GDB) $(TARGET).out

.PHONY: sim-cache
sim-cache: $(TARGET).out
#  --hartids=<a,b,...>   Explicitly specify hartids, default is 0,1,...
#  --ic=<S>:<W>:<B>      Instantiate a cache model with S sets,
#  --dc=<S>:<W>:<B>        W ways, and B-byte blocks (with S and
#  --l2=<S>:<W>:<B>        B both powers of 2).
	@echo "-------------  Build done, starting simulation  -------------"
	$(SPIKE) -p$(N_PROC) --isa=$(ISA) --ic=S_ic:W_ic:B_ic --dc=S_dc:W_dc:B_dc --l2=S_l2:W_l2:B_l2 $(TARGET).out

.PHONY: emulate
emulate:
	@echo "-------------------  Starting C++ Emulator  -------------------"
	$(C_EMULATOR) $(TARGET).out

.PHONY: vm-sim
vm-sim:
	$(CC) $(SRC_DIR)main-vm.c -o main-vm.out
	$(SPIKE) pk main-vm.out -p$(N_PROC) --isa=$(ISA) 

.PHONY: vm-emulate
vm-emulate:
	$(CC) $(SRC_DIR)main-vm.c -o main-vm.out
	$(C_EMULATOR) pk main-vm.out

DATE:=$(shell date +"%FT%H%M%S")
.PHONY: dump
dump:
	@echo ">> Dumped to dump-$(DATE).dump"
	@$(DUMPER) -d $(TARGET).out > dump-$(DATE).dump && subl dump-$(DATE).dump

.PHONY: waveform
waveform:
	@echo "----------------------------------------------------------------------"
	@echo "WARNING: Waveforms (*.VCD, *.FST) take a lot of space, invoke clean all to delete everything"
	@echo "-------------------  Starting Waveform Generation  -------------------"
	$(DEBUG_C_EMULATOR) -v - +max-cycles=$(MAX_CYCLES) $(TARGET).out | vcd2fst - waveform-$(DATE).fst
	$(GTKWAVE) waveform-$(DATE).fst $(GTKWAVE_VIEW)

.PHONY: clean
clean:
#	rm -f $(SRC_DIR)*.i $(SRC_DIR)*.s $(SRC_DIR)*.asm $(SRC_DIR)*.o $(SRC_DIR)*.d $(SRC_DIR)*.out $(SRC_DIR)*.map $(TARGET).out
	rm -f $(SRC_DIR)/*.i $(SRC_DIR)/*.asm $(SRC_DIR)/*.o $(SRC_DIR)/*.d $(SRC_DIR)/*.out $(SRC_DIR)/*.map *.out

.PHONY: cleanall
cleanall:
#	rm -f $(SRC_DIR)*.i $(SRC_DIR)*.s $(SRC_DIR)*.asm $(SRC_DIR)*.o $(SRC_DIR)*.d $(SRC_DIR)*.out $(SRC_DIR)*.map $(TARGET).out
	rm -f $(SRC_DIR)/*.i $(SRC_DIR)/*.asm $(SRC_DIR)/*.o $(SRC_DIR)/*.d $(SRC_DIR)/*.out $(SRC_DIR)/*.map *.out dump-*.dump waveform-*.fst
	
