# Name: Ingrid Varner
# Assignment: 7 – Integer Multiply Using Adds and Shifts

        .data

textAsk1:   .asciiz "Enter first number (0 to 32767): "
textAsk2:   .asciiz "Enter second number (0 to 32767): "
textErr:    .asciiz "Number out of range. Please try again.\n"
textRes:    .asciiz "The product is: "
textNL:     .asciiz "\n"

        .text
        .globl main

main:

read_first:
    li   $v0,4              # showing message for the first number
    la   $a0,textAsk1
    syscall

    li   $v0,5              # reading the user's number
    syscall
    move $s0,$v0            # saving it in s0 so I can use it later

    bltz $s0,bad_first      # negative values are not allowed

    li   $t0,32767          # highest value allowed
    slt  $t1,$t0,$s0        # checking if the number is too big
    bne  $t1,$zero,bad_first

    j    read_second        # if everything is ok, continue


bad_first:
    li   $v0,4              # printing the error message
    la   $a0,textErr
    syscall
    j    read_first         # I ask again until it's valid


read_second:
    li   $v0,4              # showing the message for the second number
    la   $a0,textAsk2
    syscall

    li   $v0,5              # reading the user's second number
    syscall
    move $s1,$v0            # storing this one in s1

    bltz $s1,bad_second     # again, can't be negative

    li   $t0,32767          # checking the max value again
    slt  $t1,$t0,$s1
    bne  $t1,$zero,bad_second

    j    do_mult            # both inputs are fine → do the multiplication


bad_second:
    li   $v0,4
    la   $a0,textErr        # showing the error again
    syscall
    j    read_second        # retry


do_mult:
    move $t0,$s0        # t0 = a (first number)
    move $t1,$s1        # t1 = b (second number)
    move $s2,$zero      # starting result at 0

    # my mental model:
    # while b > 0:
    #   if b is odd → add a to the result
    #   then double a and cut b in half

mult_loop:
    beq  $t1,$zero,done     # when b becomes 0, I'm finished

    andi $t2,$t1,1          # checking if the last bit of b is 1 (meaning odd)
    beq  $t2,$zero,skip     # if not odd, skip the add step

    addu $s2,$s2,$t0        # adding a to result when b is odd

skip:
    sll  $t0,$t0,1          # doubling a by shifting left
    srl  $t1,$t1,1          # dividing b by shifting right
    j    mult_loop          # and keep going until b hits zero


done:
    li   $v0,4              # printing the message before the result
    la   $a0,textRes
    syscall

    li   $v0,1              # finally printing the actual product
    move $a0,$s2
    syscall

    li   $v0,4              # just a newline to make it look nicer
    la   $a0,textNL
    syscall

    li   $v0,10             # exit program
    syscall
