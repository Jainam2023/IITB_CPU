library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity Adder_4bit  is
  port (A, B: in std_logic_vector(3 downto 0); S: out std_logic_vector(4 downto 0));
end entity Adder_4bit;

architecture Struct of Adder_4bit is
  signal C: std_logic_vector(4 downto 0);
	component Full_Adder is
     port(A, B, Ci: in std_logic;
         SUM, CARRY: out std_logic);
   end component;
  begin
  -- component instances
		C(0) <= '0';
		FA : for i in 0 to 3 generate 
			F_Adder : Full_Adder port map (A => A(i), B => B(i), Ci => C(i) ,SUM => S(i), CARRY => C(i+1));
		end generate FA;
		S(4) <= C(4);
end Struct;