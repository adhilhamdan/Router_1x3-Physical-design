module router_fsm(clk,resetn,pkt_valid,datain,fifo_full,
                  fifo_empty_0,fifo_empty_1,fifo_empty_2,
                  soft_reset_0,soft_reset_1,soft_reset_2,
                  parity_done,low_packet_valid,
                  detect_add,ld_state,laf_state,full_state,
                  write_enb_reg,rst_int_reg,lfd_state,busy);

input clk,resetn,pkt_valid,fifo_full;
input [1:0] datain;
input fifo_empty_0,fifo_empty_1,fifo_empty_2;
input soft_reset_0,soft_reset_1,soft_reset_2;
input parity_done,low_packet_valid;

output detect_add,ld_state,laf_state,full_state;
output write_enb_reg,rst_int_reg,lfd_state,busy;

reg detect_add,ld_state,laf_state,full_state;
reg write_enb_reg,rst_int_reg,lfd_state,busy;

reg [2:0] state;
reg fifo_empty_sel;

// state encoding
// 0=DECODE_ADDRESS 1=LOAD_FIRST_DATA 2=LOAD_DATA
// 3=LOAD_PARITY 4=FIFO_FULL_STATE 5=WAIT_TILL_EMPTY

always@(*)
begin
  if(datain == 2'b00)      fifo_empty_sel = fifo_empty_0;
  else if(datain == 2'b01) fifo_empty_sel = fifo_empty_1;
  else if(datain == 2'b10) fifo_empty_sel = fifo_empty_2;
  else                     fifo_empty_sel = 1'b0;
end

always@(posedge clk)
begin
  if(!resetn)
    state <= 3'd0;
  else if(soft_reset_0 || soft_reset_1 || soft_reset_2)
    state <= 3'd0;
  else
    case(state)
      3'd0: begin // DECODE_ADDRESS
        if(pkt_valid && (datain==2'b00||datain==2'b01||datain==2'b10))
          state <= fifo_empty_sel ? 3'd1 : 3'd5;
        else
          state <= 3'd0;
      end
      3'd1: state <= 3'd2; // LOAD_FIRST_DATA -> LOAD_DATA
      3'd2: begin // LOAD_DATA
        if(fifo_full)       state <= 3'd4;
        else if(!pkt_valid) state <= 3'd3;
        else                state <= 3'd2;
      end
      3'd3: begin // LOAD_PARITY
        if(parity_done) state <= 3'd0;
        else            state <= 3'd3;
      end
      3'd4: begin // FIFO_FULL_STATE
        if(!fifo_full) state <= 3'd2;
        else           state <= 3'd4;
      end
      3'd5: begin // WAIT_TILL_EMPTY
        if(fifo_empty_sel) state <= 3'd1;
        else               state <= 3'd5;
      end
      default: state <= 3'd0;
    endcase
end

always@(*)
begin
  detect_add    = (state == 3'd0);
  lfd_state     = (state == 3'd1);
  ld_state      = (state == 3'd2);
  full_state    = (state == 3'd4);
  laf_state     = (state == 3'd4) && !fifo_full;
  rst_int_reg   = (state == 3'd0);
  write_enb_reg = (state == 3'd2) ||
                  ((state == 3'd4) && !fifo_full) ||
                  ((state == 3'd3) && !parity_done);
  busy          = (state == 3'd4) ||
                  (state == 3'd5) ||
                  ((state == 3'd3) && parity_done);
end

endmodule
