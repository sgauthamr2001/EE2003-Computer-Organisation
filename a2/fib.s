/***********************************************************

Filename        : fib.s
Description     : Fibonacci Number Generator 
Author          : Sai Gautham Ravipati (EE19B053) 
Input           : Index of the number (n)
Output          : - nth Fibonacci number for n in W 
                  - 0 for n in Z - W
                  
***********************************************************/ 

.global fib

fib:
    li  a1, 1     # Intialising a to 1    
    mv  a2, x0    # Intialising b to 0 
    
l1: 
    bge  x0, a0, end     # Checking for condition n > 0 
    add  a3, a2, a1      # Storing c with a + b 
    mv   a1, a2          # Moving b to a 
    mv   a2, a3          # Moving c to b
    addi a0, a0, -1      # n-- 
    jal  x0, l1          # Repeating the loop  
    
end: 
    mv a0, a2   # Equivalent of returning b 
    jr ra       # Return address was stored by original call

/***********************************************************

C-function implementation without recursion:
- Gives valid output for all whole numbers. 
- Zero output for all negative integers. 

int fib(int n)
{
  int a = 1, b = 0, c;
  
  while(n > 0)
  {
     c = a + b;
     a = b;
     b = c;
     n--; 
  }
  
  return b;
}

Register Set: 

a0 <-- n 
a1 <-- a
a2 <-- b
a3 <-- c 

Finally after all operations contents of a2 are moved to a0. 

***********************************************************/ 