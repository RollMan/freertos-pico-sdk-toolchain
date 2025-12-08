/*
 * @file ir.h
 * @desc Interface for RTOS to send/receive IR signals.
 * @details Definitions of function wrappers to be registerd to the RTOS task list.
 */
#ifndef IR_IR_H
#define IR_IR_H

/*
 * @desc A RTOS task to send IR signals.
 * @details Receives signal patterns via queue or something and send it.
 */
void start_send_ir_routine();

/*
 * @desc A RTOS task to receive and record IR signals.
 * @details Receives signal patterns via queue or something and send it.
 */
void start_recv_ir_routine();
#endif IR_IR_H
