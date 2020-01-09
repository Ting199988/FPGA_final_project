# FPGA_final_project<br>
Authors: 107321044 107321023 107321016<br>
Input/Output unit:<br>

  下圖 4顆藍色按鍵用來控制方向。<br>
  [圖一](https://drive.google.com/open?id=17gxGK-Y17G4K27pkOLFT1SsXVOqlGc3f)<br>
  
  下圖 藍色區塊的1號鍵是clear，4號鍵是選定點開位置。<br>
  [圖二](https://drive.google.com/open?id=1VaKmRxqWCBTs_BJDVek5buJVyN1kdsiv)<br>
  
  下圖為clear後的初始畫面。<br>
  [圖三](https://drive.google.com/open?id=1MoLTFaIu4KKzLoKrtJqaFNRCEynEy3YJ)<br>
  
  下圖 綠色:周圍1顆炸彈、藍色:周圍2顆炸彈、紅色:周圍3顆以上炸彈、紫色:目前所在位置。<br>
  [圖四](https://drive.google.com/open?id=1-N9I9Jt2EX-kiQtpojByySrxQTAJ2U8Q)<br>
  
  下圖為踩到炸彈拜畫面。<br>
  [圖五](https://drive.google.com/open?id=1Lck5RzZnnmG67P3aYiEbWNggRDlYmHxn)<br>
  
  功能說明<br>
  移動紫色燈的位置，選定位置後看顏色判斷周圍炸彈數量，踩到炸彈就輸了。<br>
  
  ```verilog
  module final_project(output bit[7:0] DATA_R, DATA_G, DATA_B//控制亮燈,output reg[3:0]COMM,input CLK,input [1:0]buttomx, buttomy//控制移動,input choose//選定格數, clear//重置);```
  
	```verilog
  initial//初始化，clear也是這樣
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
			COMM = 4'b1000;
		end```
    
    ```verilog
    always @(posedge CLK_div)//因為刷很快，所以產生視覺暫留
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
	};```
  
  ```verilog
	//x move
		 if (buttomx == 2'b01)//right
		  begin
				if (x==3'b111)
				begin
					x = x;
					if(step_R != 0 && step_G != 1 && step_G != 0)
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
				tmp_B[x][y] <= 1'b0;//以下移動以此類推```
        
        ```verilog
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
			//以下顏色以此類推	
			end
      
			else //沒炸彈
			begin
			tmp_R[x][y] = 1;//全暗
			tmp_G[x][y] = 1;
			tmp_B[x][y] = 1;
			step_R <= tmp_R[x][y];
			step_G <= tmp_G[x][y];
			step_B <= tmp_B[x][y];
			end```
      
      ```verilog
      if(choose)//計算周圍8個位置的炸彈量
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
			count = count + 1;```
      
      ```verilog
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
      //以此類推
			end```
  
  
   Demo vedio:<br>
  [vedio](https://drive.google.com/open?id=1_r85SSGSGtsg-7bUyEJmkEdyQVvX4paM)<br>
