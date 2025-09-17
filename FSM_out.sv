module FSM_out
(
    input clk,
    input reset_n,
    input [63:0] fifo_data,
    input req,
    output reg data_end,
    output reg read_enable,
    output reg strobe_out,
    output reg [7:0] data_out
);

reg [3:0] state;

always @(posedge clk)
begin
    if(!reset_n)
    begin
      read_enable <= 0;
      state <= 0;
      strobe_out <= 0;
      data_out <= 0;
      data_end <= 0; 
    end

    else
    begin
        case(state)
            0: begin
                if(req)
                begin
                    state <= 1;
                    read_enable <= 1;
                end

                else state <= 0;
            end

            1: begin
               read_enable <= 0;
               strobe_out <= 1;
               data_out <= fifo_data[7:0];
               state <= 2; 
            end

            2: begin
                data_out <= fifo_data[15:8];
                state <= 3;
            end
            
            3: begin
                data_out <= fifo_data[23:16];
                state <= 4;
            end

            4: begin
                data_out <= fifo_data[31:24];
                state <= 5;
            end

            5: begin
               data_out <= fifo_data[39:32];
               state <= 6;
            end

            6: begin
                data_out <= fifo_data[47:40];
                state <= 7;
            end

            7: begin
                data_out <= fifo_data[55:48];
                state <= 8;
            end

            7: begin
                data_out <= fifo_data[63:56];
                data_end <= 1;
                state <= 8;
            end

            8: begin
                strobe_out <= 0;
                data_end <= 0;
                state <= 0;
            end
        endcase
    end
end

endmodule