----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/07/2021 12:24:35 PM
-- Design Name: Sign Extender
-- Module Name: Sign_Extend - Behavioral
-- Project Name: SingleCycleCPU
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

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Sign_Extend is
port (
        input : in std_logic_vector(31 downto 0);
        output : out std_logic_vector(63 downto 0)
    );
end Sign_Extend;

architecture rtl of Sign_Extend is

begin

    process is
    begin
        -- Pad output with MSB
        output <= std_logic_vector(resize(signed(input), output'length));
        wait for 10ns;
    end process;

end rtl;
