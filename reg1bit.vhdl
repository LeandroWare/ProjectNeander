library ieee;
use ieee.std_logic_1164.all;

--MUX
entity reg1bit is
  port(
    d : in std_logic;
    clock : in std_logic;
    pr, cl : in std_logic; 
    nrw : in std_logic;
    s : out std_logic
  );
end entity;

--Módulo
architecture reg1bits of reg1bit is
  component ffjk is
    port(
      d : in std_logic;
      clock : in std_logic;
      pr, cl : in std_logic;
      q, nq : out std_logic
    );
  end component;

  signal datain, dataout : std_logic;

begin
  s <= dataout;

  datain <= dataout when nrw = '0' else d; 
 
 -- instância do reg
  u_reg : ffjk port map(datain, clock, pr, cl, dataout);

end architecture;