library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity Full_Multiplier is
  port (A, B : in std_logic_vector(15 downto 0); S: out std_logic_vector(15 downto 0));
end entity Full_Multiplier;

architecture Struct of Full_Multiplier is
  --signal S: std_logic_vector(3 downto 0); 
  signal S1, S2, S3, S4, Stemp: std_logic_vector(3 downto 0);
  signal S5, S6, S7: std_logic_vector(4 downto 0);
   component Adder_4bit is
		port (A, B: in std_logic_vector(3 downto 0); S: out std_logic_vector(4 downto 0));
   end component;
	
	component Multiplier is
       port (A : in std_logic_vector(3 downto 0); B : in std_logic; M : out std_logic_vector(3 downto 0));
   end component;
	
begin
	MUL1 : Multiplier port map (A => A(3 downto 0), B => B(0), M => S1);
	MUL2 : Multiplier port map (A => A(3 downto 0), B => B(1), M => S2);
	MUL3 : Multiplier port map (A => A(3 downto 0), B => B(2), M => S3);
	MUL4 : Multiplier port map (A => A(3 downto 0), B => B(3), M => S4);
	Stemp<='0' & S1(3 downto 1);
	Adder1 : Adder_4bit port map (A => Stemp, B => S2, S => S5);
	Adder2 : Adder_4bit port map (A => S5(4 downto 1), B => S3, S => S6);
	Adder3 : Adder_4bit port map (A => S6(4 downto 1), B => S4, S => S7);
	S <= "00000000" & S7 & S6(0) & S5(0) & S1(0);
	end Struct;