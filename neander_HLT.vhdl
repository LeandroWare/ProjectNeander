library IEEE;
  use IEEE.std_logic_1164.all;

  -- ABAIXO COLOCAR EM OUYRO ARQUIVO (HLT.VHDL) TODO

entity HLT is
  port (
    c : in  std_logic_vector(2 downto 0);
    s : out std_logic_vector(10 downto 0)
  );
end entity;

architecture HLT of HLT is
begin
  s(0)          <= '0'; -- barrINC
  s(1)          <= '0'; -- barrPC
  s(4 downto 2) <= "000"; -- ULA_op
  s(5)          <= '0'; -- PC_nrw
  s(6)          <= '0'; -- AC_nrw
  s(7)          <= '0'; -- MEM_rw
  s(8)          <= '0'; -- REM_nrw
  s(9)          <= '0'; -- RDM_nrw
  s(10)         <= '0'; -- RI_nrw
end architecture;
