import processing.opengl.*;

/**
 * ColorTheme demo showing the following:
 * - construction of TColor themes via textual descriptions of shades and Colors
 * - adding an random element to the theme
 * - showing off different sort modes for the created ColorList
 *
 * Press SPACE to toggle rendering mode, any other key will re-generate a random variation of the TColor theme
 *
 * @author Karsten Schmidt <info at postspectacular dot com>
 */

import java.util.Iterator;

import toxi.color.*;
import toxi.geom.*;
import toxi.math.*;
import toxi.util.datatypes.*;

float   SWATCH_HEIGHT = 40;
float   SWATCH_WIDTH = 5;
int     SWATCH_GAP = 1;

float   MAX_SIZE = 150;
int     NUM_DISCS = 300;

boolean showDiscs=true;

void setup() {
  size(1024, 768);
  noiseDetail(2);
  smooth();
  noLoop();
}

void draw() {
  // first define our new theme
  ColorTheme t = new ColorTheme("test");

  // add different TColor options, each with their own weight
  t.addRange("soft ivory", 0.5);
  t.addRange("intense goldenrod", 0.25);
  t.addRange("warm saddlebrown", 0.15);
  t.addRange("fresh teal", 0.05);
  t.addRange("bright yellowgreen", 0.05);

  // now add another random hue which is using only bright shades
  t.addRange(ColorRange.BRIGHT, TColor.newRandom(), random(0.02, 0.05));

  // use the TColor theme to create a list of 160 Colors
  ColorList list = t.getColors(160);

  if (showDiscs) {
    background(list.getLightest().toARGB());
    discs(list);
  } 
  else {
    background(0);
    int yoff=32;
    list.sortByDistance(false);
    swatches(list, 32, yoff);
    yoff+=SWATCH_HEIGHT+10;

    list.sortByCriteria(AccessCriteria.LUMINANCE,false);
    swatches(list, 32, yoff);
    yoff+=SWATCH_HEIGHT+10;

    list.sortByCriteria(AccessCriteria.BRIGHTNESS,false);
    swatches(list, 32, yoff);
    yoff+=SWATCH_HEIGHT+10;

    list.sortByCriteria(AccessCriteria.SATURATION,false);
    swatches(list, 32, yoff);
    yoff+=SWATCH_HEIGHT+10;

    list.sortByCriteria(AccessCriteria.HUE,false);
    swatches(list, 32, yoff);
    yoff+=SWATCH_HEIGHT+10;

    list.sortByProximityTo(NamedColor.WHITE,new RGBDistanceProxy(),false);
    swatches(list, 32, yoff);
    yoff+=SWATCH_HEIGHT+10;
  }
  //saveFrame("theme-"+(System.currentTimeMillis()/1000)+".png");
}

void keyPressed() {
  if (key==' ') showDiscs=!showDiscs;
  redraw();
}

void swatches(ColorList sorted, int x, int y) {
  noStroke();
  for (Iterator i = sorted.iterator(); i.hasNext();) {
    TColor c = (TColor) i.next();
    fill(c.toARGB());
    rect(x, y, SWATCH_WIDTH, SWATCH_HEIGHT);
    x += SWATCH_WIDTH + SWATCH_GAP;
  }
}

void discs(ColorList list) {
  float numCols = list.size();
  for (int i = 0; i < NUM_DISCS; i++) {
    TColor c = list.get((int) random(numCols)).copy();
    c.alpha = random(0.5, 1);
    fill(c.toARGB());
    c = list.get((int) random(numCols));
    //stroke(c.toARGB());
    //strokeWeight(random(10));
    noStroke();
    float r = random(MAX_SIZE);
    ellipse(random(width), random(height), r, r);
  }
}

