module fifo #(parameter DEPTH = 8, parameter WIDTH = 8) (
    input  wire clk,
    input  wire rst,

    input  wire wr_en,
    input  wire rd_en,
    input  wire [WIDTH-1:0] data_in,

    output reg  [WIDTH-1:0] data_out,
    output wire full,
    output wire empty
);

  
    reg [WIDTH-1:0] mem [DEPTH-1:0];

    reg [$clog2(DEPTH):0] wr_ptr = 0;
    reg [$clog2(DEPTH):0] rd_ptr = 0;

    reg [$clog2(DEPTH+1):0] count = 0;

   
    assign full  = (count == DEPTH);
    assign empty = (count == 0);

   
    always @(posedge clk) begin
        if (rst) begin
            wr_ptr <= 0;
        end
        else if (wr_en && !full) begin
            mem[wr_ptr] <= data_in;
            wr_ptr <= wr_ptr + 1;
        end
    end

 
    always @(posedge clk) begin
        if (rst) begin
            rd_ptr <= 0;
            data_out <= 0;
        end
        else if (rd_en && !empty) begin
            data_out <= mem[rd_ptr];
            rd_ptr <= rd_ptr + 1;
        end
    end

    
    always @(posedge clk) begin
        if (rst)
            count <= 0;
        else begin
            case ({wr_en && !full, rd_en && !empty})
                2'b10: count <= count + 1; 
                2'b01: count <= count - 1; 
                default: count <= count;   
            endcase
        end
    end

endmodule