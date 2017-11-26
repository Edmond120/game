# game

bugs: processing.sound library might not work due to this issue https://github.com/processing/processing-sound/issues/81   
this bug seems to be an ubuntu only thing, if you were to encounter this bug and can't fix it then I suggest you use windows

the extra PApplets (windows) might be a bit weird (not in the same posistion as the entity it's following) in ubuntu.  

requirments:
    processing  
    the library: processing.sound  

updates: 

Controls:  
z- shoot  
ctrl- toogle direction lock  
c- hold to change direction lock  
shift- focus  
wasd- move second screen in test game  
arrow keys- move  
v b - turns worm left or right  
l k - strinks and enlarges gap between segments and nodes in worm (forgot which is which)  
n- accelerates worm  
m- decelerates worm  
worm movements are meant to be controled by the computer in the future,  
as planned attack patterns require control over other segments besides the head.  
Control varies on friction values which is currently not adjustable yet.  


worm level and test game works  


see if you can move the worm to the center of the screen(get rid of the other window  
by moving worm out of bounds then back in again)  
press J for attack pattern 1  
press h after j for attack pattern 2  
worm A.I. will be worked on after enough attack patterns have been made  
Note: the worm's friction depends on its attack pattern, so pressing J will also change  
the worm's movement.  
