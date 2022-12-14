/*
 * store_load_assembly_test.s
 *
 *  Created on: April 1st, 2022
 *      Author: kgraham
 */

 // Section .crt0 is always placed from address 0
	.section .crt0, "ax"



_start:
	.global _start

/***************************************************************
 * lui instruction test
 ***************************************************************/

// Set registers used for test validation

	addi x10, x0, -1		                // set x10 to -1
	addi x11, x0, 1			                // set x11 to 1
	addi x12, x0, 0xa5
	slli x12, x12, 8
	ori x12, x12, 0xa5
	slli x12, x12, 8         // x10 = -1 (0xffffffff)
	ori x12, x12, 0xa0       // x11 = 1 (0x00000001)
	slli x12, x12, 8		                // set x12 to 0xa5a5a000
	slli x13, x10, 12		                // set x13 to 0xfffff000

// lui (load upper immediate) test
	addi x5, x0, -1			                // set x5 to all 1s.  Required to verify that lui 0s out the lower 12-bits
	lui x5, 0xa5a5a
	bne x5, x12, FAIL		                // branch to fail if not properly load the upper 20 bits and 0s out the lower 12
	nop                      // x12 = 0xa5a5a000
	nop                      // x13 = 0xfffff000
	nop                      // x5 = 0xffffffff
	nop                      // not branch if x5 = x12 // validates upper 20-bit upper immediate loaded correctly 
	nop                                                // and lower 12-bits set to 0

/***************************************************************
 * auipc instruction tests
 ***************************************************************/

// auipc (add upper immediate to pc) test 1:  test upper 20-bit immediate added
	lui	x8, 0xa5a5a			                // Set upper 12-bit test value
	lui x9, PC_LOC			                // load PC of test address into x9
	srli x9, x9, 12			                // right-justify PC address to bit 0
PC_LOC:
	auipc x5, 0xa5a5a		                // auipc pc = PC_LOC label value
	sub x7, x5, x9			                // auipc - pc should be upper immediate value only
 	bne x7, x8, FAIL         // x8 = 0xa5a5a000   // validate upper 20-bit addition (lui)
 	nop                      // x9 = PC_LOC :: 0x000
 	nop                      // x9 = PC_LOC
 	nop                      // x5 = 0xa5a5a000 + PC_LOC (auipc)
 	nop                      // Branched to fail if x7 != 0xa5a5a000 // validates auipc added upper immediate
 // auipc (add upper immediate to pc) test 2:  test PC address added
	sub x7, x5, x8			                // subtract upper immediate from auipc
	bne x7, x9, FAIL		                // auipc - upper immediate does not equal pc 
	nop
	nop
	nop
	nop                      // Branched to fail if x7 != (0xa5a5a000 + PC_LOC) - 0xa5a5a000 = PC_LOC 
    nop                           // validated pc was added during auipc instruction
    nop
    nop
	halt
/**************************************************************************
 * End of lui_auipc_assembly test
 **************************************************************************/
	nop
	nop
	nop
	nop
	nop

FAIL:
	nop
	nop
	nop
	nop						// if this halt is reached, debug again to determine which test failed to debug
	halt
	nop
	nop
	nop
	nop
	nop
