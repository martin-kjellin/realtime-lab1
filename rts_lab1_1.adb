-- Lab1 part one
with Ada.Text_IO, Calendar;
use Ada.Text_IO, Calendar;

procedure rts_lab1_1 is
   Short_Period : Duration := 0.5;
   -- delay for a short period for F3 to do after F1 and F2
   Long_Period : Duration := 1.0;
   -- delay for a long period while F3 only do every other second
   
   Start_Time : Time;
   Next_Time : Time; -- time for delay
   
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
   begin
      Put("F3 executing, time is now:");
      Put_Line(Duration'Image(Clock - Start_Time));
   end F3;
   
begin
   Start_Time := Clock; -- the start time start go with the clock time
   Next_Time := Start_Time + Short_Period;
   
   loop
      F1; -- execute F1
      F2; -- execute F2
      delay until Next_Time;
      -- delay for 0.5 second that F3 start at 0.5 after the execution of F1 and F2

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
end rts_lab1_1;
