#include "plic_counter.h"

void Counter_Enable(void)
{
	*(volatile unsigned int *)COUNTER_ADDRESS_ENABLE = ... ;
}

void Counter_Disable(void)
{
	*(volatile unsigned int *)COUNTER_ADDRESS_ENABLE = ...;
}

void Counter_Load(unsigned int l)
{
	*(volatile unsigned int *)COUNTER_ADDRESS_COUNTERLOAD = ...;	
}

unsigned int Counter_getValue(void)
{
	return *(volatile unsigned int *)COUNTER_ADDRESS_COUNTERVALUE;
}

unsigned int Counter_Timeout(void)
{
	return *(volatile unsigned int *)COUNTER_ADDRESS_TIMEOUT;
}

void Counter_Delayus(unsigned int d)
{
	Counter_Disable();
	Counter_Load(d*500);
	Counter_Enable();
	while(!Counter_Timeout());
	Counter_Disable();
}

void Counter_EnableINT0(void)
{
	*(volatile unsigned int *)COUNTER_ADDRESS_COUNTERINTENABLE = ...;
}

void Counter_DisableINT0(void)
{
	*(volatile unsigned int *)COUNTER_ADDRESS_COUNTERINTENABLE = *(volatile unsigned int *)COUNTER_ADDRESS_COUNTERINTENABLE && (~COUNTER_ADDRESS_MASK_INT0);	
}

void Counter_DisableInterrupts(void)
{
	*(volatile unsigned int *)COUNTER_ADDRESS_COUNTERINTENABLE = ...;	
}

void Counter_EnableINT1(void)
{
	*(volatile unsigned int *)COUNTER_ADDRESS_COUNTERINTENABLE = COUNTER_ADDRESS_MASK_INT0;
}

void Counter_EnableINT2(void)
{
	*(volatile unsigned int *)COUNTER_ADDRESS_COUNTERINTENABLE = COUNTER_ADDRESS_MASK_INT0;
}

void Counter_EnableINT3(void)
{
	*(volatile unsigned int *)COUNTER_ADDRESS_COUNTERINTENABLE = COUNTER_ADDRESS_MASK_INT0;
}	