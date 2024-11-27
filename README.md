# ICS3203-CAT2-Assembly-<MUTUA-VINCENT-MUMO>-<151361>

This repository contains the solutions for the CAT 2 practical tasks for ICS3203, focusing on Assembly programming. Each task demonstrates a different aspect of programming, including control flow, array manipulation, modular programming, and data monitoring with simulation. Below are the detailed explanations and instructions for each task.

## Table of Contents
1. [Control Flow and Conditional Logic](#task-1)
2. [Array Manipulation with Looping and Reversal](#task-2)
3. [Modular Program with Subroutines for Factorial Calculation](#task-3)
4. [Data Monitoring and Control Using Port-Based Simulation](#task-4)
5. [Instructions for Compiling and Running](#instructions)

---

### Task 1: Control Flow and Conditional Logic

#### Purpose:
This program takes a user input number and classifies it as **POSITIVE**, **NEGATIVE**, or **ZERO** using conditional and unconditional jumps.

#### Code Explanation:
- The program prompts the user to input a number.
- The number is then checked using comparison and branching instructions.
- Depending on the result, the program jumps to specific labels that classify the number.

#### Insights:
- **Conditional Jump** (`jg`, `jl`, `je`): Used for checking conditions (greater than, less than, and equal).
- **Unconditional Jump** (`jmp`): Used to skip over unnecessary parts of the code once a condition is satisfied.

 **Challenges**:
 - The sign of the number (negative) is not correctly handled in the atoi subroutine.
 - Fix this by adding logic to detect and handle a negative sign (-) in the input string.



---

### Task 2: Array Manipulation with Looping and Reversal

#### Purpose:
This program takes an array of 5 integers, reverses the array in place, and prints the reversed array.

#### Code Explanation:
- The program accepts an array of integers as input.
- A loop is used to reverse the array by swapping elements in place.
- No extra memory is used; the array is reversed within the same space.
- Read the integers into an array stored in the .bss section.

  
 **Challenges**:
- Managing array elements using pointers requires careful handling to avoid out-of-bounds errors.
- Correctly updating pointers during the reversal process is crucial to avoid overwriting data.
-  Limited high-level constructs make it necessary to manually manage loops, conditions, and data movements.

---

### Task 3: Modular Program with Subroutines for Factorial Calculation

#### Purpose:
This program computes the factorial of a number using a modular subroutine, demonstrating stack usage for preserving registers.

#### Code Explanation:
- The program prompts for a number, calculates its factorial using a recursive subroutine, and outputs the result.
- The subroutine preserves registers by pushing them onto the stack and pops them after the calculation is complete.


### Insights:
**Register Management**:

- General-purpose registers: The program primarily uses registers such as RAX, RBX, RDI, and RSI to store intermediate values and results.

- Base pointer (RBP): Used to manage the stack frame within the subroutine, making it easier to reference parameters and local variables.


**Subroutine for Factorial Calculation**:

- The factorial calculation is encapsulated in a separate subroutine, improving code modularity and reusability.

- The subroutine is called from the main program, passing the input number via the stack.

- Within the subroutine, recursive calls are made to compute the factorial, demonstrating an understanding of function-like code blocks in assembly.

---

### Task 4: Data Monitoring and Control Using Port-Based Simulation

#### Purpose:
This program simulates reading a sensor value, controlling a motor, and triggering an alarm based on the sensor input.

#### Code Explanation:
- The program reads a simulated "sensor value" from a memory location (or port) and takes actions accordingly.
- If the water level is high, an alarm is triggered. If it's moderate, the motor is turned off.

#### Insights:
- **Port/Memory Location Manipulation**: The program manipulates specific memory locations or ports to simulate hardware control.
- **Conditional Logic**: The program makes decisions based on the sensor value to control the motor or alarm.

---

### Compilation and Execution

1. **Cloning the Repository:**
   ```bash
   git clone https://github.com/<YourUsername>/ICS3203-CAT2-Assembly-<MUTUA-VINCENT-MUMO>-<151361>.git
   cd ICS3203-CAT2-Assembly-<MUTUA-VINCENT-MUMO>-<151361>

 2. **Prerequisites:**
- An assembler such as NASM or MASM.
- A 64-bit assembly environment.

  3. **Compilation:**
     ```bash
     nasm -f elf64 branching.asm -o branching.o
     ld  branching.o -o branching
     ./ branching
