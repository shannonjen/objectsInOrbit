/* OBJECTS IN ORBIT by Jennifer Shannon
 Objects represented by small ellipses orbiting around elliptical paths.
 Keyboard commands:
 'd': sphere/s is/are separated into 6 spheres, each representing a decade.
 'y': sphere/s is/are separated by year.
 'c': objects and orbital paths are distinguished by country 
 source: 
 USSR: magenta
 US: teal
 China: orange
 France: redish-pink
 India: yellow
 Japan: blue
 Other: grey
 'w': returns all objects to white.
 'o': removes all but the 975 operating satellites.
 'u': sorts operating satellites into 4 user classes: military, government, civil, and commercial.
 'r': resets all objects to center
 */
int restCount=0;
int cisCount=0;
int usCount=0;
int prcCount=0;
int frCount=0;
int indCount=0;
int jpnCount=0;

PFont f;
PFont g;
PFont h;
PFont e;
PFont d;
PFont c;

import processing.video.*; 
import toxi.math.conversion.*;
import toxi.geom.*;

import processing.opengl.*;
MovieMaker mm;

ArrayList<SatEntry> satList = new ArrayList();

float theta;//degree of rotation around orgin

void setup() {
  try {//workaround for moviemaker bug
    quicktime.QTSession.open();
  } 
  catch (quicktime.QTException qte) { 
    qte.printStackTrace();
  }
  size(840, 700, OPENGL);
  //movie captures 30 fps
  mm = new MovieMaker(this, width, height, "drawing2.mov", 
  30, MovieMaker.H264, MovieMaker.BEST);
  background(0);
  smooth();
  loadSats();
  frameRate(5);//sketch is drawm at 5 fps
  f=loadFont("Helvetica-10.vlw");
  g=loadFont("Helvetica-16.vlw");
  h=loadFont("Helvetica-24.vlw");
  e=loadFont("Helvetica-20.vlw");
  d=loadFont("Helvetica-8.vlw");
  c=loadFont("Helvetica-12.vlw");
}

void draw() {
  background(15);
  smooth();
  for (SatEntry sa:satList) {
    sa.update();
    sa.render();
  }
  stroke(255);//line color
  // noFill();
  textAlign(RIGHT);
  fill(240);//text white
  textFont(h);

  text("Objects", 100, 60, 0);
  fill(220);
  text("In Orbit", 100, 84, 0);
  fill(220);
  textFont(c);
  // textAlign(LEFT);
  //text("13,880",110,72,0);
  //text("In Orbit", 200, 88, 0);
  // textFont(c);//g
  textAlign(LEFT);
  // text("37,981 Objects",110,98,0);

  line(105, 48, 105, 98);
  String strFC = Integer.toString(frameCount);
  //text(strFC, 500, 40);

  // println(frameCount);
  if (frameCount<200) {
    stroke(220);
    // noFill();
    //textAlign(RIGHT);
    fill(220);
    textFont(c);//g
    //text("All Objects", 200, 84, 0);
    fill(220);
    textFont(c);//g
    textAlign(LEFT);
    //text("34,500",110,96,0);
    text("All Countries", 110, 85, 0);
    text("37,981 Objects", 110, 98, 0);
    if (frameCount<145) {//fade out 1957-2011 text
      fill(220);
    }
    else {
      fill((199-frameCount)*4);
    }
    text("1957-2011", 110, 72, 0);
    textFont(f);
    String intro = "Since the USSR launched Sputnick in 1957, there have been 37,981 manmade objects tracked in orbit.";
    text(intro, 660, 620, 140, 250);
  }
  else if (frameCount<650) {
    textAlign(RIGHT);
    fill(220);
    //noFill();
    //textFont(g);
    //text("All Objects", 200, 84, 0);
    textFont(c);
    textAlign(LEFT);
    text("All Countries", 110, 85, 0);
    text("37,981 Objects", 110, 98, 0);
    if (frameCount<255) {//fade in launch decade text
      fill((-200+frameCount)*4);
    }
    else if (frameCount<595) {
      fill(220);
    }
    else {
      fill((650-frameCount)*4);//fade out launch decade
    }
    text("By Launch Decade", 110, 72, 0);

    if (frameCount>400) {

      textFont(f);
      textAlign(CENTER);

      text("1957-1965", width/4-10, 363, 0);
      text("1966-1974", 2*width/4, 363, 0);
      text("1975-1983", 3*width/4+10, 363, 0);
      text("1984-1992", width/4-10, 610, 0);
      text("1993-2001", 2*width/4, 610, 0);
      text("2002-2011", 3*width/4+10, 610, 0);
    }
  }
  else if (frameCount< 1150) {
    textAlign(RIGHT);
    fill(220);
    //textFont(g);
    //text("All Objects", 200, 84, 0);
    textFont(c);
    textAlign(LEFT);
    text("37,981 Objects", 110, 98, 0);
    text("All Countries", 110, 85, 0);
    if (frameCount<705) {//fade in launch year text
      fill((-650+frameCount)*4);
    }
    else if (frameCount<1095) {
      fill(220);
    }
    else {
      fill((1150-frameCount)*4);//fade out launch year
    }


    text("By Launch Year", 110, 72, 0);

    if (frameCount>900) {

      textFont(f);
      textAlign(CENTER);

      for (int i = 0; i<8; i++) {
        int lyear = 1957+i;
        String ss = Integer.toString(lyear);
        text(ss, 50+(1+i)*width/10, 122+height/9, 0);
      }
      for (int i = 0; i<8; i++) {
        int lyear = 1965+i;
        String ss = Integer.toString(lyear);
        text(ss, 50+(1+i)*width/10, 122+2*height/9, 0);
      }
      for (int i = 0; i<8; i++) {
        int lyear = 1973+i;
        String ss = Integer.toString(lyear);
        text(ss, 50+(1+i)*width/10, 122+3*height/9, 0);
      }
      for (int i = 0; i<8; i++) {
        int lyear = 1981+i;
        String ss = Integer.toString(lyear);
        text(ss, 50+(1+i)*width/10, 122+4*height/9, 0);
      }
      for (int i = 0; i<8; i++) {
        int lyear = 1989+i;
        String ss = Integer.toString(lyear);
        text(ss, 50+(1+i)*width/10, 122+5*height/9, 0);
      }
      for (int i = 0; i<8; i++) {
        int lyear = 1997+i;
        String ss = Integer.toString(lyear);
        text(ss, 50+(1+i)*width/10, 122+6*height/9, 0);
      }
      for (int i = 0; i<7; i++) {
        int lyear = 2005+i;
        String ss = Integer.toString(lyear);
        text(ss, 50+(1+i)*width/10, 122+7*height/9, 0);
      }
      /*text("1958", 50+2*width/10 , 120+height/9);
       text("1959", 50+3*width/10 , 120+height/9);
       text("1960", 50+4*width/10 , 120+height/9);
       text("1961", 50+5*width/10 , 120+height/9);
       text("1962",50+6*width/10 , 120+height/9);
       */
    }
  }
  else if (frameCount< 1450) {
    textAlign(RIGHT);
    stroke(220);
    fill(220);
    textFont(c);//g
    textAlign(LEFT);
    text("37,981 Objects", 110, 98, 0);
    // textFont(g);
    //text("All Objects", 200, 84, 0);
    textFont(c);
    textAlign(LEFT); 


    if (frameCount<1205) {//fade in 1957-2011 text
      fill((-1150+frameCount)*4);
    }
    else {
      fill(220);
    }

    text("1957-2011", 110, 72, 0);
    textFont(f);
    String countries = "Launches made by the US, USSR, China, Japan, and India account for over 97% of all man-made objects in orbit.";
    text(countries, 660, 620, 140, 250);


    if (frameCount>1395) {//fade out all countries text
      fill((1450-frameCount)*4);
    }
    else {
      fill(220);
    }
    textFont(c);
    text("All Countries", 110, 85, 0);
  }
  else if (frameCount<3100) {//country colors frameCount 1450-3100
    // textAlign(RIGHT);
    stroke(220);
    noFill();
    textFont(c);//g
    textAlign(LEFT);
    text("37,981 Objects", 110, 98, 0);
    //textFont(h);
    //text("Objects In Orbit", width/2, 65, 0);
    //textFont(g);
    //text("All Objects", 200, 84, 0);
    textFont(c);
    textAlign(LEFT);
    int alphaFade=0;
    if (frameCount<1505) {//fade in countries
      alphaFade = ((-1450+frameCount)*2);

      //fill((-1450+frameCount)*4);

      fill(84, 36, 55, alphaFade*2);
      text("USSR", 110, 85, 0);
      fill(83, 119, 122, alphaFade);
      text("US", 147, 85, 0);
      fill(217, 91, 67, alphaFade);
      text("China", 167, 85, 0);
      fill(192, 41, 66, alphaFade);
      text("France", 203, 85, 0);
      fill(236, 208, 120, alphaFade);
      text("India", 244, 85, 0);
      fill(0, 20, 220, alphaFade);
      text("Japan", 274, 85, 0);
      fill(54, 54, 54, alphaFade*2);
      text("Other", 311, 85, 0);
    }
    else if (frameCount<3045) {
      fill(84, 36, 55, 216);
      text("USSR", 110, 85, 0);
      fill(83, 119, 122, 108);
      text("US", 147, 85, 0);
      fill(217, 91, 67, 108);
      text("China", 167, 85, 0);
      fill(192, 41, 66, 108);
      text("France", 203, 85, 0);
      fill(236, 208, 120, 108);
      text("India", 244, 85, 0);
      fill(0, 20, 220, 108);
      text("Japan", 274, 85, 0);
      fill(54, 54, 54, 216);
      text("Other", 311, 85, 0);
    }
    else {
      alphaFade = ((3100-frameCount)*2);//fade out countries
      fill(84, 36, 55, alphaFade*2);
      text("USSR", 110, 85, 0);
      fill(83, 119, 122, alphaFade);
      text("US", 147, 85, 0);
      fill(217, 91, 67, alphaFade);
      text("China", 167, 85, 0);
      fill(192, 41, 66, alphaFade);
      text("France", 203, 85, 0);
      fill(236, 208, 120, alphaFade);
      text("India", 244, 85, 0);
      fill(0, 20, 220, alphaFade);
      text("Japan", 274, 85, 0);
      fill(54, 54, 54, alphaFade*2);
      text("Other", 311, 85, 0);
    }

    // text("By Decade Launched", 210, 84,0);
    /*text("Countries:",110,84,0);
     if(frameCount>1505&&frameCount<3045){//country color key
     fill(84, 36, 55, 220);
     text("USSR", 210, 84, 0);
     fill(83, 119, 122, 150);
     text("US", 258, 84, 0);
     fill(217, 91, 67, 150);
     text("China", 284, 84, 0);
     fill(192, 41, 66, 150);
     text("France", 330, 84, 0);
     fill(236, 208, 120, 150);
     text("India", 385, 84, 0);
     fill(0, 20, 220, 150);
     text("Japan", 424, 84, 0);
     fill(54, 54, 54, 220);
     text("Other", 471, 84, 0);
     }*/
    fill(220);
    if (frameCount<1650) {//fade out 1957-2011
      textFont(c);
      textAlign(LEFT);
      if (frameCount>1595) {
        fill((1650-frameCount)*4);
      }
      else {
        fill(220);
      }
      text("1957-2011", 110, 72, 0);
      textFont(f);
      String countries = "Launches made by the US, USSR, China, Japan, and India account for over 97% of all man-made objects in orbit.";
      text(countries, 660, 620, 140, 250);
    }
    else if (frameCount<2000) {
      textFont(c);
      textAlign(LEFT);
      // fill(220);

      if (frameCount<1705) {//fade in launch decade text
        fill((-1650+frameCount)*4);
      }
      else if (frameCount<1945) {
        fill(220);
      }
      else {
        fill((2000-frameCount)*4);//fade out launch decade
      }
      text("By Launch Decade", 110, 72, 0);



      if (frameCount>1850) {

        textFont(f);
        fill(220);
        textAlign(CENTER);
        text("1957-1965", width/4-10, 363, 0);
        text("1966-1974", 2*width/4, 363, 0);
        text("1975-1983", 3*width/4+10, 363, 0);
        text("1984-1992", width/4-10, 610, 0);
        text("1993-2001", 2*width/4, 610, 0);
        text("2002-2011", 3*width/4+10, 610, 0);
      }
    }
    else if (frameCount<2700) {
      textFont(c);
      textAlign(LEFT);
      fill(220);

      if (frameCount<2055) {//fade in launch year text
        fill((-2000+frameCount)*4);
      }
      else if (frameCount<2645) {
        fill(220);
      }
      else {
        fill((2700-frameCount)*4);//fade out launch year
      }


      text("By Launch Year", 110, 72, 0);
      if (frameCount>2300) {
        fill(220);
        textFont(f);
        textAlign(CENTER);
        for (int i = 0; i<8; i++) {
          int lyear = 1957+i;
          String ss = Integer.toString(lyear);
          text(ss, 50+(1+i)*width/10, 122+height/9, 0);
        }
        for (int i = 0; i<8; i++) {
          int lyear = 1965+i;
          String ss = Integer.toString(lyear);
          text(ss, 50+(1+i)*width/10, 122+2*height/9, 0);
        }
        for (int i = 0; i<8; i++) {
          int lyear = 1973+i;
          String ss = Integer.toString(lyear);
          text(ss, 50+(1+i)*width/10, 122+3*height/9, 0);
        }
        for (int i = 0; i<8; i++) {
          int lyear = 1981+i;
          String ss = Integer.toString(lyear);
          text(ss, 50+(1+i)*width/10, 122+4*height/9, 0);
        }
        for (int i = 0; i<8; i++) {
          int lyear = 1989+i;
          String ss = Integer.toString(lyear);
          text(ss, 50+(1+i)*width/10, 122+5*height/9, 0);
        }
        for (int i = 0; i<8; i++) {
          int lyear = 1997+i;
          String ss = Integer.toString(lyear);
          text(ss, 50+(1+i)*width/10, 122+6*height/9, 0);
        }
        for (int i = 0; i<7; i++) {
          int lyear = 2005+i;
          String ss = Integer.toString(lyear);
          text(ss, 50+(1+i)*width/10, 122+7*height/9, 0);
        }
      }
    }
    else if (frameCount<3100) {
      textFont(c);
      textAlign(LEFT);
      if (frameCount<2755) {//fade in 1957-2011
        fill((-2700+frameCount)*4);
      }
      else {
        fill(220);
      }
      text("1957-2011", 110, 72, 0);
    }
  }
  else if (frameCount<3300) {
    stroke(255);
    // noFill();
    //textAlign(RIGHT);
    fill(220);
    //textFont(g);
    //text("All Objects", 200, 84, 0);
    //fill(220);
    textFont(c);
    textAlign(LEFT);
    if(frameCount<3155){//fade in all countries
    fill((-3100 +frameCount)*4);
    }
    else {
      fill(220);
    }
    text("All Countries", 110, 85, 0);
      
      
      
    if(frameCount<3201){  
    if(frameCount<3145){//fade out 1957-2011 and object count
        fill(220);
      }
      else {
        fill((3200-frameCount)*4);//fade out launch year
      }
     text("1957-2011", 110, 72, 0);
      text("37,981 Objects", 110, 98, 0);
    }
 if(frameCount>3200){

    if (frameCount<3255) {//fade in current date and object count
      fill((-3200 +frameCount)*4);
    }
    else {
      fill(220);
    }
    //text("All Countries", 110, 85, 0);
    text("14,530 Objects", 110, 98, 0);
    text("Today", 110, 72, 0);
    textFont(f);
    String countries = "Of the 37,981 man-made objects tracked in orbit, over 61% have decayed or left Earth's orbit. Currently, there are 14,530 man-made objects orbiting Earth.";
    text(countries, 640, 600, 140, 250);
 }
  }
  /*else if(frameCount<3400){
   stroke(255);
   // noFill();
   //textAlign(RIGHT);
   fill(220);
   textFont(g);
   text("All Objects", 200, 84, 0);
   fill(220);
   textFont(g);
   textAlign(LEFT);
   text("1957-2011", 210, 84, 0);
   text("All Sources", 210, 101, 0);
   }*/
  else if (frameCount<3500) {
    stroke(255);
    // noFill();
    //textAlign(RIGHT);
    fill(220);
    //textFont(g);
    //text("All Operating Satellites", 200, 100, 0);
    fill(220);
    textFont(c);
    textAlign(LEFT);
    text("Today", 110, 72, 0);
    text("All Countries", 110, 85, 0);
    if(frameCount>3445){//fade out object count and text
        
         fill((3500-frameCount)*4);
      }
      else {
       fill(220);
      }
      
      
     textFont(c);
     text("14,530 Objects", 110, 98, 0);
    textFont(f);
    String countries = "Of the 37,981 man-made objects tracked in orbit, over 61% have decayed or left Earth's orbit. Currently, there are 14,530 man-made objects orbiting Earth.";
    text(countries, 640, 600, 140, 250);
  
    
  }
  else if (frameCount<3700) {
    stroke(255);
    // noFill();
    //textAlign(RIGHT);
    fill(220);
    textFont(g);
    //text("All Operating Satellites", 200, 100, 0);
    fill(220);
    textFont(c);
    textAlign(LEFT);
    text("Today", 110, 72, 0);
    
    
    
    
    

    if (frameCount<3555) {//fade in sat count and text
      fill((-3500 +frameCount)*4);
    }
   
    else if (frameCount<3645){
      fill(220);
    }
    else {
      fill((3700-frameCount)*4);//fade out 
    }
    //text("All Countries", 110, 85, 0);
    
   
    textFont(f);
    String countries = "Of the 14,530 man-made objects currently in orbit, under 6% are operating satellites. Currently, there are 975 operating satellites orbiting Earth.";
    text(countries, 640, 600, 140, 250);
     
     if (frameCount<3555) {//fade in sat count
      fill((-3500 +frameCount)*4);
    }
   
    else{
      fill(220);
    }
    
    textFont(c);
      text("975 Operating Satellites", 110, 98, 0);
      
      if (frameCount<3645){//fade our all countries
      fill(220);
    }
    else {
      fill((3700-frameCount)*4);//fade out 
    }
      text("All Countries", 110, 85, 0);
      
 }


    // text("All Sources", 210, 101, 0);
    
    
    
    else if (frameCount<3900) {
    stroke(255);
    // noFill();
    //textAlign(RIGHT);
    fill(220);
    textFont(g);
    //text("All Operating Satellites", 200, 100, 0);
    fill(220);
    textFont(c);
    textAlign(LEFT);
    text("Today", 110, 72, 0);
    text("975 Operating Satellites", 110, 98, 0);
    
    
   // text("All Countries", 110, 85, 0);
    
    
    

    if (frameCount<3755) {//fade in countries and text
      fill((-3700 +frameCount)*4);
    }
    else {
      fill(220);
    }
     textFont(f);
    String countries = "The US, USSR, and China own and operate 97% of all operating satellites currently orbiting earth.";
    text(countries, 640, 600, 140, 250);
     int alphaFade=108;
     textFont(c);
    // text("All Sources", 210, 101, 0);
    fill(84, 36, 55, alphaFade*2);
    text("USSR", 110, 85, 0);
    fill(83, 119, 122, alphaFade);
    text("US", 147, 85, 0);
    fill(217, 91, 67, alphaFade);
    text("China", 167, 85, 0);

    fill(54, 54, 54, alphaFade*2);
    text("Other", 203, 85, 0);
    //text("All Countries", 110, 85, 0);

   
   
 }


    // text("All Sources", 210, 101, 0);
    
  

  else {
    stroke(255);
    // noFill();
    //textAlign(RIGHT);
    fill(220);
    textFont(g);
    //text("All Operating Satellites", 200, 100, 0);
    fill(220);
    textFont(c);
    textAlign(LEFT);
    text("Today", 110, 72, 0);
    text("975 Operating Satellites", 110, 98, 0);

    int alphaFade=108;
    // text("All Sources", 210, 101, 0);
    fill(84, 36, 55, alphaFade*2);
    text("USSR", 110, 85, 0);
    fill(83, 119, 122, alphaFade);
    text("US", 147, 85, 0);
    fill(217, 91, 67, alphaFade);
    text("China", 167, 85, 0);

    fill(54, 54, 54, alphaFade*2);
    text("Other", 203, 85, 0);
    fill(220);
    textFont(c);
    if (frameCount>4100) {
      textAlign(CENTER);
      text("Military", 20+width/3, 362);
      //line(20+width/3,358,width/3-80,358); 
      text("Civil", 2*width/3-20, 362);
      text("Government", 20+width/3, 610);
      text("Commercial", 2*width/3-20, 610);
      //if(frameCount
    }
  }








  if (frameCount == 200) {
    sortByDecade();
  }
  if (frameCount== 650) {
    sortByYear();
  }
  if (frameCount== 1150) {
    reset();
  }
  if (frameCount==1450) {
    colorCountry();
  }
  if (frameCount== 1650) {
    sortByDecade();
  }
  if (frameCount==2000) {
    sortByYear();
  }
  if (frameCount== 2700) {
    reset();
  }
  if (frameCount==3100) {
    white();
  }
  if (frameCount==3300) {//3200
    currentOrbit();
  }
  if (frameCount==3500) {
    opSat();
  }
  if (frameCount==3700) {
    opSatCountry();
  }
  if (frameCount==3900) {
    sortByUsers();
  }
  if (frameCount==4300) {
    mm.finish();
  }

  mm.addFrame();
}

void loadSats() {
  String[]lined = loadStrings("DecadeYrSourceGoodStuff.tsv");//an array with 14531 entries 
  //println(lined.length);
  for (int i=1;i<lined.length;i=i+1) {//go through each entry
    String pieces[] = split(lined[i], TAB);//for each entry(satellite) create a new array of their values
    SatEntry sa = new SatEntry();//new arraylist
    //sa.catNum = int(pieces[0]);
    sa.launchYear = int(pieces[1]);
    //sa.launchNum = int(pieces[2]);
    sa.source = (pieces[3]);
    sa.inc = float(pieces[4]);//degrees inc
    sa.asc = random(0, 360);//degrees asc
    //sa.x = 0;//
    sa.y = 260;//
    sa.rX = PI/2;
    //sa.ty=100;
    sa.tSpeed = .02;//translation speed
    sa.fSpeed = .05;//color fade speed
    sa.ty = 260;//initial orbit radius and sattelite location
    sa.randomZ = radians(random(0, 360));//used to distribute sats on path
    sa.theta = 0;//rotational speed

    sa.ox =(width)/2;//initial origin
    sa.oy=20+height/2;//30+
    //sa.oz=0;

    sa.tox = (width)/2;//origin set at 0,0 center for big clump
    sa.toy = 20+height/2;//orgin 30+
    //sa.toz=0;
    satList.add(sa);
  }
  println(satList.size());
}

void colorCountry() {
  for (int i = 0; i < satList.size(); i=i+1) {
    SatEntry s= satList.get(i);
    //int cisCount =0;
    int a = 108;//150

    //int restCount;

    // println(s.source);
    if (s.source.equals("CIS")) {//USSR puple
      s.tcr=84;
      s.tcg=36;
      s.tcb=55;
      s.tcaS = a;

      cisCount=cisCount+1;
      println("USSR: "+cisCount);
      //  println(s.source);
    }
    else if (s.source.equals("US")) {//US teal
      s.tcr=83;
      s.tcg=119;
      s.tcb=122;
      s.tcaS = a;
      usCount=usCount+1;
      println("US: "+usCount);
    }
    else if (s.source.equals("PRC")) {//china orange
      s.tcr=217;
      s.tcg=91;
      s.tcb=67;
      s.tcaS = a;
      prcCount=prcCount+1;
      println("PRC: "+prcCount);
    }
    else if (s.source.equals("FR")) {//red
      s.tcr=192;
      s.tcg=41;
      s.tcb=66;
      s.tcaS = a;
      frCount=frCount+1;
      println("France: "+frCount);
    }
    else if (s.source.equals("IND")) {//yellow
      s.tcr=236;
      s.tcg=208;
      s.tcb=120;
      s.tcaS = a;
      indCount=jpnCount+1;
      println("India: "+indCount);
    }
    else if (s.source.equals("JPN")) {//blue
      s.tcr=0;
      s.tcg=20;
      s.tcb=220;
      s.tcaS = a;
      jpnCount=jpnCount+1;
      println("Japan: "+jpnCount);
    }
    else {//grey
      s.tcr=54;
      s.tcg=54;
      s.tcb=54;
      s.tcaS = a;
      restCount=restCount+1;
      println(restCount);
    }
  }
}
void sortByYear() {
  for (int i = 0; i < satList.size(); i++) {
    println(satList.size());
    SatEntry s= satList.get(i);
    int r = 28;
    int b= 50; //to the right
    int d = 70;//shift down
    for (int j = 0; j<9; j++) {
      if (s.launchYear ==(1957+j)) { //  1961
        s.tox = b+(j+1)*(width)/(10);
        s.toy = 80+height/9;
        s.ty = r;
      }
      for (int k = 0; k<9; k++) {
        if (s.launchYear ==(1965+k)) { //  1961
          s.tox = b+(k+1)*(width)/(10);
          s.toy = 80+2*height/9;
          s.ty = r;
        }
      } 
      for (int l = 0; l<9; l++) {
        if (s.launchYear ==(1973+l)) { //  1961
          s.tox = b+(l+1)*(width)/(10);
          s.toy = 80+3*height/9;
          s.ty = r;
        }
      } 
      for (int m = 0; m<9; m++) {
        if (s.launchYear ==(1981+m)) { //  1961
          s.tox = b+(m+1)*(width)/(10);
          s.toy = 80+4*height/9;
          s.ty = r;
        }
      } 
      for (int n = 0; n<9; n++) {
        if (s.launchYear ==(1989+n)) { //  1961
          s.tox = b+(n+1)*(width)/(10);
          s.toy = 80+5*height/9;
          s.ty = r;
        }
      } 
      for (int o = 0; o<9; o++) {
        if (s.launchYear ==(1997+o)) { //  1961
          s.tox = b+(o+1)*(width)/(10);
          s.toy = 80+6*height/9;
          s.ty = r;
        }
      }
      for (int p = 0; p<9; p++) {
        if (s.launchYear ==(2005+p)) { //  1961
          s.tox = b+(p+1)*(width)/(10);
          s.toy = 80+7*height/9;
          s.ty = r;
        }
      } 
      /* for (int q = 0; q<8; q++) {
       if (s.launchYear ==(2006+q)) { //  1961
       s.tox = b+(q+1)*(width)/(9);
       s.toy = 8*height/9;
       s.ty = r;
       }
       }*/
    }
  }
}

void reset() {
  for (int i = 0; i < satList.size(); i++) {
    SatEntry s= satList.get(i);
    s.tox=width/2;
    s.toy=20+height/2;
    s.ty= 260;
  }
}

void opSat() {
  for (int i = 0; i < satList.size(); i++) {
    SatEntry s= satList.get(i);
    if (i<976) {//976
      s.tcr=255;
      s.tcg=255;
      s.tcb=255;
      s.tca=22;
      s.tcaS=255;
      //s.tox=width/3-50;
      //s.toy=height/2;
      //s.ty=150;
    }
    else {
      s.tcr=55;
      s.tcg=55;
      s.tcb=55;
      s.tca=0;
      s.tcaS=0;
      //s.ty=300;
      //s.ty=0;
      // s.tox=2*width/3+50;
      //s.toy=height/2;
      //s.ty=150;
      //s.ca=0;
      // s.ty=0;
      //s.y=0;
      // s.tSpeed=.03;//0
      // s.fSpeed=.1;
    }
  }
}

void sortByUsers() {
  for (int i = 0; i < satList.size(); i++) {
    SatEntry s= satList.get(i);
    int r = 100;
    int a =150;
    if (i<256) {//military
      s.tox = 20+width/3;
      s.toy = 240;
      s.ty = r;
      if (i<122) {//USA
        s.tcr=83;
        s.tcg=119;
        s.tcb=122;
        s.tcaS = a;
      }
      else if (i<192) {//Russia
        s.tcr=84;
        s.tcg=36;
        s.tcb=55;
        s.tcaS = a;
      }
      else if (i<210) {//china
        s.tcr=217;
        s.tcg=91;
        s.tcb=67;
        s.tcaS = 40;
      }
      else {//other owner
        s.tcr=54;
        s.tcg=54;
        s.tcb=54;
        s.tcaS = 140;
      }
    }
    else if (i<300) {//civil
      s.tox = 2*width/3-20;
      s.toy = 240;
      s.ty=r;
      if (i<266) {//USA
        s.tcr=83;
        s.tcg=119;
        s.tcb=122;
        s.tcaS = a;
      }
      else if (i<272) {//Russia
        s.tcr=84;
        s.tcg=36;
        s.tcb=55;
        s.tcaS = a;
      }
      else if (i<277) {//china
        s.tcr=217;
        s.tcg=91;
        s.tcb=67;
        s.tcaS = 40;
      }
      else {//other owner
        s.tcr=54;
        s.tcg=54;
        s.tcb=54;
        s.tcaS = 140;
      }
    }
    else if (i<595) {//government
      s.tox = width/3+20;
      s.toy = 480;
      s.ty = r;
      if (i<412) {//USA
        s.tcr=83;
        s.tcg=119;
        s.tcb=122;
        s.tcaS = a;
      }
      else if (i<451) {//Russia
        s.tcr=84;
        s.tcg=36;
        s.tcb=55;
        s.tcaS = a;
      }
      else if (i<495) {//china
        s.tcr=217;
        s.tcg=91;
        s.tcb=67;
        s.tcaS = 40;
      }
      else {//other owner
        s.tcr=54;
        s.tcg=54;
        s.tcb=54;
        s.tcaS = 140;
      }
    } 
    else if (i<976) {
      s.tox = 2* width/3 -20;
      s.toy = 480;
      s.ty = r;
      if (i<768) {//USA
        s.tcr=83;
        s.tcg=119;
        s.tcb=122;
        s.tcaS = a;
      }
      else if (i<790) {//china
        s.tcr=217;
        s.tcg=91;
        s.tcb=67;
        s.tcaS = 40;
      }
      else {//other owner
        s.tcr=54;
        s.tcg=54;
        s.tcb=54;
        s.tcaS = 140;
      }
    }
    else {
      //s.tcr=0;
      //s.tcg=0;
      //s.tcb=0;
      s.ca=0;
      s.caS=0;
      //s.y=0;
      //s.tSpeed=.02;//0
    }
  }
}


void opSatCountry() {//differentiate operating satellites by countrycolor
  for (int i = 0; i < satList.size(); i++) {
    SatEntry s= satList.get(i);
    int r = 260;
    int a =150;
    if (i<256) {//military
      s.tox = width/2;
      s.toy = 20+height/2;
      s.ty = r;
      if (i<122) {//USA
        s.tcr=83;
        s.tcg=119;
        s.tcb=122;
        s.tcaS = a;
      }
      else if (i<192) {//Russia
        s.tcr=84;
        s.tcg=36;
        s.tcb=55;
        s.tcaS = a;
      }
      else if (i<210) {//china
        s.tcr=217;
        s.tcg=91;
        s.tcb=67;
        s.tca = 40;
      }
      else {//other owner
        s.tcr=54;
        s.tcg=54;
        s.tcb=54;
        s.tcaS = 140;
      }
    }
    else if (i<300) {//civil
      s.tox = width/2;
      s.toy = 30+height/2;
      s.ty=r;
      if (i<266) {//USA
        s.tcr=83;
        s.tcg=119;
        s.tcb=122;
        s.tcaS = a;
      }
      else if (i<272) {//Russia
        s.tcr=84;
        s.tcg=36;
        s.tcb=55;
        s.tcaS = a;
      }
      else if (i<277) {//china
        s.tcr=217;
        s.tcg=91;
        s.tcb=67;
        s.tca = 40;
      }
      else {//other owner
        s.tcr=54;
        s.tcg=54;
        s.tcb=54;
        s.tcaS = 140;
      }
    }
    else if (i<595) {//government
      s.tox = width/2;
      s.toy = 30+height/2;
      s.ty = r;
      if (i<412) {//USA
        s.tcr=83;
        s.tcg=119;
        s.tcb=122;
        s.tcaS = a;
      }
      else if (i<451) {//Russia
        s.tcr=84;
        s.tcg=36;
        s.tcb=55;
        s.tcaS = a;
      }
      else if (i<495) {//china
        s.tcr=217;
        s.tcg=91;
        s.tcb=67;
        s.tcaS = 40;
      }
      else {//other owner
        s.tcr=54;
        s.tcg=54;
        s.tcb=54;
        s.tcaS = 140;
      }
    } 
    else if (i<976) {
      s.tox = width/2;
      s.toy = 30+height/2;
      s.ty = r;
      if (i<768) {//USA
        s.tcr=83;
        s.tcg=119;
        s.tcb=122;
        s.tcaS = a;
      }
      else if (i<790) {//china
        s.tcr=217;
        s.tcg=91;
        s.tcb=67;
        s.tcaS = 40;
      }
      else {//other owner
        s.tcr=54;
        s.tcg=54;
        s.tcb=54;
        s.tcaS = 140;
      }
    }
    else {
      s.tcr=0;
      s.tcg=0;
      s.tcb=0;
      // s.ca=255;
      s.y=0;
      s.ty=0;
      s.tSpeed=0;//0
      //s.tSpeed=.03;//0
      s.fSpeed=0;
      //s.tSpeed=.02;//0
    }
  }
}




void white() {//sets all sats and orbits
  for (int i = 0; i < satList.size(); i++) {
    SatEntry s= satList.get(i);
    s.tcr=255;
    s.tcg=255;
    s.tcb=255;
    s.tca=20;
    s.tcaS=255;
  }
}


void sortByDecade() {
  for (int i = 0; i < satList.size(); i++) {
    SatEntry s= satList.get(i);
    int r = 100;//radius ofdecade orbit 

    if (s.launchYear <1966) { //  1961
      s.tox = (width)/4-10;
      s.toy = 240;
      // s.toz=0;
      s.ty = r;
    }
    else if (s.launchYear<1975) { //  1961
      s.tox = 2*(width)/4;
      s.toy = 240;
      s.ty = r;
    }
    else if (s.launchYear<1984) {
      s.tox =  3*(width)/4+10;
      s.toy = 240;
      s.ty = r;
    }
    else if (s.launchYear<1993) {
      s.tox =  1*width/4-10;
      s.toy = 480;
      s.ty = r;
    }
    else if (s.launchYear<2002) {
      s.tox =  2*width/4;
      s.toy = 480;
      s.ty= r;
    }
    else {
      s.tox =  3*width/4+10;
      s.toy = 480;
      s.ty = r;
    }
  }
}
void currentOrbit() {//for use with full data set of al tracked objects
  for (int i = 0; i < satList.size(); i++) {
    SatEntry s= satList.get(i);
    if (i<14000) {
      s.cr=255;
      s.cg=255;
      s.cb=255;
      s.ca=20;
      s.caS=255;
    }
    else {
      s.cr=255;
      s.cg=255;
      s.cb=255;
      s.ca=0;
      s.tca=0;
      s.tcaS=255;
      s.ty=2000;
      s.fSpeed=0;
    }
  }
}

void keyPressed() {
  if (key == 'c') {
    colorCountry();
  }
  if (key == 'd') {
    sortByDecade();
  }
  if (key == 'y') {
    sortByYear();
  }
  if (key == 'r') {//reset
    reset();
  }
  if (key=='w') {//all sats and orbits
    white();
  }
  if (key=='n') {//shows currently orbiting satellites
    currentOrbit();
  }
  if (key=='o') {//removes non-operating satellites
    opSat();
  }
  if (key=='s') {//sort operating sateliites by military, civil govmt, comm
    opSatCountry();
  }
  if (key=='u') {//sort operating sateliites by military, civil govmt, comm
    sortByUsers();
  }
  if (key == ' ') {
    mm.finish();  // Finish the movie if space bar is pressed!
  }
}

