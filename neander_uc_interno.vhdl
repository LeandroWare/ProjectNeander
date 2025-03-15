-- neander módulo secundario UC-PC ==================================
library IEEE;
  use IEEE.std_logic_1164.all;

entity moduloPC is
  port (
    rst, clk   : in  std_logic;
    PC_nrw     : in  std_logic;
    nbarrINC   : in  std_logic;
    barramento : in  std_logic_vector(7 downto 0);
    endereco   : out std_logic_vector(7 downto 0)
  );
end entity;

architecture dopointstuff of moduloPC is

  -- componente regPC
  component reg8bits is
    port (
      d      : in  std_logic_vector(7 downto 0);
      clock  : in  std_logic;
      pr, cl : in  std_logic;
      nrw    : in  std_logic;
      s      : out std_logic_vector(7 downto 0)
    );
  end component;

  -- componente somador8bits
  component somador8bits is
    port (
      a    : in  std_logic_vector(7 downto 0); -- entrada x
      b    : in  std_logic_vector(7 downto 0); -- entrada y
      cin  : in  std_logic;                    -- entrada carry in geral
      cout : out std_logic;                    -- saída carry out geral
      s    : out std_logic_vector(7 downto 0)  -- Resposta/Saída
    );
  end component;

  signal sendereco, s_mux2pc : std_logic_vector(7 downto 0) := (others => 'Z');
  signal sadd, x, y          : std_logic_vector(7 downto 0) := (others => 'Z');
  signal s_um                : std_logic_vector(7 downto 0) := "00000001";
  signal saddc               : std_logic;

begin

  -- registrador PC
  -- instanciar registrador normalmente como feito anteriormente
  -- easy pease lemous queeze
  u_regPC: reg8bits port map (s_mux2pc, clk, '1', rst, PC_nrw, sendereco);
  endereco <= sendereco;

  -- incrementador
  -- instanciar
  x <= sendereco;
  y <= s_um;

  -- ADDER
  u_adder: somador8bits port map (x, y, '0', saddc, sadd);

  -- mux2x8
  -- if e else basicamente
  s_mux2pc <= sadd when nbarrINC = '1' else barramento;

end architecture;
