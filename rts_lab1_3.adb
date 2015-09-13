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
		entry put(x: in integer)
		entry get(x: out integer)
	end;
	task body buffer is
		size: constant integer :=15;
		b: array (1..size);
		front: integer := 0;
		number: integer range 0..size := 0;
	begin
		loop 
		accept put(x: in integer)
			do
				if(number < size)
					b((front + number)mod size + 1):= x;
					number = number + 1;
				else
					Put_Line("Buffer is Full");
			end put;
		accept get(x: out integer) 
			do 
				if(number > 0)
					b(front mod size):= x;
					number = number - 1;
					front = front + 1;
				else
					Put_Line("Buffer is empty");
			end get;
		end loop;
	end buffer;

begin 

end rts_lab1_3;
