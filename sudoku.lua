#!/usr/bin/lua
print("--- pgm6 ---")
-- sudoku
-- 2020-feb-06

---------- begin insert puzzle from clues.txt --------
local CLUES={ -- easy; tries=72 retries=31
   6,5,0,8,7,3,0,9,0,
   0,0,3,2,5,0,0,0,8,
   9,8,0,1,0,4,3,5,7,
   1,0,5,0,0,0,0,0,0,
   4,0,0,0,0,0,0,0,2,
   0,0,0,0,0,0,5,0,3,
   5,7,8,3,0,1,0,2,6,
   2,0,0,0,4,8,9,0,0,
   0,9,0,6,2,5,0,8,1,
}

local grid9 = {}  -- CLUES are implicitly immutable, so a grid9 copy is needed
-- for i=1,81 do grid9[i] = CLUES[i] end

-- these variables are set by "solve()" later --
local tries   -- count cell changes while running
local retries    -- count backtracks while running

-----------------------------------------------------------------
-- given row 1-9 + col 1-9; return index 1-81
local function rc_to_idx( row, col )
   local idx = (row-1)*9 + col
   return idx
end

-----------------------------------------------------------------
--- given a row or column index, select first corner of box
local function box_start( rc )
   if rc < 4 then return 1 end
   if rc < 7 then return 4 end
   return 7
end

-----------------------------------------------------------------
-- return true if row already has number
local function row_has_number( puzzle, rnum, num   )
   local idx = rc_to_idx(rnum,1)
   for i=1,9 do	
      if puzzle[idx] == num then return true end
      idx = idx+1
   end
   return false
end

-----------------------------------------------------------------
-- return true if column already has number
local function col_has_number( puzzle, cnum, num   )
   local idx = rc_to_idx(1,cnum)
   for i=1,9 do	
      if puzzle[idx] == num then return true end
      idx = idx+9
   end
   return false
end

-----------------------------------------------------------------
-- return false if 'num' is already placed in row, col, or box
local function is_safe( puzzle, rn,cn, num )
   for i=1,9 do
      if row_has_number(puzzle,rn,num) then return false end
      if col_has_number(puzzle,cn,num) then return false end
   end

   local y = box_start(rn)
   local x = box_start(cn)
   
   for i=y,y+2 do
      for j=x,x+2 do
	 local idx = rc_to_idx(i,j)
	 if puzzle[idx]==num then return false end
      end
      end
   return true
end

-----------------------------------------------------------------
-- check if all cells are assigned or not
-- return row,col,true if there is an open cell
local function number_unassigned(puzzle)
   local row,col,idx,valid
   valid = false
   for row=1,9 do
      for col=1,9 do
	 local idx = rc_to_idx(row,col)
	 if puzzle[idx] == 0 then do
	       return row,col,true  end
	 end
      end
   end
   return 1,1,false
end

-----------------------------------------------------------------
-- solve sudoku using backtracking
local function solve_sudoku(puzzle)
   local row,col,valid
   row,col,valid = number_unassigned(puzzle)
   -- print(row,col,valid)
   if not valid  then return 1 end  -- 81 cells have been set
   local idx = rc_to_idx(row,col)
   puzzle[idx] = 0 -- clear before safety check
   for num=1,9 do
      if is_safe( puzzle, row,col, num ) then do
	    puzzle[idx] = num
	    -- print("pos=",pos,"num=",num)
	    tries = tries+1
	    if solve_sudoku(puzzle) then return 1 end -- recursive
	    puzzle[idx] = 0 -- did not work
	    retries = retries+1 end
      end
   end
end

-----------------------------------------------------------------
-- show puzzle rows and columns
local function print_puzzle( puzzle)
   local row,col,idx

   for row = 1,81,9 do
      for col = 1,9 do
	 idx = row + col - 1
	 io.write(string.format("%d ", puzzle[idx]))
	 if col == 3 or col == 6 then do
	       io.write(string.format(" "))  end
	 end
      end
      print("")
   end
   print("..")
end

-----------------------------------------------------------------
-- check puzzle rows and columns for 1+2+3+4+5+6+7+8+9 = 45
local function check_puzzle( puzzle)
   local row,col,idx,sum

   for col = 1,9 do
      sum = 0
      for row = 1,81,9 do
	 idx = row + col - 1
	 sum = sum + puzzle[idx]
      end
      -- print(col,sum)
      if sum ~= 45 then do
	    print("..column sum not equal 45")
	    return false end end
   end
   print("..column check ok")

   for row = 1,81,9 do
      sum = 0
      for col = 1,9 do
	 idx = row + col - 1
	 sum = sum + puzzle[idx]
      end
      -- print(row,sum)
      if sum ~= 45 then do
	    print("..row sum not equal 45")
	    return false end end
   end
   print("..row check ok")
   return true
end

-----------------------------------------------------------------
local function load_puzzle( puzzle, puzzle_id)
   id = string.format("%d.puz",puzzle_id)
   local f = io.open(id, "r")
   print(f:read("*l"))  -- skip the 1st line comment
   for idx = 1,81 do
      local n1 = f:read("*n" )
      CLUES[idx] = n1;
      --print(" ")
   end
   f:close()
   -- print_puzzle(grid9)
end

-----------------------------------------------------------------
local function start ()
   tries   = 0
   retries    = 0
   
   print("select puzzle number 1..9 ")
   local n = io.read("*n")
   if n < 1 or n > 9 then return end
   load_puzzle(CLUES,n)
   print_puzzle(CLUES)
   
   for i=1,81 do grid9[i] = CLUES[i] end

   if solve_sudoku(grid9) then
      print_puzzle(grid9);
   else
      print("No solution\n");
   end
   check_puzzle(grid9)
   print(string.format("tries=%d; retries=%d\n", tries,retries) )
end

start()  -- run the sudoku solver, print results

