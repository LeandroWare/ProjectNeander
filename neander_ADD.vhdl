library IEEE;
  use IEEE.std_logic_1164.all;

  -- ABAIXO COLOCAR EM OUYRO ARQUIVO (ADD.VHDL) TODO

entity ADDD is
  port (
    c : in  std_logic_vector(2 downto 0);
    s : out std_logic_vector(10 downto 0)
  );
end entity;

architecture ADDD of ADDD is
begin
  s(0)          <= '1';                                                     -- barrINC
  s(1)          <= '0' when c = "101" else '1';                             -- barrPC
  s(4 downto 2) <= "001";                                                   -- ULA_op
  s(5)          <= '1' when (c = "001" or c = "100") else '0';              -- PC_nrw
  s(6)          <= '1' when c = "111" else '0';                             -- AC_nrw
  s(7)          <= '0';                                                     -- MEM_rw
  s(8)          <= '1' when (c = "000" or c = "011" or c = "101") else '0'; -- REM_nrw
  s(9)          <= '1' when (c = "001" or c = "100" or c = "110") else '0'; -- RDM_nrw
  s(10)         <= '1' when c = "010" else '0';                             -- RI_nrw
end architecture;
