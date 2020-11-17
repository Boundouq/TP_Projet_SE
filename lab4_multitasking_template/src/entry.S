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

#define TICKS_PER_TASK        3000
#define MTIMECMP_BASE         0x02004000
#define MTIME_BASE            0x0200bff8


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


/* Save all the GPRs context */
.macro SAVE_CONTEXT
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

  .endm

/* Restore all the GPRs context */
.macro RESTORE_CONTEXT
  LREG x1, 1*REGBYTES(sp)
  # Do not load sp
  # LREG x2, 2*REGBYTES(sp)
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

  # initialize stacks
init_stack1:
  /* init stack1 section */
  la  a0, ...  /* note the stack grows from top to bottom */
  la  a1, ...   /* section end is actually the start of the next section */
  li  a2, ...
  jal fill_block

init_stack2:
  /* init stack2 section */
  la  a0, ...  /* note the stack grows from top to bottom */
  la  a1, ...   /* section end is actually the start of the next section */
  li  a2, ...
  jal fill_block

init_variables:
  la       t0, old_pc1
  la       t1, ...
  SREG     t1, (t0)

  la       t0, old_sp1
  la       t1, ...
  SREG     t1, (t0)

  la       t0, old_pc2
  la       t1, ...
  SREG     t1, (t0)

  la       t0, old_sp2
  la       t1, ...
  SREG     t1, (t0)

# # initialize stack pointer
  # la sp, _stack1

  # Goto _init
  # j       _init

  LREG      t0, current_task
  li        t1, 1
  li        t2, 2
  beq       t0, t2, do_task2
  #beq      t0, t1, do_task1

do_task1:
  /* set stack pointer */
  la    tp, _stack1
  la    sp, _stack1
  la    t0, task_1
  csrw  mepc, t0

  j launch_selected_task

do_task2:
  /* set stack pointer */
  la    tp, _stack2
  la    sp, _stack2
  la    t0, task_2
  csrw  mepc, t0

launch_selected_task:
  # Be/stay in M-mode after mret
  li t0, MSTATUS_MPP
  csrs mstatus, t0
  
  mret


  .align 2
trap_entry:
  # Save context in actual Stack i = {1, 2}
  #LREG  sp, (old_sp1)
  SAVE_CONTEXT

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
  li a1, ...
  csrc mie, a1
########################################


########################################
## TASK SCHEDULING PART
########################################
  # Read current_task variable to t0
  la      a0, ...
  LREG    t0, (...)

  # What task is being executed now ?
  li      t1, 1
  li      t2, 2
  beq     t0, t2, task2_to_task1

task1_to_task2:
  # Store 2 in current_task
  li        t2, ...
  SREG      ..., (a0)

  # Store SP to old_sp1
  ...      t0, ...    # t0 <= old_sp1 address
  SREG    sp, (t0)

  ...      t0, ...    # t0 <= old_pc1 address
  csrr    t1, mepc
  SREG    t1, (t0)

  # load old_pc2 to mepc
  ...     t0, ...   # t0 gets the value of old_pc2
  csrw    mepc, t0

  # load old_sp2 to sp
  ...     sp, old_sp2

  j setting_next_interrupt

task2_to_task1:
  # Store 1 in current_task
  li      t1, ...
  SREG    ..., (a0)

  # Store SP to old_sp2
  ...     t0, ...   # t0 <= old_sp2 address
  SREG    sp, (t0)

  ...     t0, ...   # t0 <= old_pc2 address
  csrr    t1, mepc
  SREG    t1, (t0)

  # load old_pc1 to mepc
  ...     t0, ...
  csrw    mepc, t0

  # load old_sp1 to sp
  ...       sp, old_sp1

setting_next_interrupt:
  # Get mtime value, add TICKS_PER_THREAD, store in mtimecmp
  ...      t3, TICKS_PER_TASK    # t3 = TICKS_PER_TASK
  ...      t0, MTIMECMP_BASE     # t0 = MTIMECMP_BASE
  ...      t1, MTIME_BASE        # t1 = MTIME_BASE
  LREG    t2, (t1)               # t2 = MTIME value
  ...     t2, t2, t3             # t2 = MTIME + TICKS_PER_TASK
  SREG    t2, (t0)               # MTIMECMP register value = MTIME + TICKS_PER_TASK
 
  # Reactivate MIP_MTIP
  li a1, MIP_MTIP
  csrs mie, a1

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

  # Restore context of the next task
  RESTORE_CONTEXT

  mret

/* Fills memory blocks */
fill_block:
  sw    a2, 0(a0)
  bgeu  a0, a1, fb_end
  addi  a0, a0, 4
  j   fill_block
fb_end:
  ret



  .section ".klocal", "...",@...
  .global current_task
  .global old_sp1
  .global old_sp2
  .global old_pc1
  .global old_pc2
  .align ...
current_task:     ... 1
old_sp1:          ... 0
old_sp2:          ... 0
old_pc1:          ... 0
old_pc2:          ... 0


# tohost and fromhost variables are used to communicate with the front-end server
# this serves to print text for example using the functions defines in syscalls
.section ".tohost","aw",@progbits
.align 6
.globl tohost
tohost: .dword 0
.align 6
.globl fromhost
fromhost: .dword 0
