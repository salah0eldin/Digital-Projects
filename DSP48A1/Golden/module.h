#ifndef MODULE_H
#define MODULE_H

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#define B_INPUT 1    // 0 for CASCADE, 1 for DIRECT
#define CARRYINSEL 0 // 0 for OPMODE5, 1 for CARRYIN

// Define constants for bit masks
#define MASK_8 0x0FF
#define MASK_18 0x03FFFF
#define MASK_36 0x00000FFFFFFFFF
#define MASK_48 0x00FFFFFFFFFFFF
#define MASK_49 0x01FFFFFFFFFFFF

#define WIDTH_1 8
#define WIDTH_2 18
#define WIDTH_3 36
#define WIDTH_4 48
#define WIDTH_5 49

// Define a structure to hold the state and inputs of the DSP48A1
typedef struct
{
    // Inputs
    int32_t A : WIDTH_2;
    int32_t B : WIDTH_2;
    int64_t C : WIDTH_4;
    int32_t D : WIDTH_2;
    int32_t BCIN : WIDTH_2;
    int64_t PCIN : WIDTH_4;
    bool CARRYIN;
    int8_t OPMODE;

    // Outputs
    int32_t BCOUT : WIDTH_2;
    int64_t M : WIDTH_3;
    bool CARRYOUT;
    int64_t P : WIDTH_4;

    // Internal signals
    int32_t B_0_wire : WIDTH_2;

    int32_t D_reg : WIDTH_2;
    int32_t B_reg : WIDTH_2;
    int64_t C_reg : WIDTH_4;
    int32_t A_reg : WIDTH_2;
    int8_t OPMODE_reg;
    bool CARRYIN_reg;

    int64_t X : WIDTH_4;
    int64_t Z : WIDTH_4;

    int64_t post_adder : WIDTH_5;

    int64_t P_b_wire : WIDTH_4;
    bool CARRYOUT_b_wire;
} DSP48A1_State;

// Function prototypes
void DSP48A1_clock_cycle(DSP48A1_State *state, DSP48A1_State *prev);

#endif // MODULE_H