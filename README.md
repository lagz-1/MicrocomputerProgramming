# **microcomputer-programming**

 **The project involves the code for my Microcomputer Systems and Interface Laboratory experiments, primarily using assembly language. Each experiment is divided into a fundamental experiment and some advanced experiments.** 

***
- ### Experiment 1
  
Write a basic input-output program in assembly language to configure the 8255 chip. Set Port A as input and Port B as output. Achieve data transfer from the toggle switches to the data LEDs. The requirement is for the data LEDs to display data dynamically as the switches are toggled.

 - Advanced

(1) Enhance the basic experiment with the following functionality: If switches K7 to K0 are all in the high state, the program should exit.

(2) Write a program to achieve the following functionality: When K0 is in the high state, the upper 4 bits of the data LEDs are illuminated; when K0 is in the low state, the lower 4 bits of the data LEDs are illuminated.

(3) Develop a program to accomplish the following tasks: When K1K0=00, all data LEDs should be turned off; when K1K0=01, the lower 4 bits of the data LEDs should be illuminated; when K1K0=10, the upper 4 bits of the data LEDs should be illuminated; when K1K0=11, all data LEDs should be turned on.


- ### Experiment 3
Develop an interrupt-driven program for the following tasks: the main program utilizes the PB port of the 8255 to output 0xFF, illuminating data LEDs D0 to D7;
  
the IR6 interrupt service routine activates the green LED (deactivating the red LED), followed by a delay, and then returns to the main program;  

the IR7 interrupt service routine activates the red LED (deactivating the green LED), followed by a delay, and then returns to the main program.

Requirements: Respond to IR6 interrupt requests triggered by a single-pulse switch *KK1+* and IR7 interrupt requests triggered by a single-pulse switch *KK2+*

 - Advanced

Control LED movement direction using a single-pulse switch:

Initially, D7 is illuminated, while the other LEDs are off.

At any moment, 

pressing *KK1* immediately shifts the illuminated LED to the right in a cyclic fashion

pressing *KK2* immediately shifts the illuminated LED to the left in a cyclic fashion

