module checker
(
    input wire clock,
    input wire rst,
    input wire soft_rst,
    input wire i_valid,
    input wire [7:0] i_lfsr, // this is the LFSR generator output, now it is the input
    output reg o_lock // this is the output for lock or unlock the LFSR
);

// state machine states
localparam UNLOCK = 1'b0; // this is the unlock state
localparam LOCK = 1'b1; // this is the lock state

// internal signals for the state machine
reg     next_state;
reg     state;

// internal signals for the counters
reg [3:0] valid_counter;
reg [3:0] valid_counter_next; 
reg [1:0] invalid_counter;
reg [1:0] invalid_counter_next;

reg       resync; // this is the resync signal
reg [7:0] lfsr_local; // this is the local LFSR generator
wire feedback; // this is the feedback signal

// state machine logic
always@(*) begin
    
    case(state)

        UNLOCK:begin // here i'm unlock so i have to check the valids, not the invalids

            if (valid_counter >= 4'd5) begin // if i'm unlock and i have 5 valids, i go to lock

                next_state = LOCK; // next state is lock
                valid_counter_next = 'd0; // reset the valid counter
            
            end
            else begin

                if  (i_lfsr != lfsr_local) begin // if i'm unlock i'm out of sync, then if the secuence is still invalid i have to resync
                    
                    resync = 1; // resync signal is 1
                    valid_counter_next = 'd0; // reset the valid counter

                end
                else begin // if the secuence is valid, i don't have to resync

                    resync = 0; // resync signal is 0
                    valid_counter_next = valid_counter + 1'b1; // increment the valid counter
                
                end

                next_state = UNLOCK; // if i don't have 5 valids, i stay in unlock state

            end

            invalid_counter_next = 'd0; // don't need to check the invalids
        end

        LOCK: begin // here i'm lock so i have to check the invalids, not the valids

            if (invalid_counter >= 2'd3) begin // if i'm lock and i have 3 invalids, i go to unlock cause i'm out of sync
                
                next_state = UNLOCK; // next state is unlock
                invalid_counter_next = 'd0; // reset the invalid counter
                resync = 1; // resync signal is 1
            
            end
            else begin
                if  (i_lfsr != lfsr_local) begin // if i'm lock i'm out of sync, then have to 
                    invalid_counter_next = invalid_counter + 1'b1;
                    resync = 0; // no need to resync because the unlock state will do it
                    
                end
                else begin // if the secuence is valid, i don't have to resync
                    invalid_counter_next = 'd0; // reset the invalid counter
                    resync = 0;
                end

                next_state = LOCK; // if i don't have 3 invalids, i stay in lock state
            end

            valid_counter_next = 'd0; // don't need to check the valids
        end
        default:
        begin
            next_state = 0;
            valid_counter_next = 0;
            invalid_counter_next = 0;
            resync = 0;
            state = 0;
        end
    endcase
end

// Valid and invalid counters
always@(posedge clock or posedge rst)
begin
    if (rst) begin
       valid_counter <= 'd0;
    end
    else if (soft_rst) begin
        valid_counter <= 'd0;
    end
    else if (i_valid) begin
        valid_counter <= valid_counter_next;
    end
end

always@(posedge clock or posedge rst)
begin
    if (rst) begin
       invalid_counter <= 'd0;
    end
    else if (soft_rst) begin
        invalid_counter <= 'd0;
    end
    else if (i_valid)
    begin
        invalid_counter <= invalid_counter_next;
    end
end

// state machine
always@(posedge clock or posedge rst)
begin
    if (rst) begin
        state   <= UNLOCK;
    end
    else begin
        state   <= next_state;
    end
end

// feedback generation for the LFSR, if the LFSR is out of sync, the feedback is the input LFSR
assign feedback = (resync) ?    i_lfsr[7] ^ (i_lfsr[6:0]==7'b0000000):
                                lfsr_local  [7] ^   (lfsr_local[6:0]==7'b0000000);

always @(posedge clock or posedge rst) begin
    if (rst) begin
        lfsr_local <= 8'hFF;
    end
    else if (soft_rst) begin
        lfsr_local <= 8'hFF;
    end
    else if (resync & i_valid) begin
        lfsr_local[0] <= feedback;
        lfsr_local[1] <= i_lfsr[0];
        lfsr_local[2] <= i_lfsr[1] ^ feedback;
        lfsr_local[3] <= i_lfsr[2] ^ feedback;
        lfsr_local[4] <= i_lfsr[3] ^ feedback;
        lfsr_local[5] <= i_lfsr[4];
        lfsr_local[6] <= i_lfsr[5];
        lfsr_local[7] <= i_lfsr[6];
    end
    else if (i_valid) begin
        lfsr_local[0] <= feedback;
        lfsr_local[1] <= lfsr_local[0];
        lfsr_local[2] <= lfsr_local[1] ^ feedback;
        lfsr_local[3] <= lfsr_local[2] ^ feedback;
        lfsr_local[4] <= lfsr_local[3] ^ feedback;
        lfsr_local[5] <= lfsr_local[4];
        lfsr_local[6] <= lfsr_local[5];
        lfsr_local[7] <= lfsr_local[6];
    end
end

// output logic for o_lock
always @(posedge clock or posedge rst) begin
    if (rst) begin
        o_lock <= 1'b0;
    end else begin
        o_lock <= (state == LOCK);
    end
end


endmodule