// % The  Spartan-6  family  offers  a  high  ratio  of  DSP48A1  slices  to  logic,
// % making  it  ideal  for  math-intensive applications. Design DSP48A1 slice of the spartan6 FPGAs.

module DSP48A1 #(
        //// ! Parameter (Attributes):
        parameter WIDTH_1 = 8,  // * Width for OPMODE
        parameter WIDTH_2 = 18, // * Width for A, B, D, BCIN, BCOUT
        parameter WIDTH_3 = 36, // * Width for M
        parameter WIDTH_4 = 48, // * Width for C, PCIN, PCOUT, P

        /**
         * * The A0REG, A1REG, B0REG, and B1REG attributes can take values of 0 or 1.
         * * These values define the number of pipeline registers in the A and B input paths.
         * # A0 and B0 are the first stages of the pipelines. 
         * # A1 and B1 are the second stages of the pipelines. 
         * ? A0REG defaults to 0 (no register). A1REG defaults to 1 (register). 
         * ? B0REG defaults to 0 (no register) B1REG defaults to 1 (register). 
         */
        parameter A0REG = 0,
        parameter A1REG = 1,
        parameter B0REG = 0,
        parameter B1REG = 1,

        /**
         * * These attributes can take a value of 0 or 1. 
         * * The number defines the number of pipeline stages. 
         * ? Default: 1 (registered)
         */
        parameter CREG = 1,
        parameter DREG = 1,
        parameter MREG = 1,
        parameter PREG = 1,
        parameter CARRYINREG = 1,
        parameter CARRYOUTREG = 1,
        parameter OPMODEREG = 1,

        /**
         * * This attribute can be set to the string CARRYIN or OPMODE5. 
         * * The CARRYINSEL attribute is used in the carry cascade input, 
         * * either the CARRYIN input will be considered or the value of opcode[5]. 
         * ? Default: OPMODE5. Tie the output of the mux to 0 if none of these string values exist.
         */
        parameter CARRYINSEL = "OPMODE5",

        /**
         * * The B_INPUT attribute defines whether: 
         * * the input to the B port is routed from the B input (attribute = DIRECT) 
         * * or the cascaded input (BCIN) from the previous DSP48A1 slice (attribute = CASCADE). 
         * ? Default: DIRECT. Tie the output of the mux to 0 if none of these string values exist.
         */
        parameter B_INPUT = "DIRECT",

        /**
         * * This attribute can be set to ASYNC or SYNC. 
         * * The RSTTYPE attribute selects whether all resets for the DSP48A1 slice should have 
         * * a synchronous or asynchronous reset capability. 
         * ? Default: SYNC.
         */
        parameter RSTTYPE = "SYNC"
    )(
        //// ! Data Ports:
        /**
         * * 18-bit data input to multiplier, and optionally to post-
         * * adder/subtracter depending on the value of OPMODE[1:0].
         */
        input [WIDTH_2-1:0] A,

        /**
         * * 18-bit data input to pre-adder/subtracter, to multiplier depending on 
         * * OPMODE[4], or to post-adder/subtracter depending on OPMODE[1:0]. 
         */ 
        input [WIDTH_2-1:0] B,

        /**
         * * 48-bit data input to post-adder/subtracter.
         */
        input [WIDTH_4-1:0] C,

        /**
         * * 18-bit data input to pre-adder/subtracter. D[11:0] are concatenated 
         * * with A and B and optionally sent to post-adder/subtracter depending on the value of OPMODE[1:0].
         */
        input [WIDTH_2-1:0] D,

        /**
         * * carry input to the post-adder/subtracter.
         */
        input CARRYIN,

        /**
         * * 36-bit buffered multiplier data output, routable to the FPGA logic. 
         * * It is either the output of the M register (MREG = 1) or the direct output of the multiplier (MREG = 0). 
         */
        output [WIDTH_3-1:0] M,

        /**
         * * Primary data output from the post-adder/subtracter. 
         * * It is either the output of the P register (PREG = 1) or the direct output of the post-adder/subtracter (PREG = 0). 
         */
        output [WIDTH_4-1:0] P,

        /**
         * * Cascade carry out signal from post-adder/subtracter. 
         * * It can be registered in (CARRYOUTREG = 1) or unregistered (CARRYOUTREG = 0). 
         * * This output is to be connected only to CARRYIN of adjacent DSP48A1 if multiple DSP blocks are used.
         */
        output CARRYOUT,

        /**
         * * Carry out signal from post-adder/subtracter for use in the FPGA logic. 
         * * It is a copy of the CARRYOUT signal that can be routed to the user logic.
         */
        output CARRYOUTF,

        //// ! Control Input Ports:
        input CLK,                  // # DSP clock
        input [WIDTH_1-1:0] OPMODE, // # Control input to select the arithmetic operations of the DSP48A1 slice.

        //// ! OPMODE Pin Descriptions:
        /**
         * # OPMODE[1:0]:
         *      ? Specifies the source of the X input to the post-adder/subtracter
         *      * 0 – Specifies to place all zeros (disable the post-adder/subtracter 
         *      *      and propagate the Z result to P)
         *      * 1 – Use the multiplier product
         *      * 2 – Use the P output signal (accumulator)
         *      * 3 – Use the concatenated D:A:B input signals
         * # OPMODE[3:2]:
         *      ? Specifies the source of the Z input to the post-adder/subtracter
         *      * 0 – Specifies to place all zeros (disable the post-adder/subtracter 
         *      *     and propagate the multiplier product or other X result to P)
         *      * 1 – Use the PCIN
         *      * 2 – Use the P output signal (accumulator)
         *      * 3 – Use the C port
         * # OPMODE[4]:  
         *      ? Specifies the use of the pre-adder/subtracter
         *      * 0 – Bypass the pre-adder supplying the data on port B directly to the multiplier
         *      * 1 – Selects to use the pre-adder adding or subtracting the values on the B and D ports 
         *      *     prior to the multiplier.
         * # OPMODE[5]: 
         *      ? Forces a value on the carry input of the carry-in register (CYI) or direct to the CIN 
         *      ? to the post-adder. Only applicable when CARRYINSEL = OPMODE5
         * # OPMODE[6]:
         *      ? Specifies whether the pre-adder/subtracter is an adder or subtracter
         *      * 0 – Specifies pre-adder/subtracter to perform an addition operation
         *      * 1 – Specifies pre-adder/subtracter to perform a subtraction operation (D-B)
         * # OPMODE[7]: 
         *      ? Specifies whether the post-adder/subtracter is an adder or subtracter
         *      * 0 – Specifies post-adder/subtracter to perform an addition operation
         *      * 1 – Specifies post-adder/subtracter to perform a subtraction operation (Z-(X+CIN))
         */

        //// ! Clock Enable Input Ports:
        input CEA,          // * Clock enable for the A port registers: (A0REG & A1REG).
        input CEB,          // * Clock enable for the B port registers: (B0REG & B1REG).
        input CEC,          // * Clock enable for the C port registers (CREG).
        input CECARRYIN,    // * Clock enable for the carry-in register (CYI) and the carry-out register (CYO).
        input CED,          // * Clock enable for the D port register (DREG).
        input CEM,          // * Clock enable for the multiplier register (MREG).
        input CEOPMODE,     // * Clock enable for the opmode register (OPMODEREG).
        input CEP,          // * Clock enable for the P output port registers (PREG = 1).

        //// ! Reset Input Ports:
        // # All the resets are active high. They are either sync or async depending on the parameter RSTTYPE.
        input RSTA,         // * Reset  for the A registers: (A0REG & A1REG).
        input RSTB,         // * Reset for the B registers: (B0REG & B1REG).
        input RSTC,         // * Reset for the C registers (CREG).
        input RSTCARRYIN,   // * Reset for the carry-in register (CYI) and the carry-out register (CYO).
        input RSTD,         // * Reset for the D register (DREG).
        input RSTM,         // * Reset for the multiplier register (MREG).
        input RSTOPMODE,    // * Reset for the opmode register (OPMODEREG).
        input RSTP,         // * Reset for the P output registers (PREG = 1).

        //// ! Cascade Ports:
        input [WIDTH_2-1:0] BCIN,   // * Cascade input for Port B.
        output [WIDTH_2-1:0] BCOUT, // * Cascade output for Port B.
        input [WIDTH_4-1:0] PCIN,   // * Cascade input for Port P.
        output [WIDTH_4-1:0] PCOUT  // * Cascade output for Port P.
    );

    //// ! Internal Signals:
    // * 01: Input Stage
    wire [WIDTH_2-1:0] B_0;
    wire [WIDTH_1-1:0] OPMODE_O;

    // * 02: Second Stage
    wire [WIDTH_2-1:0] D_1;
    wire [WIDTH_2-1:0] B_0_O;
    wire [WIDTH_2-1:0] A_1;
    wire [WIDTH_4-1:0] C_1;

    // * 03: Pre-Adder/Subtracter
    wire [WIDTH_2-1:0] D_PAS_B; // ? D + B or D - B (OPMODE[6])

    // * 04: Fourth Stage
    wire [WIDTH_2-1:0] B_1;

    // * 05: Fifth Stage
    wire [WIDTH_4-1:0] D_A_B; // ? {D_1[11:0], A_1_O, B_1_O}
    wire [WIDTH_2-1:0] B_1_O;
    wire [WIDTH_2-1:0] A_1_O;

    // * 06: Multiplier
    wire [WIDTH_3-1:0] B1_Mul_A1;
    wire CYI;

    // * 07: Seventh Stage
    wire [WIDTH_3-1:0] M_B;
    wire CYI_O;

    // * 08: Eighth Stage
    wire [WIDTH_4-1:0] X;
    wire [WIDTH_4-1:0] Z;

    // * 09: Post-Adder/Subtracter
    wire [WIDTH_4-1:0] X_Z_CIN_OP; // ? X + Z + CIN or Z - (X + CIN) (OPMODE[7])
    wire CYO;

    // * 10: Output Stage
    // ? No Signals Required

    //// ! Implementation
    // * 01: Input Stage
    assign B_0 = (B_INPUT == "DIRECT") ? B : (B_INPUT == "CASCADE") ? BCIN : 0;

    DFF #(.WIDTH(WIDTH_1), .RSTTYPE(RSTTYPE), .REGEN(OPMODEREG)) DFF_OPMODE (.d(OPMODE), .clk(CLK), .rst(RSTOPMODE), .en(CEOPMODE), .q(OPMODE_O));

    // * 02: Second Stage
    DFF #(.WIDTH(WIDTH_2), .RSTTYPE(RSTTYPE), .REGEN(DREG)) DFF_D (.d(D), .clk(CLK), .rst(RSTD), .en(CED), .q(D_1));
    DFF #(.WIDTH(WIDTH_2), .RSTTYPE(RSTTYPE), .REGEN(B0REG)) DFF_B_0 (.d(B_0), .clk(CLK), .rst(RSTB), .en(CEB), .q(B_0_O));
    DFF #(.WIDTH(WIDTH_2), .RSTTYPE(RSTTYPE), .REGEN(A0REG)) DFF_A_0 (.d(A), .clk(CLK), .rst(RSTA), .en(CEA), .q(A_1));
    DFF #(.WIDTH(WIDTH_4), .RSTTYPE(RSTTYPE), .REGEN(CREG)) DFF_C (.d(C), .clk(CLK), .rst(RSTC), .en(CEC), .q(C_1));

    // * 03: Pre-Adder/Subtracter
    assign D_PAS_B = (OPMODE_O[6]) ? D_1 - B_0_O : D_1 + B_0_O;

    // * 04: Fourth Stage
    assign B_1 = (OPMODE_O[4]) ? D_PAS_B : B_0_O;

    // * 05: Fifth Stage
    DFF #(.WIDTH(WIDTH_2), .RSTTYPE(RSTTYPE), .REGEN(B1REG)) DFF_B_1 (.d(B_1), .clk(CLK), .rst(RSTB), .en(CEB), .q(B_1_O));
    DFF #(.WIDTH(WIDTH_2), .RSTTYPE(RSTTYPE), .REGEN(A1REG)) DFF_A_1 (.d(A_1), .clk(CLK), .rst(RSTA), .en(CEA), .q(A_1_O));

    assign D_A_B = {D_1[11:0], A_1_O, B_1_O};
    assign BCOUT = B_1_O;

    // * 06: Multiplier
    assign B1_Mul_A1 = B_1_O * A_1_O;
    assign CYI = (CARRYINSEL == "OPMODE5") ? OPMODE[5] : (CARRYINSEL == "CARRYIN") ? CARRYIN: 1'b0;

    // * 07: Seventh Stage
    DFF #(.WIDTH(WIDTH_3), .RSTTYPE(RSTTYPE), .REGEN(MREG)) DFF_M_O (.d(B1_Mul_A1), .clk(CLK), .rst(RSTM), .en(CEM), .q(M_B));
    DFF #(.WIDTH(1), .RSTTYPE(RSTTYPE), .REGEN(CARRYINREG)) DFF_CYI_O (.d(CYI), .clk(CLK), .rst(RSTCARRYIN), .en(CECARRYIN), .q(CYI_O));

    (* keep *) assign M = M_B;

    // * 08: Eighth Stage
    assign X = (OPMODE_O[1:0] == 0) ? {WIDTH_4{1'b0}} : (OPMODE_O[1:0] == 1) ? {{(WIDTH_4-WIDTH_3){1'b0}}, M_B} : (OPMODE_O[1:0] == 2) ? P : D_A_B;
    assign Z = (OPMODE_O[3:2] == 0) ? {WIDTH_4{1'b0}} : (OPMODE_O[3:2] == 1) ? PCIN : (OPMODE_O[3:2] == 2) ? P : C_1;

    // * 09: Post-Adder/Subtracter
    assign {CYO, X_Z_CIN_OP} = (OPMODE_O[7]) ? {1'b0, Z} - ({1'b0, X} + CYI_O) : {1'b0, X} + {1'b0, Z} + CYI_O;

    // * 10: Output Stage
    DFF #(.WIDTH(1), .RSTTYPE(RSTTYPE), .REGEN(CARRYOUTREG)) DFF_CYO (.d(CYO), .clk(CLK), .rst(RSTCARRYIN), .en(CECARRYIN), .q(CARRYOUT));
    DFF #(.WIDTH(WIDTH_4), .RSTTYPE(RSTTYPE), .REGEN(PREG)) DFF_P (.d(X_Z_CIN_OP), .clk(CLK), .rst(RSTP), .en(CEP), .q(P));

    assign CARRYOUTF = CARRYOUT;
    assign PCOUT = P;

endmodule
