.text
main:
/*Clear R9 */
MOV  R9,#0
MOV	 R0,#200 ; 
MOV  R2,#20
MOV  R3,#4
STR  R2,[r0,#4]
LDR  R1,[r0,#4]
CMP  R1,R2
ADDEQ R9,R9,#1 /*Increment the pass counter */

MOV R0,#208
MOV R2,#90
STRB R2,[R0,#0]
LDRB R6,[R0,#0] 
CMP R2,R6
ADDEQ R9,R9,#1 /*Increment the pass counter */

ADD R2,R2,#1
STRB R2,[R0,#1]
LDRB R6,[R0,#1] 
CMP R2,R6
ADDEQ R9,R9,#1 /*Increment the pass counter */

ADD R2,R2,#1
STRB R2,[R0,#2]
LDRB R6,[R0,#2] 
CMP R2,R6
ADDEQ R9,R9,#1 /*Increment the pass counter */

ADD R2,R2,#1
STRB R2,[R0,#3]
LDRB R6,[R0,#3] 
CMP R2,R6
ADDEQ R9,R9,#1 /*Increment the pass counter */

/*Pass counter is supposed to be 5 at the end of the program
Write the passcount to mem[252]
End of program.*/ 
mov r0,#252
str r9,[r0,#0]

loop:
B loop
