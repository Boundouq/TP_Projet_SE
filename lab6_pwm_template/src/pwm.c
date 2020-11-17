#include "pwm.h"

void PWM_setPeriod (unsigned int p)
{
	*(volatile unsigned int *)(PWM_ADDRESS_BASE+ ... ) = ...;
}	

void PWM_setDuty (unsigned int d)
{
	*(volatile unsigned int *)(PWM_ADDRESS_BASE+ ... ) = ...;
}

void PWM_Enable (void)
{
	*(volatile unsigned int *)(PWM_ADDRESS_BASE + ...) = ...;
}

void PWM_Disable (void)
{
	*(volatile unsigned int *)(PWM_ADDRESS_BASE + ...) = ...;
}

unsigned int PWM_getStatus(void)
{
	return *(volatile unsigned int *)(PWM_ADDRESS_BASE + ...);
}