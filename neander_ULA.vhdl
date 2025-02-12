-- neander módulo principal ULA ===============================================
library IEEE;
use IEEE.std_logic_1164.all;

entity moduloULA is
	port(
        rst, clk    : in    std_logic;
        AC_nrw      : in    std_logic;
        ula_op      : in    std_logic_vector(2 downto 0);
        MEM_nrw     : in    std_logic;
        flags_nz    : out   std_logic_vector(1 downto 0);
		barramento  : inout std_logic_vector(7 downto 0)
	);
end entity moduloULA;

architecture domathstuff of moduloULA is
    -- componente regAC
    
    -- componente regFLAGS
    
    -- componente ULAinterno
    component moduloULAinterno is
        port(
            x, y        : in  std_logic_vector(7 downto 0);
            ula_op      : in  std_logic_vector(2 downto 0);
            flags_nz    : out std_logic_vector(1 downto 0);
            s           : out std_logic_vector(7 downto 0)
        );
    end component;  

    signal s_ac2ula, s_ula2ac : std_logic_vector(7 downto 0);
    signal s_ula2flags        : std_logic_vector(1 downto 0);

begin

    -- registrador AC

    u_registradorAC : reg_8bits port map(); 
                    --datain <= s_ula2ac;
                    --clk <= clock;
                    --cl <= rst; 
                    --preset <= '1';
                    --sinal_leitura_escrita <= AC_nrw;
                    --dataout <= s_ac2ula);

    -- registrador FLAGS
    
    u_regFLAGS : reg2bits port map();
                    --datain <= s_ula_flags;
                    --clk <= clock;
                    --cl <= rst; 
                    --preset <= '1';
                    --sinal_leitura_escrita <= AC_nrw;
                    --dataout <= flags_nz);

    -- modulo ULA interno
    
    u_ulaInterno : moduloULAinterno port map();
                    --x <= s_ac2ula;
                    --y <= barramento;
                    --ula_op <= ula_op;
                    --flags_nz <= s_ula2flags;
                    --s <= s_ula2ac);

    barramento <= s_ac2ula when MEM_nrw='1' else (others => 'Z');

end architecture domathstuff;

