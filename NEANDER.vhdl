library IEEE;
  use IEEE.std_logic_1164.all;

entity NEANDER is
  port (
    rst : in std_logic;
    clk : in std_logic
  );
end entity;

architecture comPUTAdoringstuff of NEANDER is

  component moduloULA is
    port (
      rst, clk   : in    std_logic;
      AC_nrw     : in    std_logic;
      ula_op     : in    std_logic_vector(2 downto 0);
      MEM_nrw    : in    std_logic;
      flags_nz   : out   std_logic_vector(1 downto 0);
      barramento : inout std_logic_vector(7 downto 0)
    );
  end component;

  component moduloMEM is
    port (
      rst, clk   : in    std_logic;
      nbarrPC    : in    std_logic;
      REM_nrw    : in    std_logic;
      MEM_nrw    : in    std_logic;
      RDM_nrw    : in    std_logic;
      end_PC     : in    std_logic_vector(7 downto 0);
      end_Barr   : in    std_logic_vector(7 downto 0);
      barramento : inout std_logic_vector(7 downto 0)
    );
  end component;

  component moduloUC is
    port (
      rst, clk   : in  std_logic;
      barramento : in  std_logic_vector(7 downto 0);
      RI_nrw     : in  std_logic;
      flags_nz   : in  std_logic_vector(1 downto 0);
      bctrl      : out std_logic_vector(10 downto 0)
    );
  end component;

  component moduloPC is
    port (
      rst, clk   : in  std_logic;
      PC_nrw     : in  std_logic;
      nbarrINC   : in  std_logic;
      barramento : in  std_logic_vector(7 downto 0);
      endereco   : out std_logic_vector(7 downto 0)
    );
  end component;

  -- componenentes: unidade de controle, program counter...
  --signals
  signal barramento             : std_logic_vector(7 downto 0);
  signal s_endPC, s_endBarr     : std_logic_vector(7 downto 0);
  signal flagsNZ                : std_logic_vector(1 downto 0);
  signal s_barramentoDeControle : std_logic_vector(10 downto 0);

  -- Sinais que vem do barramento de controle
  signal nbarrINC,  nbarrPC,  PC_nrw,  AC_nrw,  MEM_nrw,  REM_nrw,  RDM_nrw,  RI_nrw : std_logic;
  signal ula_op : std_logic_vector(2 downto 0);

begin

  -- modulo UC
  u_uc: moduloUC
    port map (
      rst, clk, barramento, RI_nrw, flagsNZ, s_barramentoDeControle -- n_sei e s_barramentoDeControle eu inventei, não achei a variávei certa pra essa saída
    );

  -- nbarrINC vai ser s_barramentoDeControle(0)
  -- nbarrPC vai ser s_barramentoDeConrole(1)
  -- ula_op vai ser s_barramentoDeConrole(4 downto 2)
  -- PC_nrw vai ser s_barramentoDeControle(5)
  -- AC_nrw vai ser s_barramentoDeConrole(6)
  -- MEM_nrw s_barramentoDeConrole(7)
  -- REM_nrw vai ser s_barramentoDeControle(8)
  -- RDM_nrw vai ser s_barramentoDeControle(9)
  -- RI_nrw vai ser s_barramentoDeControle(10)

  nbarrINC <= s_barramentoDeControle(0);
  nbarrPC <= s_barramentoDeControle(1);
  ula_op <= s_barramentoDeControle(4 downto 2);
  PC_nrw <= s_barramentoDeControle(5);
  AC_nrw <= s_barramentoDeControle(6);
  MEM_nrw <= s_barramentoDeControle(7);
  REM_nrw <= s_barramentoDeControle(8);
  RDM_nrw <= s_barramentoDeControle(9);
  RI_nrw <= s_barramentoDeControle(10);

  -- modulo ULA
  u_ula: moduloULA
    port map (
      rst, clk, AC_nrw, ula_op, MEM_nrw, flagsNZ, barramento
    );

  -- modulo PC
  u_pc: moduloPC
    port map (
      rst, clk, PC_nrw, nbarrINC, barramento, s_endPC
    );

  -- modulo MEMORIA
  u_mem: moduloMEM
    port map (
      rst, clk, nbarrPC, REM_nrw, MEM_nrw, RDM_nrw, s_endPC, s_endBarr, barramento
    );

  -- TODO
  -- --> VEM DA UNIDADE DE CONTROLE, AINDA NÃO TEMOS ISSO
  -- TODO -> não entendi o que aqui que vem da unidade de controle
  s_endBarr <= barramento;

end architecture;
