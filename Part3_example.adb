---------------------
-- Ada implementation of bounded-buffer problem
---------------------
-- Two tasks: a producer and consumer.  A Protected record is used as
-- a buffer between the two.
---------------------

with Text_Io;
use  Text_Io;

procedure BuffSimple is

  -----
  -- Declarations needed for the bounded buffer
  -----
  NumElems : constant := 10;
  type Buff_Ary is Array (1..NumElems) of integer;

  -----
  -- Buffer Specification
  -----
  protected Buffer is
    entry Put (X: in  integer);
    entry Get (X: out integer);
  private
    Buffers : Buff_Ary;
    Next_in, Next_out : integer range 1..NumElems := 1;
    Curr_sz : integer range 0..NumElems := 0;
  end Buffer;
    
  -----
  -- Buffer Body
  -----
  protected body Buffer is
    entry Put (X: in  integer) when curr_sz < NumElems is
    begin
      Buffers (Next_in) := X;
      Next_in := (Next_in mod NumElems) + 1;
      curr_sz := curr_sz + 1;
    end Put;

    entry Get (X: out integer) when curr_sz > 0 is
    begin
      X := Buffers (Next_out);
      Next_out := (Next_out mod NumElems) + 1;
      Curr_sz := Curr_sz - 1;
    end Get;
  end Buffer;

 
  -----
  -- Producer task
  -----
  task Producer;
  task body Producer is
    item : integer := 0;
  begin
    loop
      -- <<Produce item >>
      item := item + 1;

      Put ("item:" & item'img & "  put in buffer");
      New_line;
      -- Add to Buffer
      Buffer.Put (item);
    end loop;
  end Producer;

  -----
  -- Consumer task 
  -----
  task Consumer;
  task body Consumer is
    item : integer;
  begin
    loop
      -- Get item from Buffer
      Buffer.Get (item);

      -- <<Consume item >>
      Put ("item:" & item'img & "  obtained from buffer");
      New_line;
    end loop;
  end Consumer;

begin
  null;
end BuffSimple;
