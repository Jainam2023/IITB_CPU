library ieee;
use ieee.std_logic_1164.all;

entity Testbench is
end Testbench;

architecture ClockTB of Testbench is
	
	-- Component Instaiation of the Entity you want to verify using testbench
	component CPU is
	port(clk,reset: in std_logic; outp1,outp3,outp4, outp5: out std_logic_vector(15 downto 0);outp2: out std_logic_vector(4 downto 0); outp6: out std_logic);
	end component CPU;

	signal Clk_50, Reset : std_logic;
	signal output1,output3,output4, output5: std_logic_vector(15 downto 0);
	signal output2: std_logic_vector(4 downto 0);
	signal output6: std_logic;
	
	begin
		-- Port Mapping of the component being instantiated
		main : CPU port map (clk => Clk_50, reset => Reset, outp1 => output1, outp2=> output2, outp3=> output3, outp4=> output4, outp5 => output5, outp6 => output6);
		
		Reset <= '1', '0' after 50 us;
		
		L1: process  -- In Testbench Process statement does not have sensitivity list
					 -- the Statement written inside process block in testbench will run in a infinite loop
				begin
					Clk_50 <= '0';
					wait for 100 us; -- 100 us is used as Clk_50 freq = 50 MHz, so T = 200 us 
									 -- So T/2 Clk_50 will be OFF and for next T/2 Clk_50 will ON 
					Clk_50 <= '1';
					wait for 100 us;
			end process;
		
end ClockTB;