library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity LS is
	port(A: in std_logic_vector(15 downto 0); B: out std_logic_vector(15 downto 0) );
end entity LS;

architecture struct of LS is

component buffer_map is
	port(A: in std_logic; B: out std_logic);
end component buffer_map;

begin
	map_ent: for i in 1 to 15 generate
		bff: buffer_map port map(A(i-1), B(i));
	end generate map_ent;
	B(0)<='0';
end architecture struct;