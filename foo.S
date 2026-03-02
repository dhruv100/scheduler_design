.equ SYST_CSR,     0xE000E010    // Control and Status   (RW)
.equ SYST_RVR,     0xE000E014    // Reload Value         (RW) - UNKNOWN on reset
.equ SYST_CVR,     0xE000E018    // Current Value        (RW) - UNKNOWN on reset
.equ SYST_CALIB,  0xE000E01C    // Calibration          (RO)
.equ timeout, 0xFFFFFF
.section .vectors
vector_table:
    .word 0x20001000
    .word reset_handler
    .org 0x3c
    .word systick_handler
    .word 400

    .section .text
    .align 1
    .type reset_handler, %function
reset_handler:
    // loading values into RAM
    ldr r0, =_sidata // start of Load memory address
    ldr r1, =_sdata // start
    ldr r2, =_edata
copy_loop:
    CMP r1, r2
    bge done_copy
    ldr r4 ,[r0]
    str r4, [r1]
    add r0, r0, #4
    add r1, r1, #4
    b copy_loop

done_copy:
    // <--------Timer Driver Initialization --------->
    // loading values into registers
    ldr r0, =SYST_CSR
    ldr r1, =SYST_RVR
    ldr r2, =timeout
    ldr r3, =SYST_CVR

    //timer driver
    str r2 , [r1]
    mov r2, #0x0
    str r2, [r3]
    mov r2, #0x7
    str r2, [r0]
    mov r5, #0

    bl .
.thumb_func
systick_handler:
    PUSH {r4-r7}                @ save current task r4-r7
    MOV r0, r8
    MOV r1, r9
    MOV r2, r10
    MOV r3, r11
    PUSH {r0-r3}                @ save current task r8-r11

    //switch task based on r4
    CMP r4, #1
    BNE next1
    LDR r5, =stack_2
    MOV sp, r5
    B continue

next1:
    CMP r4, #2
    BNE next2
    MOV r4, #3
    LDR r5, =stack_3
    MOV sp, r5
    B continue

next2:
    LDR r5, =stack_1
    MOV sp, r5

continue:
    POP {r0-r3}                 //restore new task r8-r11
    MOV r8, r0
    MOV r9, r1
    MOV r10, r2
    MOV r11, r3
    POP {r4-r7}                 @ restore new task r4-r7

break_here:
    BX lr

// Tasks
    .section .text
    .p2align   4
    .global main1
    .type main1, %function
main1:
    nop
    add r0, r0, #1
    b main1

 .section .text
    .p2align   4
    .global main2
    .type main2, %function
main2:
    nop
    add r1, r1, #1
    b main2

.section .text
    .p2align   4
    .global main3
    .type main3, %function
main3:
    nop
    add r2, r2, #1
    b main3

.section .data
   .align 4
stack_1:
    .word 0x18
    .word 0x19
    .word 0x1a
    .word 0x1b
    .word 0x1
    .word 0x15
    .word 0x16
    .word 0x17
    .word 0x10
    .word 0x11
    .word 0x12
    .word 0x13
    .word 0x1c
    .word 0x309
    .word main1
    .word 0x1000000

   .zero 100
   .align 4
stack_2:
    .word 0x28
    .word 0x29
    .word 0x2a
    .word 0x2b
    .word 0x2
    .word 0x25
    .word 0x26
    .word 0x27
    .word 0x20
    .word 0x21
    .word 0x22
    .word 0x23
    .word 0x2c
    .word 0x2d
    .word main2
    .word 0x1000000

   .zero 100
   .align 4
stack_3:
    .word 0x38
    .word 0x39
    .word 0x3a
    .word 0x3b
    .word 0x3
    .word 0x35
    .word 0x36
    .word 0x37
    .word 0x30
    .word 0x31
    .word 0x32
    .word 0x33
    .word 0x3c
    .word 0x3d
    .word main3
    .word 0x1000000