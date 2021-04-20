----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/15/2021 02:13:47 PM
-- Design Name: 
-- Module Name: DataPath_TB - Behavioral
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

entity DataPath_TB is
--  Port ( );
end DataPath_TB;

architecture Behavioral of DataPath_TB is
    
    --  Control signals
    signal clock : std_logic := '0';
    constant clock_freq : integer := 100; -- 100 MHz
    constant clock_cycle : time := 1000ns/clock_freq; --    100 ns
    
    --  Program counter signals
    signal pc : std_logic_vector(63 downto 0) := (others => '0');
    signal next_pc : std_logic_vector(63 downto 0);
    
    --  Instruction memory signals
    signal instruction : std_logic_vector(31 downto 0);
    
    --  Register signals
    signal regWriteEnable : std_logic := '1';
    signal regASel : std_logic_vector(4 downto 0);
    signal regBSel : std_logic_vector(4 downto 0);
    signal regWrite : std_logic_vector(4 downto 0);
    signal writeData : std_logic_vector(63 downto 0) := (others => '0');
    signal regAOut : std_logic_vector(63 downto 0);
    signal regBOut : std_logic_vector(63 downto 0);
    
    --  Data memory signals
    signal mem_input_addr : std_logic_vector(63 downto 0);
    signal mem_input_data : std_logic_vector(63 downto 0);
    signal mem_write : std_logic := '1';
    signal mem_read : std_logic := '0';
    signal mem_output : std_logic_vector(63 downto 0);
    
    --  ALU signals
    type alu_opcode is array (0 to 5) of std_logic_vector(3 downto 0);
    signal curr_opcode_idx : integer := 0;
    signal curr_opcode : std_logic_vector(3 downto 0);
    signal alu_src : std_logic := '0';
    signal alu_in_a : std_logic_vector(63 downto 0);
    signal alu_in_b : std_logic_vector(63 downto 0);
    signal alu_out : std_logic_vector(63 downto 0);
    signal alu_z_out : std_logic;
    signal opcodes : alu_opcode := 
    (
        "0000", --  AND
        "0001", --  OR
        "0010", --  ADD
        "0110", --  SUB
        "0111", --  Pass B
        "1100" --  NOR
     );
     
    --  Sign extend signals
    signal se_output : std_logic_vector(63 downto 0);
     
begin

    -- Tick clock
    process is
    begin
        wait for clock_cycle;
        clock <= not clock;
    end process;
    
    
    --  Create program counter
    i_pc : entity work.program_counter(rtl) port map(
        clk => clock,
        next_addr => next_pc,
        curr_addr => pc
    );
    
    -- Send address from pc to instruction memory
    i_im : entity work.instruction_memory(rtl) port map (
        instr_addr => pc,
        instruction => instruction
    );
    
    -- Construct instruction parts
    process is
    
    variable x : real; 
    variable y : integer; 
    variable seed1 : integer := to_integer(unsigned(pc));
    variable seed2 : integer := to_integer(unsigned(instruction));
    
    begin
        regASel <= instruction(9 downto 5);
        regBSel <= instruction(20 downto 16);
        regWrite <= instruction(4 downto 0);
        wait for 10ns;
    end process;
    
    --  Send instructions to register file
    i_rf : entity work.register_file(rtl) port map(
        reg_write_enable => regWriteEnable,
        reg_a_sel => regASel,
        reg_b_sel => regBSel,
        reg_write_sel => regWrite,
        input_data => writeData,
        reg_a_out => regAOut,
        reg_b_out => regBOut
    );
    
    -- Sign extend instructions
    i_se : entity work.sign_extend(rtl) port map (
        input => instruction,
        output => se_output
    );
    
    --  Determine input for ALU using a multiplexor
    process is
    begin
        
    
        --  Set A input for ALU
        alu_in_a <= regAOut;
        
        --  Check ALU src code
        if alu_src = '0' then
           alu_in_b <= regBOut; --  input b is output read from register b
           
        else if alu_src = '1' then
            alu_in_b <= se_output;  -- input b is sign-extended instruction
        end if;
        end if;
        
        curr_opcode <= opcodes(curr_opcode_idx);
        
        --  Change writeData
        if clock = '1' then
            writeData <= x"aaaabbbbccccdddd";
        
        else if clock = '0' then
            writeData <= not se_output;
            
        end if;
       end if;
        
    wait for 10ns;
    end process;
    
    -- Compute data memory address with ALU
    i_alu : entity work.alu(rtl) port map (
    
        opcode => curr_opcode,
        a => alu_in_a,
        b => alu_in_b,
        output => alu_out,
        z_out => alu_z_out
    );
    
    
end Behavioral;
