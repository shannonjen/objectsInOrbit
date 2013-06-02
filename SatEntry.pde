/*

*/
class SatEntry { 

  int launchYear;
  int catNum;
  int launchNum;
  String source;

  float asc;//orbital path angles
  float inc;
  
  float y; //satellite location and orbit radius
  float ty; //translated location and orbit radius
  
  float rX;//rotate x axis

  float ox; //origin
  float oy;
  //float oz;

  float tox;//translated origin
  float toy;
  //float toz;

  float cr=255;//white sats and orbital paths
  float cb=255;
  float cg=255;
  float ca = 22;//orbit alpha 40
  float caS =255;//satellite alpha 255
  
  float tcr=255;//white sats and orbital paths
  float tcb=255;
  float tcg=255;
  float tca = 22;//orbit alpha 40
  float tcaS =255;//satellite alpha 255
  
  
  float tSpeed=.000001;//transition speed
float fSpeed =.00001;
  float randomZ;//used to distribute satelites along rotational path

  float theta = 0;//rotation around origin
 
  SatEntry() { // constructor
  }

  void update() {
    y += (ty - y) * tSpeed; // speed of orbit radius change

    ox += (tox - ox) *tSpeed;//speed of translation to new origin
    oy += (toy -oy)*tSpeed;
    
    cr = cr+(tcr-cr)*fSpeed;
    cg = cg+(tcg-cg)*fSpeed;
     cb = cb+(tcb-cb)*fSpeed;
      ca = ca+(tca-ca)*fSpeed;
      caS = caS+(tcaS-ca)*fSpeed;
  }

  void render() {
    pushMatrix();
    translate(ox, oy);//center is now origin
    noFill();
    stroke(cr, cg, cb, ca);//ca
    rotateX(rX);//orbits lay in zplane
    rotateY(radians(inc));//incliniation
    rotateX(radians(asc));//node of ascention
    rotateZ(randomZ);//distribute satellites on path
    rotateZ(theta);//rotate around the y axis 
    ellipse(0, 0, 2*y, 2*y);//orbital paths
    fill(cr, cg, cb, caS);//ca=150
    ellipse(0, y, 4, 4);//sats 5
    popMatrix();
    theta = theta+0.001;
  }
}

