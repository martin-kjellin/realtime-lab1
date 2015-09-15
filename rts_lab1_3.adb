-- Lab 1, part 3
with Ada.Text_IO;
use Ada.Text_IO;
with Ada.Numerics.Discrete_Random;
with Ada.Numerics.Float_Random;

-- Inserts integers into a FIFO buffer and gets them from the buffer.
procedure RTS_Lab1_3 is
   package Integer_Random is new Ada.Numerics.Discrete_Random(Integer);
   
   task Buffer is
      entry Put(X : in integer);
      entry Get(X : out integer);
      entry Stop;
   end;
   
   task Producer is
      entry Stop;
   end;
   
   task Consumer;
   
   -- The buffer.
   task body Buffer is
      Size : constant Integer := 15; -- Size of the buffer.
      B : array (1..Size) of Integer; -- The actual buffer.
      Front : Integer := 0; -- Decides the next position to use in the buffer.
      Number : Integer range 0..Size := 0; -- The number of integers
                                           -- in the buffer.
      Running : Boolean := True; -- The buffer should be stopped when the
                                 -- consumer finishes executing.
   begin
      while Running = True loop
	 select
	    when Number < Size => -- If the buffer is not full.
	       -- Insert an integer.
	       accept Put(X : in Integer) do
	       B((Front + Number) mod Size + 1) := X;
	       Number := Number + 1;
	       end Put;
	       
	 or

	    when Number > 0 => -- If the buffer is not empty.
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
   end Buffer;
   
   -- Inserts values in the range 0..25 into the buffer.
   task body Producer is
      F : Ada.Numerics.Float_Random.Generator;
      G : Integer_Random.Generator;
      New_Value : Integer;
      Running : Boolean := True; -- The producer should be stopped when the
                                 -- consumer finishes executing.
   begin
      Ada.Numerics.Float_Random.Reset(F);
      Integer_Random.Reset(G);
      while Running = True loop
	 select
	    accept Stop do
	       Running := False;
	    end Stop;
	 else
	    New_Value := Integer_Random.Random(G) mod 26;
	    Put("Producer inserts:");
	    Put_Line(Integer'Image(New_Value));
	    Buffer.Put(New_Value);
	    delay Duration(Ada.Numerics.Float_Random.Random(F));
	 end select;
      end loop;
   end Producer;
   
   -- Gets values from the buffer and summarizes them until the sum is over 100.
   task body Consumer is
      E : Ada.Numerics.Float_Random.Generator;
      Sum : Integer := 0;
      New_Value : Integer;
   begin
      Ada.Numerics.Float_Random.Reset(E);
      while Sum <= 100 loop
	 Buffer.Get(New_Value);
	 Put("Consumer gets:");
	 Put_Line(Integer'Image(New_Value));
	 Sum := Sum + New_Value;
	 delay Duration(Ada.Numerics.Float_Random.Random(E));
      end loop;
      Producer.Stop;
      Buffer.Stop;
   end Consumer;

begin 
   null;
end RTS_Lab1_3;
