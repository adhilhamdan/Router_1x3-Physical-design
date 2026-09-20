module router_sync(clk,resetn,datain,detect_add,write_enb_reg,
                   parity_done,soft_reset_0,soft_reset_1,soft_reset_2,
                   low_packet_valid,fifo_empty_0,fifo_empty_1,fifo_empty_2,
                   fifo_full,vld_out_0,vld_out_1,vld_out_2,write_enb);

input clk,resetn,detect_add,write_enb_reg,parity_done,low_packet_valid;
input [1:0] datain;
input soft_reset_0,soft_reset_1,soft_reset_2;
input fifo_empty_0,fifo_empty_1,fifo_empty_2;

output fifo_full,vld_out_0,vld_out_1,vld_out_2;
output [2:0] write_enb;

reg fifo_full,vld_out_0,vld_out_1,vld_out_2;
reg [2:0] write_enb;
reg [1:0] addr;

// latch address
always@(posedge clk)
begin
  if(!resetn)
    addr <= 2'd0;
  else if(detect_add)
    addr <= datain;
end

// write enable
always@(*)
begin
  write_enb = 3'b000;
  if(write_enb_reg) begin
    if(addr == 2'b00)      write_enb = 3'b001;
    else if(addr == 2'b01) write_enb = 3'b010;
    else if(addr == 2'b10) write_enb = 3'b100;
  end
end

// fifo full
always@(*)
begin
  if(addr == 2'b00)      fifo_full = ~fifo_empty_0;
  else if(addr == 2'b01) fifo_full = ~fifo_empty_1;
  else if(addr == 2'b10) fifo_full = ~fifo_empty_2;
  else                   fifo_full = 1'b0;
end

// vld_out_0
always@(posedge clk)
begin
  if(!resetn || soft_reset_0)
    vld_out_0 <= 1'b0;
  else if(parity_done && addr == 2'b00)
    vld_out_0 <= 1'b1;
  else if(fifo_empty_0)
    vld_out_0 <= 1'b0;
end

// vld_out_1
always@(posedge clk)
begin
  if(!resetn || soft_reset_1)
    vld_out_1 <= 1'b0;
  else if(parity_done && addr == 2'b01)
    vld_out_1 <= 1'b1;
  else if(fifo_empty_1)
    vld_out_1 <= 1'b0;
end

// vld_out_2
always@(posedge clk)
begin
  if(!resetn || soft_reset_2)
    vld_out_2 <= 1'b0;
  else if(parity_done && addr == 2'b10)
    vld_out_2 <= 1'b1;
  else if(fifo_empty_2)
    vld_out_2 <= 1'b0;
end

endmodule
