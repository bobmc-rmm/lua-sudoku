# lua-sudoku
Solve Sudoku with Lua

Lua is designed to have a set of useful abstractions while maintaining a small core. Numbers are floating-point by default and the default data type is Table. As such, it does not have arrays such as found in C, C++,Java, et cetera. Instead it simulates arrays or matrices using Tables.  They are pseudo-arrays constructed with invisible linked lists. So a Lua array constructor accepts a list of objects which are identified automatically with numbers and the first number is "1". 

My program represents the sudoku puzzle as a Lua 1-dimensional array but the recursive back-tracking algorithm uses row-column notation. In order to change a cell, the row-column values are converted to a single index as needed. The script is interactive. It prompts for a puzzle file number which, for now, is a single digit. It will solve most puzzles quickly but "9.puz" copied from Wikipedia takes maybe an hour. That puzzle was designed to resist brute-force algorithms. The solution takes 65 million tries and almost as many retries. A C program will solve it in 2 minutes.

I program mostly in C so I am not looking to Lua for performance. As a designer, I find it has sophisticated features and well-considered tradeoffs.

