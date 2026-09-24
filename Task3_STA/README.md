# Task 3 - Static Timing Analysis

This task covers basic Static Timing Analysis of an 8-bit ALU using clock and I/O constraints with Vivado timing analysis.

## Initial Timing Results

- WNS: -1.542 ns
- TNS: -15.264 ns
- Failing endpoints: 10
- Hold timing: Clean

## After IOB Optimization

- WNS: -0.057 ns
- TNS: -0.406 ns
- Failing endpoints: 10
- Hold timing: Clean

## Critical Path

Initial data path delay:
- 4.620 ns

After IOB optimization:
- 3.112 ns

The remaining setup timing violation is documented as part of the STA analysis.
