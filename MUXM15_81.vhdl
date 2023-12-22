library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity MUXM15_81  is
  port (inp0, inp1, inp2, inp3, inp4, inp5, inp6, inp7: in std_logic_vector(15 downto 0); cs: in std_logic_vector(2 downto 0); outp: out std_logic_vector(15 downto 0));
end entity MuxM15_81;

architecture Struct of MuxM15_81 is
  signal Temp1, Temp2 : std_logic;
  component Mux_8x1 is
       port (I0, I1, I2, I3, I4, I5, I6, I7, S0, S1, S2: in std_logic; Y: out std_logic);
   end component;
begin
  Mux : for i in 0 to 15 generate 
		MUX1: Mux_8x1 port map (I0 => inp0(i), I1 => inp1(i), I2 => inp2(i), I3 => inp3(i), I4 => inp4(i), I5 => inp5(i), 
										I6 => inp6(i), I7 => inp7(i), S0 => cs(0), S1 => cs(1), S2 => cs(2), Y => outp(i));
  end generate;
end Struct;