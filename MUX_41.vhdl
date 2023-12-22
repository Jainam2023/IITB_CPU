library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity Mux_4x1  is
  port (I0, I1, I2, I3, S0, S1: in std_logic; Y: out std_logic);
end entity Mux_4x1;

architecture Struct of Mux_4x1 is
  signal Temp1, Temp2 : std_logic;
  component Mux_2x1 is
     port(I0, I1, S: in std_logic;
         Y: out std_logic);
   end component;
begin
  -- component instances
  Mux1: Mux_2x1 port map (I0 => I0, I1 => I1, S => S0, Y => Temp1);
  Mux2: Mux_2x1 port map (I0 => I2, I1 => I3, S => S0, Y => Temp2);
  Mux3: Mux_2x1 port map (I0 => Temp1, I1 => Temp2, S => S1, Y => Y);
end Struct;