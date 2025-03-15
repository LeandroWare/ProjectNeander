library IEEE;
  use IEEE.std_logic_1164.all;

  -- ABAIXO COLOCAR EM OUYRO ARQUIVO (LDA.VHDL) TODO

entity LDA is
  port (
    c : in  std_logic_vector(2 downto 0);
    s : out std_logic_vector(10 downto 0)
  );
end entity;

architecture LDA of LDA is
begin
  s(0)          <= '1';                                                             -- barrINC
  s(1)          <= not c(2) or c(1) or not c(0);                                    -- barrPC
  s(4 downto 2) <= "000";                                                           -- ULA_op
  s(5)          <= not c(1) and (c(2) xor c(0));                                    -- PC_nrw
  s(6)          <= c(2) and c(1) and c(2);                                          -- AC_nrw
  s(7)          <= '0';                                                             -- MEM_rw
  s(8)          <= (not c(1) and (c(2) xnor c(0))) or (not c(2) and c(1) and c(0)); -- REM_nrw = 100
  s(9)          <= (c(2) and not c(0)) or (not c(2) and not c(1) and c(0));         -- RDM_nrw
  s(10)         <= not c(2) and c(1) and not c(0);                                  -- RI_nrw
end architecture;
