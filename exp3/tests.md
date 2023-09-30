> If I set the interrupt MIR6 to the locations 0x3D and 0x3F,
> conflicting with the positions of interrupt MIR7 at 0x3C and 0x3E,
> it will result in both interrupt subroutines being unable to execute correctly.


>If we change the 7th interrupt (available) in MIR7 to the 4th (serial port), the MIR7 interrupt subroutine can still operate correctly.
>However, if we change the 6th interrupt (available) in MIR6 to the 5th, the MIR6 subroutine cannot operate correctly.
