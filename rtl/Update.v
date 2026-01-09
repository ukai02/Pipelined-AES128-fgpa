module Update(clk,reset,r_in,r_out);

input clk;
input reset;
input [127:0]r_in;
output reg [127:0]r_out;


always @(posedge clk or posedge reset)
begin
	if(reset)
	begin
        r_out <= 128'h0;
	end
	else
	begin
		r_out<=r_in;
	end
end
endmodule