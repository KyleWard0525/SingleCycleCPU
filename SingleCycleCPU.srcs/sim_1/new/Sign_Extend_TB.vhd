----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/07/2021 12:27:02 PM
-- Design Name: 
-- Module Name: Sign_Extend_TB - Behavioral
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

entity Sign_Extend_TB is
--  Port ( );
end Sign_Extend_TB;

architecture Behavioral of Sign_Extend_TB is

   -- Control signal
    signal clk : std_logic := '0';
    
    --Input
    signal input : std_logic_vector(31 downto 0) := x"AFABCEFC";
    
    -- Output
    signal output : std_logic_vector(63 downto 0);

begin

    --Tick clock
    process is 
    begin
        wait for 10ns;
        clk <= not clk;
    end process;
    
    -- Call sign extender
    i_signext : entity work.sign_extend(rtl) port map
    (
    input => input,
    output => output    
    );
    
end Behavioral;
