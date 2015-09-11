with Ada.Text_IO;
with Ada.Text_IO;
use Ada.Text_IO;
with Ada.Numerics.Discrete_Random;
with Ada.Numerics.Float_Random;
use Ada.Numerics.Float_Random;

procedure randomfloat is
    
     G : Generator;
     F3_delay_time : Uniformly_Distributed;
begin 
     reset(G);
     loop
        F3_delay_time := Random(G);
        Put_Line(Float'Image(F3_delay_time));
        delay 0.5;
      end loop;

end randomfloat;
