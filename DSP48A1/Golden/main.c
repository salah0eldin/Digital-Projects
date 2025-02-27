#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <stdbool.h>

#include "module.h"

#define TEST_CASES 10

// Function to convert a number to a binary string
void to_binary_string(uint64_t num, int bits, char *str)
{
    for (int i = bits - 1; i >= 0; i--)
    {
        str[bits - 1 - i] = (num & (1ULL << i)) ? '1' : '0';
    }
    str[bits] = '\0';
}

int main()
{
    FILE *fp = fopen("golden_model.txt", "w");
    if (!fp)
    {
        printf("Error opening file!\n");
        return 1;
    }

    DSP48A1_State state, prev;
    memset(&state, 0, sizeof(DSP48A1_State));
    memset(&prev, 0, sizeof(DSP48A1_State));

    srand(time(NULL));

    char bin_str_A[19], bin_str_B[19], bin_str_C[49], bin_str_D[19];
    char bin_str_BCIN[19], bin_str_PCIN[49], bin_str_OPMODE[9], bin_str_CARRYIN[2];
    char bin_str_BCOUT[19], bin_str_M[49], bin_str_CARRYOUT[2], bin_str_P[49];

    for (int i = 0; i < TEST_CASES; i++)
    {
        state.A = rand() & MASK_18;                                         // 18-bit number
        state.B = rand() & MASK_18;                                         // 18-bit number
        state.D = rand() & MASK_18;                                         // 18-bit number
        state.C = (((int64_t)rand() << 16) | (int64_t)rand()) & MASK_48;    // 48-bit number
        state.BCIN = rand() & MASK_18;                                      // 18-bit number
        state.PCIN = (((int64_t)rand() << 16) | (int64_t)rand()) & MASK_48; // 48-bit number
        state.OPMODE = (rand() & 0xFF);                                     // 8-bit number
        state.CARRYIN = (bool)rand();

        // Simulate 4 clock cycles
        for (int j = 0; j < 4; j++)
        {
            // Copy current state to previous state
            DSP48A1_clock_cycle(&state, &prev);
            prev = state;
            // }

            // Convert numbers to binary strings
            to_binary_string(state.A, 18, bin_str_A);
            to_binary_string(state.B, 18, bin_str_B);
            to_binary_string(state.C, 48, bin_str_C);
            to_binary_string(state.D, 18, bin_str_D);
            to_binary_string(state.BCIN, 18, bin_str_BCIN);
            to_binary_string(state.PCIN, 48, bin_str_PCIN);
            to_binary_string(state.OPMODE, 8, bin_str_OPMODE);
            to_binary_string(state.CARRYIN, 1, bin_str_CARRYIN);
            to_binary_string(state.BCOUT, 18, bin_str_BCOUT);
            to_binary_string(state.M, 48, bin_str_M);
            to_binary_string(state.CARRYOUT, 1, bin_str_CARRYOUT);
            to_binary_string(state.P, 48, bin_str_P);

            // Write results to file
            fprintf(fp, "%s %s %s %s %s %s %s %s -> %s %s %s %s\n",
                    bin_str_A, bin_str_B, bin_str_C, bin_str_D, bin_str_BCIN, bin_str_OPMODE, bin_str_PCIN, bin_str_CARRYIN,
                    bin_str_BCOUT, bin_str_M, bin_str_CARRYOUT, bin_str_P);
        }
    }

    fclose(fp);
    printf("Test vectors generated in golden_model.txt\n");

    return 0;
}