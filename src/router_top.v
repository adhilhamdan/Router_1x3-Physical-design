module router_top(clk,resetn,pkt_valid,datain,
                  read_enb_0,read_enb_1,read_enb_2,
                  dout_0,dout_1,dout_2,
                  vld_out_0,vld_out_1,vld_out_2,
                  err,busy);

input clk,resetn,pkt_valid;
input [7:0] datain;
input read_enb_0,read_enb_1,read_enb_2;

output [7:0] dout_0,dout_1,dout_2;
output vld_out_0,vld_out_1,vld_out_2;
output err,busy;

wire detect_add,ld_state,laf_state,full_state;
wire write_enb_reg,rst_int_reg,lfd_state;
wire parity_done,low_packet_valid,fifo_full;
wire [2:0] write_enb;
wire [2:0] soft_reset;
wire empty_0,empty_1,empty_2;
wire [7:0] dout_reg;

router_fsm u_fsm(
  .clk(clk),.resetn(resetn),
  .pkt_valid(pkt_valid),.datain(datain[1:0]),
  .fifo_full(fifo_full),
  .fifo_empty_0(empty_0),.fifo_empty_1(empty_1),.fifo_empty_2(empty_2),
  .soft_reset_0(soft_reset[0]),.soft_reset_1(soft_reset[1]),.soft_reset_2(soft_reset[2]),
  .parity_done(parity_done),.low_packet_valid(low_packet_valid),
  .detect_add(detect_add),.ld_state(ld_state),.laf_state(laf_state),
  .full_state(full_state),.write_enb_reg(write_enb_reg),
  .rst_int_reg(rst_int_reg),.lfd_state(lfd_state),.busy(busy)
);

router_reg u_reg(
  .clk(clk),.resetn(resetn),
  .pkt_valid(pkt_valid),.datain(datain),
  .detect_add(detect_add),.ld_state(ld_state),.laf_state(laf_state),
  .full_state(full_state),.lfd_state(lfd_state),.rst_int_reg(rst_int_reg),
  .dout(dout_reg),.err(err),
  .parity_done(parity_done),.low_packet_valid(low_packet_valid)
);

router_sync u_sync(
  .clk(clk),.resetn(resetn),
  .datain(datain[1:0]),.detect_add(detect_add),
  .write_enb_reg(write_enb_reg),.parity_done(parity_done),
  .soft_reset_0(soft_reset[0]),.soft_reset_1(soft_reset[1]),.soft_reset_2(soft_reset[2]),
  .low_packet_valid(low_packet_valid),
  .fifo_empty_0(empty_0),.fifo_empty_1(empty_1),.fifo_empty_2(empty_2),
  .fifo_full(fifo_full),
  .vld_out_0(vld_out_0),.vld_out_1(vld_out_1),.vld_out_2(vld_out_2),
  .write_enb(write_enb)
);

router_fifo u_fifo0(
  .clk(clk),.resetn(resetn),.soft_reset(soft_reset[0]),
  .write_enb(write_enb[0]),.read_enb(read_enb_0),
  .lfd_state(lfd_state),.datain(dout_reg),
  .full(),.empty(empty_0),.dataout(dout_0)
);

router_fifo u_fifo1(
  .clk(clk),.resetn(resetn),.soft_reset(soft_reset[1]),
  .write_enb(write_enb[1]),.read_enb(read_enb_1),
  .lfd_state(lfd_state),.datain(dout_reg),
  .full(),.empty(empty_1),.dataout(dout_1)
);

router_fifo u_fifo2(
  .clk(clk),.resetn(resetn),.soft_reset(soft_reset[2]),
  .write_enb(write_enb[2]),.read_enb(read_enb_2),
  .lfd_state(lfd_state),.datain(dout_reg),
  .full(),.empty(empty_2),.dataout(dout_2)
);

endmodule
