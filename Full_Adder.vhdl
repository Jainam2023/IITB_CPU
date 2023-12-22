library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity Full_Adder  is
  port (A, B, Ci: in std_logic; SUM, CARRY: out std_logic);
end entity Full_Adder;

architecture Struct of Full_Adder is
  signal Z, AB, CiZ  : std_logic;
  
begin
  -- component instances
  XOR1: XOR_2 port map (A => A, B => B, Y => Z);
  XOR2: XOR_2 port map (A => Z, B => Ci, Y => SUM);
  AND1: AND_2 port map (A => A, B => B, Y => AB);
  AND2: AND_2 port map (A => Ci, B => Z, Y => CiZ); 
  OR1: OR_2 port map (A => AB, B => CiZ, Y => CARRY);
end Struct;