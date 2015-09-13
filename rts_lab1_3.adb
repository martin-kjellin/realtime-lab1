--rts_lab1.adb
--Real Time System Lab1
with Ada.Text_IO; -- Use package Ada.Text_IO
use Ada.Text_IO; -- Integrate its namespace
with Ada.Numerics.Discrete_Random;
use Ada.Numerics.Discrete_Random;
--with Ada.Calendar; 
-- Use package Ada.Calendar
		 --use Ada.Calendar;
		 --with Ada.Numerics.Float_Random;
		 --use Ada.Numerics.Float_Random;

procedure rts_lab1_3 is
   task Buffer is
      entry Put(X : in integer);
      entry Get(X : out integer);
      entry Stop;
   end;
   
   task body Buffer is
      Size: constant Integer := 15;
      B: array (1..size) of Integer;
      Front: Integer := 0;
      Number: Integer range 0..Size := 0;
      Running : Boolean := True;
   begin
      while Running = True loop
	 select
	    when Number < Size =>
	       accept Put(X : in Integer) do
		  B((Front + Number) mod Size + 1):= X;
		  Number := Number + 1;
	       end Put;
	       
	 or
	    when Number > 0 =>
	       accept Get(X : out Integer) do 
		  B(Front mod Size) := X;
		  Number := Number - 1;
		  Front := Front + 1;
	       end Get;
	    
	 or
	
	    accept Stop do
	       Running := False;
	    end Stop;
	    
	 end select;
      end loop;
   end buffer;

   task Consumer;
   
   task body Consumer is
      Sum : Integer := 0;
      New_Value : Integer;
   begin
      while Sum <= 100 loop
	 Buffer.Get(New_Value);
	 Sum := Sum + New_Value;
      end loop;
      --      Producer.Stop;
      Buffer.Stop;
   end Consumer;
   
   task body Producer is
      G : Generator;
      Produce_Range : constant Interage := 26;
   begin
      reset(G);
      Buffer.Put(Radom(G) % Produce_Range);
   end Producer;
   
begin 
   null;
end rts_lab1_3;
