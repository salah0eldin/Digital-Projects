`timescale 1ns / 1ps

module DSP48A1_tb;

    // Parameters
    parameter WIDTH_1 = 8;
    parameter WIDTH_2 = 18;
    parameter WIDTH_3 = 36;
    parameter WIDTH_4 = 48;
    parameter A0REG = 0;
    parameter A1REG = 1;
    parameter B0REG = 0;
    parameter B1REG = 1;
    parameter CREG = 1;
    parameter DREG = 1;
    parameter MREG = 1;
    parameter PREG = 1;
    parameter CARRYINREG = 1;
    parameter CARRYOUTREG = 1;
    parameter OPMODEREG = 1;
    parameter CARRYINSEL = "OPMODE5";
    parameter B_INPUT = "DIRECT";
    parameter RSTTYPE = "SYNC";

    // Inputs
    reg [WIDTH_2-1:0] A;
    reg [WIDTH_2-1:0] B;
    reg [WIDTH_4-1:0] C;
    reg [WIDTH_2-1:0] D;
    reg [WIDTH_2-1:0] BCIN;
    reg [WIDTH_1-1:0] OPMODE;
    reg [WIDTH_4-1:0] PCIN;
    reg CARRYIN;
    reg CLK;
    reg CEA, CEB, CEC, CECARRYIN, CED, CEM, CEOPMODE, CEP;
    reg RSTA, RSTB, RSTC, RSTCARRYIN, RSTD, RSTM, RSTOPMODE, RSTP;

    // Outputs
    wire CARRYOUT;
    wire [WIDTH_4-1:0] P;
    wire [WIDTH_2-1:0] BCOUT;
    wire [WIDTH_4-1:0] PCOUT;
    wire [WIDTH_3-1:0] M;
    wire CARRYOUTF;

    reg [WIDTH_2-1:0] golden_model_BCOUT;
    reg [WIDTH_3-1:0] golden_model_M;
    reg golden_model_CARRYOUT;
    reg [WIDTH_4-1:0] golden_model_P;

    // Instantiate the Unit Under Test (UUT)
    DSP48A1 #(
                .WIDTH_1(WIDTH_1),
                .WIDTH_2(WIDTH_2),
                .WIDTH_3(WIDTH_3),
                .WIDTH_4(WIDTH_4),
                .A0REG(A0REG),
                .A1REG(A1REG),
                .B0REG(B0REG),
                .B1REG(B1REG),
                .CREG(CREG),
                .DREG(DREG),
                .MREG(MREG),
                .PREG(PREG),
                .CARRYINREG(CARRYINREG),
                .CARRYOUTREG(CARRYOUTREG),
                .OPMODEREG(OPMODEREG),
                .CARRYINSEL(CARRYINSEL),
                .B_INPUT(B_INPUT),
                .RSTTYPE(RSTTYPE)
            ) uut (
                .A(A),
                .B(B),
                .C(C),
                .D(D),
                .OPMODE(OPMODE),
                .BCIN(BCIN),
                .PCIN(PCIN),
                .CARRYIN(CARRYIN),
                .CLK(CLK),
                .CEA(CEA),
                .CEB(CEB),
                .CEC(CEC),
                .CECARRYIN(CECARRYIN),
                .CED(CED),
                .CEM(CEM),
                .CEOPMODE(CEOPMODE),
                .CEP(CEP),
                .RSTA(RSTA),
                .RSTB(RSTB),
                .RSTC(RSTC),
                .RSTCARRYIN(RSTCARRYIN),
                .RSTD(RSTD),
                .RSTM(RSTM),
                .RSTOPMODE(RSTOPMODE),
                .RSTP(RSTP),
                .CARRYOUT(CARRYOUT),
                .P(P),
                .BCOUT(BCOUT),
                .PCOUT(PCOUT),
                .M(M),
                .CARRYOUTF(CARRYOUTF)
            );

    integer file;
    integer status;

    // Clock generation
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

    initial begin
        // Initialize Inputs
        B = 0;
        BCIN = 0;
        OPMODE = 0;
        D = 0;
        A = 0;
        C = 0;
        PCIN = 0;
        CARRYIN = 0;
        CEA = 0;
        CEB = 0;
        CEC = 0;
        CECARRYIN = 0;
        CED = 0;
        CEM = 0;
        CEOPMODE = 0;
        CEP = 0;
        RSTA = 0;
        RSTB = 0;
        RSTC = 0;
        RSTCARRYIN = 0;
        RSTD = 0;
        RSTM = 0;
        RSTOPMODE = 0;
        RSTP = 0;

        // Apply reset
        RSTA = 1;
        RSTB = 1;
        RSTC = 1;
        RSTCARRYIN = 1;
        RSTD = 1;
        RSTM = 1;
        RSTOPMODE = 1;
        RSTP = 1;
        @(negedge CLK);
        @(negedge CLK);
        RSTA = 0;
        RSTB = 0;
        RSTC = 0;
        RSTCARRYIN = 0;
        RSTD = 0;
        RSTM = 0;
        RSTOPMODE = 0;
        RSTP = 0;

        // Open the golden model file
        file = $fopen("../golden_model.txt", "r");
        if (file == 0) begin
            $display("Failed to open golden model file.");
            $finish;
        end

        // Read and apply test vectors
        while (!$feof(file)) begin
            status = $fscanf(file, "%d %d %h %d %d %d %h %d -> %d %h %d %h\n",
                             A, B, C, D, BCIN, OPMODE, PCIN, CARRYIN, golden_model_BCOUT, golden_model_M, golden_model_CARRYOUT, golden_model_P);


            if (status != 12) begin
                $display("ERROR: fscanf failed or incomplete data read.");
                $finish;
            end

            repeat(4) @(negedge CLK); // Wait to apply inputs

            // Compare expected and actual results
            if (golden_model_BCOUT !== BCOUT || golden_model_M !== M || golden_model_CARRYOUT !== CARRYOUT || golden_model_P !== P) begin
                $display("Failed at A=%d B=%d C=%d D=%d BCIN=%d OPMODE=%b PCIN=%d CARRYIN=%d: Expected BCOUT= %d, Got %d | Expected M=%d, Got %d | Expected CARRYOUT=%d, Got %d | Expected P=%d, Got %d",
                         A, B, C, D, BCIN, OPMODE, PCIN, CARRYIN, golden_model_BCOUT, BCOUT, golden_model_M, M, golden_model_CARRYOUT, CARRYOUT, golden_model_P, P);
            end
        end

        $fclose(file);
        $finish;
    end

endmodule
