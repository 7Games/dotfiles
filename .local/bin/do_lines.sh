#!/usr/bin/env lua

local FLAG_ASYNC = false;

function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end

if #arg < 2 then
   print(string.format("Usage: %s [args...] <file> <command> <command_arguments>...", arg[0]));
   os.exit(1);
end

local arg_offset = 1;

local FILE = "";
local COMMAND = "";

-- Get program arguments
for i = arg_offset, #arg do
    if arg[i] == "-a" or arg[i] == "--async" then
        FLAG_ASYNC = true;
    else
        break;
    end

    arg_offset = arg_offset + 1;
end

-- Set file
FILE = arg[arg_offset];
arg_offset = arg_offset + 1;

-- Get program and it's arguments
for i = arg_offset, #arg do
   COMMAND = COMMAND.." "..arg[i];
end

-- Try to read file
local file = io.open(FILE, "r")
if file then

   for line in file:lines() do
      os.execute(COMMAND.." "..line);
      print(COMMAND.." "..line);
   end
   file:close() -- Always close the file when you're done
else
   print("File doesn't exist");
   os.exit(2);
end
