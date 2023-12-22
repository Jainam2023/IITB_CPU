library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity DEMUX_81 is
	port(I:in std_logic ;S: in std_logic_vector(2 downto 0); A: out std_logic_vector(7 downto 0));
end entity DEMUX_81;

architecture struct of DEMUX_81 is
begin
  A(0) <= I and (not S(2)) and (not S(1)) and (not S(0));
  A(1) <= I and (not S(2)) and (not S(1)) and S(0);
  A(2) <= I and (not S(2)) and (S(1)) and (not S(0));
  A(3) <= I and (not S(2)) and (S(1)) and (S(0));
  A(4) <= I and (S(2)) and (not S(1)) and (not S(0));
  A(5) <= I and (S(2)) and (not S(1)) and (s(0));
  A(6) <= I and (S(2)) and (S(1)) and (not S(0));
  A(7) <= I and S(2) and S(1) and S(0);
end architecture struct;