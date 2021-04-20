----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/20/2021 11:25:32 AM
-- Design Name: 
-- Module Name: Control_Unit - Behavioral
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

entity Control_Unit is
    port (
        opcode : in std_logic_vector(10 downto 0); --   Opcode from instruction
        ALUop : out std_logic_vector(1 downto 0); --    ALU operation
        Reg2Loc : out std_logic; --     Register for Read register 2 (Rm field if 0 or Rt field if 1)
        RegWrite : out std_logic; --    Whether or not to write data to write register
        ALUsrc : out std_logic; --      Denotes where 2nd ALU operand is from
        PCsrc : out std_logic; --       PC = PC + 4 or PC = branch target
        MemRead : out std_logic; --     Read memory
        MemWrite : out std_logic; --    Write to memory
        MemToReg : out std_logic; --     Value fed to the register write data
        Branch : out std_logic --      Branch flag
    );
end Control_Unit;

architecture rtl of Control_Unit is

begin
    
    --  Compute outputs
    process is 
    begin
        --  R-type instruction
        if opcode(7) = '0' then
           --   Set output signals  
           Reg2Loc <= '0';
           ALUsrc <= '0';
           MemToReg <= '0';
           RegWrite <= '1';
           MemRead <= '0';
           MemWrite <= '0';
           Branch <= '0';
           ALUop <= "10";
        end if;
        
        --  LDUR
        if opcode = "11111000010" then    
            Reg2Loc <= 'X';
            ALUsrc <= '1';
            MemToReg <= '1';
            RegWrite <= '1';
            MemRead <= '1';
            MemWrite <= '0';
            Branch <= '0';
            ALUop <= "00";
        end if;
        
        --  STUR
        if opcode = "11111000000" then
        
            Reg2Loc <= '1';
            ALUSrc <= '1';
            MemToReg <= 'X';
            RegWrite <= '0';
            MemRead <= '0';
            MemWrite <= '1';
            Branch <= '0';
            ALUop <= "00";
        
        end if;
        
        --  CBZ
        if opcode(5) = '1' then
        
            Reg2Loc <= '1';
            ALUSrc <= '0';
            MemToReg <= 'X';
            RegWrite <= '0';
            MemRead <= '0';
            MemWrite <= '0';
            Branch <= '1';
            ALUop <= "01";
        
        end if;
    
    --  Wait for opcode to change
    wait on opcode;
    end process;

end rtl;
