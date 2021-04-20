----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/12/2021 03:35:37 PM
-- Design Name: 
-- Module Name: PC_TB - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.math_real.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PC_TB is
--  Port ( );
end PC_TB;

architecture Behavioral of PC_TB is
   
   -- Control signals
   signal clock_freq : integer := 100; -- 100MHz
   signal clock_per : time := 1000ns/clock_freq;
   signal clock : std_logic := '0';
   signal curr : std_logic_vector(63 downto 0) := (others => '0');
   
   -- Output signals
   signal output : std_logic_vector(63 downto 0);
   
begin
    
    -- Tick clock
    process is
    begin
        wait for clock_per;
        clock <= not clock;
    end process;
      
    -- Call program counter
    i_pc : entity work.program_counter(rtl) port map
    (
        clk => clock,
        next_addr => curr,
        curr_addr => curr
    );


end Behavioral;
