#ifndef __PLIC_COUNTER_H
#define __PLIC_COUNTER_H

//#define MMIO_ADDRESS 0x60000000

#define PLIC_BASE_ADDRESS			0x0C000000
#define PLIC_MAX_PRIORITY			7
// connected zero (dut.tieOff) 
#define PLIC_SOURCE_PRIORITY1   	(PLIC_BASE_ADDRESS + ...)
// connected zero (dut.tieOff)
#define PLIC_SOURCE_PRIORITY2   	(PLIC_BASE_ADDRESS + ...) 
// timer INT0 
#define PLIC_SOURCE_PRIORITY3   	(PLIC_BASE_ADDRESS + ...)
#define PLIC_SOURCE_PRIORITY(id)   	(PLIC_BASE_ADDRESS + 4*id)


#define PLIC_INT_PENDING_BASEADDR 0x0C001000
#define PLIC_INT0_BIT_PENDING    (1 << 0)
#define PLIC_INT1_BIT_PENDING    (1 << 1)
#define PLIC_INT2_BIT_PENDING    (1 << 2)
#define PLIC_INT3_BIT_PENDING    (1 << 3)
#define PLIC_INT4_BIT_PENDING    (1 << 4)

#define PLIC_INTENABLE_BASEADDR 0x0C002000
#define PLIC_INT0_BIT_ENABLE    (1 << 0)
#define PLIC_INT1_BIT_ENABLE    (1 << 1)
#define PLIC_INT2_BIT_ENABLE    (1 << 2)
#define PLIC_INT3_BIT_ENABLE    (1 << 3)
#define PLIC_INT4_BIT_ENABLE    (1 << 4)

#define PLIC_HART0_PRIO_THRESH_ADDR		0x0C200000
#define PLIC_HART0_CLAIM_COMPLETE_ADDR	0x0C200004


/* 
 * Counter Registers Map
 */
#define COUNTER_ADDRESS_ENABLE   	 	 0x00002010
#define COUNTER_ADDRESS_COUNTERLOAD  	 0x00002014
#define COUNTER_ADDRESS_TIMEOUT    	     0x00002018
#define COUNTER_ADDRESS_COUNTERVALUE 	 0x0000201C
#define COUNTER_ADDRESS_COUNTERINTENABLE 0x00002020

/*
 * Defines
 */
#define COUNTER_ADDRESS_MASK_INT0  0x00000001
#define COUNTER_ADDRESS_MASK_INT1  0x00000002
#define COUNTER_ADDRESS_MASK_INT2  0x00000004
#define COUNTER_ADDRESS_MASK_INT3  0x00000008

/*
 * Prototypes functions
 */


void Counter_Enable(void);
void Counter_Disable(void);
void Counter_Load(unsigned int);
void Counter_Delayus(unsigned int);
unsigned int Counter_getValue(void);
unsigned int Counter_Timeout(void);
void Counter_EnableINT0(void);
void Counter_EnableINT1(void);
void Counter_EnableINT2(void);
void Counter_EnableINT3(void);
void Counter_DisableINT0(void);
void Counter_DisableInterrupts(void);

#endif