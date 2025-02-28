#include "module.h"
#include <stdio.h>

// Simulate a clock cycle for the DSP48A1
void DSP48A1_clock_cycle(DSP48A1_State *state, DSP48A1_State *prev)
{
// Select B input based on B_INPUT parameter
#if B_INPUT == 1
    state->B_0_wire = state->B;
#elif B_INPUT == 0
    state->B_0 = state->BCIN;
#else
    state->B_0 = 0;
#endif

    state->D_reg = prev->D;
    state->C_reg = prev->C;
    state->OPMODE_reg = prev->OPMODE;

    state->B_reg = (prev->OPMODE_reg & (1 << 4)) ? ((prev->OPMODE_reg & (1 << 6)) ? prev->D_reg - prev->B_0_wire : prev->D_reg + prev->B_0_wire) : prev->B_0_wire;

    state->A_reg = prev->A;

    state->BCOUT = state->B_reg;

    // state->M = (uint64_t)prev->B_1 * (uint64_t)prev->A_1;
    // Ensure B_1 and A_1 are correctly sign-extended
    uint64_t b_val = prev->B_reg; // Assuming B_1 is already sign-extended
    uint64_t a_val = prev->A_reg; // Assuming A_1 is already sign-extended

    // Perform a signed multiplication
    uint64_t product = b_val * a_val;

    // Mask the result to fit into a 36-bit signed field
    state->M = product & MASK_36;

    // Select carry-in based on CARRYINSEL parameter
#if CARRYINSEL == 1
    state->CARRYIN_1 = prev->CARRYIN;
#elif CARRYINSEL == 0
    prev->CARRYIN_reg = (prev->OPMODE_reg & (1 << 5)) ? 1 : 0;
#else
    state->CARRYIN_1 = 0;
#endif

    // X input selection based on OPMODE[1:0]
    switch (prev->OPMODE_reg & 0x03)
    {
    case 0:
        prev->X = 0;
        break;
    case 1:
        prev->X = (uint64_t)prev->M;
        break;
    case 2:
        prev->X = prev->P;
        break;
    case 3:
        prev->X = (((uint64_t)prev->D_reg << 36) & 0x0FFF000000000) | (((uint64_t)prev->A_reg << 18) & 0x00FFFFC0000) | ((uint64_t)prev->B_reg & 0x03FFFF);
        break;
    }

    // Z input selection based on OPMODE[3:2]
    switch ((prev->OPMODE_reg >> 2) & 0x03)
    {
    case 0:
        prev->Z = 0;
        break;
    case 1:
        prev->Z = prev->PCIN;
        break;
    case 2:
        prev->Z = prev->P;
        break;
    case 3:
        prev->Z = prev->C_reg;
        break;
    }

    // Post-adder/subtracter operation
    if ((prev->OPMODE_reg & 0x03) == 0)
    {
        prev->P_b_wire = prev->Z;
        prev->CARRYOUT_b_wire = 0;
    }
    else if (((prev->OPMODE_reg >> 2) & 0x03) == 0)
    {
        prev->P_b_wire = prev->X;
        prev->CARRYOUT_b_wire = 0;
    }
    else
    {
        prev->post_adder = (prev->OPMODE_reg & (1 << 7)) ? (uint64_t)prev->Z - (uint64_t)prev->X - prev->CARRYIN_reg : (uint64_t)prev->X + (uint64_t)prev->Z + prev->CARRYIN_reg;

        // Update P register
        prev->P_b_wire = prev->post_adder & MASK_48;
        prev->CARRYOUT_b_wire = (prev->post_adder >> 48) & 1; // Extract carry out
    }

    state->P = prev->P_b_wire;
    state->CARRYOUT = prev->CARRYOUT_b_wire;
}