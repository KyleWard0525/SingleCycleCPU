----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/11/2021 12:56:40 PM
-- Design Name: 
-- Module Name: Program_Counter - Behavioral
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

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Program_Counter is
    port(
        clk : in std_logic;
        next_addr : inout std_logic_vector(63 downto 0);
        curr_addr : out std_logic_vector(63 downto 0)
    );
end Program_Counter;

architecture rtl of Program_Counter is
    signal pc : std_logic_vector(63 downto 0) := x"0000000000000000";
    constant max_pc : integer := 255;
begin

    -- Assign current instruction address
    process(clk) is
    begin
        -- Only operate on rising edge
        if rising_edge (clk) then
                curr_addr <= pc; 
                pc <= std_logic_vector(unsigned(pc) + 1);
                
                --  Check if pc should be reset
                if to_integer(unsigned(pc)) > max_pc then
                    --  Reset pc
                    pc <= x"0000000000000000";
                end if;
                
                next_addr <= std_logic_vector(unsigned(pc) + 1);
        end if;
    end process;

end rtl;
