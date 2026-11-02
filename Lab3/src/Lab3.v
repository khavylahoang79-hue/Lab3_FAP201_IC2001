module Lab3 (
    input  i_Clk,
    input  i_Switch,
    output o_LED
);
    reg r_LED    = 1'b0;
    reg r_Switch = 1'b0;

    always @(posedge i_Clk) begin
        r_Switch <= i_Switch;
        // Nút vừa được nhả: trước là 1, giờ là 0
        if (i_Switch == 1'b0 && r_Switch == 1'b1)
            r_LED <= ~r_LED;
    end

    assign o_LED = r_LED;
endmodule