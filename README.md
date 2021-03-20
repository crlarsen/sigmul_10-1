# First Optimization of 11-Bit Integer Multiply Circuit

## Description

Accelerate circuit performance by:
- Performing additions in parallel, when possible.
- Using Carry Look Ahead adder module rather than Ripple Carry Adder

Code is explained in the video series [Building an FPU in Verilog](https://www.youtube.com/watch?v=rYkVdJnVJFQ&list=PLlO9sSrh8HrwcDHAtwec1ycV-m50nfUVs).
See the video *Building an FPU in Verilog: Running the hp_mul Module on an FPGA*.

## Manifest

|   Filename   |                        Description                        |
|--------------|-----------------------------------------------------------|
| README.md | This file. |
| sigmul_mul.v | Significand multiply module specific to the IEEE 754 binary16 data format. |

## Copyright

:copyright: Chris Larsen, 2019-2021
