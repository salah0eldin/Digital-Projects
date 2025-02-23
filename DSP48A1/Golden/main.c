#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#include "process.h"

#define TEST_CASES 10

int main()
{
    FILE *fp = fopen("../golden_model.txt", "w");
    if (!fp)
    {
        printf("Error opening file!\n");
        return 1;
    }

    Config cfg = {1, 1}; // Example config
    Signals sig;

    srand(time(NULL));

    for (int i = 0; i < TEST_CASES; i++)
    {
        long long A = rand() % (1 << 18);
        long long B = rand() % (1 << 18);
        long long D = rand() % (1 << 18);
        long long C = ((long long)rand() << 16) | rand(); // Generate a 48-bit number
        int OPMODE = rand() % (1 << 8);
        long long BCIN = rand() % (1 << 18);
        long long PCIN = ((long long)rand() << 16) | rand();
        int CARRYIN = rand() % 2;

        process(&cfg, &sig, A, B, C, D, BCIN, OPMODE, PCIN, CARRYIN);

        fprintf(fp, "%lld %lld %lld %lld %lld %d %lld %d -> %lld %lld %d %lld\n",
                A, B, C, D, BCIN, OPMODE, PCIN, CARRYIN, sig.BCOUT, sig.M, sig.CARRYOUT, sig.P);
    }

    fclose(fp);
    printf("Test vectors generated in ../golden_model.txt\n");

    return 0;
}
