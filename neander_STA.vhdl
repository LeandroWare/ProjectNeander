library IEEE;
  use IEEE.std_logic_1164.all;

  -- ABAIXO COLOCAR EM OUYRO ARQUIVO (STA.VHDL) TODO

entity STA is
  port (
    c : in  std_logic_vector(2 downto 0);
    s : out std_logic_vector(10 downto 0)
  );
end entity;

architecture STA of STA is
begin
  s(0)          <= '1';                                                     -- barrINC
  s(1)          <= not c(2) or c(1) or not c(0);                            -- barrPC
  s(4 downto 2) <= "000";                                                   -- ULA_op
  s(5)          <= '1' when (c = "001" or c = "100") else '0';              -- PC_nrw EM CASO DE BUG: PEGAR DO LDA
  s(6)          <= '0';                                                     -- AC_nrw
  s(7)          <= '1' when c = "110" else '0';                             -- MEM_rw
  s(8)          <= '1' when (c = "000" or c = "011" or c = "101") else '0'; -- REM_nrw
  s(9)          <= '1' when (c = "001" or c = "100") else '0';              -- RDM_nrw
  s(10)         <= '1' when c = "010" else '0';                             -- RI_nrw
end architecture;
