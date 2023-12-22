library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity AND_16bit  is
  port (A, B: in std_logic_vector(15 downto 0); Y: out std_logic_vector(15 downto 0));
end entity AND_16bit;

architecture Struct of AND_16bit is
  
begin
  Gen1: for i in 0 to 15 generate 
		AND_gate: AND_2 port map (A => A(i), B => B(i), Y => Y(i));
		end generate;
end Struct;