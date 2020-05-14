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
	 reloj, reset :  IN   STD_LOGIC;
	 dipsw : in std_logic_vector (1 downto 0));
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

 
BEGIN
Process(disp_ena, reloj, reset, row, column, dipsw)
begin
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
	 z:= z + 1;
	 
	 case n  is 
		when 0 =>  --Cuadro carril 1
			if(w < 640) then 
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
	 --Dibujo del "chazis" del carro
	   if ((row > y+10 and row <y+50) and (column>x and column<x+60)) then
			red<=(OTHERS => '1');
			green <=(others => '0');
			blue <=(others => '0');
		--Llanta inferior izquierda
		elsif ((row >y+50 and row <y+60) and (column>x and column<x+20)) then
			red<=(OTHERS => '0');
			green <=(others => '0');
			blue <=(others => '1');
		--Llanta superior izquierda
		elsif ((row >y+0 and row <y+10) and (column>x and column<x+20)) then
			red<=(OTHERS => '0');
			green <=(others => '0');
			blue <=(others => '1');
		--Llanta inferior derecha
		elsif ((row >y+50 and row <y+60) and (column>x+40 and column<x+60)) then
			red<=(OTHERS => '0');
			green <=(others => '0');
			blue <=(others => '1');
		--Llanta superior derecha
		elsif ((row >y+0 and row <y+10) and (column>x+40 and column<x+60)) then
			red<=(OTHERS => '0');
			green <=(others => '0');
			blue <=(others => '1');
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
------------------------------------------------------------------------
--**************************Montañas**********************************--
------------------------------------------------------------------------
		--Base montañas
		elsif ((row>160 and row<162) and (column>z+0 and column<z+600)) then
				blue<=(OTHERS => '1');
				green<=(OTHERS => '1');
				red <= (OTHERS => '0');
		---------------------
		--Montaña izquierda--
		---------------------
		--Base montaña left 1/7	
		elsif ((row>140 and row<142) and (column>z+10 and column<z+290)) then
				blue<=(OTHERS => '1');
				green<=(OTHERS => '1');
				red <= (OTHERS => '0');
		--Base montaña left 2/7	
		elsif ((row>120 and row<122) and (column>z+20 and column<z+280)) then
				blue<=(OTHERS => '1');
				green<=(OTHERS => '1');
				red <= (OTHERS => '0');
		--Base montaña left 3/7
		elsif ((row>100 and row<102) and (column>z+40 and column<z+260)) then
				blue<=(OTHERS => '1');
				green<=(OTHERS => '1');
				red <= (OTHERS => '0');
		--Base montaña left 4/7
		elsif ((row>80 and row<82) and (column>z+60 and column<z+240)) then
				blue<=(OTHERS => '1');
				green<=(OTHERS => '1');
				red <= (OTHERS => '0');
		--Base montaña left 5/7
		elsif ((row>60 and row<62) and (column>z+80 and column<z+220)) then
				blue<=(OTHERS => '1');
				green<=(OTHERS => '1');
				red <= (OTHERS => '0');
		--Base montaña left 6/7
		elsif ((row>40 and row<42) and (column>z+100 and column<z+200)) then
				blue<=(OTHERS => '1');
				green<=(OTHERS => '1');
				red <= (OTHERS => '0');
		--Base montaña left 7/7
		elsif ((row>20 and row<22) and (column>z+140 and column<z+160)) then
				blue<=(OTHERS => '1');
				green<=(OTHERS => '1');
				red <= (OTHERS => '0');
		-------------------
		--Montaña derecha--
		-------------------
		--Base montaña left 1/7	
		elsif ((row>140 and row<142) and (column>z+310 and column<z+590)) then
				blue<=(OTHERS => '1');
				green<=(OTHERS => '1');
				red <= (OTHERS => '0');
		--Base montaña left 2/7	
		elsif ((row>120 and row<122) and (column>z+320 and column<z+580)) then
				blue<=(OTHERS => '1');
				green<=(OTHERS => '1');
				red <= (OTHERS => '0');
		--Base montaña left 3/7
		elsif ((row>100 and row<102) and (column>z+340 and column<z+560)) then
				blue<=(OTHERS => '1');
				green<=(OTHERS => '1');
				red <= (OTHERS => '0');
		--Base montaña left 4/7
		elsif ((row>80 and row<82) and (column>z+360 and column<z+540)) then
				blue<=(OTHERS => '1');
				green<=(OTHERS => '1');
				red <= (OTHERS => '0');
		--Base montaña left 5/7
		elsif ((row>60 and row<62) and (column>z+380 and column<z+520)) then
				blue<=(OTHERS => '1');
				green<=(OTHERS => '1');
				red <= (OTHERS => '0');
		--Base montaña left 6/7
		elsif ((row>40 and row<42) and (column>z+400 and column<z+500)) then
				blue<=(OTHERS => '1');
				green<=(OTHERS => '1');
				red <= (OTHERS => '0');
		--Base montaña left 7/7
		elsif ((row>20 and row<22) and (column>z+440 and column<z+460)) then
				blue<=(OTHERS => '1');
				green<=(OTHERS => '1');
				red <= (OTHERS => '0');
----------------------------------			  
--***********Obstaculos***********
----------------------------------
		--Cuadro chico/primer tipo cuadro 
		elsif ((row >s+200 and row <s+220) and (column>w and column<w+20) and (ban = false) ) then
				green<=(OTHERS => '1');		
				blue<=(OTHERS => '1');
				red <= (OTHERS => '0');
		--Cuadro grande/segundo tipo cuadro 
		elsif ((row > s+200 and row <s+220) and (column>w and column<w+40) and (ban = true) ) then
				green<=(OTHERS => '1');		
				blue<=(OTHERS => '1');
				red <= (OTHERS => '0');
		
		--Display END
		elsif ((row > 100 and row <125) and (column>420 and column<425) and (ban2 = false) ) then
				rein := true;	--**************
				green<=(OTHERS => '0');		
				blue<=(OTHERS => '1');
				red <= (OTHERS => '0');
						
		elsif ((row > 100 and row <105) and (column>425 and column<440) and (ban2 = false) ) then
				green<=(OTHERS => '0');		
				blue<=(OTHERS => '1');
				red <= (OTHERS => '0');
						
		elsif ((row > 110 and row < 115) and (column>425 and column<440) and (ban2 = false) ) then
				green<=(OTHERS => '0');		
				blue<=(OTHERS => '1');
				red <= (OTHERS => '0');
						
		elsif ((row > 120 and row <125) and (column>425 and column<440) and (ban2 = false) ) then
				green<=(OTHERS => '0');		
				blue<=(OTHERS => '1');
				red <= (OTHERS => '0');
				
				
		elsif ((row > 100 and row <125) and (column>455 and column<460) and (ban2 = false) ) then
				green<=(OTHERS => '0');		
				blue<=(OTHERS => '1');
				red <= (OTHERS => '0');
						
		elsif ((row > 105 and row <100) and (column>460 and column<465) and (ban2 = false) ) then
				green<=(OTHERS => '0');		
				blue<=(OTHERS => '1');
				red <= (OTHERS => '0');
						
		elsif ((row > 110 and row <115) and (column>465 and column<470) and (ban2 = false) ) then
				green<=(OTHERS => '0');		
				blue<=(OTHERS => '1');
				red <= (OTHERS => '0');
						
		elsif ((row > 115 and row <120) and (column>470 and column<475) and (ban2 = false) ) then
				green<=(OTHERS => '0');		
				blue<=(OTHERS => '1');
				red <= (OTHERS => '0');
				
		elsif ((row > 100 and row <125) and (column>475 and column<480) and (ban2 = false) ) then
				green<=(OTHERS => '0');		
				blue<=(OTHERS => '1');
				red <= (OTHERS => '0');
				
		elsif ((row > 100 and row <125) and (column>495 and column<500) and (ban2 = false) ) then
				green<=(OTHERS => '0');		
				blue<=(OTHERS => '1');
				red <= (OTHERS => '0');
				
		elsif ((row > 100 and row <105) and (column>500 and column<515) and (ban2 = false) ) then
				green<=(OTHERS => '0');		
				blue<=(OTHERS => '1');
				red <= (OTHERS => '0');
				
		elsif ((row > 105 and row <120) and (column>510 and column<515) and (ban2 = false) ) then
				green<=(OTHERS => '0');		
				blue<=(OTHERS => '1');
				red <= (OTHERS => '0');
						
		elsif ((row > 120	and row <125) and (column>500 and column<515) and (ban2 = false) ) then
				green<=(OTHERS => '0');		
				blue<=(OTHERS => '1');
				red <= (OTHERS => '0');
				
		else		
			red <= (OTHERS => '0');
			green <=(others => '0');
			blue <=(others => '0');	
		end if;
	end if;
end process;

END behavior;