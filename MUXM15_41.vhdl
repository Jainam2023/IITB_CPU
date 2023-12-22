library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity MUXM15_41  is
  port (inp0, inp1, inp2, inp3: in std_logic_vector(15 downto 0); cs: in std_logic_vector(1 downto 0); outp: out std_logic_vector(15 downto 0));
end entity MuxM15_41;

architecture Struct of MuxM15_41 is
  signal Temp1, Temp2 : std_logic;
  component Mux_4x1 is
       port (I0, I1, I2, I3, S0, S1: in std_logic; Y: out std_logic);
   end component;
begin
  Mux : for i in 0 to 15 generate 
		MUX1: Mux_4x1 port map (I0 => inp0(i), I1 => inp1(i), I2 => inp2(i), I3 => inp3(i), S0 => cs(0), S1 => cs(1), Y => outp(i));
  end generate;
end Struct;