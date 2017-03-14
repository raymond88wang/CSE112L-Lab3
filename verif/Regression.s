.text
main:
/* Programs adapted from http://www.cse.uaa.alaska.edu/~ssiewert/a225_doc/ARM_ASM_EXAMPLES-from-UT.pdf */
/*Init the pass register */
MOV R9,#0

/*Calculate the log of r0 register */
MOV r0,#8
BL log
MOV R6,#3  /*Compare the result and increment the counter */
CMP R1,R6
BLEQ pass


/* Calculate the sum of n natural numbers */
MOV r0,#15
BL sum
MOV r6,#120
CMP r0,r6
BLEQ pass

/*
;Pass counter is supposed to be 2 at the end of the program
;Write the passcount to mem[252]
;End of program.
*/
mov r0,#252
str r9,[r0,#0]

loop:
B loop

/*
;============================================================================================
; Calculates the log to the base 2 of a natural number and outputs the result in r1
; r0 = input variable n
; r0 = output variable m (0 by default)
; r1 = output variable k (n <= 2^k)
;=============================================================================================
*/
log:
MOV r2, #0 /*; set m = 0 */
MOV r1, #-1 /*; set k = -1 */
log_loop:
TST r0, #1 /*; test LSB(n) == 1 */
ADDNE r2, r2, #1 /*; set m = m+1 if true */
ADD r1, r1, #1 /*; set k = k+1 */
MOVS r0, r0, LSR #1 /*; set n = n>>1 */
BNE log_loop /*; continue if n != 0 */
CMP r2, #1 /*; test m ==1 */
MOVEQ r0, #1 /*; set m = 1 if true */
log_rtn:
MOV pc,lr

/*
;============================================================================================
; Calculates the sum to n natural numbers 
; r0 = input variable n
; r0 = output variable sum
;=============================================================================================
*/
sum:
MOV r1,#0 /*; set sum = 0 */
sum_loop:
ADD r1,r1,r0 /*; set sum = sum+n */
SUBS r0,r0,#1 /*; set n = n-1 */
BNE sum_loop
sum_rtn:
MOV r0,r1 /*; set return value */
MOV pc,lr

/*
;============================================================================================
;Pass subroutine increments the pass count in register R9
;============================================================================================
*/
pass:
MOV R0,#1
ADD R9,R9,R0
mov pc,lr

