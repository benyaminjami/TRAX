module test;
reg p;
wire q;
assign q = p;
initial
begin
p = 1;
#1 p = 0;
$display(q);
end 

endmodule