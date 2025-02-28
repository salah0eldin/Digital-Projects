`timescale 1ns / 1ps

module DSP48A1_tb;

    // Parameters
    parameter WIDTH_1 = 8; parameter WIDTH_2 = 18; parameter WIDTH_3 = 36; parameter WIDTH_4 = 48;
    parameter A0REG = 0; parameter A1REG = 1; parameter B0REG = 0; parameter B1REG = 1;
    parameter CREG = 1; parameter DREG = 1; parameter MREG = 1; parameter PREG = 1;
    parameter CARRYINREG = 1; parameter CARRYOUTREG = 1; parameter OPMODEREG = 1;
    parameter CARRYINSEL = "OPMODE5"; parameter B_INPUT = "DIRECT"; parameter RSTTYPE = "SYNC";

    // Inputs
    reg [WIDTH_2-1:0] A, B, D, BCIN;
    reg [WIDTH_4-1:0] C, PCIN;
    reg [WIDTH_1-1:0] OPMODE;
    reg CARRYIN, CLK;
    reg CEA, CEB, CEC, CECARRYIN, CED, CEM, CEOPMODE, CEP;
    reg RSTA, RSTB, RSTC, RSTCARRYIN, RSTD, RSTM, RSTOPMODE, RSTP;

    // Outputs
    wire CARRYOUT, CARRYOUTF;
    wire [WIDTH_4-1:0] P, PCOUT;
    wire [WIDTH_2-1:0] BCOUT;
    wire [WIDTH_3-1:0] M;

    reg [WIDTH_2-1:0] golden_model_BCOUT;
    reg [WIDTH_3-1:0] golden_model_M;
    reg golden_model_CARRYOUT;
    reg [WIDTH_4-1:0] golden_model_P;

    // Instantiate the Unit Under Test (UUT)
    DSP48A1 #(
                .WIDTH_1(WIDTH_1), .WIDTH_2(WIDTH_2), .WIDTH_3(WIDTH_3), .WIDTH_4(WIDTH_4),
                .A0REG(A0REG), .A1REG(A1REG), .B0REG(B0REG), .B1REG(B1REG),
                .CREG(CREG), .DREG(DREG), .MREG(MREG), .PREG(PREG),
                .CARRYINREG(CARRYINREG), .CARRYOUTREG(CARRYOUTREG), .OPMODEREG(OPMODEREG),
                .CARRYINSEL(CARRYINSEL), .B_INPUT(B_INPUT), .RSTTYPE(RSTTYPE)
            ) uut (
                .A(A), .B(B), .C(C), .D(D), .OPMODE(OPMODE), .BCIN(BCIN), .PCIN(PCIN), 
                .CARRYIN(CARRYIN), .CLK(CLK), .CEA(CEA), .CEB(CEB), .CEC(CEC), 
                .CECARRYIN(CECARRYIN), .CED(CED), .CEM(CEM), .CEOPMODE(CEOPMODE), 
                .CEP(CEP), .RSTA(RSTA), .RSTB(RSTB), .RSTC(RSTC), .RSTCARRYIN(RSTCARRYIN), 
                .RSTD(RSTD), .RSTM(RSTM), .RSTOPMODE(RSTOPMODE), .RSTP(RSTP), 
                .CARRYOUT(CARRYOUT), .P(P), .BCOUT(BCOUT), .PCOUT(PCOUT), .M(M), 
                .CARRYOUTF(CARRYOUTF)
            );

    integer file;
    integer status;
    integer i;
    string filelist[100];
    integer filecount;
    integer j;

    // Clock generation
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

    initial begin
        // Initialize Inputs
        {B, BCIN, OPMODE, D, A, C, PCIN, CARRYIN} = 0;
        {CEA, CEB, CEC, CECARRYIN, CED, CEM, CEOPMODE, CEP} = 8'b11111111;
        {RSTA, RSTB, RSTC, RSTCARRYIN, RSTD, RSTM, RSTOPMODE, RSTP} = 0;

        // Apply reset
        {RSTA, RSTB, RSTC, RSTCARRYIN, RSTD, RSTM, RSTOPMODE, RSTP} = 8'b11111111;
        @(negedge CLK);
        {RSTA, RSTB, RSTC, RSTCARRYIN, RSTD, RSTM, RSTOPMODE, RSTP} = 8'b00000000;

        i = 0;
        filecount = 0;

        // Open the directory and read file names
        file = $fopen("../Golden/filelist.txt", "r");
        if (file == 0) begin
            $display("Failed to open file list.");
            $finish;
        end

        while (!$feof(file)) begin
            status = $fscanf(file, "%s\n", filelist[filecount]);
            if (status == 1) begin
                filecount = filecount + 1;
            end
        end
        $fclose(file);

        // Loop through each file
        for (j = 0; j < filecount; j = j + 1) begin
            $display("Testing with file: %s", filelist[j]);
            file = $fopen({"../Golden/", filelist[j]}, "r");
            if (file == 0) begin
                $display("Failed to open golden model file: %s", filelist[j]);
                $finish;
            end

            // Read and apply test vectors
            while (!$feof(file)) begin
                status = $fscanf(file, "%b %b %b %b %b %b %b %b -> %b %b %b %b\n",
                                 A, B, C, D, BCIN, OPMODE, PCIN, CARRYIN, golden_model_BCOUT, golden_model_M, golden_model_CARRYOUT, golden_model_P);

                if (status != 12) begin
                    $display("Failed: ERROR fscanf failed or incomplete data read.");
                    $finish;
                end

                i = i + 1;
                if(i>4)
                    i = 1;

                // Compare expected and actual results
                if (golden_model_BCOUT !== BCOUT || golden_model_M !== M || golden_model_CARRYOUT !== CARRYOUT || golden_model_P !== P) begin
                    $display("%d\n", i);
                    $display("Failed at A=%h B=%h C=%h D=%h BCIN=%h OPMODE=%b PCIN=%h CARRYIN=%h: Expected BCOUT= %h, Got %h | Expected M=%h, Got %h | Expected CARRYOUT=%h, Got %h | Expected P=%h, Got %h",
                             A, B, C, D, BCIN, OPMODE, PCIN, CARRYIN, golden_model_BCOUT, BCOUT, golden_model_M, M, golden_model_CARRYOUT, CARRYOUT, golden_model_P, P);
                end

                repeat(1) @(negedge CLK);
            end

            $fclose(file);
        end

        $finish;
    end

endmodule
