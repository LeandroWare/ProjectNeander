library ieee;
use ieee.std_logic_1164.all;

entity reg2bits is
  port(
    d : in std_logic_vector(1 downto 0);
    clock : in std_logic;
    pr, cl : in std_logic; 
    nrw : in std_logic;
    s : out std_logic_vector(1 downto 0)
  );
end entity;

architecture reg2bit of reg2bits is
  component reg1bit is
  port(
    d : in std_logic;
    clock : in std_logic;
    pr, cl : in std_logic; 
    nrw : in std_logic;
    s : out std_logic
  );
end component;

begin 
 -- instâncias de regCarga1bit (8 vezes)
 u_reg0 : reg1bit port map(d(0), clock, pr, cl, nrw, s(0));
 u_reg1 : reg1bit port map(d(1), clock, pr, cl, nrw, s(1));

 -- como alternativa e sugestão, é possível trocar as 8 linhas anteriores
 -- por um generate do VHDL!
end architecture;