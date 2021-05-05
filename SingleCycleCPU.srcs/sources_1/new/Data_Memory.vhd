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
    type memory is array (256 downto 0) of std_logic_vector(7 downto 0);
    
    
     --  std_logic_vector to string
    function slv_to_string ( a: std_logic_vector) return string is
        variable b : string (a'length downto 1) := (others => NUL);
    begin
        for i in a'length downto 1 loop
        b(i) := std_logic'image(a((i-1)))(2);
        end loop;
    return b;
    end function;
    
    --  Function for mapping one numeric range onto another
    function range_map ( input_start : integer; input_end : integer; output_start: integer; output_end: integer; input: integer)
    return integer is 
        variable output : integer;
    begin
        output := output_start + ((input - input_start) * (output_end - output_start)) / (input_end - input_start);
        return output;
    end function;
    
    --  Assign memory signal and initialize the first 8 bytes
    signal mem_locs : memory := (
        
        "10000000", --  byte 0
        "01000000", --  byte 1
        "00100000", --  byte 2
        "00010000", --  byte 3
        "00001000", --  byte 4
        "00000100", --  byte 5
        "00000010", --  byte 6
        "00000001", --  byte 7
        others => "00110101" -- Initialize the remaining locations to all zeros
    );
    
    
begin
    
    process is
        variable low : integer := 0;
        variable high : integer := 7;
        variable bytes : integer := 7;
        variable int : integer;
        variable mapped_addr : integer;
    begin
        
        --  Map input address to a data memory location
        mapped_addr := range_map(0, 9999999, 0, 255, to_integer(unsigned(input_addr)));
        
        report "Mapped address value = " & integer'image(mapped_addr);

        
        -- Check if instruction is read or write
        if mem_write = '1' then
            
            low := 0;
            high := 7;

            
            --Write first byte to memory
            mem_locs(mapped_addr) <= input_data(high downto low);
            
            for i in 1 to bytes loop
              
               --Increment byte
              low := low + 8;
              high := high + 8;
             
              
              -- Write next bytes
              mem_locs(mapped_addr + i) <= input_data(high downto low);
              
             
            end loop;
   
            
        --Read operation
        else if mem_read = '1' then
            low := 0;
            high := 7;
            
            report "Input address in mem_read = " & slv_to_string(input_addr);
            
            --Read first byte from memory
            mem_data(high downto low) <= mem_locs(mapped_addr);
            
            for i in 1 to bytes loop
                --Increment byte
                low := low + 8;
                high := high + 8;
                
                
                --Read next bytes
                mem_data(high downto low) <= mem_locs(mapped_addr + i);
            
            end loop;
    end if;   
    end if;
    
    --low := 0;
   -- high := 0;
    
    wait on input_addr, input_data, mem_write, mem_read; -- Wait for change in input signals
    
    end process;
    
    
    

end rtl;
