#ifndef __ADDER_H
#define __ADDER_H


// The base address of the hardware peripheral
#define ADDER_A_REGISTER_ADDR 0x20...
#define ADDER_B_REGISTER_ADDR 0x20...
#define ADDER_S_REGISTER_ADDR 0x20...


/** @brief Sets the register A (INPUT)
 *
 *  @param a The new value.
 *  @return Void.
 */
void setA(unsigned int a);

/** @brief Sets the register B (INPUT)
 *
 *  @param b The new value.
 *  @return Void.
 */
void setB(unsigned int b);

/** @brief Sets the register B (INPUT)
 *
 *  @param Void.
 *  @return S The value of the sum register.
 */
unsigned int getS(void);

#endif