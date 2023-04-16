module traffic_signal (
  input clk,
  input reset,
  output reg red,
  output reg green,
  output reg yellow
);

reg [1:0] state;
reg [7:0] mem [0:3]; // tek portlu RAM, 4 girise sahip

parameter RED_DELAY = 20000000; // 20 milyon dongu
parameter GREEN_DELAY = 30000000; // 30 milyon dongu
parameter YELLOW_DELAY = 5000000; // 5 milyon dongu

always @(posedge clk) begin
  if (reset) begin
    state <= 2'b01;
  end else begin
    case (state)
      2'b01: begin // red
        red <= 1;
        green <= 0;
        yellow <= 0;
        if (mem[0] == 8'b0) begin
          state <= 2'b10;
        end
      end
      2'b10: begin // green
        red <= 0;
        green <= 1;
        yellow <= 0;
        if (mem[1] == 8'b0) begin
          state <= 2'b11;
        end
      end
      2'b11: begin // yellow
        red <= 0;
        green <= 0;
        yellow <= 1;
        if (mem[2] == 8'b0) begin
          state <= 2'b01;
        end
      end
      default: begin
        state <= 2'b01;
      end
    endcase
  end
end

// RAM yazma mantigi
always @(posedge clk) begin
  if (reset) begin
    mem[0] <= 8'b0;
    mem[1] <= 8'b0;
    mem[2] <= 8'b0;
    mem[3] <= 8'b0;
  end else begin
    mem[0] <= #RED_DELAY (mem[0] + 1);
    mem[1] <= #GREEN_DELAY (mem[1] + 1);
    mem[2] <= #YELLOW_DELAY (mem[2] + 1);
    mem[3] <= #RED_DELAY (mem[3] + 1);
  end
end

endmodule