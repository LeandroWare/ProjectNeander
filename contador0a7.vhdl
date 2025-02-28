library ieee;
use ieee.std_logic_1164.all;

entity contador is
    port(
        clock : in std_logic;
        reset : in std_logic;
        pr    : in std_logic;
        q     : out std_logic_vector(2 downto 0)
    );
end contador;

architecture contamento of contador is

component ffjk is
    port(
        j, k   : in std_logic;
        clock  : in std_logic;
        pr, cl : in std_logic;
        q, nq  : out std_logic
    );
end component;

component controle is
    port(
        q    : in std_logic_vector(2 downto 0);
        j, k : out std_logic_vector(2 downto 0)
    );
end component;

    signal sq, snq : std_logic_vector(2 downto 0); 
    signal sj, sk  : std_logic_vector(2 downto 0); 

begin
    u_controle : controle port map(sq, sj, sk);

    u_ffjk0 : ffjk port map(sj(0), sk(0), clock, reset, pr, sq(0), snq(0));
    u_ffjk1 : ffjk port map(sj(1), sk(1), clock, pr, reset, sq(1), snq(1));
    u_ffjk2 : ffjk port map(sj(2), sk(2), clock, pr, reset, sq(2), snq(2));

    q <= sq;
end architecture;