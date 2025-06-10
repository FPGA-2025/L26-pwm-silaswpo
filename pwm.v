module PWM (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [15:0] duty_cycle,
    input  wire [15:0] period,
    output reg         pwm_out
);

    reg [15:0] counter;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            counter <= 16'd0;
        else if (counter >= period - 1)
            counter <= 16'd0;
        else
            counter <= counter + 1;
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            pwm_out <= 1'b0;
        else
            pwm_out <= (counter < duty_cycle);
    end

endmodule
