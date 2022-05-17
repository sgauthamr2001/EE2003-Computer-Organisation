# Assignment 2

Simple assembly language programming for the RISC-V

## Goals

- Demonstrate basic working knowledge of RISC-V assembly

## Given

- Test bench assembly code for Fibonacci number
    - Some test cases 
- Template code that you can use to fill in

## Details on the assignment

### Fibonacci series

The Fibonacci series is a well known sequence of numbers that follows the pattern that the *n*th number is the sum of the previous two numbers.  This is usually represented in a recursive manner as follows (shown below for Python, similar representations for other languages):

```python
def fib(n):
    if (n==1) or (n==2):
        return 1
    else:
        return fib(n-1) + fib(n-2)
```

For coding this in Assembly language, you may want to think about how to rewrite this without recursion, since writing recursive programs in Assembly, while not impossible, is not very pleasant.

### Test cases

You are given a test bench that will call a function written by you with different input values.  The parameter *n* (number in the sequence to compute) is given in the register `a0`, and you are required to return the computed value also in `a0`.  It is up to you how you handle saving intermediate values in your function, or whether you even retain them at all.


## HowTo

The `run.sh` script performs all the steps required to compile and test your code.  It assumes the RISCV toolchain is installed. If you install on your own system you need to make the appropriate settings.
