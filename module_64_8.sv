`include "FSM_out.sv"

module module_64_8
(
    input   clk,                // сигнал синхронизации
    input   reset_n,            // сигнал сброса
    input   strobe_in,          // сигнал строба
    input   [63:0] input_data,  // входные данные
    input   req_data,           // запрос на вывод данных
    output  ready,              // сигнал готовности
    output data_end,            // сигнал конца строки
    output  strobe_out,         // сигнал строба на выход
    output  [7:0] data_out      // выходные данные
);

// память для модуля fifo
reg [63:0] mem [7:0];

// указатели чтения и записи данных в fifo
reg [3:0] wr_adr;
reg [3:0] rd_adr;

// сигнал разрешения чтения данных
wire read_enable;

// сигнал полного и пустого fifo
wire full = (wr_adr[2:0] == rd_adr[2:0]) && (wr_adr[3]!= rd_adr[3]);
wire empty = wr_adr == rd_adr;

assign ready = empty;

// изменение указателя записи данных
always @(posedge clk)
begin
    if(!reset_n) // сброс адреса записи
    begin
       wr_adr <= 0; 
    end

    else
    begin
        if(strobe_in && !full)
        begin
          wr_adr <= wr_adr + 1; // увеличение счётчика записи
        end
    end
end

// запись в fifo
always @(posedge clk)
begin
    if(strobe_in && !full)
    begin
        mem[wr_adr[2:0]] <= input_data; // запись данных
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
           rd_adr <= rd_adr + 1; // увеличение адреса чтения на 1
        end
    end
end

// промежуточный буффер для данных из fifo
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
           data_out_fifo <=  mem[rd_adr[2:0]]; // запись в промежуточный буффер
        end
    end
end

// конечный автомат вывода данных
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