--rts_lab1.adb
--Real Time System Lab1
with Ada.Text_IO; -- Use package Ada.Text_IO
use Ada.Text_IO; -- Integrate its namespace
with Ada.Calendar; -- Use package Ada.Calendar
use Ada.Calendar;
with Ada.Numerics.Float_Random;
use Ada.Numerics.Float_Random;

procedure rts_lab1_3 is
	task buffer is
		entry put(X: in integer);
		entry get(x: out integer);
	end;
	task body buffer is
		b: array (0 .. 15) of Integer;
		front : integer := 0;
		number: integer := 0;
		size: integer :=15;
		Pointer : Integer := 0;
	begin
		loop 
		accept put(x: in integer)
			do
				if(number < size) then
					b(pointer):= x;
					pointer := (pointer + 1) mod size;
				else
				   Put_Line("Buffer Full");
				end if;
			end put;
		accept get(x: out integer) 
			do
				if(pointer < size) then
					b(pointer):= x;
					pointer := (pointer + 1) mod size;
				else
				   Put_Line("Buffer Full");
				end if;
			end get;
		end loop;
	end buffer;

	task Consumer is
	   -- do something
	end;
	
	task body Consumer is
	   Sum : Integer := 0;
	   New_Value : Integer;
	begin
	   while Sum <= 100 loop
	      Buffer.Get(New_Value);
	      Sum := Sum + New_Value;
	   end loop;
	end Consumer;

begin 
   null;
end rts_lab1_3;
