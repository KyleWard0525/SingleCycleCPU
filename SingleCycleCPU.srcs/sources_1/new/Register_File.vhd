----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/11/2021 01:07:48 PM
-- Design Name: 
-- Module Name: Register_File - Behavioral
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

entity Register_File is
    port (
        reg_write_enable : in std_logic; -- Must be 1 for writes to occur 
        reg_a_sel : in std_logic_vector(4 downto 0); -- Selects register A to read from (r0-r31)
        reg_b_sel : in std_logic_vector(4 downto 0); -- Selects register B to read from (r0-r31)
        reg_write_sel : in std_logic_vector(4 downto 0); -- Selects register to write too
        input_data : in std_logic_vector(63 downto 0);
        reg_a_out : out std_logic_vector(63 downto 0); -- Data read from register A
        reg_b_out : out std_logic_vector(63 downto 0) -- Data read from register B
    );
end Register_File;

architecture rtl of Register_File is
    type reg_file is array(31 downto 0) of std_logic_vector(63 downto 0);-- Register file
    signal registers : reg_file;
begin
    -- Clock sensitive process 
    process is
    begin
           -- Read data from register A and B
           reg_a_out <= registers(to_integer(unsigned(reg_a_sel)));
           reg_b_out <= registers(to_integer(unsigned(reg_b_sel)));
           
           -- Check if input data should be written to register
           if reg_write_enable = '1' then
                -- Write input data to selected write register
                registers(to_integer(unsigned(reg_write_sel))) <= input_data;
                
                -- Check if selected write register is regA or regB
                -- If so, pass input data to that register
                if reg_write_sel = reg_a_sel then
                    reg_a_out <= input_data;
                else if reg_write_sel = reg_b_sel then
                    reg_b_out <= input_data;
                end if;
              end if;
              
           end if;
    wait for 1ns;
    end process;
end rtl;
