#include "adder.h"



void setA(unsigned int a)
{
	*(volatile unsigned int *)(ADDER_A_REGISTER_ADDR) = ...;
}

void setB(unsigned int b)
{
	*(volatile unsigned int *)(ADDER_B_REGISTER_ADDR) = ...;
}

unsigned int getS(void)
{
	return *(volatile unsigned int *)(...);
}
