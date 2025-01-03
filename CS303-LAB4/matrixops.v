module matrixops (
  input            clk,
  input            rst,
  input            enter,
  input      [1:0] X,
  input      [1:0] Y,
  output reg       Z
);

/* Your design goes here. */

parameter HOLD  = 3'b000;
parameter SET = 3'b001;
parameter CHECK = 3'b010;

reg [15:0] matrix_data;   
reg [2:0] current_state;  
reg [2:0] input_count;    
reg temp_result;         

always @(posedge clk) begin
    
    if (rst) begin
        current_state <= HOLD;
        matrix_data <= 16'b0;
        Z <= 1'b0;
        temp_result <= 1'b0;
        input_count <= 3'b0;

    end else begin
        case (current_state)

            SET: begin
                if (enter && input_count < 5) begin
                    matrix_data[{Y, X}] <= 1'b1;  
                    input_count <= input_count + 1;
                    if (input_count == 4) begin
                        current_state <= CHECK;  
                    end
                end
            end
            
            CHECK: begin
                if (enter) begin
                    temp_result <= matrix_data[{Y, X}];
                    Z <= temp_result;
                end else begin
                    Z <= temp_result;  
                end
            end

            HOLD: begin
                if (enter) begin
                    current_state <= SET;
                    input_count <= 3'b0;
                end
            end

            default: begin
                current_state <= HOLD;  
            end
        endcase
    end
end

endmodule
