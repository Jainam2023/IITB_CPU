library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity Mux_2x1  is
  port (I0, I1, S: in std_logic; Y: out std_logic);
end entity Mux_2x1;

architecture Struct of Mux_2x1 is
  signal S_BAR, Temp1, Temp2 : std_logic;
begin
  NOT1: INVERTER port map (A => S, Y => S_BAR);
  AND1: AND_2 port map (A => I0, B => S_BAR, Y => Temp1);
  AND2: AND_2 port map (A => I1, B => S, Y => Temp2);
  OR1: OR_2 port map (A => Temp1, B => Temp2, Y => Y);
end Struct;