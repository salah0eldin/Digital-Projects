#include "process.h"

void process(Config *cfg, Signals *sig)
{
    // Input Stage
    sig->B_0 = (cfg->B_INPUT == 1) ? sig->B : (cfg->B_INPUT == 0) ? sig->BCIN
                                                             : 0;
    sig->OPMODE_O = sig->OPMODE;

    // Second Stage
    sig->D_1 = sig->D;
    sig->B_0_O = sig->B_0;
    sig->A_1 = sig->A;
    sig->C_1 = sig->C;

    // Pre-Adder/Subtracter
    sig->D_PAS_B = (sig->OPMODE_O & (1 << 6)) ? (sig->D_1 - sig->B_0_O) : (sig->D_1 + sig->B_0_O);

    // Fourth Stage
    sig->B_1 = (sig->OPMODE_O & (1 << 4)) ? sig->D_PAS_B : sig->B_0_O;

    // Fifth Stage
    sig->B_1_O = sig->B_1;
    sig->A_1_O = sig->A_1;
    sig->D_A_B = (sig->D_1 & 0xFFF) | (sig->A_1_O << 12) | (sig->B_1_O << 24);
    sig->BCOUT = sig->B_1_O;

    // Multiplier
    sig->B1_Mul_A1 = sig->B_1_O * sig->A_1_O;
    sig->CYI = ((cfg->CARRYINSEL == 1) ? (sig->OPMODE & (1 << 5)) : (cfg->CARRYINSEL == 0) ? sig->CARRYIN
                                                                                      : 0)
                   ? 1
                   : 0;

    // Seventh Stage
    sig->M = sig->B1_Mul_A1;

    // Eighth Stage
    sig->X = ((sig->OPMODE_O & 3) == 0) ? 0 : ((sig->OPMODE_O & 3) == 1) ? sig->M
                                          : ((sig->OPMODE_O & 3) == 2)   ? sig->P
                                                                         : sig->D_A_B;
    sig->Z = ((sig->OPMODE_O & 12) == 0) ? 0 : ((sig->OPMODE_O & 12) == 4) ? sig->PCIN
                                           : ((sig->OPMODE_O & 12) == 8)   ? sig->P
                                                                           : sig->C_1;

    // Post-Adder/Subtracter
    sig->output_P_cout = (sig->OPMODE_O & (1 << 7)) ? (sig->Z - (sig->X + sig->CYI)) : (sig->X + sig->Z + sig->CYI);

    // Output Stage
    sig->CARRYOUT = (sig->output_P_cout & ((long long)1 << 48)) ? 1 : 0;
    sig->P = sig->output_P_cout % ((long long)1 << 48);
}
