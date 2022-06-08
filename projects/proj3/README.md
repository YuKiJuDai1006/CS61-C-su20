# CS61CPU

Look ma, I made a CPU! Here's what I did:
It's such a great idea.
Task 1: I spent three hours debugging mulhu and finally made a subcircuit for it. Besides, I find a tricky thing about 2's comcomplement and unsigned integer (mul, positive mul negative). The latter half bits of result are always same regradless the way for presenting integer.

Task 2: The most tricky thing is how to write_data to the exact reg (use wir_en signal). Besides, I find some characteristic about DMX. DMX will set 0 to all the datas in east side when it doesn't match the sel.

Task 3: So easy :)

Task 4: OMG! The logic control kills me! The most difficult thing is to design ALUSel. I come up an idea which seperate the four bits of ALUSel and calculate each of them. Finally, connect them! It's generally applicable for more bits than four. WONDERFUL IDEA FROM Wxy!
I still spent a lot of time debugging. The most tricky bug is that the PC for two stages is different, so I have to use a register to distinguish the older PC and the new PC. The bug is I match old stage with new PC.

Task 5: Correct some little mistakes about ALUSel signal. Besides, I have to use a new subcircuit to add extra logic control (swlt) to my CUP. Not so difficult.


WOW, I did it!
-
