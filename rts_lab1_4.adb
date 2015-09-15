with Ada.Text_IO;
use Ada.Text_IO;
with Ada.Numerics.Discrete_Random;

procedure rts_lab1_4 is
   package Integer_Random is new Ada.Numerics.Discrete_Random(Integer);
   use Integer_Random;
   
   type Integer_Array is array (Positive range <>) of Integer;-- Container of the Buffer
   
   protected Buffer is -- Declarations of the Buffer
      entry Put(X : in integer);
      entry Get(X : out integer);
   private
      Front : Integer := 0; -- Point to the top position of the Buffer
      Size : Integer := 15;
      Number : Integer range 0..15 := 0; -- The number of integers in the Buffer
      Buffer_Array : Integer_Array (1..15);-- Container of the Buffer
   end Buffer;
   
   task Producer is -- Declarations of the Producer
      entry Stop;
   end Producer;
   
   task Consumer; -- Declarations of the Consumer

   protected body Buffer is -- Definition of Buffer
      entry Put(X : Integer) when Number < Size is
      begin
	 Buffer_Array((Front + Number) mod Size + 1) := X; -- put x on the bottom 
	 Number := Number + 1; -- The number of integers in the Buffer plus one
      end Put;
      
      entry Get(X : out Integer) when Number > 0 is
      begin
	 X := Buffer_Array(Front mod Size + 1); -- get x from the top of the buffer
	 Number := Number - 1; -- The number of integers in the Buffer minus one 
	 Front := Front + 1; -- Point to the next top position of the Buffer
      end Get;
   end Buffer;
   
   task body Producer is -- Definition of Producer task
      G : Generator;
      Produce_Range : constant Integer := 26; -- maximun of the random number
      Running : Boolean := True; -- keep running Producer(True) or not(False)
      New_Value : Integer; -- New random number produced
   begin
      Reset(G);
      while Running = True loop
	 
      	 select
	    
      	    accept Stop do
      	       Running := False;
      	    end Stop;
	    
      	 else
	    
      	    New_Value := Random(G) mod Produce_Range; -- Produce random number from 0 to 25
      	    Put("Producer Put to buffer:");
      	    Put_Line(Integer'Image(New_Value));
      	    Buffer.Put(New_Value); -- Put number into buffer
	    
      	 end select;
      end loop;
   end Producer;
   
   task body Consumer is -- Definition of Producer task
      Sum : Integer := 0;
      New_Value : Integer;
   begin
      while Sum <= 100 loop -- loop while summerizes in consumer no more than 100
      	 Buffer.Get(New_Value); -- get number from buffer
      	 Put("Consumer get from buffer:");
      	 Put_Line(Integer'Image(New_Value));
      	 Sum := Sum + New_Value; -- summerized
      end loop;
      Producer.Stop;
   end Consumer;

begin
   null;
end rts_lab1_4;
