library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity SE6 is
	port(inp: in std_logic_vector(5 downto 0); outp: out std_logic_vector(15 downto 0));
end entity SE6;

architecture struct of SE6 is
begin
	outp(5 downto 0)<=inp;
	outp(15 downto 6)<=inp(5) & inp(5) & inp(5) & inp(5) & inp(5) & inp(5) & inp(5) & inp(5) & inp(5) & inp(5);
end architecture struct;