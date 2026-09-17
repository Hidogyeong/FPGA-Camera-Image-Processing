
// 모듈 선언
module i2cset (MCLK, MRESETn,
               I_WRITE, I_SLV_ADDR, I_REG_ADDR, I_WDATA, I_READY);

  // 입력, 출력 선언
  input MCLK;
  input MRESETn;
  output I_WRITE;
  output [6:0] I_SLV_ADDR;
  output [7:0] I_REG_ADDR;
  output [7:0] I_WDATA;
  input I_READY;

  // wire 선언
  wire I_WRITE;
  wire [6:0] I_SLV_ADDR;
  wire [7:0] I_REG_ADDR;
  wire [7:0] I_WDATA;

  // reg 선언
  reg next_mstate, curr_mstate;
  reg [15:0] next_i2c_status, curr_i2c_status;
  reg next_i2c_start, curr_i2c_start;
  reg next_ideadyp, curr_ideadyp;
  reg [14:0] next_count1, curr_count1;
  reg [14:0] next_count2, curr_count2;
  reg [31:0] i2c_reg;

  // 출력 포트에 reg를 연결
  assign I_WRITE = ~i2c_reg[31];
  assign I_SLV_ADDR = i2c_reg[22:16];
  assign I_REG_ADDR = i2c_reg[15:8];
  assign I_WDATA = i2c_reg[7:0];

  // I2C 장치에 넣어줄 값들을 지정
  // i2c_reg가 32'h00200118이 저장되면,
  // Device 주소는 8'h20 부분이 되고, 실제 spec상의 device 주소는 8'h40이다.
  // Device 내의 Sub 주소는 8'h01이다.
  // Device 내의 Sub 주소에 입력되는 값은 8'h18이다.
  // combinational logic
  always@(curr_mstate or I_READY or curr_i2c_start or curr_ideadyp or
          curr_i2c_status or curr_count1 or curr_count2)
  begin
  i2c_reg <= 32'h80000000;
  next_ideadyp <= I_READY;
  next_mstate <= curr_mstate;
  next_i2c_start <= curr_i2c_start;
  next_i2c_status <= curr_i2c_status;
  next_count1 <= curr_count1;
  next_count2 <= curr_count2;
  if (curr_mstate == 1'b1)
    begin
    if ((curr_i2c_start == 1'b1) && (I_READY == 1'b1) && (curr_ideadyp == 1'b0))
      begin
      next_i2c_status <= curr_i2c_status + 1;
      next_count2 <= 15'h0000;
      end
    case (curr_i2c_status)
      16'h0000:
        begin
        next_count1 <= curr_count1 + 1;
        if (curr_count1 == 15'd1000)
          begin
            next_count1 <= 15'd0000;
            next_count2 <= curr_count2 + 1;
            if (curr_count2 == 15'd1000)
              begin
              next_i2c_start <= 1'b1;
              i2c_reg <= 32'h00200011;
              next_count2 <= 15'd0000;
              end
          end
        end
      16'h0001: begin i2c_reg <= 32'h00200118; end
      16'h0002: begin i2c_reg <= 32'h00000000; end
      16'h0003: begin i2c_reg <= 32'h0020062C; end
      16'h0004: begin i2c_reg <= 32'h00208000; end
      16'h0005: begin i2c_reg <= 32'h00208100; end
      16'h0006: begin i2c_reg <= 32'h00208200; end
      16'h0007: begin i2c_reg <= 32'h00208300; end
      16'h0008: begin i2c_reg <= 32'h00208402; end
      16'h0009: begin i2c_reg <= 32'h00208520; end
      16'h000A: begin i2c_reg <= 32'h00208603; end
      16'h000B: begin i2c_reg <= 32'h002087C0; end
      default: begin next_mstate <= 1'b0; end
    endcase
	 end
  else
    next_mstate <= 1'b0;
  end

  // sequential logic
  // 바로 앞에 combinational logic과 연결된 flip-flop 들이다.
  always@(negedge MCLK or negedge MRESETn)
  begin
  if (MRESETn == 1'b0)
    begin
    curr_mstate <= 1'b1;
    curr_ideadyp <= 1'b1;
    curr_i2c_start <= 1'b0;
    curr_i2c_status <= 16'h0000;
    curr_count1 <= 15'h0000;
    curr_count2 <= 15'h0000;
    end
  else
    begin
    curr_mstate <= next_mstate;
    curr_ideadyp <= next_ideadyp;
    curr_i2c_start <= next_i2c_start;
    curr_i2c_status <= next_i2c_status;
    curr_count1 <= next_count1;
    curr_count2 <= next_count2;
    end
  end

endmodule
