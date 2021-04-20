----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/18/2021 04:51:49 PM
-- Design Name: 
-- Module Name: ALU_Control_TB - Behavioral
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

entity ALU_Control_TB is
--  Port ( );
end ALU_Control_TB;

architecture Behavioral of ALU_Control_TB is

    type ALUop_arr is array (2 downto 0) of std_logic_vector(1 downto 0);
    type opcode_arr is array (3 downto 0) of std_logic_vector(10 downto 0);
    
    --  Control signals
    constant clock_freq : integer := 100; --    100MHz
    constant clock_period : time := 1000ns/clock_freq;
    signal clock : std_logic := '0';
    signal counter : integer := 0; --   For iterating through arrays
    
    
    
    --  Output signal
    signal ALUopcode : std_logic_vector(3 downto 0);
    
    --  Possible ALUop signals
    signal ALUcode : ALUop_arr := (
        "00",
        "01",
        "10"
    );
    
    --  Possible opcode signals
    signal opcodes : opcode_arr := (
        "10001011000",
        "11001011000",
        "10001010000",
        "10101010000"
    );
    
    --  Input signals
    signal opcode : std_logic_vector(10 downto 0) := opcodes(counter);
    signal ALUop : std_logic_vector(1 downto 0) := ALUcode(counter);

begin
        --  Tick clock
        process is
        begin
            wait for clock_period;
            clock <= not clock;
        end process;
        
        -- Compute ALUopcode
        i_alu_contr : entity work.alu_control(rtl) port map (
            opcode => opcode,
            ALUop => ALUop,
            ALUopcode => ALUopcode
        );
        
        --  Modify inputs signals
        process is 
        begin
            counter <= counter + 1;
            
            if counter >= 2 then
                counter <= 0;
            end if;
            
            opcode <= opcodes(counter);
            ALUop <= ALUcode(counter);
            wait for clock_period;
        end process;

end Behavioral;
