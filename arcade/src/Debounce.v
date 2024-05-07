module Debounce (Clk,Key,oDeb);
	input Clk;
	input Key;
	output oDeb;
	
	reg [3:0] ShiftReg;
	reg oDeb;
	
	always @(posedge Clk) begin
	
		ShiftReg<={ShiftReg[3:1],Key};
		if (ShiftReg==4'b0000)
			oDeb<=1'b1;
		else
			oDeb<=1'b0;
	end
endmodule
