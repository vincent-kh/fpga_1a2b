# **1A2B-FPGA實作**
---

**組員**
| 學號 | 姓名 |
|:----:|:----:|
| 411025020 | 莊奕賢|
| 4112xxxxx | 邱柏諭|
| 4112xxxxx | 許詠宜|
## 玩法

### 初始化
開始遊戲時，需先將其進行初始化，以下為初始化步驟
1. 打開亂數生成器開關SW2
2. 重置亂數值，上下扳動SW3

### 遊玩
初始化之後會產生一組四位且每位不同的謎底，即可開始遊玩
1. KEY0每按一下會使HEX0顯示的數值+1，其他KEY亦然
2. 若確認好要猜測的值就上下扳動一下SW5
3. 此時HEX4顯示出B值，HEX5顯示出A值，且HEX6~7會顯示嘗試次數
4. 反覆上述步驟直至HEX5顯示4，即為4A0B遊戲獲勝

### 刷新題目
若想換到下一題可以上下撥動SW4以開始新遊戲
## 實作內容
### 目前電路
Input
>SW[1..0]：LFSR seed select
>SW[2]：LFSR enable
>SW[3]：Random number reset
>SW[4]：Random number generate
>SW[5]：顯示A、B
>SW[6]：輸入閃爍開關
>KEY[3..0]：Data2循環增值

Output
>HEX0123：猜測輸入
>HEX45：A(5)、B(4)
>HEX67：嘗試猜測次數

![FINAL](https://hackmd.io/_uploads/BJrNfmsw6.jpg)

---
### 隨機數值產生
#### 14位元LFSR
以下是一個藉由LFSR生成偽隨機訊號的verilog程式
>clk：刷新隨機值
>rst：恢復值為seed
>seed：初始值
>en：啟用LFSR
>ran：14bit的亂數輸出
>done：ran已輪迴至seed

```verilog=
module lfsr_14bit(
    input clk,     // clock signal
    input rst,     // reset signal
    input [13:0] seed,  // seed value
    input en,      // enable signal
    output reg [13:0] ran,   // random number
    output reg done   // done signal
);

// declare a 14-bit register to store the LFSR state
reg [13:0] state;
// declare a reg to store the feedback bit
reg feedback;

// always block to calculate the feedback bit
always @* begin
    // Use different taps for a better pseudorandom sequence
    feedback = state[13] ^ state[11] ^ state[10] ^ state[1];
end

// always block to update the state and the random number at the positive edge of the clock
always @(posedge clk) begin
    // if reset is high, set the state to the seed value
    if (rst) begin
        state <= seed;
        ran <= seed;
        done <= 0;
    end
    // else if enable is high, shift the state to the right and insert the feedback bit to the left
    else if (en) begin
        state <= {feedback, state[13:1]};
        ran <= state;
        // if the state is equal to the seed value, set the done signal to high
        if (state == seed) begin
            done <= 1;
        end
        // else set the done signal to low
        else begin
            done <= 0;
        end
    end
end

endmodule
```

#### 亂數產生元件

![random_gen](https://hackmd.io/_uploads/SyD0S7svp.jpg)

#### 10近位解碼器
將14bit(0~16384)取十近位後四位的值生成各4個bit的訊號輸出
>inp：14bit輸入
>h3：千位數輸出
>h2：百位數輸出
>h1：十位數輸出
>h0：個位數輸出
```verilog=
module oct_decode(inp,h3,h2,h1,h0);

input [13:0]inp;
output [3:0]h3;
output [3:0]h2;
output [3:0]h1;
output [3:0]h0;

assign h0=inp%10;
assign h1=(inp/10)%10;
assign h2=(inp/100)%10;
assign h3=(inp/1000)%10;

endmodule 
```
---
### 資料檢測
#### 比較器
若data1=data2，則eq輸出True
>data1、data2：資料輸入
>eq：比較結果
```verilog=
module com(
    input [3:0] data1,
    input [3:0] data2,
    output reg eq
);

always @* begin
    if (data1 == data2)
        eq = 1'b1;
    else
        eq = 1'b0;
end
endmodule 
```

#### 四資料比較器(four_data_com)
由四筆4bit的資料輸入，若有重複則EQ輸出True
檢測四個位數中是否有重複的數字出現
>DATA1、2、3、4：資料輸入
>EQ：比較結果
>
![image](https://hackmd.io/_uploads/r1Ko7ZwP6.png)

#### Adder
將A、B、C、D加起來並輸出至out
```verilog=
module adder (A,B,C,D,out);

	input A,B,C,D;
	output [3:0]out;
	
	assign out=A+B+C+D;
	
endmodule
```

#### A
比較相應位數是否相同，若相同則使com的eq輸出1，再用adder將結果加起來輸出
>DATA1_1,2,3,4：猜測資料輸入
>DATA2_1,2,3,4：答案資料輸入
>A：同位同值數

![image](https://hackmd.io/_uploads/By_IC-Dv6.png)


#### 1對3比較器(c_b_3)
將D1與D1、D2、D3比較，若有相同則EQ3輸出True
>D1：比較資料輸入
>D2_1,2,3：待比較資料輸入
>EQ3：比較結果

![image](https://hackmd.io/_uploads/SyER-GPDT.png)


#### B
比較其他位數是否相同，若相同則使c_b_3的EQ3輸出1，再用adder將結果加起來輸出
>DATA1_1,2,3,4：猜測資料輸入
>DATA2_1,2,3,4：答案資料輸入
>B：異位同值數

![image](https://hackmd.io/_uploads/HJfrQfDva.png)

---

### 顯示

#### 七段顯示器(seven_display)
將4bit的資料輸入轉換為7bit的七段顯示器輸出
>SW：4bit輸入
>H：7bit輸出
```verilog=
module seven_display(SW,H);

	input [3:0]SW;
	output [6:0]H;
	reg [6:0]H;
	
	always@ (SW)
	begin
		case (SW)
				  //gfedcba
			0: H=7'b1000000;
			1: H=7'b1111001;
			2: H=7'b0100100;
			3: H=7'b0110000;
			4: H=7'b0011001;
			5: H=7'b0010010;
			6: H=7'b0000010;
			7: H=7'b1011000;
			8: H=7'b0000000;
			9: H=7'b0011000;
		default:H=7'b1111111;
	endcase
end
endmodule 
```

#### 四對四七段顯示器(seven_display_4by4)
![image](https://hackmd.io/_uploads/H1Lp9mjD6.png)
#### AB顯示(ab_dis)
```verilog=
module ab_dis(A,B,SW,AO,BO);

input [3:0]A;
input [3:0]B;
input SW;
output reg [3:0]AO;
output reg [3:0]BO;

always @(posedge SW)
begin 
AO<=A;
BO<=B;
end 
endmodule 
```
#### 輸入閃爍
將七段顯示器輸出接到seven_bit_or的data，將任意頻率的時脈接入en
實現七段顯示器閃爍
```verilog=
module seven_bit_or(
    input [6:0] data,
    input en,
    output [6:0] out_data
);

genvar i;

generate
    for (i = 0; i < 7; i = i + 1) begin : NAND_generate
        assign out_data[i] = |{data[i], en};
    end
endgenerate

endmodule 
```
![seven_display_blink](https://hackmd.io/_uploads/H1X0sXjv6.jpg)

---

### 輸入
#### 循環增值器(inp_add)
對key每輸入一次上升邊緣觸發，使num=num+1
>key：觸發訊號
>num：輸出數值
```verilog=
module inp_add(key,num);

input key;
output reg [3:0]num;

always@(posedge key)
begin
	if(num<9)
	num=num+1;
	else
	num=0;
end
endmodule
```

---

[檔案與程式碼](https://github.com/vincent-kh/fpga_1a2b)

