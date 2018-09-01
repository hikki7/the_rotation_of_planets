//sliderのライブらり
import controlP5.*;
//音のライブラリ
import ddf.minim.*;
import ddf.minim.signals.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;

ControlP5 cp5;
Clock clock;

Minim minim;
AudioPlayer bgm;
AudioSample hover;


float dir;//時計の半径
float day;//日
//水星、金星、火星、木星、土星、天王星、海王星、月
int choosePlanet=0;
int[]whatPlanet={1, 0, 0, 0, 0, 0, 0, 0};

void setup() {
  fullScreen(P2D);
  //size(1024,768,P2D);
  smooth();
  background(21);
  colorMode(HSB, 360, 100, 100);
  dir=width/20;
  cp5=new ControlP5(this);

  minim = new Minim(this);
  bgm = minim.loadFile("communication_of_aliens.mp3");
  //===================hoverの時の音
  hover=minim.loadSample("a007.mp3", 2048);
  bgm.loop();
  //object指向
  clock=new Clock(dir, hover);
}


void draw() {
  //fill(21, 80);
  //noStroke();
  //rect(0, 0, width, height);

  background(21);
  //毎回countをとる
  clock.countup();

  //planetsのbasic
  clock.basicPlanets();

  //earthのbasic
  clock.basicEarth();

  //上のtextの表示
  clock.drawSpeed();

  //earthの針みたいな部分　
  clock.earthNeedle();

  //planetsの針みたいな部分
  clock.planetNeedle();

  //earthの針
  clock.drawEarth();

  //planetsの針
  clock.drawPlanet();

  //earthのgui的な部分
  clock.guiEarth();

  //planetのgui的な部分
  clock.guiplanets();

  //下のplanetを出力
  clock.selectedPlanets();

  //下のplanetsの部分を出す
  clock.borderPlanets();

  //earthのtext
  clock.textEarth();

  //planetのtext
  clock.textPlanets();

  //下の部分のplanetsのtextの部分
  clock.informPlanets();
  
  //hoverしたら音を鳴らす
  clock.playAudio();
}

void keyPressed() {

  if (key=='a'||key=='A') {
    //水星
    clock.choosePlanet=0;
    clock.count=0;
    background(21);
    hover.trigger();
  } else if (key=='s'||key=='S') {
    //金星
    clock.choosePlanet=1;
    clock.count=0;    
    background(21);
    hover.trigger();
  } else if (key=='d'||key=='D') {
    //火星
    clock.choosePlanet=2;
    clock.count=0;
    background(21);
    hover.trigger();
  } else if (key=='f'||key=='F') {
    //木星
    clock.choosePlanet=3;
    clock.count=0;
    background(21);
    hover.trigger();
  } else if (key=='g'||key=='G') {
    //土星
    clock.choosePlanet=4;
    clock.count=0;
    background(21);
    hover.trigger();
  } else if (key=='h'||key=='H') {
    //天王星
    clock.choosePlanet=5;
    clock.count=0;
    background(21);
    hover.trigger();
  } else if (key=='j'||key=='J') {
    //海王星
    clock.choosePlanet=6;
    clock.count=0;
    background(21);
    hover.trigger();
  } else if (key=='k'||key=='K') {
    //月
    clock.choosePlanet=7;
    clock.count=0;
    background(21);
    hover.trigger();
  }
}

void stop() {
  hover.close();
  minim.stop();
  super.stop();
}
