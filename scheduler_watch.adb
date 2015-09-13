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
      task Watchdog;
      
      task body Watchdog is
	 Alarm_Time : Time := Clock + Short_Period;
      begin
	 while Clock < Alarm_Time loop
	    null;
	 end loop;
	 
	 Put_Line("Deadline exceeded!");
	 Next_Time := Next_Time + Long_Period;
      end Watchdog;

   begin
      Put("F3 executing, time is now:");
      Put_Line(Duration'Image(Clock - Start_Time));
      delay Long_Period;
      abort Watchdog;
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
