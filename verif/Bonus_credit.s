.text
main:
/*Clear R9 */
MOV  R9,#0

/*Check the register shifted modes */
MOV	 R0,#200 ; 
MOV  R2,#20
MOV  R3,#4
MOV  R4,#2
/* Don't check the register shifted modes for now */
/*STR  R2,[R0,R3, LSL #2] */
/*LDR  R1,[R0,R3, LSL #2] */
STR  R2,[R0,#4]
LDR  R1,[R0,#4]
CMP  R1,R2
ADDEQ R9,R9,#1 /*Increment the pass counter */


/*Check LDRH and STRH */
MOV R0,#208
MOV R2,#255
ADD R2,R2,R2
STRH R2,[R0,#0]
LDRH R6,[R0,#0] 
CMP R2,R6
ADDEQ R9,R9,#1 /*Increment the pass counter */

/*Check LDRH and STRH */
ADD R2,R2,#1
STRH R2,[R0,#2]
LDRH R6,[R0,#2] 
CMP R2,R6
ADDEQ R9,R9,#1 /*Increment the pass counter */


/*Pass counter is supposed to be 3 at the end of the program
Write the passcount to mem[252]
End of program. */
mov r0,#252
str r9,[r0,#0]

loop:
B loop
