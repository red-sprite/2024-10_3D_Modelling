// RedSprite OpenSCAD Intro
// Small set of commands see https://openscad.org/cheatsheet/index.html
// Author: kevin@kgolding.co.uk

// For each "Part" below, use * to disable before moving onto the next part
// which you enabled by removing the *

// PART 1
// ======

// Simple 3D and cutting out
difference() {
    cube([3,4,6]);
    cube(4, center=true);
    translate([-1, 2, 4]) rotate([0,90,0]) cylinder(5, r=1.2, $fn=60);
}

// Super helpful modifiers
// * disable
// ! show only
// # highlight / debug
// % transparent / background
























// PART 2 - Modules, padding 2D to 3D, loops and hulls
// ===================================================

// MyShape() draws a 3D cube with rounded corners
module MyShape(width=5, depth=5, height=5, r=0.5) {
    linear_extrude(height)
    hull() {
        for (x = [r, width-r]) {
            for (y = [r, depth-r]) {
                translate([x, y, 0]) circle(r, $fn=50);
            }
        }
    }
}

*MyShape(width=10);





















// PART 3 - Making a box with a lid
// ================================

// Box and lid variables
w = 5;      // Width
d = 8;      // Depth
h = 5;      // Height
wall = 0.5; // Wall thickness

module BoxAndLid() {
    // Box
    difference() {
        MyShape(width=w, depth=d, height=h);
        translate([wall, wall, wall]) MyShape(width=w-wall*2, depth=d-wall* 2, height=h);
    }

    // Lid
    *translate([0,0,h]) rotate([-Angle(-180),0,0]) union() {
        MyShape(width=w, depth=d, height=wall);
        translate([wall,wall,-wall]) MyShape(width=w-wall*2, depth=d-wall* 2, height=wall);
    }
}


*BoxAndLid();




























// PART 4 - Custom function and animation
// ======================================

// Angle() returns 0 to x pausing at 0 and x during animation.
// $t varies from 0 to 1 during animation, and we return 0 for the first
// 0.25 of the animation loop, then stepping up to x during the next 0.25 of
// the loop, then stopping for the third quarter of the loop before stepping
// back to 0 at the end of the loop, ready to repeat
function Angle(x = 90)
    = $t <= 0.25? 0
    : $t <= 0.5 ? ($t-0.25)*x*4
    : $t <= 0.75 ? x
    : (1-$t)*x*4;

// Bonus Projection
// =================
*projection(cut=true) translate([0,0,-h/2]) rotate([90,0,0]) BoxAndLid();

