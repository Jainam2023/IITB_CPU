library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity MUXM3_21 is
	port(	inp0: in std_logic_vector(2 downto 0);
			inp1: in std_logic_vector(2 downto 0);
			cs: in std_logic; outp: out std_logic_vector(2 downto 0));
end entity MUXM3_21;

architecture struct of MUXM3_21 is
component Mux_2x1 is
       port (I0, I1, S: in std_logic; Y: out std_logic);
   end component;
begin
  Mux : for i in 0 to 2 generate 
		MUX1: Mux_2x1 port map (I0 => inp0(i), I1 => inp1(i), S => cs, Y => outp(i));
  end generate;

end architecture struct;