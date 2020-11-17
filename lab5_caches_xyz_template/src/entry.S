#/*======================================================================*/
#/* TIMA LABORATORY                                                      */
#/*======================================================================*/

#include "encoding.h"
#include "mtrap.h"

#if __riscv_xlen == 64
# define LREG ld
# define SREG sd
# define REGBYTES 8
#else
# define LREG lw
# define SREG sw
# define REGBYTES 4
#endif

  .section ".text.init"
  .globl _start

.macro INIT_GPRS_I

  li  x1, 0
  li  x2, 0
  li  x3, 0
  li  x4, 0
  li  x5, 0
  li  x6, 0
  li  x7, 0
  li  x8, 0
  li  x9, 0
  li  x10,0
  li  x11,0
  li  x12,0
  li  x13,0
  li  x14,0
  li  x15,0
  li  x16,0
  li  x17,0
  li  x18,0
  li  x19,0
  li  x20,0
  li  x21,0
  li  x22,0
  li  x23,0
  li  x24,0
  li  x25,0
  li  x26,0
  li  x27,0
  li  x28,0
  li  x29,0
  li  x30,0
  li  x31,0

.endm

_start:
  INIT_GPRS_I

  # initialize trap vector
  la t0, trap_entry
  csrw mtvec, t0

  # gp = Global Pointer
  # tp = Thread Pointer
  # sp = Stack Pointer

  # initialize global pointer
  la gp, _gp

# init_stack:
#   /* init stack section */
#   la  a0, _stack_end  /* note the stack grows from top to bottom */
#   la  a1, __stack-4   /* section end is actually the start of the next section */
#   li  a2, 0
#   jal fill_block

  # initialize thread pointer
  la  tp, _stack

  # initialize stack pointer
  la sp, _stack

  # Goto _init
  # j  _init

######################################################
##      X + Y or X + Z
######################################################


#define TAB_SIZE (4096)
#define caseXY  (0)
#define caseXZ  (!caseXY)
  
  # for (i = 0; i < N; i++) {S = S + X[i] + Y[i];}
  li t0, 0     // i=0
  ... t1, ...  // copy TAB_SIZE to t1
  li t2, 4     // 4 Bytes for each element
  li t3, 0     // Contains the address offset (0, 4, 8, 12 ...)
  li t6, 0     // S

  ... a0, ... // load tab_X address to a0
#if(caseXY)
  ... a1, ... // load tab_Y address to a1
#elif(caseXZ)
  ... a1, ... // load tab_Z address to a1
#endif

loop:
  ... t3, t0, t2 // t3 <- i * t2 = i * 4
  ... t4, t3, a0 // t4 <- tab_X + (i*4)
  ... t5, t3, a1 // t5 <- tab_Y + (i*4)
  ... t4, (t4)    // reading (tab_X + (i*4)) which is pointed to by t4 to t4
  ... t5, (t5)    // reading (tab_Y + (i*4)) which is pointed to by t5 to t4
  ... t6, t6, t4 // S += tab_X + (i*4)
  ... t6, t6, t5 // S += tab_Y + (i*4)

  addi t0, t0, 1
  blt t0, t1, loop

#######################################################

  li a0, (99 << 1 | 0x01)
  la a1, tohost
  sd a0, (a1)
1:
  wfi
  j 1b
  #j exit


  .align 2
trap_entry:
  addi sp, sp, -REGBYTES*32

  SREG x1, 1*REGBYTES(sp)
  SREG x2, 2*REGBYTES(sp)
  SREG x3, 3*REGBYTES(sp)
  SREG x4, 4*REGBYTES(sp)
  SREG x5, 5*REGBYTES(sp)
  SREG x6, 6*REGBYTES(sp)
  SREG x7, 7*REGBYTES(sp)
  SREG x8, 8*REGBYTES(sp)
  SREG x9, 9*REGBYTES(sp)
  SREG x10, 10*REGBYTES(sp)
  SREG x11, 11*REGBYTES(sp)
  SREG x12, 12*REGBYTES(sp)
  SREG x13, 13*REGBYTES(sp)
  SREG x14, 14*REGBYTES(sp)
  SREG x15, 15*REGBYTES(sp)
  SREG x16, 16*REGBYTES(sp)
  SREG x17, 17*REGBYTES(sp)
  SREG x18, 18*REGBYTES(sp)
  SREG x19, 19*REGBYTES(sp)
  SREG x20, 20*REGBYTES(sp)
  SREG x21, 21*REGBYTES(sp)
  SREG x22, 22*REGBYTES(sp)
  SREG x23, 23*REGBYTES(sp)
  SREG x24, 24*REGBYTES(sp)
  SREG x25, 25*REGBYTES(sp)
  SREG x26, 26*REGBYTES(sp)
  SREG x27, 27*REGBYTES(sp)
  SREG x28, 28*REGBYTES(sp)
  SREG x29, 29*REGBYTES(sp)
  SREG x30, 30*REGBYTES(sp)
  SREG x31, 31*REGBYTES(sp)

  csrr a0, mcause
  # // if it's an exception go to general_trap_handler
  bgez a0, general_trap_handler

  # // else discard the MSB and decode the rest
  sll a0, a0, 1

  # Is it a machine timer interrupt?
  li a1, IRQ_M_TIMER*2
  # // else if not a timer interrupt go to forward 1:
  bne a1, a0, general_trap_handler

machine_timer_interrupt_handler:
########################################
## Deactivating the timer interrupts while in the ISR
########################################
  # Clear Timer Interrupt Enable bit of MIE
  li a1, MIP_MTIP
  csrc mie, a1
########################################

#define MTIMECMP_BASE           0x02004000
#define MTIME_BASE              0x0200bff8

########################################
## Deactivating the timer FOREVER
########################################
  li a1, -1ULL
  # # we write mtimecmp address to t0
  li t0, MTIMECMP_BASE
  # # then write -1LL to mtimecmp
  SREG a1, (t0)
########################################

  j return_from_trap_handler

general_trap_handler:
  csrr a0, mcause
  csrr a1, mepc
  mv a2, sp
  jal handle_trap
  csrw mepc, a0

return_from_trap_handler:
  # Remain in M-mode after mret
  li t0, MSTATUS_MPP
  csrs mstatus, t0

  LREG x1, 1*REGBYTES(sp)
  LREG x2, 2*REGBYTES(sp)
  LREG x3, 3*REGBYTES(sp)
  LREG x4, 4*REGBYTES(sp)
  LREG x5, 5*REGBYTES(sp)
  LREG x6, 6*REGBYTES(sp)
  LREG x7, 7*REGBYTES(sp)
  LREG x8, 8*REGBYTES(sp)
  LREG x9, 9*REGBYTES(sp)
  LREG x10, 10*REGBYTES(sp)
  LREG x11, 11*REGBYTES(sp)
  LREG x12, 12*REGBYTES(sp)
  LREG x13, 13*REGBYTES(sp)
  LREG x14, 14*REGBYTES(sp)
  LREG x15, 15*REGBYTES(sp)
  LREG x16, 16*REGBYTES(sp)
  LREG x17, 17*REGBYTES(sp)
  LREG x18, 18*REGBYTES(sp)
  LREG x19, 19*REGBYTES(sp)
  LREG x20, 20*REGBYTES(sp)
  LREG x21, 21*REGBYTES(sp)
  LREG x22, 22*REGBYTES(sp)
  LREG x23, 23*REGBYTES(sp)
  LREG x24, 24*REGBYTES(sp)
  LREG x25, 25*REGBYTES(sp)
  LREG x26, 26*REGBYTES(sp)
  LREG x27, 27*REGBYTES(sp)
  LREG x28, 28*REGBYTES(sp)
  LREG x29, 29*REGBYTES(sp)
  LREG x30, 30*REGBYTES(sp)
  LREG x31, 31*REGBYTES(sp)

  addi sp, sp, REGBYTES*32
  mret

/* Fills memory blocks */
fill_block:
  sw    a2, 0(a0)
  bgeu  a0, a1, fb_end
  addi  a0, a0, 4
  j   fill_block
fb_end:
  ret


  .section ".cache_test","..",@... 
  .align 2
  .globl tab_X
  tab_X: ... ... , 0x000000AA
#if(caseXY)
  .globl tab_Y
  tab_Y: ... ... , 0x000000BB
#elif(caseXZ)
  .globl tab_Z
  empty_block:  ... ... , 0x000000AA
  tab_Z:        ... ... , 0xAA
#endif


# tohost and fromhost variables are used to communicate with the front-end server
# this serves to print text for example using the functions defines in syscalls
.section ".tohost","aw",@progbits
.align 6
.globl tohost
tohost: .dword 0
.align 6
.globl fromhost
fromhost: .dword 0
