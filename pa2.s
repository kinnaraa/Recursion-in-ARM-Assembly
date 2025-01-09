.section .data

input_prompt    :   .asciz  "Input a string: "
input_spec      :   .asciz  "%[^\n]"
palindrome_spec :   .asciz  "String is a palindrome (T/F): %c\n"
buffer          :   .space 128

.section .text

.global main

# program execution begins here
main:
    sub sp, sp, #112
    ldr x0, =input_prompt
    bl printf

    ldr x0, =input_spec
    ldr x1, =buffer
    bl scanf

    ldr x0, =buffer
    ldrb w2, [x0]
    cbz w2, ifEmpty

    mov x1, x0
    b findEndString

ifEmpty:
    ldr x0, =palindrome_spec
    mov w1, #'T'
    bl printf
    b exit

findEndString:
    ldrb w2, [x1]
    cbz w2, moveEnd
    add x1, x1, #1
    b findEndString

moveEnd:
    sub x1, x1, #1

checkIfPalindrome:
    cmp x0, x1
    bgt isPalindrome
    bl recursivePalindrome          
    cbz w0, printNotPalindrome

    ldr x0, =palindrome_spec
    mov w1, #'T'
    bl printf
    b exit

printNotPalindrome:
    ldr x0, =palindrome_spec
    mov w1, #'F'
    bl printf

# branch to this label on program completion
exit:
    mov x0, 0
    mov x8, 93
    svc 0
    ret

recursivePalindrome:
    stp x0, x1, [sp, #-16]!
    str x30, [sp, #-8]!

    cmp x0, x1
    bge isPalindrome

    ldrb w2, [x0]
    ldrb w3, [x1]

    cmp w2, w3
    bne notPalindrome

    add x0, x0, #1
    sub x1, x1, #1

    bl recursivePalindrome

    ldr x30, [sp], #8
    add sp, sp, #16
    ret

isPalindrome:
    mov w0, #1
    ldr x30, [sp], #8
    add sp, sp, #16
    ret

notPalindrome:
    mov w0, #0
    ldr x30, [sp], #8
    add sp, sp, #16
    ret
