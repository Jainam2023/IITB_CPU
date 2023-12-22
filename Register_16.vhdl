library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity Register_16 is
	port(Clk, Reset, enable : in std_logic;
		D_in : in std_logic_vector(15 downto 0);
		D_out : out std_logic_vector(15 downto 0));
end entity;

architecture struct of Register_16 is
	signal D: std_logic_vector(15 downto 0);
	signal Do: std_logic_vector(15 downto 0);
	signal Dob: std_logic_vector(15 downto 0);
	component D_FlipFlop is
		port( D: in std_logic; clk: in std_logic; enable: in std_logic; Reset: in std_logic; 
			Preset: in std_logic; Q: out std_logic; Qb: out std_logic);
	end component D_FlipFlop;
begin
	D<=D_in;
	generation:  for i in 0 to 15 generate
		dff: D_FlipFlop port map(D=>D(i), clk=>clk, enable=>enable, reset=>Reset, preset=>'0', Q=>Do(i), Qb=>Dob(i));
	end generate;
	D_out<=Do;
end architecture struct;