`include "FSM_out.sv"

module module_64_8
(
    input   clk,
    input   reset_n,
    input   strobe_in,
    input   [63:0] input_data,
    input   req_data,
    output  ready,
    output data_end,
    output  strobe_out,
    output  [7:0] data_out
);

// память для модуля fifo
reg [63:0] mem [7:0];

reg [3:0] wr_adr;
reg [3:0] rd_adr;
wire read_enable;

wire full = (wr_adr[2:0] == rd_adr[2:0]) && (wr_adr[3]!= rd_adr[3]);
wire empty = wr_adr == rd_adr;

assign ready = empty;

// изменение указателя записи данных
always @(posedge clk)
begin
    if(!reset_n)
    begin
       wr_adr <= 0; 
    end

    else
    begin
        if(strobe_in && !full)
        begin
          wr_adr <= wr_adr + 1; 
        end
    end
end

// запись в fifo
always @(posedge clk)
begin
    if(strobe_in && !full)
    begin
        mem[wr_adr[2:0]] <= input_data;
    end
end

// измненение указателя чтения данных
always @(posedge clk)
begin
    if(!reset_n)
    begin
       rd_adr <= 0; 
    end

    else
    begin
        if(read_enable)
        begin
           rd_adr <= rd_adr + 1; 
        end
    end
end

reg [63:0] data_out_fifo;

always @(posedge clk)
begin
    if(!reset_n)
    begin
        data_out_fifo <= 0;
    end

    else
    begin
        if(read_enable)
        begin
           data_out_fifo <=  mem[rd_adr[2:0]]; 
        end
    end
end


FSM_out FSM_out_1
(
    .clk            (clk),
    .reset_n        (reset_n),
    .fifo_data      (data_out_fifo),
    .req            (req_data),
    .data_end       (data_end),
    .read_enable    (read_enable),
    .strobe_out     (strobe_out),
    .data_out       (data_out)
);


endmodule