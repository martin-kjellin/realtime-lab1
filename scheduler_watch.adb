with Ada.Text_IO, Calendar;
use Ada.Text_IO, Calendar;

procedure Scheduler_Watch is
   Short_Period : Duration := 0.5;
   Long_Period : Duration := 1.0;
   -- Start_Time : Time := Clock;
   -- Next_Time : Time := Start_Time + Short_Period;   
   Start_Time : Time;
   Next_Time : Time;
   
   procedure F1 is
   begin
      Put("F1 executing, time is now:");
      Put_Line(Duration'Image(Clock - Start_Time));
   end F1;
   
   procedure F2 is
   begin
      Put("F2 executing, time is now:");
      Put_Line(Duration'Image(Clock - Start_Time));
   end F2;
   
   procedure F3 is
      task Watchdog is
	 entry Stop;
      end;
      
      task body Watchdog is
	 Alarm_Time : Time := Clock + Short_Period;
	 Running : Boolean := True;
      begin
	 while Running = True loop
	    select
	       
	       accept Stop do
		  Running := False;
	       end Stop;
	       
	    else
	       
	       if Clock > Alarm_Time then
		  Put_Line("Deadline exceeded!");
		  Next_Time := Next_Time + Long_Period;
		  -- presupposes that F3 always takes less than 1 second
		  
		  Running := False;
	       end if;
	       
	    end select;
	 end loop;
      end Watchdog;

   begin
      Put("F3 executing, time is now:");
      Put_Line(Duration'Image(Clock - Start_Time));
      delay 0.2;
      --delay Long_Period;
      Watchdog.Stop;
   exception
      when Tasking_Error => null;
   end F3;
   
begin
   Start_Time := Clock;
   Next_Time := Start_Time + Short_Period;
   loop
      F1;
      F2;
      delay until Next_Time;
      
      Next_Time := Next_Time + Short_Period;
      F3;
      delay until Next_Time;
      
      Next_Time := Next_Time + Long_Period;
      F1;
      F2;
      delay until Next_Time;
      
      Next_Time := Next_Time + Short_Period;
   end loop;
end Scheduler_Watch;
