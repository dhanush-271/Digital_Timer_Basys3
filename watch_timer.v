`timescale 1ns / 1ps
module watch_timer(input clk, reset, start, edit, edit_shift, inc, output [0:6] seg,output [3:0] digit,output reg shift_conf, edit_conf, start_conf);

initial shift_conf=0;
initial edit_conf=0;
initial start_conf=0;

reg edit_place;
reg [5:0] seconds,minutes;

wire [3:0] ones,tens,hundreds,thousands;

//initial values
initial edit_place=1;
initial seconds=0;
initial minutes=0;

digits digits_1(clk,reset,seconds,minutes,ones,tens,hundreds,thousands);
seven_seg seven_seg_1(clk,reset,ones,tens,hundreds,thousands,seg,digit);

parameter e0 = 0;
parameter e1 = 1; 
parameter start_sig =2;
 
reg [1:0] state = e0, nstate = e0;   

 //Slower Clock
 reg sclk=0;
 integer count=0;
 reg[31:0] scount=0;
 always @(posedge clk) begin
     if(count==49_999_999) begin
         count<=0;
         sclk<=~sclk;
     end 
     else count<=count+1;
 end
 
 //Clock Run
always @(posedge(clk) ) begin
	case(state)
	
	e0: begin
		if(reset == 1'b1) begin 
			if(scount<25_000_000)
                scount<=scount+1;
            else begin
                if(reset && scount==25_000_000) begin
                    seconds<=0;
                    minutes<=0;
                    scount<=scount+1;
                end
                else begin
                    seconds<=seconds;
                    minutes<=minutes;
                    scount<=scount+1;
                end
            end
		end
		
        else if(edit) begin
            if(scount<25_000_000)
                scount<=scount+1;
            else begin
                if(edit && scount==25_000_000) begin
                    nstate<=e1;
                    edit_conf<=1;
                    scount<=scount+1;
                end
                else begin
                    nstate<=nstate;
                    edit_conf<=1;
                    scount<=scount+1;
                end
            end
        end
        else if(start) begin
            if(scount<25_000_000)
                scount<=scount+1;
            else begin
                if(start && scount==25_000_000) begin
                    nstate<=start_sig;
                    start_conf<=1;
                    scount<=scount+1;
                end
                else begin
                    nstate<=nstate;
                    start_conf<=1;
                    scount<=scount+1;
                end
            end
        end	
        else begin
            scount<=0;
            edit_conf<=0;
            start_conf<=0;
            state<=nstate;
        end
		
	end
	
	start_sig: begin
		if(reset == 1'b1) begin 
            if(scount<25_000_000)
                scount<=scount+1;
            else begin
                if(reset && scount==25_000_000) begin
                    seconds<=0;
                    minutes<=0;
                    scount<=scount+1;
                end
                else begin
                    seconds<=seconds;
                    minutes<=minutes;
                    scount<=scount+1;
                end
            end
        end
		
        else if(start) begin
            if(scount<25_000_000)
                scount<=scount+1;
            else begin
                if(start && scount==25_000_000) begin 
                    nstate<=e0;
                    start_conf<=1;
                    scount<=scount+1;
                end
                else begin
                    nstate<=nstate;
                    start_conf<=1;
                    scount<=scount+1;
                end
            end
        end	
        else begin
            state<=nstate;
            start_conf<=0;
            scount<=0;
            if(sclk==1'b1 && count==0 && nstate==start_sig) begin  
                if(minutes>0) begin
                    if(seconds>0) 
                        seconds<=seconds-1;
                    else begin
                        minutes<=minutes-1;
                        seconds<=6'd59;
                    end
                end
                else begin
                    if(seconds==0) begin
                        seconds<=seconds;
                        minutes<=minutes;
                        state<=e0;
                    end
                    else
                        seconds<=seconds-1;
                end		
            end
        end
		
	end
	
	e1: begin
		if(reset == 1'b1) begin 
            if(scount<25_000_000)
                scount<=scount+1;
            else begin
                if(reset && scount==25_000_000) begin
                    seconds<=0;
                    minutes<=0;
                    scount<=scount+1;
                end
                else begin
                    seconds<=seconds;
                    minutes<=minutes;
                    scount<=scount+1;
                end
            end
        end
		
        else if(edit) begin
            if(scount<25_000_000)
                scount<=scount+1;
            else begin
                if(edit && scount==25_000_000) begin
                    scount<=scount+1;
                    edit_conf<=1;
                    nstate<=e0;
                end
                else begin
                    edit_conf<=1;
                    nstate<=nstate;
                    scount<=scount+1;
                end
            end
        end
        else if(edit_shift) begin
            if(scount<25_000_000)
                scount<=scount+1;
            else begin
                if(edit_shift && scount==25_000_000) begin
                    scount<=scount+1;
                    shift_conf<=1;
                    edit_place<=~edit_place;
                end
                else begin
                    shift_conf<=1;
                    edit_place<=edit_place;
                    scount<=scount+1;
                end
            end
        end
        else if(inc) begin
            if(scount<25_000_000)
                scount<=scount+1;
            else begin
                if(inc && scount==25_000_000) begin
                    scount<=scount+1;
                    if(edit_place) begin
                        if(minutes<60)
                            minutes<=minutes+1;
                        else
                            minutes<=0;
                    end 
                    else begin
                        if(seconds<59)
                            seconds<=seconds+1;
                        else
                            seconds<=0;
                    end
                end
                else begin
                    scount<=scount+1;
                    minutes<=minutes;
                    seconds<=seconds;
                end
            end
        end
        else begin
            scount<=0;
            edit_conf<=0;
            shift_conf<=0;
            state<=nstate;
        end
	end
	
	default: begin
		state<=e0;
		seconds<=seconds;
		minutes<=minutes;
	end
	endcase
end

endmodule