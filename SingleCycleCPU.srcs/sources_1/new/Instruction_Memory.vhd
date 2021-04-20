----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/14/2021 02:03:14 PM
-- Design Name: 
-- Module Name: Instruction_Memory - Behavioral
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

entity Instruction_Memory is
    port (
        instr_addr : in std_logic_vector(63 downto 0);
        instruction : out std_logic_vector(31 downto 0)
    );
end Instruction_Memory;

architecture rtl of Instruction_Memory is
    type memory is array (0 to 255) of std_logic_vector(31 downto 0);
    signal mem_instr : memory := (
    "11111000010000000000000101000010", --  LDUR X2, [X10, #0]
    "11111000010000001000000101000011", --  LDUR X3, [X10, #8]
    "11001011000000100000000001100100", --  SUB X4, X3, X2
    "10001011000000100000000001100101", --  ADD X5, X3, X2
    "10110100000000000000000001000001", --  CBZ X1, #2
    "10110100000000000000000001000000", --  CBZ X0, #2
    "11111000010000000000000101000010", --  LDUR X2, [X10, #0]
    "10101010000000110000000001000110", --  ORR X6, X2, X3
    "10001010000000110000000001000111", --  AND X7, X2, X3
    "11111000000000001000000011100100", --  STUR X4, [X7, #8]
    "00010100000000000000000000000010", --  B #2
    "11111000010000001000000101000011", --  LDUR X3, [X10, #8]
    "10001011000000010000000000001000",  --  ADD X8, X0, X1
    others => "00000000000000000000000000000000" -- Set the rest of the memory to 0
    );
begin

    --Select instruction from addr
    process is 
    begin
        instruction <= mem_instr(to_integer(unsigned(instr_addr)));
        wait on instr_addr;
    end process;
    

end rtl;
