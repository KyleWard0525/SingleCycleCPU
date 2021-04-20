----------------------------------------------------------------------------------
-- Company: 
-- Engineer: kward60
-- 
-- Create Date: 04/05/2021 03:15:08 PM
-- Design Name: Arithmetic Logic Unit
-- Module Name: ALU - Behavioral
-- Project Name: SingleCycleCPU
-- Target Devices: 
-- Tool Versions: 
-- Description: Takes 2 64-bit inputs, 4-bit control bus, a 64-bit output, and
-- a 1-bit output for conditional branching
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

entity ALU is
    port(
    
    opcode : in std_logic_vector(3 downto 0);
    a : in std_logic_vector(63 downto 0);
    b : in std_logic_vector(63 downto 0);
    output : inout std_logic_vector(63 downto 0);
    z_out : inout std_logic
    
    );
end ALU;

architecture rtl of ALU is

    function slv_to_string ( a: std_logic_vector) return string is
        variable b : string (a'length-1 downto 1) := (others => NUL);
    begin
        for i in a'length-1 downto 1 loop
        b(i) := std_logic'image(a((i-1)))(2);
        end loop;
    return b;
    end function;
    
begin

    -- Perform operation for given opcode
    process is
    begin
        
    
        -- Select operation
        case opcode is
        
        -- AND operation
        when "0000" =>
            output <= a and b;
            report "ALU performed AND operation";
            
        -- OR operation
        when "0001" =>
            output <= a or b;
            report "ALU performed OR operation";
            
       -- ADD operation
        when "0010" =>
            output <= std_logic_vector(unsigned(a) + unsigned(b));
            report "ALU performed ADD operation";
        
        -- SUB operation
        when "0110" =>
            output <= std_logic_vector(unsigned(a) - unsigned(b));
            report "ALU performed SUB operation";
        
        -- Pass b operation
        when "0111" =>
            output <= b;
            report "ALU performed PASS operation";
        
        -- NOR operation
        when "1100" =>
            output <= a nor b;
            report "ALU performed NOR operation";
        
        when others =>
            report "other";
        
        end case;
    
    --  Assert zero output
    if output = x"0000000000000000" then
        z_out <= '1';
    end if;
       
    wait for 10ns;
    end process;


end rtl;
