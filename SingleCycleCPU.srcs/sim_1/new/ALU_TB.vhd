----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/06/2021 05:02:26 PM
-- Design Name: 
-- Module Name: ALU_TB - Behavioral
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

entity ALU_TB is
--  Port ( );
end ALU_TB;

architecture Behavioral of ALU_TB is

    signal clk : std_logic := '0';
    
    -- Input signals
    signal opcode : std_logic_vector(3 downto 0) := "0000";
    signal a : std_logic_vector(63 downto 0) := x"FD1FABCD12FACAFD";
    signal b : std_logic_vector(63 downto 0) := x"ABCBDCBABCDAADDA";
    
    -- Outputs
    signal output : std_logic_vector(63 downto 0);
    signal z_out : std_logic;

begin

    -- Tick clock
    process is
    begin
        wait for 10ns;
        clk <= not clk;
    end process;

    i_alu : entity work.ALU(rtl) port map (
        opcode => opcode,
        a => a,
        b => b,
        output => output,
        z_out => z_out
        );
    
    -- Change opcode every 100ns
    process is
    begin
        wait for 100ns;
        opcode <= "0001";
        wait for 100ns;
        opcode <= "0010";
        wait for 100ns;
        opcode <= "0110";
        wait for 100ns;
        opcode <= "0111";
        wait for 100ns;
        opcode <= "1100";
    end process;

end Behavioral;
