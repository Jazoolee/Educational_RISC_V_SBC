# Educational RISC V SBC (SLRV)

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

## Introduction 

* RISC V 32IM Core with Builtin 1Kb data memory and Integrated 2KB SRAM for Instruction memory.
* Main purpose of this design is to improve the Digital system design/VLSI/Processor design education in Sri Lanka, which is spearheaded by the [Department of Electronic and Telecommunication Engineering](https://ent.uom.lk/) of the [University of Moratuwa, Sri Lanka](uom.lk) in Collaboration with [Skill Surf](https://www.skillsurf.lk/).
* Roughly around 100 lines of system verilog written by [MCR748](https://github.com/MCR748/100line-processor).
* SRAM is from the [OpenRAM](https://github.com/VLSIDA/OpenRAM) initiative.
* Submitted to the UNIC CASS 2024 tapeout program by the [IEEE CASS](https://ieee-cas.org/)
* Integrated with the Caravel user management template from [Efabless](https://efabless.com/) which is based on the SKY Water 130nm PDK.
* Entire design was done using only open source tools/PDK/Macro and the design files are freely available for anyone as a reference.

## Directory Structure

* /Verilog/RTL & /Verilog/gl contains the initial RTL design and the final powered gate level netlists.
* /GDS contains the final output gds files of the core SLRV (Srilankan Risc V), SRAM Macro, Both of them integrated into a wrapper (User project wrapper) and the final IC4 Caravel Integration.
* /OpenLane contains the config files used for OpenLane.
