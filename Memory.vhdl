library ieee;
use ieee.std_logic_1164.all;
library work;
use work.Gates.all;
use work.mat_pak.all;
use ieee.numeric_std.all;

entity Memory is
	port(Din,Add: in std_logic_vector(15 downto 0); Mem_Read, Mem_Write,clk,reset: in std_logic; Dout: out std_logic_vector(15 downto 0));
end entity Memory;

architecture struct of Memory is
signal mem_arr : matrix(0 to 1023, 7 downto 0) := ("10100010", --LW
																"01000000",
																
																"10100100",  --LW
																"10000000",
																
																"10000010",  --LHI
																"10000000",
																
																"00010010",  --ADI
																"10000000",
																
																"00100010",  --SUB
																"10001000",
																
																"01110000",  --END
																"00000000",
																others=>"00000000");

begin
	clock_proc:process(clk,reset,Add,Din, Mem_read, Mem_write, mem_arr)
	begin
		if(Mem_read='1') then
			mem_arr<=mem_arr;
			for i in 0 to 7 loop
				Dout(i+8)<=mem_arr(to_integer(unsigned(Add)),i);
				Dout(i)<=mem_arr(to_integer(unsigned(Add))+1,i);
			end loop;
		elsif(clk='0' and clk' event) then
			if(reset='1') then
				mem_arr<=("10100010",
							 "11000000",
							
							 "10100101",
							 "00000000",
							
							 "10000010",
							 "10000000",
							
							 "00010010",
							 "10000000",
							
							 "00100010",
							 "10001000",
							 
							 "01110000",
							 "00000000",
							 others=>"00000000");
				for i in 7 downto 0 loop
					Dout(i) <= mem_arr(1,i);
					Dout(i+8) <= mem_arr(0,i);
				end loop;
			else
				if(to_integer(unsigned(Add))<=12) then
					if( Mem_write='1') then
						for i in 0 to 7 loop
							mem_arr(to_integer(unsigned(Add)),i)<=Din(i+8);
							mem_arr(to_integer(unsigned(Add))+1,i)<=Din(i);
						end loop;
						Dout<="0000000000000000";
					
					else
						Dout<="0000000000000000";
					end if;
				else
					NULL;
				end if;
			end if;
		end if;
	end process;

end architecture struct;