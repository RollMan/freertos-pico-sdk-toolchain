/*
 * @file ir_impl.h
 * @desc Implementation definitions that actually sends/receives IR signals.
 */
#ifndef IR_IR_IMPL_IR_IMPL_H
#define IR_IR_IMPL_IR_IMPL_H
#include <stdint.h>

/*
 * @brief Alternates between turning on and off an IR LED with a given @c pattern.
 * @param [in] pattern: a list of period how long LED keeps turn on/off. The very first element is ON period.
 * @param [in] length: the number of elements in @c pattern.
 */
void send_ir(uint32_t const * const pattern, size_t const length);

#endif
