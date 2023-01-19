
### CLOCK_GENERATOR SPEC
- Inputs:
    - `clk` 
    - `rst`
    - `baud` - required baud rate on the input bus of size 17 bits
- Output:
    - `tx_clk`

Assumptions: 
- The base clock frequency is considered to be 50MHz and baud rate is lower than this value.
- We consider the baud rates 4800, 9600, 14400, 19200, 38400 and 57600.

### Block Diagram
![BLOCK_DIAGRAM](CLOCK_GENERATOR_Block_Diagram.jpg)

[Link for project on EDA Playground](https://edaplayground.com/x/Qh_F)
