module PWM_Control #(
    parameter CLK_FREQ = 25_000_000
)(
    input  wire clk,
    input  wire rst_n,
    output wire [7:0] leds
);

    wire pwm_out;
    reg [15:0] duty_cycle = 0;
    reg [15:0] period = CLK_FREQ / 1250; // 1.25 kHz
    reg dir = 1; // 1: aumentando, 0: diminuindo

    // Instancia o PWM
    PWM pwm_inst (
        .clk(clk),
        .rst_n(rst_n),
        .duty_cycle(duty_cycle),
        .period(period),
        .pwm_out(pwm_out)
    );

    // Controle do fade
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            duty_cycle <= 0;
        else begin
            if (dir)
                duty_cycle <= duty_cycle + 1;
            else
                duty_cycle <= duty_cycle - 1;

            if (duty_cycle >= period * 70 / 100)
                dir <= 0;
            else if (duty_cycle <= period / 100) // ~0.0025%
                dir <= 1;
        end
    end


    assign leds = {8{pwm_out}}; // todos LEDs refletem o PWM

endmodule
