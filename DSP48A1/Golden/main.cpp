#include <iostream>
#include <fstream>
#include <cstdlib>
#include <ctime>
#include <cstring>
#include <map>
#include <string>

#include "module.h"

#define TEST_CASES 100

DSP48A1_State state, prev;
int test_number = 1;

// Function to convert a number to a binary string
void to_binary_string(uint64_t num, int bits, char *str)
{
    for (int i = bits - 1; i >= 0; i--)
    {
        str[bits - 1 - i] = (num & (1ULL << i)) ? '1' : '0';
    }
    str[bits] = '\0';
}

// Function to generate a filename based on the signals to be randomized
std::string generate_filename(const std::map<std::string, bool> &randomize_signals)
{
    std::string filename = std::to_string(test_number++) + "_golden_model_";
    for (const auto &signal : randomize_signals)
    {
        if (signal.second)
        {
            filename += signal.first + "_";
        }
    }
    filename += ".txt";
    return filename;
}

// Function to generate test vectors
void generate_test_vectors(const std::map<std::string, bool> &randomize_signals, int test_cases)
{
    std::string filename = generate_filename(randomize_signals);
    std::ofstream fp(filename);
    if (!fp.is_open())
    {
        std::cerr << "Error opening file: " << filename << std::endl;
        return;
    }

    srand(time(NULL));

    char bin_str_A[19], bin_str_B[19], bin_str_C[49], bin_str_D[19];
    char bin_str_BCIN[19], bin_str_PCIN[49], bin_str_OPMODE[9], bin_str_CARRYIN[2];
    char bin_str_BCOUT[19], bin_str_M[49], bin_str_CARRYOUT[2], bin_str_P[49];

    for (int i = 0; i < test_cases; i++)
    {
        if (randomize_signals.at("A"))
            state.A = rand() & MASK_18;
        if (randomize_signals.at("B"))
            state.B = rand() & MASK_18;
        if (randomize_signals.at("D"))
            state.D = rand() & MASK_18;
        if (randomize_signals.at("C"))
            state.C = (((int64_t)rand() << 16) | (int64_t)rand()) & MASK_48;
        if (randomize_signals.at("BCIN"))
            state.BCIN = rand() & MASK_18;
        if (randomize_signals.at("PCIN"))
            state.PCIN = (((int64_t)rand() << 16) | (int64_t)rand()) & MASK_48;
        if (randomize_signals.at("OPMODE"))
            state.OPMODE = (rand() & 0xFF);
        if (randomize_signals.at("CARRYIN"))
            state.CARRYIN = (bool)rand();

        // Simulate 4 clock cycles
        for (int j = 0; j < 4; j++)
        {
            // Copy current state to previous state
            DSP48A1_clock_cycle(&state, &prev);
            prev = state;

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
            fp << bin_str_A << " " << bin_str_B << " " << bin_str_C << " " << bin_str_D << " "
               << bin_str_BCIN << " " << bin_str_OPMODE << " " << bin_str_PCIN << " " << bin_str_CARRYIN
               << " -> " << bin_str_BCOUT << " " << bin_str_M << " " << bin_str_CARRYOUT << " " << bin_str_P << "\n";
        }
    }

    fp.close();
    std::cout << "Test vectors generated in " << filename << std::endl;

    // Add filename to filelist.txt
    std::ofstream filelist("filelist.txt", std::ios::app);
    if (!filelist.is_open())
    {
        std::cerr << "Error opening filelist.txt" << std::endl;
        return;
    }
    filelist << filename << std::endl;
    filelist.close();
}

int main()
{
    // Remove filelist.txt at the start
    std::remove("filelist.txt");

    memset(&state, 0, sizeof(DSP48A1_State));
    memset(&prev, 0, sizeof(DSP48A1_State));
    
    std::map<std::string, bool> randomize_signals;
    
    randomize_signals = {
        {"A", true},
        {"B", true},
        {"C", true},
        {"D", true},
        {"BCIN", true},
        {"PCIN", true},
        {"OPMODE", true},
        {"CARRYIN", true}};

    generate_test_vectors(randomize_signals, TEST_CASES);

    randomize_signals = {
        {"A", true},
        {"B", true},
        {"C", true},
        {"D", true},
        {"BCIN", true},
        {"PCIN", false},
        {"OPMODE", false},
        {"CARRYIN", false}};

    generate_test_vectors(randomize_signals, TEST_CASES);
    
    state.OPMODE = 0x35;
    randomize_signals = {
        {"A", true},
        {"B", true},
        {"C", true},
        {"D", true},
        {"BCIN", true},
        {"PCIN", false},
        {"OPMODE", false},
        {"CARRYIN", false}};

    generate_test_vectors(randomize_signals, TEST_CASES);

    return 0;
}
