library IEEE;
use IEEE.std_logic_1164.all;

entity moduloMEM is
	port(
        rst, clk   : in    std_logic;
        nbarrPC    : in    std_logic;
        REM_nrw    : in    std_logic;
        MEM_nrw    : in    std_logic;
        RDM_nrw    : in    std_logic;
        end_PC     : in    std_logic_vector(7 downto 0);       
        end_Barr   : in    std_logic_vector(7 downto 0);
		barramento : inout std_logic_vector(7 downto 0)
	);
end entity moduloMEM;

architecture dostoragestuff of moduloMEM is
    -- componente regREM e regRDM
    component reg8bits is
        port(
            d : in std_logic;
            clock : in std_logic;
            cl, pr : in std_logic; 
            nrw : in std_logic;
            s : out std_logic
        );
    end component;

    -- componente MEMORIA
    component as_ram is
	    port(
		    addr  : in    std_logic_vector(7 downto 0);
		    data  : inout std_logic_vector(7 downto 0);
		    notrw : in    std_logic;
		    reset : in    std_logic
	    );
    end component as_ram;

    signal s_mux2rem, s_rem2mem, s_mem2rdm : std_logic_vector(7 downto 0) := (others => 'Z');
    signal s_rdm2barr : std_logic_vector(7 downto 0) := (others => 'Z');
begin

    -- mux2x8
    s_mux2rem <= end_PC   when nbarrPC = '1' else
                 end_Barr when nbarrPC = '0' else
                 (others => 'Z');

    -- registrador REM
    u_reg_8bits_rem : reg8bits port map(
        s_mux2rem, clk, rst, '1', REM_nrw, s_rem2mem 
    );

    -- Memória
    -- remember
   
    -- registrador RDM
    u_reg_8bits_rdm : reg8bits port map(
        s_mem2rdm, clk, rst, '1', RDM_nrw, s_rdm2barr
    );

    -- trap killer!
    barramento <= s_rdm2barr when MEM_nrw = '0' else (others => 'Z');
    s_mem2rdm  <= barramento when MEM_nrw = '1' else (others => 'Z');

end architecture;