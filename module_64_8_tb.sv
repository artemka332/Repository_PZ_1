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

always #10 clk = !clk;

initial begin

    // ждём несколько тактов
    for( i = 0;i < 15; i++)
    begin
        @(negedge clk);
    end

    // активируем сигнал сброса данных
    reset_n = 0;

    // ждём несколько тактов
    for( i = 0;i < 15; i++)
    begin
        @(negedge clk);
    end

    // деактивируем сигнал сброса
    reset_n = 1;

    // ждём несколько тактов
    for( i = 0;i < 7; i++)
    begin
        @(negedge clk);
    end

    // поднимаем сигнал разрешения записи данных
    strobe_in = 1;

    // запись данных
    for( i = 0;i < 16; i++)
    begin
        // генерируем данные для младшей и старшей части
        input_data[63:32] = $urandom();
        input_data[31:0] = $urandom();
        @(negedge clk); // добавили задержку
    end

    // убираем сигнал сброса данных
    strobe_in = 0;

    // продвигаем время моделирования
    for( i = 0;i < 100; i++)
    begin
        @(negedge clk);
    end

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