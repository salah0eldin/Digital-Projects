#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#include "process.h"

#define TEST_CASES 10

int main()
{
    FILE *fp = fopen("golden_model.txt", "w");
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
        sig.A = rand() % ((long)1 << 18);
        sig.B = rand() % ((long)1 << 18);
        sig.D = rand() % ((long)1 << 18);
        sig.C = ((long long)rand() << 16) | rand(); // Generate a 48-bit number
        sig.OPMODE = rand();
        sig.BCIN = rand() % ((long)1 << 18);
        sig.PCIN = ((long long)rand() << 16) | rand();
        sig.CARRYIN = rand() % 2;

        process(&cfg, &sig);

        fprintf(fp, "%lx %lx %llx %lx %lx %x %llx %x -> %lx %llx %x %llx\n",
                sig.A, sig.B, sig.C, sig.D, sig.BCIN, sig.OPMODE, sig.PCIN, sig.CARRYIN, sig.BCOUT, sig.M, sig.CARRYOUT, sig.P);
    }

    fclose(fp);
    printf("Test vectors generated in ../golden_model.txt\n");

    return 0;
}
