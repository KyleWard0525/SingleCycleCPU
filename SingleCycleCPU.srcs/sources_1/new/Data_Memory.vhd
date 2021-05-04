----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/11/2021 02:28:29 PM
-- Design Name: 
-- Module Name: Data_Memory - Behavioral
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

entity Data_Memory is
    port(
        input_addr : in std_logic_vector(63 downto 0); -- Input address
        input_data : in std_logic_vector(63 downto 0); 
        mem_write : in std_logic; -- Allows memory writes when enabled
        mem_read : in std_logic; --Allows memory reads when endabled
        mem_data : out std_logic_vector(63 downto 0) -- Data read from memory
    );
end Data_Memory;

architecture rtl of Data_Memory is
    type memory is array (63 downto 0) of std_logic_vector(7 downto 0);
    
    --  Assign memory signal and initialize the first 8 bytes
    signal mem_locs : memory := (
        
        "11110000", --  byte 0
        "00001111", --  byte 1
        "11111111", --  byte 2
        "00000000", --  byte 3
        "10101010", --  byte 4
        "11001100", --  byte 5
        "11011101", --  byte 6
        "10111011", --  byte 7
        others => "00000000" -- Initialize the remaining locations to all zeros
    );
    
    
begin
    
    process is
        variable low : integer := 0;
        variable high : integer := 7;
        variable bytes : integer := 7;
    begin
        
        -- Check if instruction is read or write
        if mem_write = '1' then
            
            --Write first byte to memory
            mem_locs(to_integer(unsigned(input_addr))) <= input_data(high downto low);
            
            for i in 1 to bytes loop
              --Increment byte
              low := low + 8;
              high := high + 8;
              -- Write next bytes
              mem_locs(to_integer(unsigned(input_addr)) + i) <= input_data(high downto low);
              
            end loop;
   
            
        --Read operation
        else if mem_read = '1' then
            low := 0;
            high := 7;
            --Read first byte from memory
            mem_data(high downto low) <= mem_locs(to_integer(unsigned(input_addr)));
            
            for i in 1 to bytes loop
                --Increment byte
                low := low + 8;
                high := high + 8;
                
                --Read next bytes
                mem_data(high downto low) <= mem_locs(to_integer(unsigned(input_addr) + i));
            
            end loop;
    end if;   
    end if;
    
    wait on input_addr, input_data, mem_write, mem_read; -- Wait for change in input signals
    
    end process;
    
    
    

end rtl;
