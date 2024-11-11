<!-- Description: Explaining bitwise operators in Lua language and its application in practice. -->

tags: lua beginner

# Bitwise operations in Lua

<input type="checkbox" class="toc-toggle" id="toc-toggle">
<label for="toc-toggle">Table of contents</label>

[TOC]

!!! tip
    Bitwise operators: `&`, `|`, `~`, `>>`, `<<` were presented
    since Lua 5.3. In Lua 5.2, there is a [bit32 module](https://www.lua.org/manual/5.2/manual.html#6.7).
    In Lua 5.1 an extra library like [this one](https://github.com/AlberTajuelo/bitop-lua) should be installed.

Bitwise operations in Lua are the same as [bitwise operations in C](https://en.wikipedia.org/wiki/Bitwise_operations_in_C).

## Bits and bytes

Bitwise operations are the operations on bits. Each byte consists of 8 bits, which can have values only 1 or 0, called a binary number.

```text
Byte 1 0000 0000
Byte 2 0001 0100
Byte 3 0001 0100
Byte 4 1111 1100
...
```
## Binary numbers

A binary number is a number expressed in the base-2 numeral system or binary numeral system, used in computer science.

- **Decimal**: base-10 number used in daily life around the world;
- **Binary**: base-2;
- **Octal**: base-8;
- **Hexadecimal**: base-16.

|Decimal | Binary | Octal | Hexadecimal  |
|-------:| ------:|------:|-------------:|
|      0 | 0      |     0 |            0 |
|      1 | 1      |     1 |            1 |
|      2 | 10     |     2 |            2 |
|      3 | 11     |     3 |            3 |
|      4 | 100    |     4 |            4 |
|      5 | 101    |     5 |            5 |
|      6 | 110    |     6 |            6 |
|      7 | 111    |     7 |            7 |
|      8 | 1000   |    10 |            8 |
|      9 | 1001   |    11 |            9 |
|     10 | 1010   |    12 |            A |
|     11 | 1011   |    13 |            B |
|     12 | 1100   |    14 |            C |
|     13 | 1101   |    15 |            D |
|     14 | 1110   |    16 |            E |
|     15 | 1111   |    17 |            F |

*Table 1. The first 16 numbers in various number systems.*

### Bit numbering

Bits in the byte are placed in definite order, like 
the numbers in decimal system. The less meaningful bit is placed at the right side.
The <strong style="color: var(--color-sec)">least significant bit (LSb)</strong> is placed from the right side, and correspondingly, the <strong style="color: var(--color-pri)">most significant bit (MSb)</strong> is from the left side.

<code class="bitbox">87654321</code> order<br>
<code>
<strong class="bitbox" style="color: var(--color-pri)">0</strong>000000<strong  class="bitbox" style="color: var(--color-sec)">0</strong>
</code> bits

## Bitwise operations

Usually bitwise operations are not widely used in scripting 
languages, like Lua or JavaScript. Developers who is writing scripts
usually not very familiar with bits, because there is no need to dive
so deeply into low level. Sometimes bits might be very useful
and make code shorter and reduce memory usage. From the other side,
overusing bitwise operators might lead to cryptic and hardly maintainable
code. This tool should be used wisely.

!!! tip
    There might be differences in 32-bit and 64-bit systems; be sure
    that your final code will run on the same system; otherwise, it
    might lead to unexpected results.

Lua (since 5.3) has in-built the following bitwise operators:

- `&`: bitwise AND
- `|`: bitwise OR
- `~`: bitwise exclusive OR
- `>>`: right shift
- `<<`: left shift
- `~`: unary bitwise NOT

### Bitwise AND `&`

```lua
21 & 19 --> 17
```

The bitwise AND operation compares two binary numbers bit by bit
and returns a new number where each bit is set to 1 only if both
corresponding bits of the operands are 1; otherwise, the resulting bit is set to 0.

```text
  00010101 (decimal 21)
& 00010011 (decimal 19)
-----------
  00010001 (decimal 17)
```

### Bitwise OR `|`

```lua
21 | 19 --> 23
```

The bitwise OR operation compares two binary numbers bit by bit and
returns a new number where each bit is set to 1 if either of the
corresponding bits in the operands is 1. If both bits are 0, the
result is 0.

```text
  00010101 (decimal 21)
| 00010011 (decimal 19)
-----------
  00010111 (decimal 23)
```

### Bitwise XOR `~`

```lua
21 ~ 19 --> 6
```

The bitwise XOR (exclusive OR) operation compares two binary
numbers bit by bit and returns a new number where each bit is set
to 1 if the corresponding bits of the operands are different. If
both bits are the same (either both 0 or both 1), so the result is
0.

```text
  00010101 (decimal 21)
~ 00010011 (decimal 19)
-----------
  00000110 (decimal 6)
```

### Bitwise NOT `~`

```lua
~21 --> -22
```

The bitwise NOT inverts bits zeros into ones and vice versa. Do
not be confused with XOR `~`, which is applied to two operands, but
unary NOT to only one number.

```text
~ 00010101 (decimal 21)
-----------
  11101010 (decimal signed -22, unsigned 234*)
```

!!! tip
    By default, in Lua numbers are signed, unless it is compiled to
    use unsigned integers. The 8th bit means for number 0 -
    positive, 1 for negative numbers; this is why in the upper
    example signed is equal to **-22**.

### Bitwise left `<<` and right `>>` shift

```lua
21 << 2 --> 84
21 >> 3 --> 2
```

Bitwise shift operations move the bits of a number to the left or
right by a specified number of positions. Both right and left
shifts fill the vacant bits with zeros. Negative displacements
shift to the other direction; displacements with absolute values
equal to or higher than the number of bits in an integer result in
zero (as all bits are shifted out).

Left shift:

```text
   00010101 (decimal 21)
<<        2
------------
   01010100 (decimal 84)

Right shift:

```text
   00010101 (decimal 21)
>>        3
------------
   00000010 (decimal 2)
```

## Logical equivalents

Four of the bitwise operators have equivalent
[logical operators](/post/logic-in-lua.html).They are equivalent
in that they have the same [truth tables](/post/logic-in-lua.html#truth-table).
However, logical operators treat each operand as having only one
value, either true or false, rather than treating each bit of an
operand as an independent value. Also, logical operations performs
[short-circuit evaluation](/post/logic-in-lua.html#conditional-ternary-operator).

| Bitwise  | Logical   |
|----------|-----------|
| `a & b`  | `a and b` |
| `a | b`  | `a or b`  |
|  `a ^ b` | `a ~= b`  |
| `~a`     | `not a`   |

## Some applications of bitwise operations

Here are some examples of how bitwise can be used in the daily job.

### Check that number is odd or even

```lua
2 & 1 == 0     -- even
12 & 1 == 0    -- even
444 & 1 == 0   -- even
1 & 1 == 1     -- odd
3 & 1 == 1     -- odd
123 & 1 == 1   -- odd
-- and so on.
```

We are interested only in the 1st bit: is this 0 or 1. If both bits
are 1, then the number is always odd. From the examples below
everything becomes much clearer:

```text
  00000010 (decimal 2)
& 00000001 (decimal 1)
-----------
  00000000 (decimal 0)
  Result is 0, thus 2 is even.

```

```text
  00001110 (decimal 14)
& 00000001 (decimal 1)
-----------
  00000000 (decimal 0)
  Result is 0, thus 14 is even.

```
```text
  00000111 (decimal 7)
& 00000001 (decimal 1)
-----------
  00000001 (decimal 1)
  Result is 1, thus 7 is odd.
```

### Bit flags

Another widely used case for bitwise operations is the permissions
pattern. It is very common in C to set permission for a file access
using bits.

Consider:

```lua
-- power of 2
local READ = 1
local WRITE = 2
local EXEC = 4

function open(filename, mode)
  if mode & READ == 1 then
    -- can read file
  end
  if mode & WRITE == 1 then
    -- can write to file
  end
  if mode & EXEC == 1 then
    -- can execute a file
  end
end

-- Can read, write, execute
open("poetry.sh", READ | WRITE | EXEC)
```

Explanation:

```text

  00000001 (READ 1)
| 00000010 (WRITE 2)
| 00000100 (EXEC 4)
-----------
  00000111 (7)

Read

  00000111 (7)
& 00000001 (1)
-----------
  00000001 (Can read)

Write

  00000111 (7)
& 00000010 (2)
-----------
  00000010 (Can write)

Execute

  00000111 (7)
& 00000100 (4)
-----------
  00000100 (Can execute)
```

### Memory management

Using Lua for programming IoT and microcontrollers where
memory is very limited. However, this topic falls outside
the purview of this discussion this article.

## References

- [Lua Manual: Bitwise operations](https://www.lua.org/manual/5.4/manual.html#3.4.2)
- [Wikipedia: Bitwise operations in C](https://en.wikipedia.org/wiki/Bitwise_operations_in_C)
- [Wikipedia: Bit numbering](https://en.wikipedia.org/wiki/Bit_numbering)

*[IoT]: Internet of things