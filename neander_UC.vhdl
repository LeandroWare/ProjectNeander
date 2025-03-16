-- neander módulo principal UC ===============================================
library IEEE;
  use IEEE.std_logic_1164.all;

entity moduloUC is
  port (
    rst, clk   : in  std_logic;
    barramento : in  std_logic_vector(7 downto 0);
    RI_nrw     : in  std_logic;
    flags_nz   : in  std_logic_vector(1 downto 0);
    bctrl      : out std_logic_vector(10 downto 0)
  );
end entity;

architecture docontrolstuff of moduloUC is
  -- componente regRI
  component reg8bits is
    port (
      d      : in  std_logic_vector(7 downto 0);
      clock  : in  std_logic;
      pr, cl : in  std_logic;
      nrw    : in  std_logic;
      s      : out std_logic_vector(7 downto 0)
    );
  end component;

  -- componente DECODE
  -- on code!
  -- componente Contador0-7
  component contador is
    port (
      clock : in  std_logic;
      reset : in  std_logic;
      pr    : in  std_logic;
      q     : out std_logic_vector(2 downto 0)
    );
  end component;

  -- componente UC-interno
  -- on code!
  -- 3bits de contador
  signal s_ciclo : std_logic_vector(2 downto 0) := (others => 'Z');

  signal s_ri2dec : std_logic_vector(7 downto 0) := (others => 'Z');

  -- nop, sta, lda, add, or, and, not, jmp, jn, jz, hlt
  signal s_dec2uc : std_logic_vector(10 downto 0) := (others => 'Z');

  signal s_bctrl : std_logic_vector(10 downto 0) := (others => 'Z');

  -- observacao
  signal instrucaoAtiva : string(1 to 3);
  signal operacaoULA    : string(1 to 3);
  signal FLAGS          : string(1 to 2);

  -- Componentes dos comandos
  component LDA is
    port (
      c : in  std_logic_vector(2 downto 0);
      s : out std_logic_vector(10 downto 0)
        -- signal b_ctrl
    );
  end component;

  component NOP is
    port (
      c : in  std_logic_vector(2 downto 0);
      s : out std_logic_vector(10 downto 0)
        -- signal b_ctrl
    );
  end component;

  component STA is
    port (
      c : in  std_logic_vector(2 downto 0);
      s : out std_logic_vector(10 downto 0)
        -- signal b_ctrl
    );
  end component;

  component ADDD is
    port (
      c : in  std_logic_vector(2 downto 0);
      s : out std_logic_vector(10 downto 0)
        -- signal b_ctrl
    );
  end component;

  component ORR is
    port (
      c : in  std_logic_vector(2 downto 0);
      s : out std_logic_vector(10 downto 0)
        -- signal b_ctrl
    );
  end component;

  component ANDD is
    port (
      c : in  std_logic_vector(2 downto 0);
      s : out std_logic_vector(10 downto 0)
        -- signal b_ctrl
    );
  end component;

  component NOTT is
    port (
      c : in  std_logic_vector(2 downto 0);
      s : out std_logic_vector(10 downto 0)
        -- signal b_ctrl
    );
  end component;

  component JMP is
    port (
      c : in  std_logic_vector(2 downto 0);
      s : out std_logic_vector(10 downto 0)
        -- signal b_ctrl
    );
  end component;

  component JN is
    port (
      c       : in  std_logic_vector(2 downto 0);
      jn_flag :     std_logic;
      s       : out std_logic_vector(10 downto 0)
        -- signal b_ctrl
    );
  end component;

  component JZ is
    port (
      c       : in  std_logic_vector(2 downto 0);
      jz_flag :     std_logic;
      s       : out std_logic_vector(10 downto 0)
        -- signal b_ctrl
    );
  end component;

  component HLT is
    port (
      c : in  std_logic_vector(2 downto 0);
      s : out std_logic_vector(10 downto 0)
        -- signal b_ctrl
    );
  end component;

  -- os sinais cabulosos
  --- cada sinal é um componente como o neander_LDA.vhdl
  signal sNOP : std_logic_vector(10 downto 0) := (others => 'Z');
  signal sSTA : std_logic_vector(10 downto 0) := (others => 'Z');
  signal sLDA : std_logic_vector(10 downto 0) := (others => 'Z');
  signal sADD : std_logic_vector(10 downto 0) := (others => 'Z');
  signal sOR  : std_logic_vector(10 downto 0) := (others => 'Z');
  signal sAND : std_logic_vector(10 downto 0) := (others => 'Z');
  signal sNOT : std_logic_vector(10 downto 0) := (others => 'Z');
  signal sJMP : std_logic_vector(10 downto 0) := (others => 'Z');
  signal sJN  : std_logic_vector(10 downto 0) := (others => 'Z');
  signal sJZ  : std_logic_vector(10 downto 0) := (others => 'Z');
  signal sHLT : std_logic_vector(10 downto 0) := (others => 'Z');

  signal in_jn, in_jz : std_logic;

begin
  -- registrador RI
  u_regRI: reg8bits port map (barramento, clk, '1', rst, RI_nrw, s_ri2dec);

  -- contador
  u_contador: contador port map (clk, rst, '1', s_ciclo);

  -- decodificador 8 para 11
  s_dec2uc <= "10000000000" when s_ri2dec = "00000000" else -- NOP
              "01000000000" when s_ri2dec = "00010000" else -- STA
              "00100000000" when s_ri2dec = "00100000" else -- LDA
              "00010000000" when s_ri2dec = "00110000" else -- ADD
              "00001000000" when s_ri2dec = "01000000" else -- OR
              "00000100000" when s_ri2dec = "01010000" else -- AND
              "00000010000" when s_ri2dec = "01100000" else -- NOT
              "00000001000" when s_ri2dec = "10000000" else -- JMP
              "00000000100" when s_ri2dec = "10010000" else -- JN
              "00000000010" when s_ri2dec = "10100000" else -- JZ
              "00000000001" when s_ri2dec = "11110000"; -- HLT

  -- Unidade de Controle
  -- vou usar como componente
  s_bctrl <= sNOP when s_dec2uc = "10000000000" else
             sSTA when s_dec2uc = "01000000000" else
             sLDA when s_dec2uc = "00100000000" else
             sADD when s_dec2uc = "00010000000" else
             sOR  when s_dec2uc = "00001000000" else
             sAND when s_dec2uc = "00000100000" else
             sNOT when s_dec2uc = "00000010000" else
             sJMP when s_dec2uc = "00000001000" else
             sJN  when s_dec2uc = "00000000100" else
             sJZ  when s_dec2uc = "00000000010" else
             sHLT when s_dec2uc = "00000000001";

  in_jn <= flags_nz(1);
  in_jz <= flags_nz(0);

  -- componente LDA
  u_LDA: LDA port map (s_ciclo, sLDA);
  -- componente STA
  u_STA: STA port map (s_ciclo, sSTA);
  -- componente NOP
  u_NOP: NOP port map (s_ciclo, sNOP);
  -- componente ADD
  u_ADD: ADDD port map (s_ciclo, sADD);
  -- componente ORR
  u_OR: ORR port map (s_ciclo, sOR);
  -- componente ANDD
  u_AND: ANDD port map (s_ciclo, sAND);
  -- componente NOTT
  u_NOT: NOTT port map (s_ciclo, sNOT);
  -- componente JMP
  u_JMP: JMP port map (s_ciclo, sJMP);
  -- componente JN
  u_JN: JN port map (s_ciclo, in_jn, sJN);
  -- componente JZ
  u_JZ: JZ port map (s_ciclo, in_jz, sJZ);
  -- componente HLT
  u_HLT: HLT port map (s_ciclo, sHLT);

  bctrl <= s_bctrl;

  -- PARA DEBUGGING:
  instrucaoAtiva <= "NOP" when s_ri2dec = "00000000" else -- NOP
                    "STA" when s_ri2dec = "00010000" else -- STA
                    "LDA" when s_ri2dec = "00100000" else -- LDA
                    "ADD" when s_ri2dec = "00110000" else -- ADD
                    "ORR" when s_ri2dec = "01000000" else -- OR
                    "AND" when s_ri2dec = "01010000" else -- AND
                    "NOT" when s_ri2dec = "01100000" else -- NOT
                    "JMP" when s_ri2dec = "10000000" else -- JMP
                    "JMP" when s_ri2dec = "10010000" else -- JN
                    "JMP" when s_ri2dec = "10100000" else -- JZ
                    "HLT" when s_ri2dec = "11110000" else -- HLT
                    "ERR";

  operacaoULA <= "001" when s_bctrl = sADD else
                 "101" when s_bctrl = sOR else
                 "011" when s_bctrl = sAND else
                 "100" when s_bctrl = sNOT else
                 "000" when s_bctrl = sLDA else
                 "ERR";

  FLAGS <= "JN" when in_jn = '1' else
           "JZ" when in_jz = '1' else
           "NA";

end architecture;

