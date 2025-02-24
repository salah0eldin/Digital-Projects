#ifndef PROCESS_H
#define PROCESS_H

typedef struct {
    int B_INPUT, CARRYINSEL;
} Config;

typedef struct {
    long A : 18;
    long B : 18;
    long long C : 48;
    long D : 18;
    long BCIN : 18;
    char OPMODE;
    long long PCIN : 48;
    char CARRYIN : 1;
    long B_0 : 18; // 18-bit
    long D_1 : 18; // 18-bit
    long B_0_O : 18; // 18-bit
    long A_1 : 18; // 18-bit
    long long C_1 : 48; // 48-bit
    long D_PAS_B : 18; // 18-bit
    long B_1 : 18; // 18-bit
    long B_1_O : 18; // 18-bit
    long A_1_O : 18; // 18-bit
    long long D_A_B : 48; // 48-bit
    long long B1_Mul_A1 : 36; // 36-bit
    char CYI : 1; // 1-bit
    long long X : 48; // 48-bit
    long long Z : 48; // 48-bit
    long long output_P_cout : 48; // 48-bit
    char OPMODE_O; // 8-bit
    char CYO; // 1-bit
    char CARRYOUT; // 1-bit
    long long P : 48; // 48-bit
    long BCOUT : 18; // 18-bit
    long long M : 36; // 36-bit
} Signals;

void process(Config *cfg, Signals *sig);

#endif // PROCESS_H
