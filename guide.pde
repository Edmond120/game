/*
---------------------------------------------------------
Understanding this huge file of gibberish 101 -by edmond
---------------------------------------------------------
Chapter 0 -processing
======================
To keep things simple, when you run a processing sketch,
the function settings() is called
then the function setup() is called
and then the function draw() is looped over and over.
all of these functions are in the "game" tab.
I made my code similar to netlogo to make it easier for me to train my slaves, I mean.... collaborators.

Chapter 1 -game modes
======================
in the tab "game"'s setup function there is the line
~~~~~~~~~~~~~~~~~~~~~~~~
mode = new mainMenu();
~~~~~~~~~~~~~~~~~~~~~~~~
-a mode like mainMenu has two functions, _setup() and tick(). If you know netlogo then you should understand this, if you
don't know netlogo then you should do research on netlogo and then come back.
-switching modes is easy, just do
~~~~~~~~~~~~~~~~~~~~~~~~
mode = someOtherMode;
//if you are creating a new mode then you will have to call _setup after like this
//mode._setup()
~~~~~~~~~~~~~~~~~~~~~~~~
all data is saved in the object and as long as that mode is not referencing that object, it will be in a "frozen" state

Chapter 2 -scaleing
======================
-the ratio of the game screen is 16/9=x/y
-the size unit in this game is x * scale, such that 16 * scale pixels take up the entire width of the game screen
-all unit conversions (multiplying by scale) is taken care of in the constructor of the object that does not require 
a parameter called "parent"
-this is because when an object creates another entity it might pass on its own variables, and those variables are already scaled
-all entitys will use the constructor that requires "parent" when creating another entity (parent is itself), that
constructor will NOT scale the parameters

-----^^^SIMPLIFIED VERSION^^^-----

if an object calls a constructor of an object that has the class "entity" as a parent
and the first parameter is "this", then it will NOT scale the units for you.
(ex. new bullet(this,otherParameters) --->>> units are not scaled, parent = this
     new bullet(otherParameters)      --->>> units are scaled, parent = null)
the "parent" parameter is just for situations like, if you get killed by an enemy bullet
then enemyBullet.parent == the unit that killed you

----------------------------------
//I suck at making tutorials -edmond


*/