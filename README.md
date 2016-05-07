# Mastermind  
  
#### Instructions:  
Code breaker must guess the code set by Codemaker within 12 turns. The code is a combination of 4 colors from the following set:  
 - 'R'ed  
 - 'G'reen  
 - 'B'lue  
 - 'W'hite  
 - 'O'range  
 - 'Y'ellow  
Repetitions are allowed. After each guess, the codebreaker gets the information about how precise the guess is.  
'Exact' (X) matches represent the number of correct colors in good positions.  
'Partial' (O) matches represent correct colors, but in wrong positions.  

Example 1:  
code:  R G B W  
guess: R W O Y  

Feedback: XO  

Example 2:  
code:  W W O O  
guess: W W W O  

Feedback: XXX  
  
Note that Codebreaker didn't get information about second 'Orange'.  

Codemaker wins if Codebreaker fails to guess the code within 12 turns. Otherwise it's Codebreaker's victory.  