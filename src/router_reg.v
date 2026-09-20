module router_reg(clk,resetn,pkt_valid,datain,detect_add,
                  ld_state,laf_state,full_state,lfd_state,
                  rst_int_reg,dout,err,parity_done,low_packet_valid);

input clk,resetn,pkt_valid;
input [7:0] datain;
input detect_add,ld_state,laf_state,full_state,lfd_state,rst_int_reg;

output [7:0] dout;
output err,parity_done,low_packet_valid;

reg [7:0] dout;
reg err,parity_done,low_packet_valid;
reg [7:0] header_byte,fifo_full_byte;
reg [7:0] internal_parity,packet_parity;

// dout register
always@(posedge clk)
begin
  if(!resetn)
    dout <= 8'd0;
  else if(detect_add && pkt_valid)
    header_byte <= datain;
  else if(lfd_state)
    dout <= header_byte;
  else if(ld_state && !full_state)
    dout <= datain;
  else if(laf_state)
    dout <= fifo_full_byte;
end

// fifo full byte
always@(posedge clk)
begin
  if(!resetn)
    fifo_full_byte <= 8'd0;
  else if(full_state)
    fifo_full_byte <= datain;
end

// internal parity
always@(posedge clk)
begin
  if(!resetn || rst_int_reg)
    internal_parity <= 8'd0;
  else if(lfd_state)
    internal_parity <= internal_parity ^ header_byte;
  else if(ld_state)
    internal_parity <= internal_parity ^ datain;
end

// packet parity
always@(posedge clk)
begin
  if(!resetn)
    packet_parity <= 8'd0;
  else if(ld_state && !pkt_valid)
    packet_parity <= datain;
end

// parity done
always@(posedge clk)
begin
  if(!resetn || rst_int_reg)
    parity_done <= 1'b0;
  else if(ld_state && !pkt_valid)
    parity_done <= 1'b1;
  else if(laf_state && low_packet_valid)
    parity_done <= 1'b1;
end

// low packet valid
always@(posedge clk)
begin
  if(!resetn || rst_int_reg)
    low_packet_valid <= 1'b0;
  else if(ld_state && !pkt_valid)
    low_packet_valid <= 1'b1;
  else
    low_packet_valid <= 1'b0;
end

// error
always@(posedge clk)
begin
  if(!resetn)
    err <= 1'b0;
  else if(parity_done)
    err <= (internal_parity != packet_parity);
  else
    err <= 1'b0;
end

endmodule
