/*
    Red-Sprite logo in 3D
    https://www.meetup.com/Red-Sprite/
    Author: kevin@kgolding.co.uk
*/

$fn = 20;           // Smoothness
overlap = 0.15;     // Overlap of the virtual squares that the logo is made up from
rounding = 0.1;     // Rounding of square corners
view = "Default";   // ["Default", "Grid", "Half", "Whole", "Rounded"]

// View switcher, so that one can quickly change what is displayed using the customizer
if (view == "Default") {
    RedSpritePadded();
} else if (view == "Grid") {
    Grid();
} else if (view == "Half") {
    Half();
    Grid();
} else if (view == "Whole") {
    Whole();
    Grid();
} else if (view == "Rounded") {
    RedSpritePadded();
    Grid();
}

// Half() draws half of the RedSprite logo, by first drawing a body
// and then cutting out the bits we don't want
module Half() {
    difference() {
        // The body, which we cut out what we don't want
        // Prefix with ! to only show this item
        square([6,8]);
        
        // Eye(s)
        translate([2,4,0]) square([1,1]);

        // Leg(s)
        translate([4,0,0]) square([1,3]);
        translate([5,0,0]) square([1,1]);

        // Sid(e)
        translate([5,4,0]) square([1,1]);
        translate([4,5,0]) square([2,1]);
        translate([3,6,0]) square([3,1]);

        // Ear(s)
        translate([0,6,0]) square([2,1]);
        translate([0,7,0]) square([3,1]);
        translate([3,6,0]) square([3,1]);
        translate([4,7,0]) square([2,1]);

        // Mouth, which breaks from the regular square size as it need to look
        // a little more open!
        square([1+overlap,1]);
        translate([0,1-overlap,0]) square([3,1+overlap]);
    }
}

// Whole() combines two halfs, one mirrored and overlapped by half a square
// to get the middle section a little narrower
module Whole() {
    union() {
        Half();
        mirror([1,0,0])
            translate([-1,0,0])
                Half();
    };
}

// RedSpriteOverlapRounded uses minkowski to increase the size of the shape
// by outlining it with circle around, making it fatter and joining
// the squares where they are diagonally related, and then applies 
// rounding using the Polyround module
module RedSpriteOverlapRounded() {
    Polyround(rounding) {
        minkowski() {
            Whole();
            circle(overlap);
        }
    }
}

// RedSpritePadded takes our 2D shape and colors it red and extrudes (aka pads)
// it into a 3D model
module RedSpritePadded() {
    color("red")
        linear_extrude(1)
            RedSpriteOverlapRounded();    
}

// Hidden extras
// Scaling whilst extruding to give a angled effect
*translate([0,15,0]) linear_extrude(4, scale=0.8) translate([0,-4,0]) RedSpriteOverlapRounded();

// grid draws a checker background and x/y axises to help
// talk through the design process
module Grid() {
    Xmin = -5;
    Xmax = 5;
    Ymin = 0;
    Ymax = 7;
    textPad = 0.25;
    textSize = 1 - 2 * textPad;
    
    // Show grid behind model
    color("black", 0.2) translate([0,0,-0.1]) linear_extrude(0.1) {
        // Legends
        color("black") translate([(Xmax+Xmin)/2+textPad,Ymax+2,0])
            text(text="X", size=textSize, valign="baseline");
        color("black") translate([Xmax+2,(Ymax+Ymin)/2+textPad,0])
            text(text="Y", size=textSize, valign="baseline");
        
        for (x = [Xmin:Xmax]) {
            for (y = [Ymin:Ymax]) {
                // X Axises
                if (y == Ymin) {
                    color("black", 0.5) translate([x+textPad,Ymax+1+textPad,0])
                        text(text=str(x), size=textSize, valign="bottom");
                }
                // Y Axises
                if (x == Xmax) {
                    color("black", 0.5) translate([Xmax+1+textPad,y+textPad,0])
                        text(text=str(y), size=textSize, valign="bottom");
                }
                // Checker background
                if ((x + y % 2 )% 2 == 0) {
                    color("silver", 0.2) translate([x,y,0]) square(1);
                }
            }
        }
    }
}

// Polyround rounds a given shape by a given radius, optionally
// by either inside and outside (default is both)
module Polyround(radius,inside=true,outside=true){
// src https://www.reddit.com/r/openscad/comments/ji30g3/comment/ga6n7aa/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
	if (inside == true){
		if (outside == true){
			// Inside corners
			offset(r=-radius)
			offset(delta=radius)
			// Outside corners
			offset(r=radius)
			offset(delta=-radius)
			children();
		} else {
			// Inside corners
			offset(r=-radius)
			offset(delta=radius)
			children();
		}
	} else {
		if (outside == true) {
			// Outside corners
			offset(r=radius)
			offset(delta=-radius)
			children();
		} else {
			children();
		}
	}
}
