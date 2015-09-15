-- Lab1 part two
with Ada.Text_IO, Calendar, Ada.Numerics.Float_Random;
use Ada.Text_IO, Calendar, Ada.Numerics.Float_Random;

procedure Scheduler_Watch is
   Short_Period : Duration := 0.5;
   -- delay for a short period for F3 to do after F1 and F2
   Long_Period : Duration := 1.0;
   -- delay for a long period while F3 only do every other second
   little_time : Duration := 0.1; 
   -- for F3 work less than 0.5 just delay for a s

   Start_Time : Time;
   Next_Time : Time; -- time for delay

   G : Generator; -- generate a random number
   F3exeutedtime : Uniformly_Distributed; 
   -- a number from generator and decide the time for F3 to execute

   procedure F1 is -- printing the executing time of F1
   begin
      Put("F1 executing, time is now:");
      Put_Line(Duration'Image(Clock - Start_Time));
   end F1;
   
   procedure F2 is -- printint the executing time of F2
   begin
      Put("F2 executing, time is now:");
      Put_Line(Duration'Image(Clock - Start_Time));
   end F2;
   
   procedure F3 is -- printing the executing time of F3 
                   -- with watchdog to check if F3 meets the deadline
      task Watchdog is
	 entry Stop;
      end;
      
      task body Watchdog is
	 Alarm_Time : Time := Clock + Short_Period; -- check the time if is more than 0.5	     
	 Running : Boolean := True; -- if F3 execute less than 0.5 should stop the watchdog
      begin
	 while Running = True loop
	    select
	       accept Stop do
		  Running := False; -- Stop the watchdog
	       end Stop;
	    else
	       if Clock > Alarm_Time then
	          Put_Line("Deadline exceeded!");
	          Next_Time := Next_Time + Long_Period;
		  -- presupposes that F3 always takes less than 1 second
		  Running := False; -- stop the watchdog
	       end if;  
	    end select;
	 end loop;
      end Watchdog;

   begin
      Put("F3 executing, time is now:");
      Put_Line(Duration'Image(Clock - Start_Time));
      if(F3exeutedtime < 0.5) then
         delay little_time;
      else delay Short_Period;
      end if;
      Watchdog.Stop;
   exception
      when Tasking_Error => null;
   end F3;
   
begin
   Start_Time := Clock; -- the start time start go with the clock time
   Next_Time := Start_Time + Short_Period;
   loop
      F1; -- execute F1
      F2; -- execute F2
      delay until Next_Time;
      -- delay for 0.5 second that F3 start at 0.5 after the execution of F1 and F2
      
      reset (G);
      F3exeutedtime := Random(G); -- generate a random number 
      if (F3exeutedtime>0.5) then
	 Put_Line("F3 executed more than 0.5.");
      else
	 Put_Line("F3 executed less than 0.5.");
      end if;

      Next_Time := Next_Time + Short_Period;
      F3;
      delay until Next_Time;
      -- delay for 0.5 second that F1 start again at the whole second
      
      Next_Time := Next_Time + Long_Period;
      F1;
      F2;
      delay until Next_Time;
      -- delay for 1.0 second that F3 only execute every other second
      Next_Time := Next_Time + Short_Period;
   end loop;
end Scheduler_Watch;
