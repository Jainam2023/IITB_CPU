library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity SE9 is
	port(inp: in std_logic_vector(8 downto 0); outp: out std_logic_vector(15 downto 0));
end entity SE9;

architecture struct of SE9 is
begin
	outp(8 downto 0)<=inp;
	outp(15 downto 9)<=inp(5) & inp(5) & inp(5) & inp(5) & inp(5) & inp(5) & inp(5);
end architecture struct;