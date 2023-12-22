library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;

entity D_FLipFlop is
	port( D: in std_logic; clk: in std_logic; enable: in std_logic; Reset: in std_logic; 
			Preset: in std_logic; Q: out std_logic; Qb: out std_logic);
end entity D_FlipFlop;

architecture struct of D_FlipFlop is
	signal state: std_logic:='0';
begin
  clock_process: process(D,clk,enable,preset,reset)
  begin
		if(preset ='1') then
			state<='1';
		elsif (reset='1') then
			state<='0';
		elsif (Clk'event and Clk='0') then
			if(enable='1') then
				case(D) is
					when '0' =>
						state <= '0';
					when '1' =>
						state <= '1';
					when others=>
						null;
				end case;
			elsif(enable='0') then
				state<=state;
			end if;
		end if;
  end process clock_process;
  Q<=state;
  Qb<=not state; 

end architecture struct;