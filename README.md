# CS271
------------- Project 1 - Basic Logic and Arithmetic Program

Introduction

The purpose of this assignment is to acquaint you with elementary MASM programming and integer arithmetic operations (CLO 3, 4).

Introduction to MASM assembly language
Defining variables (integer and string)
Using library procedures for I/O
Integer arithmetic
What you must do

Program Description
Write and test a MASM program to perform the following tasks:

Display your name and program title on the output screen.
Display instructions for the user.
Prompt the user to enter three numbers (A, B, C) in strictly descending order.
Calculate and display the sum and differences: (A+B, A-B, A+C, A-C, B+C, B-C, A+B+C).
Display a closing message.
Program Requirements
The program must be fully documented and laid out according to the CS271 Style Guide . This includes a complete header block for identification, description, etc., and a comment outline to explain each section of code.
The main procedure must be divided into logical sections:
introduction
get the data
calculate the required values
display the results
say goodbye
The results of calculations must be stored in named variables before being displayed.

------------- Project 3 - Data Validation, Looping, and Constants

The purpose of this assignment is to reinforce concepts around looping, data validation, and control structures, to provide practice with signed arithmetic operations, and to bring the status register flags into focus (CLO 3, 4).

Implementing data validation
Implementing an accumulator
Integer arithmetic
Defining variables (integer and string)
Using constants (integer)
Using library procedures for I/O
Implementing control structures (decision, loop)
What you must do

Program Description
Write and test a MASM program to perform the following tasks in order specified:

Display the program title and programmer’s name.
Get the user's name, and greet the user.
Display instructions for the user.
Repeatedly prompt the user to enter a number.
Validate the user input to be in [-200, -100] or [-50, -1] (inclusive).
Notify the user of any invalid negative numbers (negative, but not in the ranges specified)
Count and accumulate the valid user numbers until a non-negative number is entered. Detect this using the SIGN flag. 
(The non-negative number and any numbers not in the specified ranges are discarded.)
Calculate the (rounded integer) average of the valid numbers and store in a variable.
Display:
the count of validated numbers entered
NOTE: if no valid numbers were entered, display a special message and skip to (f)
the sum of valid numbers
the maximum (closest to 0) valid user value entered
the minimum (farthest from 0) valid user value entered
the average, rounded to the nearest integer
-20.01 rounds to -20
-20.5 rounds to -20
-20.51 rounds to -21
-20.99 rounds to -21
a parting message (with the user’s name)
Program Requirements
The program must be fully documented and laid out according to the CS271 Style Guide . This includes a complete header block for identification, description, etc., section comments for logical sections of code (modules) and block comments for code blocks.
The main procedure must be modularized into commented logical sections (procedures are not required this time)
The four value limits must be defined as constants.
The user input loop should terminate depending on the value of the SIGN flag.
The Min, Max, Count, Sum, and Average must all be stored in named variables as they are calculated.


------------- Project 4 - Nested Loops and Procedures

Program Description
Write a program to calculate prime numbers. First, the user is instructed to enter the number of primes to be displayed, and is prompted to enter an integer in the range [1 ... 200]. The user enters a number, n, and the program verifies that 1 ≤ n ≤ 200. If n is out of range, the user is re-prompted until they enter a value in the specified range. The program then calculates and displays the all of the prime numbers up to and including the nth prime. The results must be displayed 10 prime numbers per line, in ascending order, with at least 3 spaces between the numbers. The final row may contain fewer than 10 values.

Program Requirements
The programmer’s name and program title must appear in the output.
The counting loop (1 to n) must be implemented using the LOOP instruction.
The main procedure must consist of only procedure calls (with any necessary framing). It should be a readable "list" of what the program will do.
Each procedure will implement a section of the program logic, i.e., each procedure will specify how the logic of its section is implemented. The program must be modularized into at least the following procedures and sub-procedures:
introduction
getUserData - Obtain user input
validate - Validate user input n is in specified bounds
showPrimes - display n prime numbers; utilize counting loop and the LOOP instruction to keep track of the number primes displayed; candidate primes are generated within counting loop and are passed to isPrime for evaluation
isPrime - receive candidate value, return boolean (0 or 1) indicating whether candidate value is prime (1) or not prime (0)
farewell
The upper and lower bounds of user input must be defined as constants.
The USES directive is not allowed on this project.
If the user enters a number outside the range [1 ... 200] an error message must be displayed and the user must be prompted to re-enter the number of primes to be shown.
The program must be fully documented and laid out according to the CS271 Style Guide . This includes a complete header block for identification, description, etc., a comment outline to explain each section of code, and proper procedure headers/documentation.
