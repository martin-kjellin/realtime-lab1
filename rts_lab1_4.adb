with Ada.Text_IO;
use Ada.Text_IO;
with Ada.Numerics.Discrete_Random;

procedure rts_lab1_4 is
   package Integer_Random is new Ada.Numerics.Discrete_Random(Integer);
   use Integer_Random;
   
   protected Buffer is -- Declarations of the Buffer
      entry Put(X : in integer);
      entry Get(X : out integer);
      entry Stop;
   private
      Size : constant Integer := 15; -- Size of the Buffer
      B : array (1..Size) of Integer; -- Container of the Buffer
      Front : Integer := 0; -- Point to the top position of the Buffer
      Running : Boolean := True; -- keep running Buffer(True) or not(False)
      Number : Integer range 0..Size := 0; -- The number of integers in the Buffer  
   end Buffer;

   protected body Buffer is -- Definition of Buffer task 
   begin
      while Running = True loop
	 select
	    when Number < Size => -- if the Buffer is not full
	       accept Put(X : in Integer) do
		  B((Front + Number) mod Size + 1) := X; -- put x on the bottom 
		  Number := Number + 1; -- The number of integers in the Buffer plus one
	       end Put;
	       
	 or

	    when Number > 0 => -- if the Buffer is not empty
	       accept Get(X : out Integer) do 
		  X := B(Front mod Size + 1); -- get x from the top of the buffer
		  Number := Number - 1; -- The number of integers in the Buffer minus one 
		  Front := Front + 1; -- Point to the next top position of the Buffer
	       end Get;
	    
	 or
	
	    accept Stop do
	       Running := False;
	    end Stop;
	    
	 end select;
      end loop;
   end buffer;
   
   task Producer is -- Declarations of the Producer
      entry Stop;
   end Producer;
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
   
   task Consumer; -- Declarations of the Consumer
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
      Buffer.Stop;
   end Consumer;

begin 
   null;
end rts_lab1_4;
