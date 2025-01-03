// DO NOT CHANGE THE NAME OR THE SIGNALS OF THIS MODULE


/* Your design goes here. */

module battleship (
  input            clk  ,
  input            rst  ,
  input            start,
  input      [1:0] X    ,
  input      [1:0] Y    ,
  input            pAb  ,
  input            pBb  ,
  output reg [7:0] disp0,
  output reg [7:0] disp1,
  output reg [7:0] disp2,
  output reg [7:0] disp3,
  output reg [7:0] led
);

/* Your design goes here. */
parameter IDLE        = 4'b0000;
parameter SHOW_A      = 4'b0001;
parameter SET_A       = 4'b0010;
parameter SHOW_B      = 4'b0011;
parameter SET_B       = 4'b0100;
parameter A_SHOOT     = 4'b0101;
parameter B_SHOOT     = 4'b0110;
parameter A_SINK      = 4'b0111;
parameter B_SINK      = 4'b1000;
parameter A_WIN       = 4'b1001;
parameter B_WIN       = 4'b1010;
parameter ERROR_A     = 4'b1011;
parameter ERROR_B     = 4'b1100;
parameter SHOW_SCORE  = 4'b1101;

reg [15:0] mapA;
reg [15:0] mapB;
reg [3:0] scoreA;
reg [3:0] scoreB;
reg [3:0] currentState;
reg [3:0] next_state;
reg [2:0] inputCountA;
reg [2:0] inputCountB;
reg [8:0] timer;
reg Z;

always @(posedge clk) begin

  if (rst) begin
    currentState <= IDLE;
  end
  else begin
    case (currentState)
      IDLE: begin

        mapA <= 16'b0000000000000000;
        mapB <= 16'b0000000000000000;
        scoreA <= 4'b0000;
        scoreB <= 4'b0000;
        inputCountA <= 3'b000;
        inputCountB <= 3'b000;
        timer <= 3'b000;

        if (start) begin
          currentState <= SHOW_A;
        end
        else begin
          currentState <= IDLE;
        end
      end
      SHOW_A: begin
        if (timer < 50) begin
          timer <= timer + 1;
          currentState <= SHOW_A;
        end
        else begin
          timer <= 0;
          currentState <= SET_A;
        end
      end

      SET_A: begin
        if (pAb) begin
          if (mapA[X * 4 + Y]) begin
            currentState <= ERROR_A;
          end
          else begin
            if(inputCountA > 2) begin
              mapA[X * 4 + Y] <= 1;
              currentState <= SHOW_B;
            end
            else begin
              mapA[X * 4 + Y] <= 1;
              inputCountA <= inputCountA + 1;
              currentState <= SET_A;
            end
          end
        end
        else begin
          currentState <= SET_A;
        end
      end

      ERROR_A: begin
        if (timer < 50) begin
          currentState <= ERROR_A;
          timer <= timer + 1;
        end
        else begin
          currentState <= SET_A;
          timer <= 0;
        end
      end

      SHOW_B: begin
        if (timer < 50) begin
          currentState <= SHOW_B;
          timer <= timer + 1;
        end
        else begin
          currentState <= SET_B;
          timer <= 0;
        end
      end

      SET_B :
      begin
        if (pBb) begin
          if (mapB[X * 4 + Y]) begin
            currentState <= ERROR_B;
          end
          else begin
            if(inputCountB > 2) begin
              mapB[X * 4 + Y] <= 1;
              currentState <= SHOW_SCORE;
            end
            else begin
              mapB[X * 4 + Y] <= 1;
              inputCountB <= inputCountB + 1;
              currentState <= SET_B;
            end
          end
        end
        else begin
          currentState <= SET_B;
        end
      end

      ERROR_B: begin
        if (timer < 50) begin
          currentState <= ERROR_B;
          timer <= timer + 1;
        end
        else begin
          currentState <= SET_B;
          timer <= 0;
        end
      end

      SHOW_SCORE: begin
        if (timer < 50) begin
          currentState <= SHOW_SCORE;
          timer <= timer + 1;
        end
        else begin
          currentState <= A_SHOOT;
          timer <= 0;
        end
      end

      A_SHOOT:
      begin
        if (pAb) begin
          if (mapB[X * 4 + Y]) begin
            scoreA <= scoreA + 1;
            mapB[X * 4 + Y] <= 0;
            Z <= 1;
            currentState <= A_SINK;
          end
          else begin
            Z <= 0;
            scoreA <= scoreA;
            currentState <= A_SINK;
          end
        end
        else begin
          currentState <= A_SHOOT;
        end
      end

      A_SINK:
      begin
        if (timer < 50) begin
          currentState <= A_SINK;
          timer <= timer + 1;
        end
        else begin
          timer <= 0;
          if (scoreA > 3) begin
            currentState <= A_WIN;
          end
          else begin
            currentState <= B_SHOOT;
          end
        end
      end

      A_WIN:
      begin
        if (timer < 50)
        begin
          timer <= timer + 1;
          currentState <= A_WIN;
        end

        else if (timer<100)
        begin
          timer <= timer + 1;
          currentState <= A_WIN;
        end
        else 
        begin
          timer <= 0;
          currentState <= A_WIN;
        end
     

      end
     
      B_SHOOT:
      begin
        if (pBb) begin
          if (mapA[X * 4 + Y]) begin
            scoreB <= scoreB + 1;
            mapA[X * 4 + Y] <= 0;
            Z <= 1;
            currentState <= B_SINK;
          end
          else begin
            Z <= 0;
            scoreB <= scoreB;
            currentState <= B_SINK;
          end
        end
        else begin
          currentState <= B_SHOOT;
        end
      end

      B_SINK:
      begin
        if (timer < 50) begin
          currentState <= B_SINK;
          timer <= timer + 1;
        end
        else begin
          if (scoreB > 3) begin
            currentState <= B_WIN;
          end
          else begin
            currentState <= A_SHOOT;
          end
          timer <= 0;
        end
      end

      B_WIN: 
      begin
        if (timer < 50)
        begin
          timer <= timer + 1;
          currentState <= B_WIN;
        end

        else if (timer<100)
        begin
          timer <= timer + 1;
          currentState <= B_WIN;
        end
        else 
        begin
          timer <= 0;
          currentState <= B_WIN;
        end
     

      end
      
    endcase
  end
end

always @ (*)
begin
  case (currentState)
    IDLE: begin
      disp0 = 8'b01111001; // "E"
      disp1 = 8'b00111000; // "L"
      disp2 = 8'b01011110; // "d"
      disp3 = 8'b00000110; // "I"
      led = 8'b10011001;
    end

    SHOW_A: begin
      disp0 = 8'b00000000;
      disp1 = 8'b00000000;
      disp2 = 8'b00000000;
      disp3 = 8'b01110111; // "A"

      led[7] = 1;
      led[6] = 0;
      led[5] = 0;
      led[4] = 0;
      led[3] = 0;
      led[2] = 0;
      led[1] = 0;
      led[0] = 0;
    end

    SET_A: begin
      disp3 = 8'b00000000;
      disp2 = 8'b00000000;

      if (X == 2'b00)  // 0
        disp1 = 8'b00111111;

      else if (X == 2'b01) // 1
        disp1 = 8'b00000110;

      else if (X == 2'b10) // 2
        disp1 = 8'b01011011;

      else if (X == 2'b11) // 3
        disp1 = 8'b01001111;
        else 
          disp1 = 8'b00000000;


      if (Y == 2'b00)  // 0
        disp0 = 8'b00111111;

      else if (Y == 2'b01) // 1
        disp0 = 8'b00000110;

      else if (Y == 2'b10) // 2
        disp0 = 8'b01011011;

      else if (Y == 2'b11) // 3
        disp0 = 8'b01001111;
        else 
          disp0 = 8'b00000000;

      led[4] = inputCountA[0];
      led[5] = inputCountA[1];
      led[7] = 1;

      led[0] = 0;
      led[1] = 0;
      led[2] = 0;
      led[3] = 0;
      led[6] = 0;
    end

    ERROR_A: begin
      disp0 = 8'b01011100; // "o"
      disp1 = 8'b01010000; // "r"
      disp2 = 8'b01010000; // "r"
      disp3 = 8'b01111001; // "E"

      led[7] = 1;
      led[4] = 1;
      led[3] = 1;
      led[0] = 1;

      led[6] = 0;
      led[5] = 0;
      led[2] = 0;
      led[1] = 0;
    end

    A_SHOOT: begin
      disp3 = 8'b00000000;
      disp2 = 8'b00000000;

      if (X == 2'b00)  // 0
        disp1 = 8'b00111111;

      else if (X == 2'b01) // 1
        disp1 = 8'b00000110;

      else if (X == 2'b10) // 2
        disp1 = 8'b01011011;

      else if (X == 2'b11) // 3
        disp1 = 8'b01001111;
        else 
          disp1 = 8'b00000000;


      if (Y == 2'b00)  // 0
        disp0 = 8'b00111111;

      else if (Y == 2'b01) // 1
        disp0 = 8'b00000110;

      else if (Y == 2'b10) // 2
        disp0 = 8'b01011011;

      else if (Y == 2'b11) // 3
        disp0 = 8'b01001111;
        else 
          disp0 = 8'b00000000;

      led[4] = scoreA[0];
      led[5] = scoreA[1];
      led[2] = scoreB[0];
      led[3] = scoreB[1];

      led[7] = 1;
      led[6] = 0;
      led[1] = 0;
      led[0] = 0;
    end

    A_SINK: begin
      disp3 = 8'b00000000;
      if (scoreA == 0)
        disp2 = 8'b00111111; // 0
      else if (scoreA == 1)
        disp2 = 8'b00000110; // 1
      else if (scoreA == 2)
        disp2 = 8'b01011011; // 2
      else if (scoreA == 3)
        disp2 = 8'b01001111;  // 3
      else
        disp2 = 8'b01100110;  // 4

      disp1 = 8'b01000000; // -

      if (scoreB == 0)
        disp0 = 8'b00111111; // 0
      else if (scoreB == 1)
        disp0 = 8'b00000110; // 1
      else if (scoreB == 2)
        disp0 = 8'b01011011; // 2
      else if (scoreB == 3)
        disp0 = 8'b01001111;  // 3
      else
        disp0 = 8'b01100110;  // 4

      if (Z)
          led[7:0] = 8'b11111111;
      else
          led[7:0] = 8'b00000000;
      end

      SHOW_B: begin
      disp0 = 8'b00000000;
      disp1 = 8'b00000000;
      disp2 = 8'b00000000;
      disp3 = 8'b01111100; // B ama küçük

      led[7] = 1;
      led[4] = 1;
      led[3] = 1;
      led[0] = 1;

      led[6] = 0;
      led[5] = 0;
      led[2] = 0;
      led[1] = 0;
    end

    SET_B: begin
      disp3 = 8'b00000000;
      disp2 = 8'b00000000;

      if (X == 2'b00)  // 0
        disp1 = 8'b00111111;

      else if (X == 2'b01) // 1
        disp1 = 8'b00000110;

      else if (X == 2'b10) // 2
        disp1 = 8'b01011011;

      else if (X == 2'b11) // 3
        disp1 = 8'b01001111;
      else 
          disp1 = 8'b00000000;

      if (Y == 2'b00)  // 0
        disp0 = 8'b00111111;

      else if (Y == 2'b01) // 1
        disp0 = 8'b00000110;

      else if (Y == 2'b10) // 2
        disp0 = 8'b01011011;

      else if (Y == 2'b11) // 3
        disp0 = 8'b01001111;
      else 
          disp0 = 8'b00000000;

      led[2] = inputCountB[0];
      led[3] = inputCountB[1];
      led[0] = 1;

      led[7] = 0;
      led[6] = 0;
      led[5] = 0;
      led[4] = 0;
      led[1] = 0;
    end

    ERROR_B: begin
      disp0 = 8'b01011100; // o
      disp1 = 8'b01010000; // r
      disp2 = 8'b01010000; // r
      disp3 = 8'b01111001; // E

      led[7] = 1;
      led[4] = 1;
      led[3] = 1;
      led[1] = 1;

      led[6] = 0;
      led[5] = 0;
      led[2] = 0;
      led[0] = 0;
    end

    B_SHOOT: begin
      disp3 = 8'b00000000;
      disp2 = 8'b00000000;

      if (X == 2'b00)  // 0
        disp1 = 8'b00111111;

      else if (X == 2'b01) // 1
        disp1 = 8'b00000110;

      else if (X == 2'b10) // 2
        disp1 = 8'b01011011;

      else if (X == 2'b11) // 3
        disp1 = 8'b01001111;
      else 
          disp1 = 8'b00000000;

      if (Y == 2'b00)  // 0
        disp0 = 8'b00111111;

      else if (Y == 2'b01) // 1
        disp0 = 8'b00000110;

      else if (Y == 2'b10) // 2
        disp0 = 8'b01011011;

      else if (Y == 2'b11) // 3
        disp0 = 8'b01001111;
      else 
          disp0 = 8'b00000000;

      led[4] = scoreA[0];
      led[5] = scoreA[1];
      led[2] = scoreB[0];
      led[3] = scoreB[1];


      led[7] = 0;
      led[6] = 0;
      led[1] = 0;
      led[0] = 1;
    end

    B_SINK: begin
      disp3 = 8'b00000000;
      if (scoreA == 0)
      disp2 = 8'b00111111; // 0
    else if (scoreA == 1)
      disp2 = 8'b00000110; // 1
    else if (scoreA == 2)
      disp2 = 8'b01011011; // 2
    else if (scoreA == 3)
      disp2 = 8'b01001111;  // 3
    else
      disp2 = 8'b01100110;  // 4

    disp1 = 8'b01000000; // -

    if (scoreB == 0)
      disp0 = 8'b00111111; // 0
    else if (scoreB == 1)
      disp0 = 8'b00000110; // 1
    else if (scoreB == 2)
      disp0 = 8'b01011011; // 2
    else if (scoreB == 3)
      disp0 = 8'b01001111;  // 3
    else
      disp0 = 8'b01100110;  // 4

      if (Z)
        led[7:0] = 8'b11111111;
      else
        led[7:0] = 8'b00000000;
    end

    SHOW_SCORE: begin

      disp3 = 8'b00000000;
      disp2 = 8'b00111111;
      disp1 = 8'b01000000; // -
      disp0 = 8'b00111111;


      led[7] = 1;
      led[4] = 1;
      led[3] = 1;
      led[0] = 1;

      led[6] = 0;
      led[5] = 0;
      led[2] = 0;
      led[1] = 0;
    end

    A_WIN: begin
      disp3 = 8'b01110111; // A

      if (scoreA == 0)
        disp2 = 8'b00111111; // 0
      else if (scoreA == 1)
        disp2 = 8'b00000110; // 1
      else if (scoreA == 2)
        disp2 = 8'b01011011; // 2
      else if (scoreA == 3)
        disp2 = 8'b01001111;  // 3
      else
        disp2 = 8'b01100110;  // 4

      disp1 = 8'b01000000; // -

      if (scoreB == 0)
        disp0 = 8'b00111111; // 0
      else if (scoreB == 1)
        disp0 = 8'b00000110; // 1
      else if (scoreB == 2)
        disp0 = 8'b01011011; // 2
      else if (scoreB == 3)
        disp0 = 8'b01001111;  // 3
      else
        disp0 = 8'b01100110;  // 4
        
      
      if (timer < 50)
      begin
        led = 8'b10101010;
      end

      else  
      begin
        led = 8'b01010101;
      end

   
      end

    B_WIN: begin
      disp3 = 8'b01111100; // B ama küçük

      if (scoreA == 0)
        disp2 = 8'b00111111; // 0
      else if (scoreA == 1)
        disp2 = 8'b00000110; // 1
      else if (scoreA == 2)
        disp2 = 8'b01011011; // 2
      else if (scoreA == 3)
        disp2 = 8'b01001111;  // 3
      else
        disp2 = 8'b01100110;  // 4
        disp1 = 8'b01000000; // -

      if (scoreB == 0)
        disp0 = 8'b00111111; // 0
      else if (scoreB == 1)
        disp0 = 8'b00000110; // 1
      else if (scoreB == 2)
        disp0 = 8'b01011011; // 2
      else if (scoreB == 3)
        disp0 = 8'b01001111;  // 3
      else
        disp0 = 8'b01100110;  // 4
      
      if (timer < 50)
      begin
        led = 8'b10101010;
      end

      else 
      begin
        led = 8'b01010101;
      end


  
    end

    default: begin
      disp0 = 8'b00000000;
      disp1 = 8'b00000000;
      disp2 = 8'b00000000;
      disp3 = 8'b00000000;
      led = 8'b00000000;
    end
  endcase
end
endmodule