----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/11/2021 02:47:13 PM
-- Design Name: 
-- Module Name: Data_Memory_TB - Behavioral
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

entity Data_Memory_TB is
--  Port ( );
end Data_Memory_TB;

architecture Behavioral of Data_Memory_TB is
    
    -- Input Signals
    signal input_addr : std_logic_vector(63 downto 0) := x"0000000000000000";
    signal input_data : std_logic_vector(63 downto 0) := x"abcdefedcbafabcf";
    signal mem_write : std_logic := '1';
    signal mem_read : std_logic := '0';
    
    -- Output signal
    signal output : std_logic_vector(63 downto 0) := (others => '0');
    

begin

    -- Write input data to memory
    i_datamem : entity work.data_memory(rtl) port map (
        input_addr => input_addr,
        input_data => input_data,
        mem_write => mem_write,
        mem_read => mem_read,
        mem_data => output
    );
    
    -- Switch to read mode
    process is 
    begin
        wait for 100ns;
        mem_write <= '0';
        mem_read <= '1';
    end process;


end Behavioral;
