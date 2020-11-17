#ifndef __PWM_H
#define __PWM_H


// The base address of the hardware peripheral
#define PWM_ADDRESS_BASE 0x2000


/** @brief Configure the period of the PWM module.
 *
 *  @param p The total number period cycles.
 *  @return Void.
 */
void PWM_setPeriod (unsigned int p);

/** @brief Configures the duty cycle of the PWM module.
 *
 *  @param d The total number duty cycles.
 *  @return Void.
 */
void PWM_setDuty (unsigned int d);

/** @brief Sets the enable LSB bit to 1.
 *
 *  @param Void.
 *  @return Void.
 */
void PWM_Enable (void);

/** @brief Clears the enable LSB bit.
 *
 *  @param Void
 *  @return Void.
 */
void PWM_Disable (void);

/** @brief Reads the status register.
 *
 *  @param Void
 *  @return PWM Status Register.
 */
unsigned int PWM_getStatus(void);

#endif