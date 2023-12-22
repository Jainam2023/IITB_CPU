library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity ALU is
  port (ALU_A, ALU_B : in std_logic_vector(15 downto 0); S: in std_logic_vector(2 downto 0); ALU_C: out std_logic_vector(15 downto 0); ALU_Z: out std_logic);
end entity ALU;

architecture Struct of ALU is
  signal Cin, Sel, Temp: std_logic;
  signal Temp0, Temp1, Temp2, Temp3, Output: std_logic_vector(15 downto 0);
  
	component Full_Adder_Sub16bit  is
		port (A: in std_logic_vector(15 downto 0); B: in std_logic_vector(15 downto 0); M: in std_logic; S: out std_logic_vector(15 downto 0));
	end component;
	
	component Full_Multiplier is
		port (A, B : in std_logic_vector(15 downto 0); S: out std_logic_vector(15 downto 0));
	end component;
	
	component AND_16bit  is
		port (A, B: in std_logic_vector(15 downto 0); Y: out std_logic_vector(15 downto 0));
	end component;
	
	component OR_16bit  is
		port (A, B: in std_logic_vector(15 downto 0); Sel: in std_logic; Y: out std_logic_vector(15 downto 0));
	end component;
		
	component MUXM15_41 is
		port(	inp0: in std_logic_vector(15 downto 0);
				inp1: in std_logic_vector(15 downto 0);
				inp2: in std_logic_vector(15 downto 0);
				inp3: in std_logic_vector(15 downto 0);
				cs: in std_logic_vector(1 downto 0); outp: out std_logic_vector(15 downto 0));
	end component MUXM15_41;
	
	component OR_16input  is
		port (A: in std_logic_vector(15 downto 0); Y: out std_logic);
	end component;
	
begin
	Cin <= S(1) and (not S(0));
	Sel <= (S(0) and S(2)) or (S(2) and S(1)) or (S(1) and S(0));
	
	Add_sub: Full_Adder_Sub16bit port map (A => ALU_A, B => ALU_B, M => Cin, S => Temp0);
	Mul: Full_Multiplier port map (A => ALU_A, B => ALU_B, S => Temp1);
	And_gate: AND_16bit port map (A => ALU_A, B => ALU_B, Y => Temp2);
	OR_Imp: OR_16bit port map (A => ALU_A, B => ALU_B, Sel => S(1), Y => Temp3);
	
	MUX: MUXM15_41 port map (inp0 => Temp0, inp1 => Temp1, inp2 => Temp2, inp3 => Temp3, cs(1) => S(2), cs(0) => Sel, outp => Output);
	
	OR_16inputs: OR_16input port map (A => Output, Y => Temp);
		
	ALU_C <= Output;
	ALU_Z <= not Temp;
	end Struct;



	