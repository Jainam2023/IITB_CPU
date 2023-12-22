library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity Multiplier  is
  port (A : in std_logic_vector(3 downto 0); B : in std_logic; M : out std_logic_vector(3 downto 0));
end entity Multiplier;

architecture Struct of Multiplier is
begin
  -- component instances
  Mul1: AND_2 port map (A => A(0), B => B, Y => M(0));
  Mul2: AND_2 port map (A => A(1), B => B, Y => M(1));
  Mul3: AND_2 port map (A => A(2), B => B, Y => M(2));
  Mul4: AND_2 port map (A => A(3), B => B, Y => M(3));
end Struct;