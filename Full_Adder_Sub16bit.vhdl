library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity Full_Adder_Sub16bit  is
  port (A: in std_logic_vector(15 downto 0); B: in std_logic_vector(15 downto 0); M: in std_logic; S: out std_logic_vector(15 downto 0));
end entity Full_Adder_sub16bit;

architecture Struct of Full_Adder_sub16bit is

	component Full_Adder is
     port(A, B, Ci: in std_logic;
         SUM, CARRY: out std_logic);
   end component;
	
	signal Carry : std_logic_vector(16 downto 0);
	signal B_new : std_logic_vector(15 downto 0);
  begin
	Gen1 : for i in 0 to 15 generate
		XOR_gate : XOR_2 port map (A => B(i), B => M, Y => B_new(i));
	end generate;
	
	Carry(0) <= M;
	
	Gen2 : for i in 0 to 15 generate 
		FA : Full_Adder port map (A => A(i), B => B_new(i), Ci => Carry(i), SUM => S(i), CARRY => Carry(i+1));
		end generate;
end Struct;