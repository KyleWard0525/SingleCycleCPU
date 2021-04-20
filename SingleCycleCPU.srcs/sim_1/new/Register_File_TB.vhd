----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/11/2021 01:41:12 PM
-- Design Name: 
-- Module Name: Register_File_TB - Behavioral
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

entity Register_File_TB is
--  Port ( );
end Register_File_TB;

architecture Behavioral of Register_File_TB is
    
    -- Control signals
    signal clk : std_logic := '0';
    constant clk_freq : integer := 70; -- 70 MHz
    constant clk_period : time := 1000ns/clk_freq;
    
    -- Input signals
    signal en_write : std_logic := '1'; -- Enable writes
    signal reg_a : std_logic_vector(4 downto 0) := "00001"; -- Register A
    signal reg_b : std_logic_vector(4 downto 0) := "00010"; -- Register B
    signal write_reg : std_logic_vector(4 downto 0) := "00001"; -- Register to write to
    signal input_data : std_logic_vector(63 downto 0) := x"abceabceabceabce"; -- Data to write to register
    
    -- Output signals
    signal reg_a_out : std_logic_vector(63 downto 0); -- Data read from register A
    signal reg_b_out : std_logic_vector(63 downto 0); -- Data read from register B
    
begin

    --Tick clock
    process is 
    begin
        wait for clk_period;
        clk <= not clk;
    end process;
    
    i_regfile : entity work.register_file(rtl) port map (
        clk => clk,
        reg_write_enable => en_write,
        reg_a_sel => reg_a,
        reg_b_sel => reg_b,
        reg_write_sel => write_reg,
        input_data => input_data,
        reg_a_out => reg_a_out,
        reg_b_out => reg_b_out
    );
    
    

end Behavioral;
