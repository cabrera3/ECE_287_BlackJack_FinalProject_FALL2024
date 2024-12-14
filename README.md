# Please Note

As of now this project does not work in its intended form. 

There is a bug I have tried correcting that causes the "player_hand [5:0]" register array to be filled with values outside of the seven segment display module's desired cases. This causes the program to fill the player's hand with card values outside of the typical 52 card deck point values (1-11). When this happens the player becomes unable to draw cards and instead "busts" and fails the game instantly once a decision is made to either draw or fold on a hand of cards. 

Additionally, the linear feedback shift register (LFSR) module which I used to generate the shuffled deck register array "deck [11:0]" will at times output a number greater than 10. This causes the seven segment display to turn all of its segments off and inputs an undesired card value into the player or dealer's hand.

The logic dictating the dealer's behavior function's well on its own and may be pulled for use in a future project.

Finally, the name's of files connected to this project do not fit with their usecase. This is because the script was generated on top of an already existing project designed by Dr. Peter Jamieson of Miami University to save time programing the pin assignments. Thank you Dr. Jamieson for all of your support, understanding, and tough love for all your students. My time in this course was challenging but I enjoyed it to the fullest extent. Best to you and yours, love and honor.
