library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity Score is
	port (reloj: in std_logic;
			L1, L2, L3, L4, L5, L6: out std_logic_vector (6 downto 0));
end entity;

architecture arc_Score of Score is
	signal segundo: std_logic;
	signal n: std_logic;
	signal Qs: std_logic_vector(3 downto 0);
	signal QUS: std_logic_vector(3 downto 0);
	signal QDS: std_logic_vector(3 downto 0);
	signal e: std_logic;
	signal r: std_logic;
	signal Qr: std_logic_vector(1 downto 0);
	signal QUM: std_logic_vector(3 downto 0);
	signal QDM: std_logic_vector(3 downto 0);
	signal QUH: std_logic_vector(3 downto 0);
	signal QDH: std_logic_vector(3 downto 0);
	signal z: std_logic;
	signal x: std_logic;
	signal u: std_logic;
	signal d: std_logic;
	signal o: std_logic;
	signal p: std_logic;
	signal reset: std_logic;
	
begin 
	divisor: process (reloj)
		variable cuenta: std_logic_vector(27 downto 0) := X"0000000";
	begin
		if rising_edge (reloj) then
			if cuenta = X"48009E0" then
				cuenta:= X"0000000";
			else
				cuenta:= cuenta + 1;
			end if;
		end if;
		segundo <= cuenta(21);
	end process;
	
--000001
Segundo_Unidades: process (segundo)
variable cuenta: std_logic_vector(3 downto 0) := "0000";
begin
	if rising_edge (segundo) then
		if cuenta = "1001" then
			cuenta := "0000";
			n <= '1';
		else
			cuenta := cuenta + 1;
			n <= '0';
		end if;
	end if;
	QUS <= cuenta;
end process;

--000010	
Segundo_Decenas: process (n)
variable cuenta: std_logic_vector(3 downto 0) := "0000";
begin
	if rising_edge(n) then
		if cuenta = "1001" then
			cuenta := "0000";
			e <= '1';
		else 
			cuenta := cuenta + 1;
			e<= '0';
		end if;
	end if;
	QDS <= cuenta;
end process;

--000100
Minuto_Unidades: Process(E, reset)
variable cuenta: std_logic_vector(3 downto 0) := "0000";
begin
	if rising_edge(E) then
		if cuenta = "1001" then 
			cuenta := "0000";
			z <= '1';
		else
			cuenta := cuenta + 1;
			z <= '0';
		end if;
	end if;
	if reset = '1' then
		cuenta := "0000";
	end if;
	QUM <= cuenta;
	U <= cuenta(2);
end Process;

--001000
Minuto_Decenas: Process(Z, reset)
variable cuenta: std_logic_vector(3 downto 0) := "0000";
begin
	if rising_edge(Z) then
		if cuenta = "1001" then
			cuenta := "0000";
		else
			cuenta := cuenta + 1;
		end if;
	end if;
	if reset = '1' then
		cuenta := "0000";
	end if;
	QDM<= cuenta;
	D <= cuenta(1);
end Process;	

--010000
Hora_Unidades: Process(R, reset)
variable cuenta: std_logic_vector(3 downto 0) := "0000";
begin
	if rising_edge(R) then
		if cuenta = "1001" then 
			cuenta := "0000";
			z <= '1';
		else
			cuenta := cuenta + 1;
			z <= '0';
		end if;
	end if;
	if reset = '1' then
		cuenta := "0000";
	end if;
	QUH <= cuenta;
	O <= cuenta(2);
end Process;

--100000
Hora_Decenas: Process(X, reset)
variable cuenta: std_logic_vector(3 downto 0) := "0000";
begin
	if rising_edge(X) then
		if cuenta = "1001" then
			cuenta := "0000";
		else
			cuenta := cuenta + 1;
		end if;
	end if;
	if reset = '1' then
		cuenta := "0000";
	end if;
	QDH<= cuenta;
	P <= cuenta(1);
end Process;
	
inicia: process (U,D, O, P)
begin
	reset <= (U and D and O and P);
end process;
	
	with   QDM SELECT       
		L1 <= "1000000" when "0000",   --0            
				"1111001" when "0001",   --1           
				"0100100" when "0010",   --2            
				"0110000" when "0011",   --3            
				"0011001" when "0100",   --4            
				"0010010" when "0101",   --5           
				"0000010" when "0110",   --6            
				"1111000" when "0111",   --7           
				"0000000" when "1000",   --8            
				"0010000" when "1001",   --9                    
				"1000000" when others;   --0
				
	with   QUM SELECT       
		L2 <= "1000000" when "0000",   --0            
				"1111001" when "0001",   --1           
				"0100100" when "0010",   --2            
				"0110000" when "0011",   --3            
				"0011001" when "0100",   --4            
				"0010010" when "0101",   --5           
				"0000010" when "0110",   --6            
				"1111000" when "0111",   --7           
				"0000000" when "1000",   --8            
				"0010000" when "1001",   --9                    
				"1000000" when others;   --0
				
	with   QDS SELECT       
		L3 <= "1000000" when "0000",   --0            
				"1111001" when "0001",   --1           
				"0100100" when "0010",   --2            
				"0110000" when "0011",   --3            
				"0011001" when "0100",   --4            
				"0010010" when "0101",   --5           
				"0000010" when "0110",   --6            
				"1111000" when "0111",   --7           
				"0000000" when "1000",   --8            
				"0010000" when "1001",   --9                    
				"1000000" when others;   --0
				
	with   QUS SELECT       
		L4 <= "1000000" when "0000",   --0            
				"1111001" when "0001",   --1           
				"0100100" when "0010",   --2            
				"0110000" when "0011",   --3            
				"0011001" when "0100",   --4            
				"0010010" when "0101",   --5           
				"0000010" when "0110",   --6            
				"1111000" when "0111",   --7           
				"0000000" when "1000",   --8            
				"0010000" when "1001",   --9                    
				"1000000" when others;   --0
	
	with   QDH SELECT       
		L5 <= "1000000" when "0000",   --0            
				"1111001" when "0001",   --1           
				"0100100" when "0010",   --2            
				"0110000" when "0011",   --3            
				"0011001" when "0100",   --4            
				"0010010" when "0101",   --5           
				"0000010" when "0110",   --6            
				"1111000" when "0111",   --7           
				"0000000" when "1000",   --8            
				"0010000" when "1001",   --9                    
				"1000000" when others;   --0
				
	with   QUH SELECT       
		L6 <= "1000000" when "0000",   --0            
				"1111001" when "0001",   --1           
				"0100100" when "0010",   --2            
				"0110000" when "0011",   --3            
				"0011001" when "0100",   --4            
				"0010010" when "0101",   --5           
				"0000010" when "0110",   --6            
				"1111000" when "0111",   --7           
				"0000000" when "1000",   --8            
				"0010000" when "1001",   --9                    
				"1000000" when others;   --0

end architecture;