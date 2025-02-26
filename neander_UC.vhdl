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
  component moduloContador is
    port (
      rst, clk : in  std_logic;
      counter  : out std_logic_vector(2 downto 0)
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

begin
  -- registrador RI
  u_regRI: reg8bits port map (barramento, clk, '1', rst, RI_nrw, s_ri2dec);

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
              "00000000001" when s_ri2dec = "11110000";     -- HLT

  -- contador
  -- Unidade de Controle
end architecture;
