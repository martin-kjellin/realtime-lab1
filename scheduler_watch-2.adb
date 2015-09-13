-- Lab1 part two
with Ada.Text_IO, Calendar, Ada.Numerics.Float_Random;
use Ada.Text_IO, Calendar, Ada.Numerics.Float_Random;

procedure Scheduler_Watch is
   Short_Period : Duration := 0.5;
   Long_Period : Duration := 1.0;
   -- Start_Time : Time := Clock;
   -- Next_Time : Time := Start_Time + Short_Period;   
   Start_Time : Time;
   Next_Time : Time;
   G : Generator;
   F3exeutedtime : Uniformly_Distributed;

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
         entry stop;
      end Watchdog;

      task body Watchdog is
         Alarm_Time : Time := Clock + Short_Period;
      begin
         loop 
            select 
               accept stop do exit loop;
               end stop;
            end select;

            Put_Line("Deadline_exceeded.");
         end loop;
               
         -- checking_loop : loop
         --    if(Clock < Alarm_Time) then null;
         --    else 
               
         --       exit checking_loop;
         --    end if;
         -- end loop checking_loop;
         
      end Watchdog;

   begin
      Put("F3 executing, time is now:");
      Put_Line(Duration'Image(Clock - Start_Time));
      delapy
      if(F3exeutedtime < 0.5) then 
         Watchdog.stop;
      end if;
   end F3;
   
begin
   Start_Time := Clock;
   Next_Time := Start_Time + Short_Period;
   loop
      F1;
      F2;
      delay until Next_Time;
      reset (G);
      F3exeutedtime := Random(G);
      if (F3exeutedtime>0.5) then
            Put_Line("F3 executed more than 0.5.");
            Next_Time := Next_Time + long_period;
      else
            Put_Line("F3 executed less than 0.5.");
            Next_Time := Next_Time + short_period;
        end if;
      F3;
        delay until Next_Time;
        Next_Time := Next_Time + short_period;
   end loop;
end Scheduler_Watch;
