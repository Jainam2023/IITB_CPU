library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;
use work.mat_pak.all;

entity MUXM_81 is
	port(inp: in matrix(7 downto 0,15 downto 0); cs: in std_logic_vector(2 downto 0); outp: out std_logic_vector(15 downto 0));
end entity MUXM_81;

architecture struct of MUXM_81 is
begin

end architecture struct;