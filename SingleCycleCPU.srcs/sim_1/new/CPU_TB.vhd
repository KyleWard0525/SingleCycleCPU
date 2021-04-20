----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/20/2021 11:58:43 AM
-- Design Name: 
-- Module Name: CPU_TB - Behavioral
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

entity CPU_TB is
--  Port ( );
end CPU_TB;

architecture Behavioral of CPU_TB is

    --  Clock signals
    signal clock : std_logic := '0';
    signal clock_freq : integer := 100; --  100MHz
    signal clock_cycle : time := 1000ns / clock_freq;
    
    --  Program counter
    signal pc : std_logic_vector(63 downto 0);
    signal next_pc : std_logic_vector(63 downto 0);
    
    --  Current instruction
    signal curr_instr : std_logic_vector(31 downto 0);
    
    --  Sign extended instruction
    signal se_instr : std_logic_vector(63 downto 0);
    
    --  Register file signals
    signal regWrite : std_logic; -- Enable writing to write register
    signal regA : std_logic_vector(4 downto 0); --  Read register 1
    signal regB : std_logic_vector(4 downto 0); --  Read register 2
    signal regW : std_logic_vector(4 downto 0); --  Write register
    signal writeData : std_logic_vector(63 downto 0) := (others => '0'); -- Data to write to write register
    signal regAOut : std_logic_vector(63 downto 0); --  Output of register A
    signal regBOut : std_logic_vector(63 downto 0); --  Output of register B
    
    --  Control unit signals 
    signal opcode : std_logic_vector(10 downto 0);
    signal ALUop : std_logic_vector(1 downto 0);
    signal Reg2Loc : std_logic;
    signal ALUsrc : std_logic;
    signal PCsrc : std_logic;
    signal MemRead : std_logic;
    signal MemWrite : std_logic;
    signal MemToReg : std_logic;
    signal Branch : std_logic;
    
    --  ALU signals
    signal ALUopcode : std_logic_vector(3 downto 0);
    signal ALUoutput : std_logic_vector(63 downto 0);
    signal ALUzout : std_logic;

begin

    --  Tick clock
    process is 
    begin
        wait for clock_cycle;
        clock <= not clock;
        writeData <= std_logic_vector(unsigned(writeData) + 1); --  Increment data
    end process;
    
    --  Create Program Counter (PC)
    i_pc : entity work.program_counter(rtl) port map 
    (
        clk => clock,
        next_addr => next_pc,
        curr_addr => pc
    );
    
    -- Send address from pc to instruction memory
    i_im : entity work.instruction_memory(rtl) port map (
        instr_addr => pc,
        instruction => curr_instr
    );
    
    --  Sign-extend the current instruction
    i_se : entity work.sign_extend(rtl) port map (
        input => curr_instr,
        output => se_instr
    );
    
    --  Get opcode
    opcode <= curr_instr(31 downto 21);
    
    --  Create Control Unit
    i_cu : entity work.control_unit(rtl) port map (
        opcode => opcode,
        ALUop => ALUop,
        Reg2Loc => Reg2Loc,
        RegWrite => regWrite, -- Pass to register file
        ALUsrc => ALUsrc,
        PCsrc => PCsrc,
        MemRead => MemRead,
        MemWrite => MemWrite,
        MemToReg => MemToReg,
        Branch => Branch
    );
    
    --  Deconstruct instruction operands
    process is 
    begin
        
        regA <= curr_instr(9 downto 5); --  Value for Register A
        
        --  Check Reg2Loc flag
        if Reg2Loc = '1' then
            regB <= curr_instr(4 downto 0); --  Rt field (LDUR or STUR)
            
        else if Reg2Loc = '0' then
            regB <= curr_instr(20 downto 16); -- Rm field (R-type)
    
         end if;    
        end if;
        
        regW <= curr_instr(4 downto 0); --  Write register
    wait for 1ns;
    end process;
    
    --  Read/Write to or from Register File
    i_rf : entity work.register_file(rtl) port map (
        reg_write_enable => regWrite,
        reg_a_sel => regA,
        reg_b_sel => regB,
        reg_write_sel => regW,
        input_data => writeData,
        reg_a_out => regAOut,
        reg_b_out => regBOut
    );
    
    --  Create ALU Control Unit
    i_alu_contr : entity work.alu_control(rtl) port map (
        opcode => opcode,
        ALUop => ALUop,
        ALUopcode => ALUopcode
    );
    
    --  Create ALU
    i_alu : entity work.alu(rtl) port map (
        opcode => ALUopcode,
        a => regAOut,
        b => regBOut,
        output => ALUoutput,
        z_out => ALUzout
    );

end Behavioral;
