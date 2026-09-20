module router_fifo(clk,resetn,soft_reset,write_enb,read_enb,lfd_state,datain,full,empty,dataout);

input clk,resetn,soft_reset,write_enb,read_enb,lfd_state;
input [7:0] datain;
output full,empty;
output [7:0] dataout;

reg full,empty;
reg [7:0] dataout;
reg [3:0] rd_ptr,wr_ptr;
reg [6:0] count;
reg temp;

// flat 16x8 memory
reg [7:0] mem0,mem1,mem2,mem3,mem4,mem5,mem6,mem7;
reg [7:0] mem8,mem9,mem10,mem11,mem12,mem13,mem14,mem15;

// lfd latch
always@(posedge clk)
begin
  if(!resetn) temp <= 1'b0;
  else        temp <= lfd_state;
end

// write
always@(posedge clk)
begin
  if(!resetn || soft_reset) begin
    wr_ptr <= 4'd0;
    mem0<=8'd0; mem1<=8'd0; mem2<=8'd0; mem3<=8'd0;
    mem4<=8'd0; mem5<=8'd0; mem6<=8'd0; mem7<=8'd0;
    mem8<=8'd0; mem9<=8'd0; mem10<=8'd0; mem11<=8'd0;
    mem12<=8'd0; mem13<=8'd0; mem14<=8'd0; mem15<=8'd0;
  end
  else if(write_enb && !full) begin
    case(wr_ptr)
      4'd0:  mem0  <= datain;
      4'd1:  mem1  <= datain;
      4'd2:  mem2  <= datain;
      4'd3:  mem3  <= datain;
      4'd4:  mem4  <= datain;
      4'd5:  mem5  <= datain;
      4'd6:  mem6  <= datain;
      4'd7:  mem7  <= datain;
      4'd8:  mem8  <= datain;
      4'd9:  mem9  <= datain;
      4'd10: mem10 <= datain;
      4'd11: mem11 <= datain;
      4'd12: mem12 <= datain;
      4'd13: mem13 <= datain;
      4'd14: mem14 <= datain;
      4'd15: mem15 <= datain;
    endcase
    wr_ptr <= wr_ptr + 4'd1;
  end
end

// read
always@(posedge clk)
begin
  if(!resetn || soft_reset) begin
    rd_ptr  <= 4'd0;
    dataout <= 8'd0;
  end
  else if(read_enb && !empty) begin
    case(rd_ptr)
      4'd0:  dataout <= mem0;
      4'd1:  dataout <= mem1;
      4'd2:  dataout <= mem2;
      4'd3:  dataout <= mem3;
      4'd4:  dataout <= mem4;
      4'd5:  dataout <= mem5;
      4'd6:  dataout <= mem6;
      4'd7:  dataout <= mem7;
      4'd8:  dataout <= mem8;
      4'd9:  dataout <= mem9;
      4'd10: dataout <= mem10;
      4'd11: dataout <= mem11;
      4'd12: dataout <= mem12;
      4'd13: dataout <= mem13;
      4'd14: dataout <= mem14;
      4'd15: dataout <= mem15;
    endcase
    rd_ptr <= rd_ptr + 4'd1;
  end
end

// count / full / empty
always@(posedge clk)
begin
  if(!resetn || soft_reset) begin
    count <= 7'd0;
    full  <= 1'b0;
    empty <= 1'b1;
  end
  else begin
    case({(write_enb && !full),(read_enb && !empty)})
      2'b10: count <= count + 7'd1;
      2'b01: count <= count - 7'd1;
      default: count <= count;
    endcase
    full  <= (count == 7'd16);
    empty <= (count == 7'd0);
  end
end

endmodule
