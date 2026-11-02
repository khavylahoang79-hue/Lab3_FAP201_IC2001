`timescale 1ns/1ps
module Lab3_tb;
    reg i_Clk = 0;
    reg i_Switch = 0;
    wire o_LED;

    Lab3 uut (.i_Clk(i_Clk), .i_Switch(i_Switch), .o_LED(o_LED));

    always #20 i_Clk = ~i_Clk;

    initial begin
        i_Switch = 0; #200;
        i_Switch = 1; #200;  // nhấn
        i_Switch = 0; #200;  // nhả -> LED bật
        i_Switch = 1; #200;  // nhấn
        i_Switch = 0; #200;  // nhả -> LED tắt
        $finish;
    end
endmodule