`timescale 1ns/1ps

module fifo_tb;

    parameter DEPTH = 8;
    parameter WIDTH = 8;

    reg clk;
    reg rst;
    reg wr_en;
    reg rd_en;
    reg [WIDTH-1:0] data_in;

    wire [WIDTH-1:0] data_out;
    wire full;
    wire empty;

    fifo #(DEPTH, WIDTH) dut (
        .clk(clk),
        .rst(rst),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .data_in(data_in),
        .data_out(data_out),
        .full(full),
        .empty(empty)
    );

    always #5 clk = ~clk;

    initial begin
   
    $dumpfile("fifo.vcd"); 
    $dumpvars(0, fifo_tb);  
      
        clk = 0;
        rst = 1;
        wr_en = 0;
        rd_en = 0;
        data_in = 0;

        #10;
        rst = 0;

        $display("Writing data into FIFO...");
        repeat (5) begin
            @(posedge clk);
            wr_en = 1;
            rd_en = 0;
            data_in = data_in + 1;
        end

        @(posedge clk);
        wr_en = 0;

        $display("Reading data from FIFO...");
        repeat (5) begin
            @(posedge clk);
            rd_en = 1;
            wr_en = 0;
        end

        @(posedge clk);
        rd_en = 0;

     
        $display("Simultaneous read/write...");
        repeat (3) begin
            @(posedge clk);
            wr_en = 1;
            rd_en = 1;
            data_in = data_in + 1;
        end

        @(posedge clk);
        wr_en = 0;
        rd_en = 0;

        #20;
        $finish;
    end

endmodule
