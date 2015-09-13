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
		entry put(X: in integer)
		entry get(x: out integer)
	end;
	task body buffer is
		b: array (0 .. 15);
		front: integer := 0;
		number: integer := 0;
		size: integer :=15;
	begin
		loop 
		accept put(x: in integer)
			do
				if(number < size)
					b(pointer):= x;
					pointer = (pointer + 1) mod size;
				else
					Put_Line("Buffer Full");
			end put;
		accept get(x: out integer) 
			do 
				if(pointer < size)
					b(pointer):= x;
					pointer = (pointer + 1) mod size;
				else
					Put_Line("Buffer Full");
			end get;
		end loop;
	end buffer;

begin 

end rts_lab1_3;
