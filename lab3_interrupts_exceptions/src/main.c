/*======================================================================*/
/* TIMA LABORATORY                                                      */
/*======================================================================*/
#include "encoding.h"
#include "util.h"

#define MTIMECMP_BASE           ...
#define MTIME_BASE              ...

#define MTIME           ((volatile long long *)(MTIME_BASE))
#define MTIMECMP        ((volatile long long *)(MTIMECMP_BASE))

void init_csrs()
{
    write_csr(mie, ...);
    write_csr(sie, ...);
    write_csr(mip, ...);
    write_csr(sip, ...);
    write_csr(mideleg, ...);
    write_csr(medeleg, ...);
}

void enable_timer_interrupts()
{
    *MTIMECMP = ... ; // Set MTIMECMP to very high value before activation
    set_csr(mie, ...); // Set the Machine Timer Interrupt Enable bit to 1
    set_csr(mstatus, ...); // Set the MSTATUS global Interrupt Enable bit to 1
    *MTIMECMP = ...;  // Set MTIMECMP to MTIME + 1000 (configuring the first interrupt)
}


volatile int counter = 0;

int main(int argc, char** argv)
{
    init_csrs();
    
    enable_timer_interrupts();

    while (counter < 100) {
        // Printing MTIME, MTIMECMP, and counter values.
        printf("mtime = %lld ..  mtimecmp = %lld -- Counter = %d\n", ... , ... , ...);
    }
    // final value of counter
    printf("counter %d\n", ... );

    return 0;
}