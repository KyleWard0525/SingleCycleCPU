----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/07/2021 12:24:35 PM
-- Design Name: Sign Extender
-- Module Name: Sign_Extend - Behavioral
-- Project Name: SingleCycleCPU
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

entity Sign_Extend is
port (
        input : in std_logic_vector(31 downto 0);
        output : inout std_logic_vector(63 downto 0)
    );
end Sign_Extend;

architecture rtl of Sign_Extend is
     --  std_logic_vector to string
    function slv_to_string ( a: std_logic_vector) return string is
        variable b : string (a'length-1 downto 1) := (others => NUL);
    begin
        for i in a'length-1 downto 1 loop
        b(i) := std_logic'image(a((i-1)))(2);
        end loop;
    return b;
    end function;
begin

    process is
        variable dtiOffset : std_logic_vector(8 downto 0); --   Instruction offset for data transfer
        variable branchOffset : std_logic_vector(18 downto 0); --   Intstruction offset for branch 
    
    begin
        --  Determine if instruction is data transfer or branch
        if input(26) = '1' then
            --  Branch
            branchOffset := input(23 downto 5);
        
            -- Sign extend
            output <= std_logic_vector(resize(signed(branchOffset), output'length));
            
        --  Data transfer instruction
        else if input(26) = '0' then
            
            dtiOffset := input(20 downto 12);
            
            -- Sign extend
            output <= std_logic_vector(resize(signed(branchOffset), output'length));
           
        
        end if;    
       end if;
    
        
        wait on input;
    end process;

end rtl;
