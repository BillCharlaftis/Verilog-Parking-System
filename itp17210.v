module parkingManager(input IN,input OUT0,input OUT1,output [31:0] CARS,output [31:0] AVAILABLE,output FULL,output FLOOR0,output FLOOR1);
    wire IN,OUT0,OUT1;
    reg [31:0] CARS;
    reg [31:0] AVAILABLE;
    reg [31:0] zeroFloor;
    reg [31:0] firstFloor;
    reg FULL, FLOOR0, FLOOR1;

    initial begin
        CARS = 2'd00;
        AVAILABLE = 1000;
        zeroFloor = 0;
        firstFloor = 0;
        FULL = 1'b0;
        FLOOR0 = 1'b1;
        FLOOR1 = 1'b1;
    end
    always@(IN or OUT0 or OUT1) begin
        if (IN == 1) begin
            if(AVAILABLE > 0) begin
                CARS  = CARS +1;
                AVAILABLE = AVAILABLE -1;
                if(CARS > 500) begin
                    FLOOR0 = 1'b0;
                    firstFloor = firstFloor +1;
                end else begin
                    zeroFloor = zeroFloor +1;
                end
                if(CARS == 1000) begin
                    FLOOR1 = 1'b0;
                    FULL = 1'b1;
                end
            end
        end
        if ((OUT0 == 1) && (zeroFloor >0) && (zeroFloor <= 500)) begin
            CARS  = CARS -1;
            AVAILABLE = AVAILABLE +1;
            if(!FLOOR0) begin
                FLOOR0 = 1'b1;
            end
            if(FULL) begin
                FULL = 1'b0;
            end
        end
        if ((OUT1 == 1) && (firstFloor >0) && (firstFloor <= 500)) begin
            CARS  = CARS -1;
            AVAILABLE = AVAILABLE +1;
            if(!FLOOR1) begin
                FLOOR1 = 1'b1;
            end
            if(FULL) begin
                FULL = 1'b0;
            end
        end
    end
endmodule

module top;
    reg in,out0,out1;
    wire [31:0] cars;
    wire [31:0] available;
    wire full, floor0, floor1; 

    parkingManager dum(in,out0,out1,cars,available,full,floor0,floor1);
    initial begin
        $dumpfile("itp17210.vcd");
        $dumpvars(0);
        in = 1'b0;
        out0 = 1'b0;
        out1 = 1'b0;

        while (!full) begin
          case ($urandom%3)
                0 : begin
                    in = 1'b1;
                    #5 in = 1'b0;
                  end
                1 : begin
                    if(cars >0) begin
                        out0 = 1'b1;
                        #5 out0 = 1'b0;
                    end
                end
                2 : begin
                    if(cars >500) begin
                        out1 = 1'b1;
                        #5 out1 = 1'b0;
                    end
                end
            endcase
        end
    end
 endmodule