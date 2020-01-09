module divfreq(input CLK, output reg CLK_div);//保持視覺暫留
reg [24:0] Count;
always @(posedge CLK)
begin
if(Count > 25000)
begin
Count <= 25'b0;
CLK_div <= ~CLK_div;
end
else
Count <= Count + 1'b1;
end
endmodule

module divfreq2(input CLK, output CLK_div2);//移動閃爍
reg [24:0]Count;
always @(posedge CLK)
begin
if(Count > 25000000)
begin
Count <= 25'b0;
CLK_div2 <= ~CLK_div2;
end
else
Count <= Count + 1'b1;
end
endmodule


module final_project(output bit[7:0] DATA_R, DATA_G, DATA_B,output reg[3:0]COMM,input CLK,input [1:0]buttomx, buttomy,input choose, clear);
		
		bit [7:0] tmp_R[7:0],tmp_G[7:0],tmp_B[7:0];
		initial//全部亮白光
		begin
		tmp_R [7:0]=
		'{8'b11111111,
		8'b11111111,
		8'b11111111,
		8'b11111111,
		8'b11111111,
		8'b11111111,
		8'b11111111,
		8'b11111111
		};
		tmp_G [7:0]=
		'{8'b00000000,
		8'b00000000,
		8'b00000000,
		8'b00000000,
		8'b00000000,
		8'b00000000,
		8'b00000000,
		8'b00000000
		};
		tmp_B [7:0]=
		'{8'b00000000,
		8'b00000000,
		8'b00000000,
		8'b00000000,
		8'b00000000,
		8'b00000000,
		8'b00000000,
		8'b00000000
		};
			COMM = 4'b1000;
		end
		
		bit [2:0] cnt;
		
	divfreq f0(CLK,CLK_div);
	divfreq2 f1(CLK,CLK_div2);
	
	reg t = 3;
	always @(posedge CLK_div)//因為刷很快，所以視覺暫留
	begin 
		if (cnt>=7)
	cnt=0;
	else
	cnt=cnt+1;
	COMM={1'b1, cnt};	
		
	DATA_R = tmp_R[cnt];
	DATA_G = tmp_G[cnt];
	DATA_B = tmp_B[cnt];
	end
		
	
	bit [2:0]x = 3'b011;
	bit [2:0]y = 3'b011;
	bit step_R = 0 ;
	bit step_G = 0 ;
	bit step_B = 0 ;
	
	bit [7:0] bomb [7:0]=//設置炸彈
	'{8'b00000000,
	8'b11111111,
	8'b11111111,
	8'b11111111,
	8'b11111111,
	8'b11111111,
	8'b11111111,
	8'b11111111
	};
	
	always @( posedge CLK_div2)//移動
	begin
	//x
		 if (buttomx == 2'b01)//right
		  begin
				if (x==3'b111)
				begin
					x = x;
					if(step_R != 0 && step_G != 1 && step_G != 0)//?
					begin
					tmp_R[x-1'b1][y] <= step_R;
					tmp_G[x-1'b1][y] <= step_G;
					tmp_B[x-1'b1][y] <= step_B;
					end
				end
				else
				begin
					x=x+1'b1;	
					tmp_R[x-1'b1][y] <= step_R;//把上一個點的狀態還回去
					tmp_G[x-1'b1][y] <= step_G;
					tmp_B[x-1'b1][y] <= step_B;
				end
				step_R <= tmp_R[x][y];//把踩到點的狀態存起來
				step_G <= tmp_G[x][y];
				step_B <= tmp_B[x][y];
				tmp_R[x][y] <= 1'b0;//紫色
				tmp_G[x][y] <= 1'b1;
				tmp_B[x][y] <= 1'b0;
		  end

		  else if (buttomx==2'b10)//left
		  begin
				if (x==3'b000)
				begin
					x=x;
					if(step_R != 0 && step_G != 1 && step_G != 0)
					begin
					tmp_R[x+1'b1][y] <= step_R;
					tmp_G[x+1'b1][y] <= step_G;
					tmp_B[x+1'b1][y] <= step_B;
					end
				end
				else
				begin
					x=x-1'b1;
					tmp_R[x+1'b1][y] <= step_R;
					tmp_G[x+1'b1][y] <= step_G;
					tmp_B[x+1'b1][y] <= step_B;
				end
				step_R <= tmp_R[x][y];
				step_G <= tmp_G[x][y];
				step_B <= tmp_B[x][y];
				tmp_R[x][y] <= 1'b0;
				tmp_G[x][y] <= 1'b1;
				tmp_B[x][y] <= 1'b0;
		  end
	//y 
		  if (buttomy==2'b10)//up
		  begin
				if (y==3'b000)
				begin
					y=y;
					if(step_R != 0 && step_G != 1 && step_G != 0)
					begin
					tmp_R[x][y+1'b1] <= step_R;
					tmp_G[x][y+1'b1] <= step_G;
					tmp_B[x][y+1'b1] <= step_B;
					end
				end
				else
				begin
					y=y-1'b1;	
					tmp_R[x][y+1'b1] <= step_R;
					tmp_G[x][y+1'b1] <= step_G;
					tmp_B[x][y+1'b1] <= step_B;
				end	
				step_R <= tmp_R[x][y];
				step_G <= tmp_G[x][y];
				step_B <= tmp_B[x][y];
				tmp_R[x][y] <= 1'b0;
				tmp_G[x][y] <= 1'b1;
				tmp_B[x][y] <= 1'b0;
		  end
			
			else if(buttomy==2'b01)//down
			begin
				if (y==3'b111)
				begin
					y = 3'b111;
					if(step_R != 0 && step_G != 1 && step_G != 0)
					begin
					tmp_R[x][y-1'b1] <= step_R;
					tmp_G[x][y-1'b1] <= step_G;
					tmp_B[x][y-1'b1] <= step_B;
					end
				end
				else
				begin
					y=y+1'b1;	
					tmp_R[x][y-1'b1] <= step_R;
					tmp_G[x][y-1'b1] <= step_G;
					tmp_B[x][y-1'b1] <= step_B;
				end	
				step_R <= tmp_R[x][y];
				step_G <= tmp_G[x][y];
				step_B <= tmp_B[x][y];
				tmp_R[x][y] <= 1'b0;
				tmp_G[x][y] <= 1'b1;
				tmp_B[x][y] <= 1'b0;
			end	
			
		if(clear)//重新開始
		begin
		tmp_R [7:0]=
		'{8'b00000000,
		8'b00000000,
		8'b00000000,
		8'b00000000,
		8'b00000000,
		8'b00000000,
		8'b00000000,
		8'b00000000
		};
		tmp_G [7:0]=
		'{8'b00000000,
		8'b00000000,
		8'b00000000,
		8'b00000000,
		8'b00000000,
		8'b00000000,
		8'b00000000,
		8'b00000000
		};
		tmp_B [7:0]=
		'{8'b00000000,
		8'b00000000,
		8'b00000000,
		8'b00000000,
		8'b00000000,
		8'b00000000,
		8'b00000000,
		8'b00000000
		};
		x = 3'b011;
		y = 3'b011;
		step_R <= 0 ;
		step_G <= 0 ;
		step_B <= 0 ;
	 end
			
		if(choose == 1'b1)//按了選擇鍵
		begin
			if(bomb[x][y] == 1'b0)//而且是炸彈
			begin
			{tmp_R[7],tmp_R[6],tmp_R[5],tmp_R[4],tmp_R[3],tmp_R[2],tmp_R[1],tmp_R[0]} =
			{8'b11111111,
			 8'b11101101,
			 8'b11101101,
			 8'b11101101,
			 8'b11101101,
			 8'b10000001,
			 8'b11111111,
			 8'b11111111
			};
			{tmp_G[7],tmp_G[6],tmp_G[5],tmp_G[4],tmp_G[3],tmp_G[2],tmp_G[1],tmp_G[0]} =
			{8'b11111111,
			 8'b11111111,
			 8'b11111111,
			 8'b11111111,
			 8'b11111111,
			 8'b11111111,
			 8'b11111111,
			 8'b11111111
			};
			{tmp_B[7],tmp_B[6],tmp_B[5],tmp_B[4],tmp_B[3],tmp_B[2],tmp_B[1],tmp_B[0]} =
			{8'b11111111,
			 8'b11111111,
			 8'b11111111,
			 8'b11111111,
			 8'b11111111,
			 8'b11111111,
			 8'b11111111,
			 8'b11111111
			};	
			end
			else //沒炸彈
			begin
			tmp_R[x][y] = 1;//全暗
			tmp_G[x][y] = 1;
			tmp_B[x][y] = 1;
			step_R <= tmp_R[x][y];
			step_G <= tmp_G[x][y];
			step_B <= tmp_B[x][y];
			end
			
			//warning
			if(count == 1)//周圍1顆
			begin
			tmp_R[x][y] = 1;
			tmp_G[x][y] = 0;
			tmp_B[x][y] = 1;
			step_R <= tmp_R[x][y];
			step_G <= tmp_G[x][y];
			step_B <= tmp_B[x][y];
			end
			if(count == 2)//周圍2顆
			begin
			tmp_R[x][y] = 1;
			tmp_G[x][y] = 1;
			tmp_B[x][y] = 0;
			step_R <= tmp_R[x][y];
			step_G <= tmp_G[x][y];
			step_B <= tmp_B[x][y];
			end
			if(count >= 3)//周圍3顆以上
			begin
			tmp_R[x][y] = 0;
			tmp_G[x][y] = 1;
			tmp_B[x][y] = 1;
			step_R <= tmp_R[x][y];
			step_G <= tmp_G[x][y];
			step_B <= tmp_B[x][y];
			end
	
		end
	 end
	 
	 integer count = 0;
	//scan & count
	always @(posedge CLK_div)//計算周圍8個位置的炸彈量
	begin
		if(choose)
		begin
		count = 0;
		if(bomb[x][y]==1'b1)
		begin
			if(bomb[x - 1][y - 1]==1'b0)
			count = count + 1;
			if(bomb[x ][y - 1]==1'b0)
			count = count + 1;
			if(bomb[x + 1][y - 1]==1'b0)
			count = count + 1;
			if(bomb[x - 1][y]==1'b0)
			count = count + 1;
			if(bomb[x + 1][y]==1'b0)
			count = count + 1;
			if(bomb[x - 1][y + 1]==1'b0)
			count = count + 1;
			if(bomb[x][y + 1]==1'b0)
			count = count + 1;
			if(bomb[x + 1][y + 1]==1'b0)
			count = count + 1;
		end
		end
	
	end

endmodule
