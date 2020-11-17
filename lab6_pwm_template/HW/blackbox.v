module blackbox (
	input clock,
	input reset,
	input  [31:0] a,
	input  [31:0] b,
	output reg [31:0] s 
);
always @(posedge clock) begin
	if(reset) begin
		s <= 0;
	end else begin
		s <= a + b;
 	end
end
endmodule