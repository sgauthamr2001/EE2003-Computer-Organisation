# Assignment 4: Synthesis

This assignment is an extension of the original a4, with the addition of synthesis using yosys.

## Goals

- To be able to produce a synthesizable design of your single cycle CPU.

## Details on the assignment

Most of the things are the same as the original a4. You will notice that in the file "program_file_synth.txt", the last file that is included is a file present in the yosys installation location. In particular, it comes under the xilinx folder. This is because the synth.ys (a script for yosys) generates a verilog output after synthesis and this will require additional modules/primitives, which define the actual hardware on the board. Here we use the xilinx primitives, and hence we need to specify the appropriate location of the file that includes the definition of these primitives.
