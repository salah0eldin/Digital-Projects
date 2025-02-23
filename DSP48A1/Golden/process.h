#ifndef PROCESS_H
#define PROCESS_H

typedef struct {
    int B_INPUT, CARRYINSEL;
} Config;

typedef struct {
    long long B_0, D_1, B_0_O, A_1, C_1;
    long long D_PAS_B, B_1, B_1_O, A_1_O, D_A_B;
    long long B1_Mul_A1, CYI, X, Z;
    int OPMODE_O, CYO, CARRYOUT;
    long long P, BCOUT, M;
} Signals;

void process(Config *cfg, Signals *sig, long long A, long long B, long long C, long long D, long long BCIN, int OPMODE, long long PCIN, int CARRYIN);

#endif // PROCESS_H
