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

    --  std_logic_vector to string
    function slv_to_string ( a: std_logic_vector) return string is
        variable b : string (a'length downto 1) := (others => NUL);
    begin
        for i in a'length downto 1 loop
        b(i) := std_logic'image(a((i-1)))(2);
        end loop;
    return b;
    end function;

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
    signal writeData : std_logic_vector(63 downto 0) := x"00000000000000af"; -- Data to write to write register
    signal regAOut : std_logic_vector(63 downto 0); --  Output of register A
    signal regBOut : std_logic_vector(63 downto 0); --  Output of register B
    
    --  Control unit signals 
    signal opcode : std_logic_vector(10 downto 0);
    signal ALUop : std_logic_vector(1 downto 0);
    signal Reg2Loc : std_logic;
    signal ALUsrc : std_logic;
    signal PCsrc : std_logic := '0';
    signal MemRead : std_logic;
    signal MemWrite : std_logic;
    signal MemToReg : std_logic;
    signal Branch : std_logic;
    
    --  ALU signals
    signal ALUopcode : std_logic_vector(3 downto 0);
    signal ALUoperand2 : std_logic_vector(63 downto 0);
    signal ALUoutput : std_logic_vector(63 downto 0);
    signal ALUzout : std_logic;
    
    --  Branch signals
    signal branchTarg : std_logic_vector(63 downto 0);
    
    --  Memory signals
    signal memOutput : std_logic_vector(63 downto 0);

begin

    --  Tick clock
    process is 
    begin
        wait for clock_cycle;
        clock <= not clock;
    end process;
    
    --  Create Program Counter (PC)
    i_pc : entity work.program_counter(rtl) port map 
    (
        clk => clock,
        next_addr => next_pc,
        PCsrc => PCsrc, 
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
    process(clock) is 
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
    
    --  Determine 2nd operand for ALU
    process(clock) is
    begin
        
        --  Operand comes from Read data 2
        if ALUSrc = '0' then
            ALUoperand2 <= regBOut;
        
        --  Operand comes from immmediate field (sign extended)
        else if ALUsrc = '1' then
            ALUoperand2 <= se_instr;
        end if;
        
    end if;
    
    end process;
    
    --  Create ALU
    i_alu : entity work.alu(rtl) port map (
        opcode => ALUopcode,
        a => regAOut,
        b => ALUoperand2,
        output => ALUoutput,
        z_out => ALUzout
    );
    
    --  Check ALU output
    process(clock) is
        variable shifted_instr : std_logic_vector(63 downto 0);
    begin
        
        --  Branch statement (ALUzout and Branch) = PCSrc
        if (ALUzout and Branch) = '1' then
        
            --  Compute shifted instruction
            shifted_instr := std_logic_vector(unsigned(se_instr) sll 2);
        
            --  Compute branch target using adder with inputs pc and shifted_instr
            branchTarg <= std_logic_vector(unsigned(pc) + unsigned(shifted_instr)); 
            
            --  Set next_pc
            next_pc <= branchTarg;
            
          end if;
    
    
    end process; 
    
    --  Read/Write data to or from data memory
    i_memory : entity work.data_memory(rtl) port map (
    
        input_addr => ALUoutput,
        input_data => writeData,
        mem_write => MemWrite,
        mem_read => MemRead,
        mem_data => memOutput
    );
    
    
    --  Determine the value for writeData
    process(clock) is
    begin
    
        --  writeData comes from data read from memory
        if MemToReg = '1' then
            writeData <= memOutput;
            
        --  writeData comes from ALU result
        else
            writeData <= ALUOutput;
        
        end if;
    
    end process;
    

end Behavioral;
