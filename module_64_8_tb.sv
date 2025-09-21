`include "module_64_8.sv"

module module_64_8_tb;

reg clk = 0;
reg reset_n = 1;
reg strobe_in = 0;
reg [63:0] input_data = 0;
reg req_data = 0;
wire ready;
wire data_end;
wire strobe_out;
wire [7:0] data_out;

integer i;

module_64_8 module_64_8_1
(
    .clk(clk),
    .reset_n(reset_n),
    .strobe_in(strobe_in),
    .input_data(input_data),
    .req_data(req_data),
    .ready(ready),
    .data_end(data_end),
    .strobe_out(strobe_out),
    .data_out(data_out)
);

always #5 clk = !clk;

initial begin

    @(negedge clk);


    reset_n = 0;

    for( i = 0;i < 10; i++)
    begin
        @(negedge clk);
    end

    reset_n = 1;

    for( i = 0;i < 7; i++)
    begin
        @(negedge clk);
    end

    // запись данных
    for( i = 0;i < 5; i++)
    begin
        strobe_in = 1;
        input_data = $urandom() % 1024;
        @(negedge clk);
    end

    strobe_in = 0;

end

always @(posedge clk)
begin
    $display("Данные на выходе: %d",data_out);
end

// блок запроса данных
always @(posedge clk)
begin
    if(ready)
    begin
      req_data <= 1;  
    end

    else
    begin
        req_data <= 0; 
    end
end

endmodule