library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity CPU is
	port(clk,reset: in std_logic; outp1,outp3,outp4,outp5: out std_logic_vector(15 downto 0);outp2: out std_logic_vector(4 downto 0); outp6: out std_logic);
end entity CPU;

architecture struct of CPU is

type state is (rst,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15,s16, endstate);
signal y_present, y_next: state:=rst;

component D_FlipFlop is
		port( D: in std_logic; clk: in std_logic; enable: in std_logic; Reset: in std_logic; 
			Preset: in std_logic; Q: out std_logic; Qb: out std_logic);
end component D_FlipFlop;

component Reg_File is
	port(A1,A2,A3: in std_logic_vector(2 downto 0); rf_write: in std_logic; D3: in std_logic_vector(15 downto 0); clk,reset: in  std_logic; D1,D2: out std_logic_vector(15 downto 0));
end component Reg_File;

component Register_16 is
	port(Clk, Reset, enable : in std_logic;
		D_in : in std_logic_vector(15 downto 0);
		D_out : out std_logic_vector(15 downto 0));
end component Register_16;

component ALU is
	port (ALU_A, ALU_B : in std_logic_vector(15 downto 0); S: in std_logic_vector(2 downto 0); ALU_C: out std_logic_vector(15 downto 0); ALU_Z: out std_logic);
end component ALU;

component Memory is
	port(Din,Add: in std_logic_vector(15 downto 0); Mem_Read, Mem_Write,clk,reset: in std_logic; Dout: out std_logic_vector(15 downto 0));
end component Memory;

component SE9 is
	port(inp: in std_logic_vector(8 downto 0); outp: out std_logic_vector(15 downto 0));
end component SE9;

component SE6 is
	port(inp: in std_logic_vector(5 downto 0); outp: out std_logic_vector(15 downto 0));
end component SE6;

component LS is
	port(A: in std_logic_vector(15 downto 0); B: out std_logic_vector(15 downto 0) );
end component LS;

component MUXM15_21 is
	port(	inp0: in std_logic_vector(15 downto 0);
			inp1: in std_logic_vector(15 downto 0);
			cs: in std_logic; outp: out std_logic_vector(15 downto 0));
end component MUXM15_21;

component MUXM15_41 is
	port(	inp0: in std_logic_vector(15 downto 0);
			inp1: in std_logic_vector(15 downto 0);
			inp2: in std_logic_vector(15 downto 0);
			inp3: in std_logic_vector(15 downto 0);
			cs: in std_logic_vector(1 downto 0); outp: out std_logic_vector(15 downto 0));
end component MUXM15_41;

component MUXM3_21 is
	port(	inp0: in std_logic_vector(2 downto 0);
			inp1: in std_logic_vector(2 downto 0);
			cs: in std_logic; outp: out std_logic_vector(2 downto 0));
end component MUXM3_21;

component MUXM3_41 is
	port(	inp0: in std_logic_vector(2 downto 0);
			inp1: in std_logic_vector(2 downto 0);
			inp2: in std_logic_vector(2 downto 0);
			inp3: in std_logic_vector(2 downto 0);
			cs: in std_logic_vector(1 downto 0); outp: out std_logic_vector(2 downto 0));
end component MUXM3_41;

component MUXM15_81 is
	port(	inp0: in std_logic_vector(15 downto 0);
			inp1: in std_logic_vector(15 downto 0);
			inp2: in std_logic_vector(15 downto 0);
			inp3: in std_logic_vector(15 downto 0);
			inp4: in std_logic_vector(15 downto 0);
			inp5: in std_logic_vector(15 downto 0);
			inp6: in std_logic_vector(15 downto 0);
			inp7: in std_logic_vector(15 downto 0);
			cs: in std_logic_vector(2 downto 0); outp: out std_logic_vector(15 downto 0));
end component MUXM15_81;



signal present: std_logic_vector(4 downto 0);

signal T1_write, T2_write, T3_write, RF_write, Mem_Read, Mem_Write, IR_Write, Z_Write: std_logic:='0'; --control signals

signal T1_out, T2_out, T3_out, RF_D1, RF_D2, ALU_C, Mem_out, IR_out, LS6_Out, SE6_out, SE9_out, M9_out, LS9_out, M6_out, M1_out,
		 M7_out, M10_out, M2_out, M5_out: std_logic_vector(15 downto 0):=(others=>'0');

signal ALU_cont: std_logic_vector(2 downto 0):=(others=>'0');

signal two_15: std_logic_vector(15 downto 0):="0000000000000010";

signal zero_15: std_logic_vector(15 downto 0):="0000000000000000";

signal M3_out, M4_out: std_logic_vector(2 downto 0):=(others=>'0');

signal M3_cont, M9_cont, M7_cont, M10_cont, M6_cont: std_logic:='0';

signal M1_cont, M4_cont: std_logic_vector(1 downto 0):=(others=>'0'); 

signal M2_cont, M5_cont: std_logic_vector(2 downto 0):=(others=>'0');

signal zero_8: std_logic_vector(7 downto 0):="00000000";

signal ALU_Z, Z_Out, Z_outb: std_logic:='0';

signal op_code: std_logic_vector(3 downto 0):="0000";
begin

	clock_proc:process(clk,reset)
	begin
		if(clk='1' and clk' event) then
			if(reset='1') then
				y_present <= rst;
			else
				y_present <= y_next; 
			end if;
		end if;
	end process;
	
	
	states: process(y_present)
	begin--assign values to control signals
			case y_present is
				when rst=>
					---initialise
					present<="00000";
					RF_write<='0';
					ALU_cont<="000";
					T1_write<='0';
					T2_write<='0';
					T3_write<='0';
					Mem_Read<='0';
					Mem_Write<='0';
					IR_write<='0';
					Z_write<='0';
					M1_cont<="00";
					M4_cont<="00";
					M2_cont<="000";
					M5_cont<="000";
					M3_cont<='0';
					M9_cont<='0';
					M7_cont<='0';
					M10_cont<='0';
					M6_cont<='0';
					y_next<=s1;
				when s1=>
					present<="00001";
					RF_write<='0';
					ALU_cont<="000";
					T1_write<='0';
					T2_write<='0';
					T3_write<='1';
					Mem_Read<='1';
					Mem_Write<='0';
					IR_write<='1';
					Z_write<='0';
					M1_cont<="00";
					M4_cont<="00";
					M2_cont<="000";
					M5_cont<="000";
					M3_cont<='0';
					M9_cont<='0';
					M7_cont<='0';
					M10_cont<='0';
					M6_cont<='0';
					y_next<=s2;
				when s2=>
					present<="00010";
					RF_write<='1';
					ALU_cont<="000";
					T1_write<='1';
					T2_write<='1';
					T3_write<='0';
					Mem_Read<='0';
					Mem_Write<='0';
					IR_write<='0';
					Z_write<='0';
					M1_cont<="00";
					M4_cont<="00";
					M2_cont<="000";
					M5_cont<="000";
					M3_cont<='1';
					M9_cont<='0';
					M7_cont<='0';
					M10_cont<='0';
					M6_cont<='0';
						case op_code is
							when "0000"| "0010"| "0011"| "0100"| "0101" |"0110"=>
								y_next<=s3;
							when "0001"=>
								y_next<=s5;
							when "1000"| "1001"=>
								y_next<=s7;
							when "1101" | "1111"=>
								y_next<=s8;
							when "1100"=>
								y_next<=s11;
							when "1010" | "1011"=>
								y_next<=s13;
							when "1110"|"0111"=>
								y_next<=endstate;
							when others=>
								NULL;
						end case;
				when s3=>
					present<="00011";
					RF_write<='0';
					ALU_cont<=IR_out(14 downto 12);
					T1_write<='0';
					T2_write<='0';
					T3_write<='1';
					Mem_Read<='0';
					Mem_Write<='0';
					IR_write<='0';
					Z_write<='0';
					M1_cont<="01";
					M4_cont<="00";
					M2_cont<="001";
					M5_cont<="000";
					M3_cont<='0';
					M9_cont<='0';
					M7_cont<='0';
					M10_cont<='0';
					M6_cont<='0';
					y_next<=s4;
				when s4=>
					present<="00100";
					RF_write<='1';
					ALU_cont<="000";
					T1_write<='0';
					T2_write<='0';
					T3_write<='0';
					Mem_Read<='0';
					Mem_Write<='0';
					IR_write<='0';
					Z_write<='0';
					M1_cont<="00";
					M4_cont<="01";
					M2_cont<="000";
					M5_cont<="000";
					M3_cont<='0';
					M9_cont<='0';
					M7_cont<='0';
					M10_cont<='0';
					M6_cont<='0';
					y_next<=s1;
				when s5=>
					present<="00101";
					RF_write<='0';
					ALU_cont<=IR_out(14 downto 12);
					T1_write<='0';
					T2_write<='0';
					T3_write<='1';
					Mem_Read<='0';
					Mem_Write<='0';
					IR_write<='0';
					Z_write<='0';
					M1_cont<="01";
					M4_cont<="00";
					M2_cont<="010";
					M5_cont<="000";
					M3_cont<='0';
					M9_cont<='0';
					M7_cont<='0';
					M10_cont<='0';
					M6_cont<='0';
					y_next<=s6;
				when s6=>
					present<="00110";
					RF_write<='1';
					ALU_cont<="000";
					T1_write<='0';
					T2_write<='0';
					T3_write<='0';
					Mem_Read<='0';
					Mem_Write<='0';
					IR_write<='0';
					Z_write<='0';
					M1_cont<="00";
					M4_cont<="10";
					M2_cont<="000";
					M5_cont<="000";
					M3_cont<='0';
					M9_cont<='0';
					M7_cont<='0';
					M10_cont<='0';
					M6_cont<='0';
					y_next<=s1;
				when s7=>
					present<="00111";
					RF_write<='1';
					ALU_cont<="000";
					T1_write<='0';
					T2_write<='0';
					T3_write<='0';
					Mem_Read<='0';
					Mem_Write<='0';
					IR_write<='0';
					Z_write<='0';
					M1_cont<="00";
					M4_cont<="11";
					M2_cont<="000";
					M5_cont<="001";
					M3_cont<='0';
					M9_cont<='0';
					M7_cont<='0';
					M10_cont<=IR_out(12);
					M6_cont<='0';
					y_next<=s1;
				when s8=>
					present<="01000";
					RF_write<='1';
					ALU_cont<="010";
					T1_write<='0';
					T2_write<='0';
					T3_write<='0';
					Mem_Read<='0';
					Mem_Write<='0';
					IR_write<='0';
					Z_write<='0';
					M1_cont<="10";
					M4_cont<="11";
					M2_cont<="001";
					M5_cont<="010";
					M3_cont<='0';
					M9_cont<='0';
					M7_cont<='0';
					M10_cont<='0';
					M6_cont<='0';
					if(IR_out(13)='0') then
						y_next<=s9;
					elsif(IR_out(13)='1') then
						y_next<=s10;
					end if;
				when s9=>
					present<="01001";
					RF_write<='1';
					ALU_cont<="000";
					T1_write<='0';
					T2_write<='0';
					T3_write<='0';
					Mem_Read<='0';
					Mem_Write<='0';
					IR_write<='0';
					Z_write<='0';
					M1_cont<="10";
					M4_cont<="00";
					M2_cont<="100";
					M5_cont<="010";
					M3_cont<='0';
					M9_cont<='0';
					M7_cont<='0';
					M10_cont<='0';
					M6_cont<='0';
					y_next<=s1;
				when s10=>
					present<="01010";
					RF_write<='1';
					ALU_cont<="000";
					T1_write<='0';
					T2_write<='0';
					T3_write<='0';
					Mem_Read<='0';
					Mem_Write<='0';
					IR_write<='0';
					Z_write<='0';
					M1_cont<="00";
					M4_cont<="00";
					M2_cont<="000";
					M5_cont<="011";
					M3_cont<='0';
					M9_cont<='0';
					M7_cont<='0';
					M10_cont<='0';
					M6_cont<='0';
					y_next<=s1;
				when s11=>
					present<="01011";
					RF_write<='0';
					ALU_cont<="010";
					T1_write<='0';
					T2_write<='0';
					T3_write<='0';
					Mem_Read<='0';
					Mem_Write<='0';
					IR_write<='0';
					Z_write<='1';
					M1_cont<="01";
					M4_cont<="00";
					M2_cont<="001";
					M5_cont<="000";
					M3_cont<='0';
					M9_cont<='0';
					M7_cont<='0';
					M10_cont<='0';
					M6_cont<='0';
					y_next<=s12;
				when s12=>
					present<="01100";
					RF_write<='1';
					ALU_cont<="000";
					T1_write<='0';
					T2_write<='0';
					T3_write<='0';
					Mem_Read<='0';
					Mem_Write<='0';
					IR_write<='0';
					Z_write<='0';
					M1_cont<="10";
					M4_cont<="00";
					M2_cont<="011";
					M5_cont<="100";
					M3_cont<='0';
					M9_cont<='0';
					M7_cont<=Z_out;
					M10_cont<='0';
					M6_cont<='0';
					y_next<=s1;
				when s13=>
					present<="01101";
					RF_write<='0';
					ALU_cont<="000";
					T1_write<='0';
					T2_write<='0';
					T3_write<='1';
					Mem_Read<='0';
					Mem_Write<='0';
					IR_write<='0';
					Z_write<='0';
					M1_cont<="11";
					M4_cont<="00";
					M2_cont<="010";
					M5_cont<="000";
					M3_cont<='0';
					M9_cont<='0';
					M7_cont<='0';
					M10_cont<='0';
					M6_cont<='0';
					if(IR_out(12)='1') then
						y_next<=s16;
					elsif(IR_out(12)='0') then
						y_next<=s14;
					end if;
				when s14=>
					present<="01110";
					RF_write<='0';
					ALU_cont<="000";
					T1_write<='1';
					T2_write<='0';
					T3_write<='0';
					Mem_Read<='1';
					Mem_Write<='0';
					IR_write<='0';
					Z_write<='0';
					M1_cont<="00";
					M4_cont<="00";
					M2_cont<="000";
					M5_cont<="000";
					M3_cont<='0';
					M9_cont<='1';
					M7_cont<='0';
					M10_cont<='0';
					M6_cont<='1';
					y_next<=s15;
				when s15=>
					present<="01111";
					RF_write<='1';
					ALU_cont<="000";
					T1_write<='0';
					T2_write<='0';
					T3_write<='0';
					Mem_Read<='0';
					Mem_Write<='0';
					IR_write<='0';
					Z_write<='0';
					M1_cont<="00";
					M4_cont<="11";
					M2_cont<="000";
					M5_cont<="101";
					M3_cont<='0';
					M9_cont<='0';
					M7_cont<='0';
					M10_cont<='0';
					M6_cont<='0';
					y_next<=s1;
				when s16=>
					present<="10000";
					RF_write<='0';
					ALU_cont<="000";
					T1_write<='0';
					T2_write<='0';
					T3_write<='0';
					Mem_Read<='0';
					Mem_Write<='1';
					IR_write<='0';
					Z_write<='0';
					M1_cont<="00";
					M4_cont<="00";
					M2_cont<="000";
					M5_cont<="000";
					M3_cont<='0';
					M9_cont<='0';
					M7_cont<='0';
					M10_cont<='0';
					M6_cont<='1';
					y_next<=s1;
				when endstate=>
					present<= "10001";
					RF_write<='0';
					ALU_cont<="000";
					T1_write<='0';
					T2_write<='0';
					T3_write<='0';
					Mem_Read<='0';
					Mem_Write<='0';
					IR_write<='0';
					Z_write<='0';
					M1_cont<="00";
					M4_cont<="00";
					M2_cont<="000";
					M5_cont<="000";
					M3_cont<='0';
					M9_cont<='0';
					M7_cont<='0';
					M10_cont<='0';
					M6_cont<='0';
					y_next<= endstate;
				when others=>
					NULL;
			end case;
	end process;

SE9_1: SE9 port map(inp=>IR_out(8 downto 0), outp=>SE9_out);	
	
SE6_1: SE6 port map(inp=>IR_out(5 downto 0), outp=>SE6_out);	
	
ls6: LS port map(A=>SE6_out,B=>LS6_out);

ls9: LS port map(A=>SE9_out,B=>LS9_out);	
	
Z: D_FLipFlop port map(D=>ALU_Z, clk=>clk, enable=>Z_write, reset=>reset, preset=>'0', Q=>Z_out, Qb=>Z_outb);
	
T1: Register_16 port map(clk=>clk, reset=>reset, enable=>T1_write, D_in=>M9_Out, D_out=>T1_out);

T2: Register_16 port map(clk=>clk, reset=>reset, enable=>T2_write, D_in=>RF_D2, D_out=>T2_out);

T3: Register_16 port map(clk=>clk, reset=>reset, enable=>T3_write, D_in=>ALU_C, D_out=>T3_out);

IR: Register_16 port map(clk=>clk, reset=>reset, enable=>IR_write, D_in=>Mem_out, D_out=>IR_out);

alu1: ALU port map(ALU_A=>M1_out, ALU_B=>M2_out, S=>ALU_cont , ALU_C=>ALU_C, ALU_Z=>ALU_Z);

RF: Reg_File port map(A1=>M3_out, A2=>IR_out(8 downto 6), A3=>M4_out, rf_write=>RF_write, D3=>M5_out, clk=>clk, reset=>reset, D1=>RF_D1, D2=>RF_D2);

mem: Memory port map(Din=>T1_out, Add=>M6_out, Mem_Read=>Mem_Read, Mem_Write=>Mem_Write, Dout=>Mem_out, clk=>clk, reset=>reset);


m9: MUXM15_21 port map(inp0=>RF_D1, inp1=>Mem_Out, outp=>M9_out, cs=>M9_cont);


m6: MUXM15_21 port map(inp0=>RF_D1, inp1=>T3_out, outp=>M6_out, cs=>M6_cont);


m1: MUXM15_41 port map(inp0=>RF_D1, inp1=>T1_out, inp2=> T3_out,inp3=> T2_out, outp=>M1_out, cs=>M1_cont);


m2: MUXM15_81 port map(inp0=>two_15, inp1=>T2_out, inp2=>SE6_out, inp3=> LS6_out, inp4=>LS9_out, inp5=> zero_15, inp6=>zero_15, inp7=>zero_15, outp=>M2_out, cs=>M2_cont);


m3: MUXM3_21 port map("111", IR_out(11 downto 9), outp=>M3_out, cs=>M3_cont);


m4: MUXM3_41 port map("111", IR_out(5 downto 3), IR_out(8 downto 6), IR_out(11 downto 9), outp=>M4_out, cs=>M4_cont);


m5: MUXM15_81 port map(T3_out, M10_out, ALU_C, T2_out, M7_out, T1_out, zero_15, zero_15, outp=>M5_out, cs=>M5_cont);

m7: MUXM15_21 port map(T3_out, ALU_c, outp=>M7_out, cs=>M7_cont);

m10: MUXM15_21 port map(inp0(15 downto 8)=>IR_out(7 downto 0), inp0(7 downto 0)=>zero_8, inp1(15 downto 8)=>zero_8, inp1(7 downto 0)=>IR_out(7 downto 0),outp=> M10_out, cs=>M10_cont);

op_code<=IR_out(15 downto 12);

outp1<=ALU_C;
outp2<=present;
outp3<= IR_out;
outp4<= Mem_out;
outp5<= M7_out;
outp6<= Z_out;
end architecture struct;