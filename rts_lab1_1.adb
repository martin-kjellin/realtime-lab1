-- Lab 1, part 1
with Ada.Text_IO, Calendar;
use Ada.Text_IO, Calendar;

-- Executes three processes according to the following pattern:
-- 1. F1 is executed every second.
-- 2. F2 starts when F1 terminates.
-- 3. F3 is executed every other second,
--    starting 0.5 seconds after F1's start.
procedure RTS_Lab1_1 is
   Start_Time : Time;
   Next_Time : Time; -- Time for next event.
   
   -- Prints the current time.
   procedure F1 is
   begin
      Put("F1 executing, time is now:");
      Put_Line(Duration'Image(Clock - Start_Time));
   end F1;
   
   -- Prints the current time.
   procedure F2 is
   begin
      Put("F2 executing, time is now:");
      Put_Line(Duration'Image(Clock - Start_Time));
   end F2;
   
   -- Prints the current time.
   procedure F3 is
   begin
      Put("F3 executing, time is now:");
      Put_Line(Duration'Image(Clock - Start_Time));
   end F3;
   
begin
   Start_Time := Clock; -- Store the current time.
   Next_Time := Start_Time;
   
   loop
      F1;
      F2;
      Next_Time := Next_Time + 0.5;
      delay until Next_Time;
      -- Make F3 start 0.5 seconds after the start of F1.

      F3;
      Next_Time := Next_Time + 0.5;
      delay until Next_Time;
      -- Make F1 start 0.5 seconds after the start of F3.

      F1;
      F2;
      Next_Time := Next_Time + 1.0;
      delay until Next_Time;
      -- Make the loop restart 1.0 seconds after the start of F1.
   end loop;
end RTS_Lab1_1;
