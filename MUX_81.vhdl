library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity Mux_8x1  is
  port (I0, I1, I2, I3, I4, I5, I6, I7, S0, S1, S2: in std_logic; Y: out std_logic);
end entity Mux_8x1;

architecture Struct of Mux_8x1 is
  signal Temp1, Temp2 : std_logic;
  component Mux_2x1 is
     port(I0, I1, S: in std_logic;
         Y: out std_logic);
   end component;
	
	
	component Mux_4x1  is
		port (I0, I1, I2, I3, S0, S1: in std_logic; Y: out std_logic);
	end component;

begin
 
  Mux1: Mux_4x1 port map (I0 => I0, I1 => I1, I2 => I2, I3 => I3, S1 => S1, S0 => S0, Y => Temp1);
  Mux2: Mux_4x1 port map (I0 => I4, I1 => I5, I2 => I6, I3 => I7, S1 => S1, S0 => S0, Y => Temp2);
  Mux3: Mux_2x1 port map (I0 => Temp1, I1 => Temp2, S => S2, Y => Y);

end Struct;