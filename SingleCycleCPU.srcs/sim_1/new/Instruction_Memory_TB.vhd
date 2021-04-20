----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/14/2021 02:42:27 PM
-- Design Name: 
-- Module Name: Instruction_Memory_TB - Behavioral
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

entity Instruction_Memory_TB is
--  Port ( );
end Instruction_Memory_TB;

architecture Behavioral of Instruction_Memory_TB is
    
    --  Control signals
    signal clock : std_logic := '0';
    constant clock_freq : integer := 100; --    100 MHz
    constant clock_period : time := 1000ns/clock_freq;
    
    --  Program counter
    signal pc : std_logic_vector(63 downto 0);
    signal next_addr : std_logic_vector(63 downto 0);
    
    -- Instruction from memory
    signal instruction : std_logic_vector(31 downto 0) := (others => '0');
    
begin

    --  Tick clock
    process is 
    begin
        wait for clock_period;
        clock <= not clock;
    end process;

    --  Create instance of program counter
    i_pc : entity work.program_counter(rtl) port map(
        clk => clock,    
        next_addr => next_addr,
        curr_addr => pc
    );
    
    --  Create instruction memory instance
    i_im : entity work.instruction_memory(rtl) port map(
        instr_addr => pc,
        instruction => instruction
    );

end Behavioral;
