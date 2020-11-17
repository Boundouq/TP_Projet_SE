/*======================================================================*/
/* TIMA LABORATORY                                                      */
/*======================================================================*/
#include "encoding.h"
#include "util.h"

#define TICKS_PER_TASK  3000

#define MTIME_BASE      0x0200bff8
#define MTIME           ((volatile long long *)(MTIME_BASE))
#define MTIMECMP_BASE   0x02004000
#define MTIMECMP        ((volatile long long *)(MTIMECMP_BASE))

volatile long long global_counter1, global_counter2;
extern void exit(int);

void start_scheduler()
{
    ... = ... + TICKS_PER_TASK; // MTIMECMP value = MTIME value + TICKS_PER_TASK

    set_csr(... , ...); // Set MIP_MTIP bit of mie
    set_csr(..., ...); // Set MSTATUS_MIE bit of mstatus    
}

void stop_scheduler()
{
    ... = ...; // Deactivate timer by setting MTIMECMP to 0xFFFF.....FF

    clear_csr(..., ...);  // Clear MIP_MTIP bit of mie register
    clear_csr(..., ...);  // Clear MSTATUS_MIE bit of mstatus
}

void init_csrs()
{
    write_csr(mie, 0);
    write_csr(sie, 0);
    write_csr(mip, 0);
    write_csr(sip, 0);
    write_csr(mideleg, 0);
    write_csr(medeleg, 0);
}

void task_1()
{
  init_csrs();
  start_scheduler();

  while(1){
      global_counter1++;
      printf("TASK_1 [P %d] ..  mtime = 0x%llx ..  mtimecmp = 0x%llx   Counter1 = %d  -   Counter2 = %d \n", global_counter1, *MTIME, *MTIMECMP, global_counter1, global_counter2);
  }

  printf("TASK_1 - END"); // You can play with the while condition to reach here!
  stop_scheduler();

  exit(99); // A code so that we finished
}


void task_2()
{
    while(1){
      global_counter2++;
    }
}
