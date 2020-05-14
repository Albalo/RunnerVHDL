LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY Game is 
	port(clk, reset , reset_n: IN std_logic;
			red, green, blue: out std_logic_vector (3 downto 0);
			dipsw : in std_logic_vector (1 downto 0);
			VGA_clk	: inout std_logic:='0';
			n_blank, n_sync, h_sync, v_sync: out std_logic);
			
end entity;

Architecture arc_Game of Game is
signal cclk: std_logic;
signal cdisp_ena: std_logic;
signal crow, ccolumn: INTEGER;
signal cReloj: std_logic;
--signal cVGA : std_logic;
--signal cDip: std_logic_vector (1 downto 0);

BEGIN
VGA_clk<=cclk;
U1: Entity WORK.Gen25MHz(behavior)  port map (clk, cclk);
U2: Entity work.vga_controller(behavior) port map (cclk, reset, h_sync,v_sync, cdisp_ena, ccolumn, crow, n_blank, n_sync);
U3: Entity work.hw_image_generator(behavior) port map (cdisp_ena, crow, ccolumn, red, green, blue, cReloj,reset_n, dipsw);
U4: Entity work.RelojLento(arqrelojlento) port map (clk, cReloj);


END ARCHITECTURE;