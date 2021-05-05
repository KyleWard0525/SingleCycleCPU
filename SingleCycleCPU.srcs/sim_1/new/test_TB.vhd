----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/05/2021 01:14:23 AM
-- Design Name: 
-- Module Name: test_TB - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity test_TB is
--  Port ( );
end test_TB;

architecture Behavioral of test_TB is

    constant clock_freq : integer := 9001;
    constant clock_cycle : time := 1000ns / clock_freq;
    signal clock : std_logic := '0';
    
begin

    process is 
    begin
        wait for 1us;
        clock <= not clock;
    end process;


end Behavioral;
