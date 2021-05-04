----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/18/2021 04:25:33 PM
-- Design Name: 
-- Module Name: ALU_Control - Behavioral
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

entity ALU_Control is
    port (
        opcode : in std_logic_vector(10 downto 0);
        ALUop : in std_logic_vector(1 downto 0);
        ALUopcode : out std_logic_vector (3 downto 0)
    );
end ALU_Control;

architecture rtl of ALU_Control is

begin

    --  Calculate ALUopcode
    process is
    begin
        
        case ALUop is
        --  LDUR and STUR
            when "00" =>
                ALUopcode <= "0010";
        --  CBZ
            when "01" =>
                ALUopcode <= "0111";
        --  R-type instruction
            when "10" =>
                --  Check opcode
                case opcode is
                    --  ADD
                    when "10001011000" =>
                        ALUopcode <= "0010";
                        
                    --  SUB
                    when "11001011000" =>
                        ALUopcode <= "0110";
                        
                    --  AND
                    when "10001010000" =>
                        ALUopcode <= "0000";
                        
                    --  OR
                    when "10101010000" =>
                        ALUopcode <= "0001";
                        
                    when others =>
                        
                end case;
                    when others =>
                    
        end case;
        
    wait on opcode,ALUop; --    Wait for a change in input signal
    
    end process;

end rtl;
