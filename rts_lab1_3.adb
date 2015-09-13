with Ada.Text_IO;
use Ada.Text_IO;
with Ada.Numerics.Discrete_Random;

procedure rts_lab1_3 is
   package Integer_Random is new Ada.Numerics.Discrete_Random(Integer);
   use Integer_Random;
   
   task Buffer is
      entry Put(X : in integer);
      entry Get(X : out integer);
      entry Stop;
   end;
   
   task Producer is
      entry Stop;
   end;
   
   task Consumer;
   
   task body Buffer is
      Size : constant Integer := 15;
      B : array (1..Size) of Integer;
      Front : Integer := 0;
      Number : Integer range 0..Size := 0;
      Running : Boolean := True;
   begin
      while Running = True loop
	 select
	    when Number < Size =>
	       accept Put(X : in Integer) do
		  B((Front + Number) mod Size + 1) := X;
		  Number := Number + 1;
	       end Put;
	       
	 or

	    when Number > 0 =>
	       accept Get(X : out Integer) do 
		  X := B(Front mod Size + 1);
		  Number := Number - 1;
		  Front := Front + 1;
	       end Get;
	    
	 or
	
	    accept Stop do
	       Running := False;
	    end Stop;
	    
	 end select;
      end loop;
   end buffer;
   
   task body Producer is
      G : Generator;
      Produce_Range : constant Integer := 26;
      New_Value : Integer;
      Running : Boolean := True;
   begin
      Reset(G);
      while Running = True loop
	 select
	    
	    accept Stop do
	       Running := False;
	    end Stop;
	    
	 else
	    
	    New_Value := Random(G) mod Produce_Range;
	    Put("To buffer:");
	    Put_Line(Integer'Image(New_Value));
	    Buffer.Put(New_Value);
	    
	 end select;
      end loop;
   end Producer;
   
   task body Consumer is
      Sum : Integer := 0;
      New_Value : Integer;
   begin
      while Sum <= 100 loop
	 Buffer.Get(New_Value);
	 Put("From buffer:");
	 Put_Line(Integer'Image(New_Value));
	 Sum := Sum + New_Value;
      end loop;
      Producer.Stop;
      Buffer.Stop;
   end Consumer;

begin 
   null;
end rts_lab1_3;
