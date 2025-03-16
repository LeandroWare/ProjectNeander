library ieee;
use ieee.std_logic_1164.all;

entity ffjkd is
    port(
        d      : in std_logic;
        clock  : in std_logic;
        pr, cl : in std_logic;
        q, nq  : out std_logic
    );
end ffjkd;

architecture ff of ffjkd is
    signal s_snj , s_snk   : std_logic;
    signal s_sns , s_snr   : std_logic;
    signal s_sns2, s_snr2  : std_logic;
    signal s_eloS, s_eloR  : std_logic;
    signal s_eloQ, s_elonQ : std_logic;
    signal s_nClock        : std_logic;
begin

    s_nClock <= not(clock);
    
    -- s_snj (primeiro NAND)
    s_snj <= not(d and clock and s_elonQ);
    
    -- s_snk
    s_snk <= not((not d) and clock and s_eloQ);

    -- s_sns
    s_sns <= not(pr and s_snj and s_eloR);

    -- s_snr
    s_snr <= not(cl and s_snk and s_eloS);

    -- s_sns2
    s_sns2 <= s_nClock nand s_sns;

    -- s_snr2
    s_snr2 <= s_nClock nand s_snr;

    -- s_eloS
    s_eloS <= s_sns;

    -- s_eloR
    s_eloR <= s_snr;

    -- s_eloQ
    s_eloQ <= not(pr and s_sns2 and s_elonQ);

    -- s_elonQ
    s_elonQ <= not(cl and s_snr2 and s_eloQ);

    -- envio de saídas de NAND para Q e NQ
    q <= s_eloQ;
    nq <= s_elonQ;

end architecture ff;