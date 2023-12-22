library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity OR_16input  is
  port (A: in std_logic_vector(15 downto 0); Y: out std_logic);
end entity OR_16input;

architecture Struct of OR_16input is
  signal Temp : std_logic_vector(15 downto 0);
begin
	Temp(0) <= A(0);
	Gen1: for i in 1 to 15 generate
		OR_gate: OR_2 port map (A => Temp(i-1), B => A(i), Y => Temp(i));
		end generate;
	Y <= Temp(15);	
end Struct;