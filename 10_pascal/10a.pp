uses
  sysutils;

type
  Bot = 0..209;
  Value = 0..71;
  Output = 0..20;
  DestinationType = (ToBot, ToOutput);
  Instruction = record
    low_to_type: DestinationType;
    low_to_index: integer;
    high_to_type: DestinationType;
    high_to_index: integer;
  end;

var
  line: string;
  values_held: array[0..209] of array of Value;
  instructions: array[0..209] of Instruction;
  ready_bots: array of Bot;

function read_word(): string;
var
  index: integer;
begin
  index := pos(' ', line);
  if index = 0 then
  begin
    read_word := line;
    line := '';
  end
  else
  begin
    read_word := leftstr(line, index - 1);
    line := rightstr(line, length(line) - index);
  end;
end;

procedure skip_word(expected: string);
var
  word: string;
begin
  word := read_word();
  if word <> expected then
  begin
    writeln('expected ', expected, ' but got ', word);
    halt(1);
  end;
end;

function read_integer(): integer;
begin
  read_integer := strtoint(read_word());
end;

procedure add_ready_bot(bot: Bot);
var
  len: integer;
begin
  len := length(ready_bots);
  setlength(ready_bots, len + 1);
  ready_bots[len] := bot;
end;

procedure remove_ready_bot(bot: Bot);
var
  len: integer;
  i: integer;
begin
  len := length(ready_bots);
  for i := 0 to len - 1 do
  begin
    if ready_bots[i] = bot then
    begin
      ready_bots[i] := ready_bots[len - 1];
      setlength(ready_bots, len - 1);
      exit;
    end;
  end;
  halt(1);
end;

procedure add_value(bot: Bot; value: Value);
var
  len: integer;
begin
  len := length(values_held[bot]);
  if len = 0 then
  begin
    setlength(values_held[bot], 1);
    values_held[bot][0] := value;
    exit;
  end;
  if len = 1 then
  begin
    setlength(values_held[bot], 2);
    if value > values_held[bot][0] then
      values_held[bot][1] := value
    else
    begin
      values_held[bot][1] := values_held[bot][0];
      values_held[bot][0] := value;
    end;
    add_ready_bot(bot);
    exit;
  end;
  if len = 2 then
  begin
    writeln('bot ', bot, ' already holds 2 values');
    halt(1);
  end;
end;

procedure read_instructions();
var
  value: integer;
  bot: integer;
begin
  while not eof(input) do
  begin
    readln(line);
    if read_word() = 'value' then
    begin
      value := read_integer();
      skip_word('goes');
      skip_word('to');
      skip_word('bot');
      bot := read_integer();
      add_value(bot, value);
    end
    else
    begin
      bot := read_integer();
      skip_word('gives');
      skip_word('low');
      skip_word('to');
      if read_word() = 'bot' then
        instructions[bot].low_to_type := ToBot
      else
        instructions[bot].low_to_type := ToOutput;
      instructions[bot].low_to_index := read_integer();
      skip_word('and');
      skip_word('high');
      skip_word('to');
      if read_word() = 'bot' then
        instructions[bot].high_to_type := ToBot
      else
        instructions[bot].high_to_type := ToOutput;
      instructions[bot].high_to_index := read_integer();
    end;
  end;
end;

procedure give(value: Value; to_type: DestinationType; to_index: integer);
begin
  if to_type = ToOutput then
  begin
  end
  else
  begin
    add_value(to_index, value);
  end;
end;

procedure execute_instruction(bot: Bot);
var
  i: integer;
begin
  if (values_held[bot][0] = 17) and (values_held[bot][1] = 61) then writeln(bot);
  give(values_held[bot][0], instructions[bot].low_to_type, instructions[bot].low_to_index);
  give(values_held[bot][1], instructions[bot].high_to_type, instructions[bot].high_to_index);
  setlength(values_held[bot], 0);
  remove_ready_bot(bot);
end;

begin
  read_instructions();
  while length(ready_bots) > 0 do
  begin
    execute_instruction(ready_bots[0]);
  end;
end.
