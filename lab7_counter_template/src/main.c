/*======================================================================*/
/* TIMA LABORATORY                                                      */
/*======================================================================*/
#include "encoding.h"
#include "util.h"
#include "plic_counter.h"


void init_csrs()
{
    write_csr(mie, 0);
    write_csr(sie, 0);
    write_csr(mip, 0);
    write_csr(sip, 0);
    write_csr(mideleg, 0);
    write_csr(medeleg, 0);
}


void enable_plic_interrupts()
{
    
    // Setting the Priority of the interrupt with ID 3 to value 1, so that the interrupt can be fired
    // Recall that an interrupt is fired when its priority is > than the threshold
    *(volatile unsigned int *)PLIC_SOURCE_PRIORITY3 = 1;

    // Setting the priority threshold to Zero
    *(volatile unsigned int *)PLIC_HART0_PRIO_THRESH_ADDR = 0;

    // clear interrupt pending
    *(volatile unsigned int *)(PLIC_INT_PENDING_BASEADDR) = 0;

    // PLIC ENABLE interrupt of ID 3
    // (ID 1 and ID 2 are connected to zero)
    *(volatile unsigned int *)(PLIC_INTENABLE_BASEADDR) = PLIC_INT3_BIT_ENABLE;

    // Enable MEIP (Machine External Interrupt Pending) bit in MIE register
    set_csr(mie, MIP_MEIP);

    // Enable MIE (Machine Interrupt Enable) bit of MSTATUS
    set_csr(mstatus, MSTATUS_MIE );    
}


volatile int counter = 0;


int main(int argc, char** argv)
{
    // Traitement PWM ici
    ...

    return 0;
}
