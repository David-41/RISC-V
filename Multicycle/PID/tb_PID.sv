`timescale 1 ns / 1 ps

module tb_PID ();

    // Signals definition
    logic clk, rst, en;
    logic[31:0] reference, feedback, k1, k2, k3;
    logic[31:0] control;
    int reffile, fbfile, cfile, efile, e1file, e2file, m1file, m2file,
        m3file, ufile, kfile;

    PID dut(
        .clk(clk),
        .en(en),
        .arst(rst),
        .srst(1'b1),
        .reference(reference),
        .feedback(feedback),
        .k1(k1),
        .k2(k2),
        .k3(k3),
        .control(control)
    );

    // Generate clock
    always begin
        clk = 1; #5;
        $fdisplay(cfile, "%0d", $signed(control));
        $fdisplay(efile, "%0d", $signed(dut.error));
        $fdisplay(e1file, "%0d", $signed(dut.error1));
        $fdisplay(e2file, "%0d", $signed(dut.error2));
        $fdisplay(m1file, "%0d", $signed(dut.multiplied1));
        $fdisplay(m2file, "%0d", $signed(dut.multiplied2));
        $fdisplay(m3file, "%0d", $signed(dut.multiplied3));
        $fdisplay(ufile, "%0d", $signed(dut.control1));
        $fscanf(reffile, "%d", reference);
        $fscanf(fbfile, "%d", feedback);
        if($feof(reffile)) begin
            $fclose(reffile);
            $fclose(fbfile);
            $fclose(cfile);
            $fclose(efile);
            $fclose(e1file);
            $fclose(e2file);
            $fclose(m1file);
            $fclose(m2file);
            $fclose(m3file);
            $fclose(ufile);
            $fclose(kfile);
            $stop;
        end
        clk = 0; #5;
    end

    // Initialization
    initial begin
        en = 0;
        rst = 0; 

        reffile = $fopen("./Matlab/reffile.txt", "r");
        if(reffile) $display("reffile opened succesfully");
        else begin
            $display("reffile failed to open");
            $stop;
        end
        
        fbfile = $fopen("./Matlab/fbfile.txt", "r");
        if(fbfile) $display("fbfile opened succesfully");
        else begin
            $display("fbfile failed to open");
            $fclose(reffile);
            $stop;
        end
        
        cfile = $fopen("./Matlab/cfile.txt", "w");
        if(cfile) $display("cfile opened succesfully");
        else begin
            $display("cfile failed to open");
            $fclose(reffile);
            $fclose(fbfile);
            $stop;
        end

        efile = $fopen("./Matlab/efile.txt", "w");
        if(efile) $display("efile opened succesfully");
        else begin
            $display("efile failed to open");
            $fclose(reffile);
            $fclose(fbfile);
            $fclose(cfile);
            $stop;
        end

        e1file = $fopen("./Matlab/e1file.txt", "w");
        if(e1file) $display("e1file opened succesfully");
        else begin
            $display("e1file failed to open");
            $fclose(reffile);
            $fclose(fbfile);
            $fclose(cfile);
            $fclose(efile);
            $stop;
        end

        e2file = $fopen("./Matlab/e2file.txt", "w");
        if(e2file) $display("e2file opened succesfully");
        else begin
            $display("e2file failed to open");
            $fclose(reffile);
            $fclose(fbfile);
            $fclose(cfile);
            $fclose(efile);
            $fclose(e1file);
            $stop;
        end

        m1file = $fopen("./Matlab/m1file.txt", "w");
        if(m1file) $display("m1file opened succesfully");
        else begin
            $display("m1file failed to open");
            $fclose(reffile);
            $fclose(fbfile);
            $fclose(cfile);
            $fclose(efile);
            $fclose(e1file);
            $fclose(e2file);
            $stop;
        end

        m2file = $fopen("./Matlab/m2file.txt", "w");
        if(m2file) $display("m2file opened succesfully");
        else begin
            $display("m2file failed to open");
            $fclose(reffile);
            $fclose(fbfile);
            $fclose(cfile);
            $fclose(efile);
            $fclose(e1file);
            $fclose(e2file);
            $fclose(m1file);
            $stop;
        end
        
        m3file = $fopen("./Matlab/m3file.txt", "w");
        if(m3file) $display("m3file opened succesfully");
        else begin
            $display("m3file failed to open");
            $fclose(reffile);
            $fclose(fbfile);
            $fclose(cfile);
            $fclose(efile);
            $fclose(e1file);
            $fclose(e2file);
            $fclose(m1file);
            $fclose(m2file);
            $stop;
        end

        ufile = $fopen("./Matlab/ufile.txt", "w");
        if(ufile) $display("ufile opened succesfully");
        else begin
            $display("ufile failed to open");
            $fclose(reffile);
            $fclose(fbfile);
            $fclose(cfile);
            $fclose(efile);
            $fclose(e1file);
            $fclose(e2file);
            $fclose(m1file);
            $fclose(m2file);
            $fclose(m3file);
            $stop;
        end

        kfile = $fopen("./Matlab/kfile.txt", "r");
        if(kfile) $display("kfile opened succesfully");
        else begin
            $display("kfile failed to open");
            $fclose(reffile);
            $fclose(fbfile);
            $fclose(cfile);
            $fclose(efile);
            $fclose(e1file);
            $fclose(e2file);
            $fclose(m1file);
            $fclose(m2file);
            $fclose(m3file);
            $fclose(ufile);
            $stop;
        end

        $fscanf(kfile, "%d", k1);
        $fscanf(kfile, "%d", k2);
        $fscanf(kfile, "%d", k3);

        #7 rst = 1;
        en = 1;
    end
endmodule