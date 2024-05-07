module Pseudo_Random(Clk,Rst,Gen,Show_Num);
	input Clk;
	input Rst;
	input Gen;
	output [7:0] Show_Num;
	
	wire xor1,xor2,xor3;
	wire [7:0] Rd_Out;
	
	assign xor1= (!Rst) ? 1'b1 : (Rd_Out[1] ^ Rd_Out[7]) ;
	assign xor2= Rd_Out[2] ^ Rd_Out [7];
	assign xor3= Rd_Out[3] ^ Rd_Out[7];
	assign Show_Num = (!Gen)? Rd_Out : Show_Num;
	
	D_FF u1(.Clk(Clk),.D(Rd_Out[7]),.Q(Rd_Out[0]));
	D_FF u2(.Clk(Clk),.D(Rd_Out[0]),.Q(Rd_Out[1]));
	D_FF u3(.Clk(Clk),.D(xor1),.Q(Rd_Out[2]));
	D_FF u4(.Clk(Clk),.D(xor2),.Q(Rd_Out[3]));
	D_FF u5(.Clk(Clk),.D(xor3),.Q(Rd_Out[4]));
	D_FF u6(.Clk(Clk),.D(Rd_Out[4]),.Q(Rd_Out[5]));
	D_FF u7(.Clk(Clk),.D(Rd_Out[5]),.Q(Rd_Out[6]));
	D_FF u8(.Clk(Clk),.D(Rd_Out[6]),.Q(Rd_Out[7]));
	
	
endmodule
