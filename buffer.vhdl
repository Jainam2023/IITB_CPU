library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity buffer_map is
	port(A: in std_logic; B: out std_logic);
end entity buffer_map;

architecture struct of buffer_map is
begin
	B<=A;
end architecture struct;