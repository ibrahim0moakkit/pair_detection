`timescale 1ns/1ns

module seq_det_tb;
reg reset,in,clk=0;
wire out;

seq_det u1(clk,reset,in,out);

always begin clk=~clk; #10; end

always @(*) begin
$display("%0t time= reset=%b in=%b out=%b ",$time,reset,in,out);

end

initial begin
reset=1'b1;
#20;
reset=1'b0;
in=0;
#20;
in=0;
#20;
in=1;
#20;
in=1;
#20;
in=0;
#20;

end



endmodule



module seq_det(input clk,reset,in,
               output reg out); 
reg [2:0] curr_state, next_state;
//states 
parameter IDLE=3'b000;
parameter s_0=3'b001;
parameter s_1=3'b010;
parameter s_01=3'b011;
parameter s_10=3'b100;
parameter s_00=3'b101;
parameter s_11=3'b110;



// current state logic
always @(posedge clk) begin
if(reset) curr_state<=IDLE;
else curr_state<=next_state;
end

// output logic, noore machine
always @(curr_state)
begin
if(curr_state==s_11 || curr_state==s_00) out=1;
else out=0;
end

//next state logic

always @(in or curr_state)
begin
case (curr_state)
IDLE: next_state=(in)?s_1:s_0;
s_0: next_state=(in)?s_01:s_00;
s_1: next_state=(in)?s_11:s_10;
s_01: next_state=(in)?s_11:s_10;
s_10: next_state=(in)?s_01:s_00;
s_11: next_state=(in)?s_11:s_10;
s_00: next_state=(in)?s_01:s_00;
endcase
end

endmodule





