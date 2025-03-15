library IEEE;
  use IEEE.std_logic_1164.all;

  -- ABAIXO COLOCAR EM OUYRO ARQUIVO (JZ.VHDL) TODO

entity JZ is
  port (
    c : in  std_logic_vector(2 downto 0);
    jz_flag : in std_logic;
    s : out std_logic_vector(10 downto 0)
  );
end entity;

architecture JZ of JZ is

  component JMP is
    port (
      c : in  std_logic_vector(2 downto 0);
      s : out std_logic_vector(10 downto 0)
    );
  end component;

  component FALSEJMP is
    port (
      c : in  std_logic_vector(2 downto 0);
      s : out std_logic_vector(10 downto 0)
    );
  end component;

  signal s_jmp, s_falsejmp : std_logic_vector(10 downto 0);

begin

  u_jmp : JMP port map(c, s_jmp);
  u_falsejmp : FALSEJMP port map(c, s_falsejmp);

  s <= s_jmp when jz_flag = '1' else s_falsejmp;
end architecture;
