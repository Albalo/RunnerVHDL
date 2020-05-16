--------------------------------------------------------------------------------
--
--   FileName:         hw_image_generator.vhd
--   Dependencies:     none
--   Design Software:  Quartus II 64-bit Version 12.1 Build 177 SJ Full Version
--
--   HDL CODE IS PROVIDED "AS IS."  DIGI-KEY EXPRESSLY DISCLAIMS ANY
--   WARRANTY OF ANY KIND, WHETHER EXPRESS OR IMPLIED, INCLUDING BUT NOT
--   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
--   PARTICULAR PURPOSE, OR NON-INFRINGEMENT. IN NO EVENT SHALL DIGI-KEY
--   BE LIABLE FOR ANY INCIDENTAL, SPECIAL, INDIRECT OR CONSEQUENTIAL
--   DAMAGES, LOST PROFITS OR LOST DATA, HARM TO YOUR EQUIPMENT, COST OF
--   PROCUREMENT OF SUBSTITUTE GOODS, TECHNOLOGY OR SERVICES, ANY CLAIMS
--   BY THIRD PARTIES (INCLUDING BUT NOT LIMITED TO ANY DEFENSE THEREOF),
--   ANY CLAIMS FOR INDEMNITY OR CONTRIBUTION, OR OTHER SIMILAR COSTS.
--
--   Version History
--   Version 1.0 05/10/2013 Scott Larson
--     Initial Public Release
--    
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

ENTITY hw_image_generator IS
  GENERIC(
   pixels_y :  INTEGER := 478;   --row that first color will persist until
   pixels_x :  INTEGER := 600);  --column that first color will persist until

	
  PORT(
    disp_ena :  IN   STD_LOGIC;  --display enable ('1' = display time, '0' = blanking time)
    row      :  IN   INTEGER;    --row pixel coordinate
    column   :  IN   INTEGER;    --column pixel coordinate
    red      :  OUT  STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');  --red magnitude output to DAC
    green    :  OUT  STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');  --green magnitude output to DAC
    blue     :  OUT  STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');
	 reloj, reset, reset_total, reloj2:  IN   STD_LOGIC;
	 dipsw	 :	 in std_logic_vector (1 downto 0);
	 L1, L2, L3, L4, L5, L6: out std_logic_vector (6 downto 0));
	 -- a,b,c,d,e,f,g: out std_logic;
	 -- num: in std_logic_vector(6 downto 0)); --blue magnitude output to DAC
	
    
	 END hw_image_generator;

ARCHITECTURE behavior OF hw_image_generator IS
 
	shared variable x : integer := 560;
	shared variable y : integer := 295;
	shared VARIABLE z : integer ; 
	shared VARIABLE n : integer range 0 to 3:=  0;
	shared VARIABLE w : integer := -20; 		--Establce el rango de el limite a donde se va a llevar el obstaculo
	shared VARIABLE s : integer := -20;
	shared VARIABLE ban : boolean := false;	--flag/bandera 1
	shared VARIABLE ban2 : boolean := true;	--bandera2=false se activa el game over
	shared VARIABLE rein	: boolean	:= false;
	--signal score : integer range 0 to 100000000:= 0;
	--Score
	signal segundo: std_logic;
	signal m: std_logic;
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
	signal vv: std_logic;
	signal v: std_logic;
	signal u: std_logic;
	signal d: std_logic;
	signal o: std_logic;
	signal p: std_logic;
	signal rst: std_logic;
 
BEGIN

--Reset general
--process(disp_ena, reset_total)
--begin
--	if(ban2 = false and reset_total = '1') then
--		ban2 := true;
--	end if;
--end process;

Process(disp_ena, reloj, reset, row, column, dipsw)
begin
	
	--if(ban2 = false and reset_total = '1') then
		--ban2 := true;
	--end if;

--Movimineto del Carro/Jugador
	if (reloj'event and reloj = '1') then 
--Movimiento hacia arriba con "10" y se reinicia en el origen del objeto (20,295)
		if(dipsw = "00" and y < 410) then
			y := y + 1;
--Movimiento hacia arriba con "10" y se reinicia en el origen del objeto (20,295)
		elsif(dipsw = "10" and y > 190) then
			y := y - 1;
--En otro caso, se va a regresar a la posición original de (20,320).
		else
			x := 560;
			y := 295;
		end if ;
	end if; 
	
--Movimiento de obstáculos y fondo
if (reloj'event and reloj = '1') then 
    --Z define el avance para después reiniciar el ciclado/pasada
	 if(z < 100 and reset = '1' and ban2 = true)then 
	 z:= z + 2;
	 
	 case n  is 
		when 0 =>  --Cuadro carril 1
			if(w < 660) then 
				ban := false;
				s := 20;	--Mide lo que esta sobre la instancia en el eje Y
				w := w + 4;	--Velodcidad con la que cae
				if((( x > w and (w+40 > x+20 and w <x+20)) or (w < x and (w+40 < x+20 and w+40 > x ))) 
					and (s + 180 <= y and (s + 220 >= y and s+180 < y+220 ))) then 
					ban2 := false;
				end if;
			else 
				n := 1;
				w := -20;
				s := -20;
			end if ;
		when 1 =>  --Cuadro carril 3
			if(w < 640) then
				ban := false;	
				s := 200; --Mide lo que esta sobre la instancia en el eje Y
				w := w + 4;
				--if(((w  > x and (w+20 > x +20 and w < x + 20)) or (w  < x and (w+20 < x +20 and w +20 > x ))) 
					--and (s  <= y and (s + 20 >= y and s+20 < s+20 ))) then
				if((( x > w and (w+40 > x+20 and w <x+20)) or (w < x and (w+40 < x+20 and w+40 > x ))) 
					and (s + 180 <= y and (s + 220 >= y and s+180 < y+220 ))) then 
					ban2 := false;
				end if;
			else 
				n := 2;
				w := -20;
				s := -20;
			end if ;
		when 2 =>  --Cuadro carril 2 
			if(w < 620) then 
				ban := true;
			   s := 110; --Mide lo que esta sobre la instancia en el eje Y
				w := w + 4;
				if((( x > w and (w+40 > x+20 and w <x+20)) or (w < x and (w+40 < x+20 and w+40 > x ))) 
					and (s + 180 <= y and (s + 220 >= y and s+180 < y+220 ))) then
					ban2 := false;
				end if;
			else 
				n := 3;
				w := -20;
				s := -20;
			end if ;
		when 3 =>  --Cuadro carril 2 
			if(w < 620) then
				ban:= true;
				s := 110; --Mide lo que esta sobre la instancia en el eje Y
				w := w +4;
				if((( x > w and (w+40 > x+20 and w <x+20)) or (w < x and (w+40 < x+20 and w+40 > x ))) 
					and (s + 180 <= y and (s + 220 >= y and s+180 < y+220 ))) then 
					ban2 := false;
				end if;
			else 
				n := 0;
				w := -20;
				s := -20;
			end if ;
      end case;
	
	 else 
	 z:= 0;
	 
	 end if;
	  
end if; 

	 if(disp_ena = '1') THEN        --display time
----------------------------------------------------------------------
--**********************Carro/Jugador*******************************--
----------------------------------------------------------------------
	 --Dibujo de Carro/Jugador
	 --Dibujo de elementos de sombreado y luces
		if ((row > y+20 and row <y+25) and (column>x+15 and column<x+25)) then
			red<=(OTHERS => '1');
			green <=(others => '1');
			blue <=(others => '1');
		elsif ((row > y+25 and row <y+30) and (column>x+45 and column<x+55)) then
			red<=(OTHERS => '0');
			green <=(others => '1');
			blue <=(others => '1');
		elsif ((row > y+25 and row <y+30) and (column> x+25 and column <x+30)) then
			red<=(OTHERS => '0');
			green <=(others => '1');
			blue <=(others => '1');
		elsif ((row > y+15 and row <y+25) and (column>x+15 and column<x+30)) then
			red<=(OTHERS => '0');
			green <=(others => '0');
			blue <=(others => '0');
		elsif ((row > y+10 and row <y+15) and (column>x+25 and column<x+40)) then
			red<=(OTHERS => '0');
			green <=(others => '0');
			blue <=(others => '0');
		elsif ((row > y+10 and row <y+30) and (column>x+25 and column<x+30)) then
			red<=(OTHERS => '0');
			green <=(others => '0');
			blue <=(others => '0');
		elsif ((row > y+30 and row <y+35) and (column>x+5 and column<x+25)) then
			red<=(OTHERS => '1');
			green <=(others => '1');
			blue <=(others => '1');
		elsif ((row > y+20 and row <y+25) and (column>x+30 and column<x+45)) then
			red<=(OTHERS => '1');
			green <=(others => '1');
			blue <=(others => '1');
		elsif ((row > y+25 and row <y+30) and (column>x+25 and column<x+40)) then
			red<=(OTHERS => '0');
			green <=(others => '0');
			blue <=(others => '0');
		elsif ((row > y+10 and row <y+30) and (column>x+45 and column<x+55)) then
			red<=(OTHERS => '0');
			green <=(others => '0');
			blue <=(others => '0');
		elsif ((row > y+5 and row <y+10) and (column>x+55 and column<x+65)) then
			red<=(OTHERS => '0');
			green <=(others => '0');
			blue <=(others => '0');
		elsif ((row > y+30 and row <y+35) and (column>x+55 and column<x+65)) then
			red<=(OTHERS => '0');
			green <=(others => '0');
			blue <=(others => '0');
		elsif ((row > y+30 and row <y+35) and (column>x+65 and column<x+75)) then
			red<=(OTHERS => '1');
			green <=(others => '1');
			blue <=(others => '1');
		--"Chazis" del carro
	   elsif ((row > y+10 and row <y+30) and (column>x and column<x+65)) then
			red<=(OTHERS => '1');
			green <=(others => '0');
			blue <=(others => '0');
		elsif ((row > y+5 and row <y+35) and (column>x+5 and column<x+65)) then
			red<=(OTHERS => '1');
			green <=(others => '0');
			blue <=(others => '0');
		elsif ((row > y and row <y+40) and (column>x+10 and column<x+30)) then
			red<=(OTHERS => '1');
			green <=(others => '0');
			blue <=(others => '0');
		elsif ((row > y and row <y+40) and (column>x+50 and column<x+75)) then
			red<=(OTHERS => '1');
			green <=(others => '0');
			blue <=(others => '0');
		
-----------------------------------------------------------------------
--*****************************Autopista*****************************--
-----------------------------------------------------------------------	 
--*********************Franjas de acotamiento************************--
-----------------------------------------------------------------------     	
		--Franja/Barra superior de acotamiento
	   elsif ((row > 185 and row <195) and (column>0 and column<640)) THEN 
				green<=(OTHERS => '1');
				blue<=(OTHERS => '1');
				red <= (OTHERS => '1');
		--Franja/Barra inferior de acotamiento		
      elsif ((row > 455 and row <465) and (column>0 and column<640)) then
				green<=(OTHERS => '1');
				blue<=(OTHERS => '1');
				red <= (OTHERS => '1');
-----------------------------------------------------------------------				
--********************Franjas entre carriles*************************--
-----------------------------------------------------------------------
--Franja superior
		--Franja superior sección 6
		elsif ((row > 280 and row <285) and (column>z+620 and column<z+680)) then
				green<=(OTHERS => '1');		
				blue<=(OTHERS => '1');
				red <= (OTHERS => '1');
		--Franja superior sección 6
		elsif ((row > 280 and row <285) and (column>z+520 and column<z+580)) then
				green<=(OTHERS => '1');		
				blue<=(OTHERS => '1');
				red <= (OTHERS => '1');
		--Franja superior sección 5		
      elsif ((row > 280 and row <285) and (column>z+420 and column<z+480)) then
				green<=(OTHERS => '1');		
				blue<=(OTHERS => '1');
				red <= (OTHERS => '1');
		--Franja superior sección 4			
      elsif ((row > 280 and row <285) and (column>z+320 and column<z+380)) then
				green<=(OTHERS => '1');		
				blue<=(OTHERS => '1');
				red <= (OTHERS => '1');
		--Franja superior sección 3
		elsif ((row > 280 and row <285) and (column>z+220 and column<z+280)) then
				green<=(OTHERS => '1');		
				blue<=(OTHERS => '1');
				red <= (OTHERS => '1');
		--Franja superior sección 2		
      elsif ((row > 280 and row <285) and (column>z+120 and column<z+180)) then
				green<=(OTHERS => '1');		
				blue<=(OTHERS => '1');
				red <= (OTHERS => '1');
		--Franja superior sección 1			
      elsif ((row > 280 and row <285) and (column>z+20 and column<z+80)) then
				green<=(OTHERS => '1');		
				blue<=(OTHERS => '1');
				red <= (OTHERS => '1');
		--Franja superior sección 0			
      elsif ((row > 280 and row <285) and (column>z-80 and column<z-20)) then
				green<=(OTHERS => '1');		
				blue<=(OTHERS => '1');
				red <= (OTHERS => '1');
--Franja inferior
		--Franja inferior sección 7
		elsif ((row > 360 and row <365) and (column>z+620 and column<z+680)) then
				green<=(OTHERS => '1');		
				blue<=(OTHERS => '1');
				red <= (OTHERS => '1');
		--Franja inferior sección 6
		elsif ((row > 360 and row <365) and (column>z+520 and column<z+580)) then
				green<=(OTHERS => '1');		
				blue<=(OTHERS => '1');
				red <= (OTHERS => '1');
		--Franja inferior sección 5		
      elsif ((row > 360 and row <365) and (column>z+420 and column<z+480)) then
				green<=(OTHERS => '1');		
				blue<=(OTHERS => '1');
				red <= (OTHERS => '1');
		--Franja inferior sección 4			
      elsif ((row > 360 and row <365) and (column>z+320 and column<z+380)) then
				green<=(OTHERS => '1');		
				blue<=(OTHERS => '1');
				red <= (OTHERS => '1');
		--Franja inferior sección 3
		elsif ((row > 360 and row <365) and (column>z+220 and column<z+280)) then
				red <= (OTHERS => '1');
				green<=(OTHERS => '1');		
				blue<=(OTHERS => '1');
				--red <= (OTHERS => '1');
		--Franja inferior sección 2		
      elsif ((row > 360 and row <365) and (column>z+120 and column<z+180)) then
				green<=(OTHERS => '1');		
				blue<=(OTHERS => '1');
				red <= (OTHERS => '1');				
		--Franja inferior sección 1			
      elsif ((row > 360 and row <365) and (column>z+20 and column<z+80)) then
				green<=(OTHERS => '1');
				blue<=(OTHERS => '1');
				red <= (OTHERS => '1');
		--Franja inferior sección 0			
      elsif ((row > 360 and row <365) and (column>z-80 and column<z-20)) then
				green<=(OTHERS => '1');
				blue<=(OTHERS => '1');
				red <= (OTHERS => '1');
---------------------------------------------
--*****************Fondo*******************--
---------------------------------------------
---------------------------------------------------------------
--***************************Moon****************************--
---------------------------------------------------------------
		elsif ((row > 20 and row <80) and (column>20 and column<80)) then
				green<=(OTHERS => '1');
				blue<=(OTHERS => '1');
				red <= (OTHERS => '1');
		elsif ((row > 30 and row <70) and (column>10 and column<90)) then
				green<=(OTHERS => '1');
				blue<=(OTHERS => '1');
				red <= (OTHERS => '1');
		elsif ((row > 10 and row <90) and (column>30 and column<70)) then
				green<=(OTHERS => '1');
				blue<=(OTHERS => '1');
				red <= (OTHERS => '1');
---------------------------------------------------------------		
--***************************Stars***************************--
---------------------------------------------------------------
		elsif ((row > 20 and row <25) and (column>z-25 and column <z-20)) then
			red<=(OTHERS => '1');
			green <=(others => '1');
			blue <=(others => '1');
		elsif ((row > 80 and row <85) and (column>z-85 and column <z-80)) then
			red<=(OTHERS => '1');
			green <=(others => '1');
			blue <=(others => '1');
		elsif ((row > 50 and row <55) and (column>z+0 and column <z+05)) then
			red<=(OTHERS => '1');
			green <=(others => '1');
			blue <=(others => '1');
		elsif ((row > 20 and row <25) and (column>z+20 and column <z+25)) then
			red<=(OTHERS => '1');
			green <=(others => '1');
			blue <=(others => '1');
		elsif ((row > 50 and row <55) and (column>z+50 and column <z+55)) then
			red<=(OTHERS => '1');
			green <=(others => '1');
			blue <=(others => '1');
		elsif ((row > 80 and row <85) and (column>z+80 and column <z+85)) then
			red<=(OTHERS => '1');
			green <=(others => '1');
			blue <=(others => '1');
		elsif ((row > 50 and row <55) and (column>z+100 and column <z+105)) then
			red<=(OTHERS => '1');
			green <=(others => '1');
			blue <=(others => '1');
		elsif ((row > 20 and row <25) and (column>z+120 and column <z+125)) then
			red<=(OTHERS => '1');
			green <=(others => '1');
			blue <=(others => '1');
		elsif ((row > 50 and row <55) and (column>z+150 and column <z+155)) then
			red<=(OTHERS => '1');
			green <=(others => '1');
			blue <=(others => '1');
		elsif ((row > 80 and row <85) and (column>z+180 and column <z+185)) then
			red<=(OTHERS => '1');
			green <=(others => '1');
			blue <=(others => '1');
		elsif ((row > 50 and row <55) and (column>z+200 and column <z+205)) then
			red<=(OTHERS => '1');
			green <=(others => '1');
			blue <=(others => '1');
		elsif ((row > 20 and row <25) and (column>z+220 and column <z+225)) then
			red<=(OTHERS => '1');
			green <=(others => '1');
			blue <=(others => '1');
		elsif ((row > 50 and row <55) and (column>z+250 and column <z+255)) then
			red<=(OTHERS => '1');
			green <=(others => '1');
			blue <=(others => '1');
		elsif ((row > 80 and row <85) and (column>z+280 and column <z+285)) then
			red<=(OTHERS => '1');
			green <=(others => '1');
			blue <=(others => '1');
		elsif ((row > 50 and row <55) and (column>z+300 and column <z+305)) then
			red<=(OTHERS => '1');
			green <=(others => '1');
			blue <=(others => '1');
		elsif ((row > 20 and row <25) and (column>z+320 and column <z+325)) then
			red<=(OTHERS => '1');
			green <=(others => '1');
			blue <=(others => '1');
		elsif ((row > 50 and row <55) and (column>z+350 and column <z+355)) then
			red<=(OTHERS => '1');
			green <=(others => '1');
			blue <=(others => '1');
		elsif ((row > 80 and row <85) and (column>z+380 and column <z+385)) then
			red<=(OTHERS => '1');
			green <=(others => '1');
			blue <=(others => '1');
		elsif ((row > 50 and row <55) and (column>z+400 and column <z+405)) then
			red<=(OTHERS => '1');
			green <=(others => '1');
			blue <=(others => '1');
		elsif ((row > 20 and row <25) and (column>z+420 and column <z+425)) then
			red<=(OTHERS => '1');
			green <=(others => '1');
			blue <=(others => '1');
		elsif ((row > 50 and row <55) and (column>z+450 and column <z+455)) then
			red<=(OTHERS => '1');
			green <=(others => '1');
			blue <=(others => '1');
		elsif ((row > 80 and row <85) and (column>z+480 and column <z+485)) then
			red<=(OTHERS => '1');
			green <=(others => '1');
			blue <=(others => '1');
		elsif ((row > 50 and row <55) and (column>z+500 and column <z+505)) then
			red<=(OTHERS => '1');
			green <=(others => '1');
			blue <=(others => '1');
		elsif ((row > 20 and row <25) and (column>z+520 and column <z+525)) then
			red<=(OTHERS => '1');
			green <=(others => '1');
			blue <=(others => '1');
		elsif ((row > 50 and row <55) and (column>z+550 and column <z+555)) then
			red<=(OTHERS => '1');
			green <=(others => '1');
			blue <=(others => '1');
		elsif ((row > 80 and row <85) and (column>z+580 and column <z+585)) then
			red<=(OTHERS => '1');
			green <=(others => '1');
			blue <=(others => '1');
		elsif ((row > 50 and row <55) and (column>z+600 and column <z+605)) then
			red<=(OTHERS => '1');
			green <=(others => '1');
			blue <=(others => '1');
		elsif ((row > 20 and row <25) and (column>z+620 and column <z+625)) then
			red<=(OTHERS => '1');
			green <=(others => '1');
			blue <=(others => '1');
		elsif ((row > 50 and row <55) and (column>z+650 and column <z+655)) then
			red<=(OTHERS => '1');
			green <=(others => '1');
			blue <=(others => '1');
		elsif ((row > 80 and row <85) and (column>z+680 and column <z+685)) then
			red<=(OTHERS => '1');
			green <=(others => '1');
			blue <=(others => '1');
----------------------------------			  
--***********Obstaculos***********
----------------------------------
		--Obstáculo 1
		elsif ((row >s+205 and row <s+210) and (column>w+50 and column<w+70) and (ban = false) ) then
				red <= (OTHERS => '1');
				green<=(OTHERS => '1');	
				blue<=(OTHERS => '1');
		elsif ((row >s+215 and row <s+220) and (column>w+50 and column<w+60) and (ban = false) ) then
				red <= (OTHERS => '1');
				green<=(OTHERS => '1');	
				blue<=(OTHERS => '1');
		elsif ((row >s+215 and row <s+220) and (column>w+30 and column<w+45) and (ban = false) ) then
				red <= (OTHERS => '1');
				green<=(OTHERS => '1');	
				blue<=(OTHERS => '1');
		elsif ((row >s+205 and row <s+210) and (column>w and column<w+10) and (ban = false) ) then
				red <= (OTHERS => '1');
				green<=(OTHERS => '1');	
				blue<=(OTHERS => '1');
		elsif ((row >s+210 and row <s+215) and (column>w+45 and column<w+50) and (ban = false) ) then
				red <= (OTHERS => '0');
				green<=(OTHERS => '1');	
				blue<=(OTHERS => '1');
		elsif ((row >s+210 and row <s+215) and (column>w+20 and column<w+30) and (ban = false) ) then
				red <= (OTHERS => '0');
				green<=(OTHERS => '1');	
				blue<=(OTHERS => '1');
		elsif ((row >s+205 and row <s+210) and (column>w+10 and column<w+20) and (ban = false) ) then
				red <= (OTHERS => '0');
				green<=(OTHERS => '0');	
				blue<=(OTHERS => '0');
		elsif ((row >s+230 and row <s+235) and (column>w+10 and column<w+20) and (ban = false) ) then
				red <= (OTHERS => '0');
				green<=(OTHERS => '0');	
				blue<=(OTHERS => '0');
		elsif ((row >s+210 and row <s+230) and (column>w+20 and column<w+30) and (ban = false) ) then
				red <= (OTHERS => '0');
				green<=(OTHERS => '0');	
				blue<=(OTHERS => '0');
		elsif ((row >s+210 and row <s+215) and (column>w+35 and column<w+50) and (ban = false) ) then
				red <= (OTHERS => '0');
				green<=(OTHERS => '0');	
				blue<=(OTHERS => '0');
		elsif ((row >s+225 and row <s+230) and (column>w+35 and column<w+50) and (ban = false) ) then
				red <= (OTHERS => '0');
				green<=(OTHERS => '0');	
				blue<=(OTHERS => '0');
		elsif ((row >s+210 and row <s+230) and (column>w+45 and column<w+50) and (ban = false) ) then
				red <= (OTHERS => '0');
				green<=(OTHERS => '0');	
				blue<=(OTHERS => '0');
		elsif ((row >s+215 and row <s+225) and (column>w+45 and column<w+60) and (ban = false) ) then
				red <= (OTHERS => '0');
				green<=(OTHERS => '0');	
				blue<=(OTHERS => '0');
		---Chazis
		elsif ((row >s+210 and row <s+230) and (column>w and column<w+75) and (ban = false) ) then
				red <= (OTHERS => '0');
				green<=(OTHERS => '0');
				blue<=(OTHERS => '1');
		elsif ((row >s+205 and row <s+235) and (column>w and column<w+70) and (ban = false) ) then
				red <= (OTHERS => '0');
				green<=(OTHERS => '0');
				blue<=(OTHERS => '1');
		elsif ((row >s+200 and row <s+240) and (column>w and column<w+25) and (ban = false) ) then
				red <= (OTHERS => '0');
				green<=(OTHERS => '0');
				blue<=(OTHERS => '1');
		elsif ((row >s+200 and row <s+240) and (column>w+45 and column<w+65) and (ban = false) ) then
				red <= (OTHERS => '0');
				green<=(OTHERS => '0');
				blue<=(OTHERS => '1');
--------------------------------------------------------------------------------------------------
		--Obstáculo 2
--		elsif ((row > s+200 and row <s+220) and (column>w and column<w+40) and (ban = true) ) then
--				green<=(OTHERS => '1');		
--				blue<=(OTHERS => '1');
--				red <= (OTHERS => '0');
				elsif ((row >s+205 and row <s+210) and (column>w+50 and column<w+70) and (ban = true) ) then
				red <= (OTHERS => '1');
				green<=(OTHERS => '1');	
				blue<=(OTHERS => '1');
		elsif ((row >s+215 and row <s+220) and (column>w+50 and column<w+60) and (ban = true) ) then
				red <= (OTHERS => '1');
				green<=(OTHERS => '1');	
				blue<=(OTHERS => '1');
		elsif ((row >s+215 and row <s+220) and (column>w+30 and column<w+45) and (ban = true) ) then
				red <= (OTHERS => '1');
				green<=(OTHERS => '1');	
				blue<=(OTHERS => '1');
		elsif ((row >s+205 and row <s+210) and (column>w and column<w+10) and (ban = true) ) then
				red <= (OTHERS => '1');
				green<=(OTHERS => '1');	
				blue<=(OTHERS => '1');
		elsif ((row >s+210 and row <s+215) and (column>w+45 and column<w+50) and (ban = true) ) then
				red <= (OTHERS => '0');
				green<=(OTHERS => '1');	
				blue<=(OTHERS => '1');
		elsif ((row >s+210 and row <s+215) and (column>w+20 and column<w+30) and (ban = true) ) then
				red <= (OTHERS => '0');
				green<=(OTHERS => '1');	
				blue<=(OTHERS => '1');
		elsif ((row >s+205 and row <s+210) and (column>w+10 and column<w+20) and (ban = true) ) then
				red <= (OTHERS => '0');
				green<=(OTHERS => '0');	
				blue<=(OTHERS => '0');
		elsif ((row >s+230 and row <s+235) and (column>w+10 and column<w+20) and (ban = true) ) then
				red <= (OTHERS => '0');
				green<=(OTHERS => '0');	
				blue<=(OTHERS => '0');
		elsif ((row >s+210 and row <s+230) and (column>w+20 and column<w+30) and (ban = true) ) then
				red <= (OTHERS => '0');
				green<=(OTHERS => '0');	
				blue<=(OTHERS => '0');
		elsif ((row >s+210 and row <s+215) and (column>w+35 and column<w+50) and (ban = true) ) then
				red <= (OTHERS => '0');
				green<=(OTHERS => '0');	
				blue<=(OTHERS => '0');
		elsif ((row >s+225 and row <s+230) and (column>w+35 and column<w+50) and (ban = true) ) then
				red <= (OTHERS => '0');
				green<=(OTHERS => '0');	
				blue<=(OTHERS => '0');
		elsif ((row >s+210 and row <s+230) and (column>w+45 and column<w+50) and (ban = true) ) then
				red <= (OTHERS => '0');
				green<=(OTHERS => '0');	
				blue<=(OTHERS => '0');
		elsif ((row >s+215 and row <s+225) and (column>w+45 and column<w+60) and (ban = true) ) then
				red <= (OTHERS => '0');
				green<=(OTHERS => '0');	
				blue<=(OTHERS => '0');
		--Chazis
		elsif ((row >s+210 and row <s+230) and (column>w and column<w+75) and (ban = true) ) then
				red <= (OTHERS => '1');
				green<=(OTHERS => '1');
				blue<=(OTHERS => '0');
		elsif ((row >s+205 and row <s+235) and (column>w and column<w+70) and (ban = true) ) then
				red <= (OTHERS => '1');
				green<=(OTHERS => '1');
				blue<=(OTHERS => '0');
		elsif ((row >s+200 and row <s+240) and (column>w and column<w+25) and (ban = true) ) then
				red <= (OTHERS => '1');
				green<=(OTHERS => '1');
				blue<=(OTHERS => '0');
		elsif ((row >s+200 and row <s+240) and (column>w+45 and column<w+65) and (ban = true) ) then
				red <= (OTHERS => '1');
				green<=(OTHERS => '1');
				blue<=(OTHERS => '0');
-----------------------------------------------------------------------				
--***********************GAME*OVER*Mensaje***************************--
-----------------------------------------------------------------------
		--Letra "G"
		elsif ((row > 120 and row <160) and (column>150 and column<160) and (ban2 = false) ) then
				rein := true;	--
				red <= (OTHERS => '1');
				green<=(OTHERS => '0');		
				blue<=(OTHERS => '0');			
		elsif ((row > 120 and row <130) and (column>150 and column<180) and (ban2 = false) ) then
				red <= (OTHERS => '1');
				green<=(OTHERS => '0');		
				blue<=(OTHERS => '0');
		elsif ((row > 150 and row <160) and (column>150 and column<180) and (ban2 = false) ) then
				red <= (OTHERS => '1');
				green<=(OTHERS => '0');		
				blue<=(OTHERS => '0');
		elsif ((row > 140 and row <160) and (column>170 and column<180) and (ban2 = false) ) then
				red <= (OTHERS => '1');
				green<=(OTHERS => '0');		
				blue<=(OTHERS => '0');
		--Letra "A"
		elsif ((row > 130 and row <160) and (column>190 and column<200) and (ban2 = false) ) then
				red <= (OTHERS => '1');
				green<=(OTHERS => '0');		
				blue<=(OTHERS => '0');
		elsif ((row > 120 and row <130) and (column>200 and column<210) and (ban2 = false) ) then
				red <= (OTHERS => '1');
				green<=(OTHERS => '0');		
				blue<=(OTHERS => '0');
		elsif ((row > 140 and row <150) and (column>190 and column<220) and (ban2 = false) ) then
				red <= (OTHERS => '1');
				green<=(OTHERS => '0');		
				blue<=(OTHERS => '0');
		elsif ((row > 130 and row <160) and (column>210 and column<220) and (ban2 = false) ) then
				red <= (OTHERS => '1');
				green<=(OTHERS => '0');		
				blue<=(OTHERS => '0');
		--Letra "M"
		elsif ((row > 120 and row <160) and (column>230 and column<240) and (ban2 = false) ) then
				red <= (OTHERS => '1');
				green<=(OTHERS => '0');
				blue<=(OTHERS => '0');
		elsif ((row > 130 and row <140) and (column>230 and column<250) and (ban2 = false) ) then
				red <= (OTHERS => '1');
				green<=(OTHERS => '0');
				blue<=(OTHERS => '0');
		elsif ((row > 140 and row <150) and (column>250 and column<260) and (ban2 = false) ) then
				red <= (OTHERS => '1');
				green<=(OTHERS => '0');		
				blue<=(OTHERS => '0');
		elsif ((row > 130 and row <140) and (column>260 and column<280) and (ban2 = false) ) then
				red <= (OTHERS => '1');
				green<=(OTHERS => '0');
				blue<=(OTHERS => '0');
		elsif ((row > 120 and row <160) and (column>270 and column<280) and (ban2 = false) ) then
				red <= (OTHERS => '1');
				green<=(OTHERS => '0');
				blue<=(OTHERS => '0');
		--Letra "E"
		elsif ((row > 120 and row <160) and (column>290 and column<300) and (ban2 = false) ) then
				red <= (OTHERS => '1');
				green<=(OTHERS => '0');
				blue<=(OTHERS => '0');
		elsif ((row > 120 and row <130) and (column>290 and column<320) and (ban2 = false) ) then
				red <= (OTHERS => '1');
				green<=(OTHERS => '0');
				blue<=(OTHERS => '0');
		elsif ((row > 150 and row <160) and (column>290 and column<320) and (ban2 = false) ) then
				red <= (OTHERS => '1');
				green<=(OTHERS => '0');
				blue<=(OTHERS => '0');
		elsif ((row > 135 and row <145) and (column>290 and column<310) and (ban2 = false) ) then
				red <= (OTHERS => '1');
				green<=(OTHERS => '0');
				blue<=(OTHERS => '0');
		--Letra "O"
		elsif ((row > 130 and row <150) and (column>350 and column<360) and (ban2 = false) ) then
				red <= (OTHERS => '0');
				green<=(OTHERS => '0');
				blue<=(OTHERS => '0');
		elsif ((row > 120 and row <160) and (column>340 and column<370) and (ban2 = false) ) then
				red <= (OTHERS => '1');
				green<=(OTHERS => '0');
				blue<=(OTHERS => '0');
		--Letra "V"
		elsif ((row > 120 and row <150) and (column>380 and column<390) and (ban2 = false) ) then
				red <= (OTHERS => '1');
				green<=(OTHERS => '0');
				blue<=(OTHERS => '0');
		elsif ((row > 120 and row <150) and (column>400 and column<410) and (ban2 = false) ) then
				red <= (OTHERS => '1');
				green<=(OTHERS => '0');
				blue<=(OTHERS => '0');
		elsif ((row > 150 and row <160) and (column>390 and column<400) and (ban2 = false) ) then
				red <= (OTHERS => '1');
				green<=(OTHERS => '0');
				blue<=(OTHERS => '0');
		--Letra "E"
		elsif ((row > 120 and row <160) and (column>420 and column<430) and (ban2 = false) ) then
				red <= (OTHERS => '1');
				green<=(OTHERS => '0');
				blue<=(OTHERS => '0');
		elsif ((row > 120 and row <130) and (column>420 and column<450) and (ban2 = false) ) then
				red <= (OTHERS => '1');
				green<=(OTHERS => '0');
				blue<=(OTHERS => '0');
		elsif ((row > 150 and row <160) and (column>420 and column<450) and (ban2 = false) ) then
				red <= (OTHERS => '1');
				green<=(OTHERS => '0');
				blue<=(OTHERS => '0');
		elsif ((row > 135 and row <145) and (column>420 and column<440) and (ban2 = false) ) then
				red <= (OTHERS => '1');
				green<=(OTHERS => '0');
				blue<=(OTHERS => '0');
		--Letra "R"
		elsif ((row > 120 and row <160) and (column>460 and column<470) and (ban2 = false) ) then
				red <= (OTHERS => '1');
				green<=(OTHERS => '0');
				blue<=(OTHERS => '0');
		elsif ((row > 120 and row <125) and (column>460 and column<490) and (ban2 = false) ) then
				red <= (OTHERS => '1');
				green<=(OTHERS => '0');
				blue<=(OTHERS => '0');
		elsif ((row > 135 and row <140) and (column>460 and column<490) and (ban2 = false) ) then
				red <= (OTHERS => '1');
				green<=(OTHERS => '0');
				blue<=(OTHERS => '0');
		elsif ((row > 120 and row <140) and (column>480 and column<490) and (ban2 = false) ) then
				red <= (OTHERS => '1');
				green<=(OTHERS => '0');
				blue<=(OTHERS => '0');
		elsif ((row > 140 and row <150) and (column>470 and column<480) and (ban2 = false) ) then
				red <= (OTHERS => '1');
				green<=(OTHERS => '0');
				blue<=(OTHERS => '0');
		elsif ((row > 150 and row <160) and (column>480 and column<490) and (ban2 = false) ) then
				red <= (OTHERS => '1');
				green<=(OTHERS => '0');
				blue<=(OTHERS => '0');
		
		else		
			red <= (OTHERS => '0');
			green <=(others => '0');
			blue <=(others => '0');	
		end if;
	end if;
end process;


--Score
divisor: process (reloj2)
		variable cuenta: std_logic_vector(27 downto 0) := X"0000000";
	begin
	if ( reset = '1' and ban2 = true) then
		if rising_edge (reloj2) then
			if cuenta = X"48009E0" then
				cuenta:= X"0000000";
			else
				cuenta:= cuenta + 1;
			end if;
		end if;
		segundo <= cuenta(21);
	end if;
	end process;
	
--000001
Segundo_Unidades: process (segundo)
variable cuenta: std_logic_vector(3 downto 0) := "0000";
begin
	if rising_edge (segundo) then
		if cuenta = "1001" then
			cuenta := "0000";
			m <= '1';
		else
			cuenta := cuenta + 1;
			m <= '0';
		end if;
	end if;
	QUS <= cuenta;
end process;

--000010	
Segundo_Decenas: process (m)
variable cuenta: std_logic_vector(3 downto 0) := "0000";
begin
	if rising_edge(m) then
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
Minuto_Unidades: Process(E, rst)
variable cuenta: std_logic_vector(3 downto 0) := "0000";
begin
	if rising_edge(E) then
		if cuenta = "1001" then 
			cuenta := "0000";
			vv <= '1';
		else
			cuenta := cuenta + 1;
			vv <= '0';
		end if;
	end if;
	if rst = '1' then
		cuenta := "0000";
	end if;
	QUM <= cuenta;
	U <= cuenta(2);
end Process;

--001000
Minuto_Decenas: Process(VV, rst)
variable cuenta: std_logic_vector(3 downto 0) := "0000";
begin
	if rising_edge(VV) then
		if cuenta = "1001" then
			cuenta := "0000";
		else
			cuenta := cuenta + 1;
		end if;
	end if;
	if rst = '1' then
		cuenta := "0000";
	end if;
	QDM<= cuenta;
	D <= cuenta(1);
end Process;	

--010000
Hora_Unidades: Process(R, rst)
variable cuenta: std_logic_vector(3 downto 0) := "0000";
begin
	if rising_edge(R) then
		if cuenta = "1001" then 
			cuenta := "0000";
			VV <= '1';
		else
			cuenta := cuenta + 1;
			VV <= '0';
		end if;
	end if;
	if rst = '1' then
		cuenta := "0000";
	end if;
	QUH <= cuenta;
	O <= cuenta(2);
end Process;

--100000
Hora_Decenas: Process(v, rst)
variable cuenta: std_logic_vector(3 downto 0) := "0000";
begin
	if rising_edge(v) then
		if cuenta = "1001" then
			cuenta := "0000";
		else
			cuenta := cuenta + 1;
		end if;
	end if;
	if rst = '1' then
		cuenta := "0000";
	end if;
	QDH<= cuenta;
	P <= cuenta(1);
end Process;
	
inicia: process (U,D, O, P)
begin
	rst <= (U and D and O and P);
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


END behavior;