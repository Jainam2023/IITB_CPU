library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity MUXM15_21  is
  port (inp0, inp1: in std_logic_vector(15 downto 0); cs: in std_logic; outp: out std_logic_vector(15 downto 0));
end entity MuxM15_21;

architecture Struct of MuxM15_21 is
  signal Temp1, Temp2 : std_logic;
  component Mux_2x1 is
       port (I0, I1, S: in std_logic; Y: out std_logic);
   end component;
begin
  Mux : for i in 0 to 15 generate 
		MUX1: Mux_2x1 port map (I0 => inp0(i), I1 => inp1(i), S => cs, Y => outp(i));
  end generate;
end Struct;