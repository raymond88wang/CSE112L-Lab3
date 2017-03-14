.text
main:
MOV  R0,#170 /* 0XAA */
MOV  R1,#85  /*0X55 */
MOV  R2,#255
MOV  R9,#0
/*Fill	R3 with AAs */
LSL  R3,R0,#8
ORR  R3,R3,R0
LSL  R3,R3,#8
ORR  R3,R3,R0
LSL  R3,R3,#8
ORR  R3,R3,R0
/*Fill	r4 with FFs */
LSL  R4,R2,#8
ORR  R4,R4,R2
LSL  R4,R4,#8
ORR  R4,R4,R2
LSL  R4,R4,#8
ORR  R4,R4,R2
/*Fill	R5 with 55S */
LSL  R5,R1,#8
ORR  R5,R5,R1
LSL  R5,R5,#8
ORR  R5,R5,R1
LSL  R5,R5,#8
ORR  R5,R5,R1
/*AND  check */
AND  R6,R3,R5
TST  R6,R4 ;
ADDEQ	R9,R9,#1 /*Increment pass count */
/*ORR  Check */
ORR  R6,R3,R5
MOV  R0,#0
TEQ  R6,R0
ADDNE	R9,R9,#1 /*Incremnt the pass count */
/*ADD  check */
ADD  R6,R3,R5
ADD  R6,R6,R3  /* R6 =0xAAAAAAA9 */
SUB  R6,R6,#169 /*substract 0xA9 from R6 */
MOV  R0,#170
/*Mask	the lower bits of r6 */
ORR  R6,R6,R0  /* R6 =0XAAAAAAAA */
CMP  R6,R3
ADDEQ	R9,R9,#1 /*Increment pass count */
/*MVN  check */
MVN  R6,R3    /* R6 = ~R3 */
CMP  R6,R5
ADDEQ	R9,R9,#1 /*Increment pass count */
/*BIC  Check */
BIC  R6,R3,R5
CMP  R6,R3
ADDEQ	R9,R9,#1 /*Increment pass count */
/*EOR  Check */
EOR  R6,R3,R5
CMP  R6,R4
ADDEQ	R9,R9,#1 /*Increment pass count */
/*Shift	left	check */
LSL  r6,r3,#8
SUB  r6,r3,r6
CMP  r6,#170
ADDEQ	R9,R9,#1 /*Increment pass count */

/*Rotate	right	check */
ROR  r6,r3,#1
cmp  r6,r5
ADDEQ	R9,R9,#1 /*Increment pass count*/

/* Comment the rotate section of the code */
/*Extend	rotate */
/*RRX  R6,R3 */
/*ADDCS	R9,R9,#1 *//*;Increment pass count */


/*;Shift	right check */
LSR  R6,R3,#32
cmp  r6,#0
ADDEQ	R9,R9,#1 /*;Increment pass count*/


/*Pass counter is supposed to be 9 at the end of the program
Write the passcount to mem[252]
End of program.
*/
mov r0,#252
str r9,[r0,#0]

loop:
B loop
