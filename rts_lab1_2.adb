-- Lab 1, part 2
with Ada.Text_IO, Calendar, Ada.Numerics.Float_Random;
use Ada.Text_IO, Calendar, Ada.Numerics.Float_Random;

-- Executes three processes according to the following pattern:
-- 1. F1 is executed every second.
-- 2. F2 starts when F1 terminates.
-- 3. F3 is executed every other second,
--    starting 0.5 seconds after F1's start.
-- If F3 takes more than 0.5 seconds to execute, a warning
-- message is printed, and the next execution of F1 is
-- delayed so that it starts at whole seconds.
procedure RTS_Lab1_2 is
   Start_Time : Time;
   Next_Time : Time; -- Time for next event.

   G : Generator; -- Used to generate random numbers.
   
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
   
   -- Prints the current time. Includes a watchdog to check
   -- if the execution finishes within 0.5 seconds.
   procedure F3 is
      task Watchdog is
	 entry Stop;
      end;
      
      task body Watchdog is
	 Alarm_Time : Time := Clock + 0.5;	     
	 Running : Boolean := True; -- The watchdog should
	                            -- be stopped when F3
	                            -- finishes executing.
      begin
	 while Running = True loop
	    select
	       accept Stop do
		  Running := False; -- Stop the watchdog.
	       end Stop;
	    else
	       if Clock > Alarm_Time then
	          Put_Line("Deadline exceeded!");
	          Next_Time := Next_Time + 1.0; -- Delay F1.
		  Running := False; -- Stop the watchdog.
	       end if;  
	    end select;
	 end loop;
      end Watchdog;

   begin
      Put("F3 executing, time is now:");
      Put_Line(Duration'Image(Clock - Start_Time));
      
      Reset(G);
      if Random(G) < 0.5 then
         delay 0.1;
      else delay 0.6;
      end if;
      
      Watchdog.Stop;
   exception
      when Tasking_Error => null;
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
end RTS_Lab1_2;
