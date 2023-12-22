library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity OR_16bit  is
  port (A, B: in std_logic_vector(15 downto 0); Sel: in std_logic; Y: out std_logic_vector(15 downto 0));
end entity OR_16bit;

architecture Struct of OR_16bit is
  signal A_new : std_logic_vector(15 downto 0);
begin
	Gen1: for i in 0 to 15 generate
		XOR_gate: XOR_2 port map (A => A(i), B => Sel, Y => A_new(i));
		end generate;
		
	Gen2: for i in 0 to 15 generate 
		OR_gate: OR_2 port map (A => A_new(i), B => B(i), Y => Y(i));
		end generate;
		
end Struct;