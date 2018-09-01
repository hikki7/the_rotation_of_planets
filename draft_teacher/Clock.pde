class Clock {

  //自転の時差
  float[]dDay={58.65, 243.0, 1.026, 0.408, 0.425, 0.746, 0.796, 27.32};
  //一般相対性理論の時差(100年あたりのsecondの違い)
  //float[]dDay={0.3, 1.9, 0.4, 63.6, 22.8, 8.0, 9.7, 99.0};
  //====================惑星のそれぞれの情報
  //planetsの質量
  float[]M={3.285, 48.67, 6.39, 18980, 5683, 868.1, 1024.3, 0.734581};
  //planetsの半径
  float[]R={2440, 6052, 3390, 69911, 58232, 25362, 24622, 1.737};
  //planetsの重力
  float[]G={3.7, 8.87, 3.711, 24.79, 10.44, 8.87, 11.15, 1.62};
  //planetsの公転周期
  float[]RC={88, 225, 687, 4380, 10585, 30660, 60225, 27};
  //planetsの自転周期
  float[]RP={58.6462, 116.75, 1.02595675, 0.4135344, 0.44403, 0.71833, 0.67125, 27.32166};
  //planetsの表面積
  float[]SA={0.748, 4.602, 1.448, 617.2, 427, 80.83, 76.18, 0.3793};
  //planetsの名前
  String[]planet={"Mercury", "Venus", "Mars", "Jupiter", "Saturn", "Uranus", "Neptune", "Moon"};
  //planetsの色
  float[]col=new float[8];
  color[]Col=new color[8];
  color[]backCol=new color[8];

  //==================地球の基本情報

  //地球の色
  float earthCol;
  color earthColor;
  //地球の質量
  float earthM=59.72 ;
  //地球の半径
  float earthR= 6371;
  //地球の重力
  float earthG=9.807;
  //地球の公転周期
  float earthRC=365;
  //地球の自転周期
  float earthRP=1;
  //地球の表面積
  float earthSA=5.101;

  //===============オブジェクト指向の部分
  float diam;//直径
  float day;//地球の日時
  float count;//resrt能力付きのframecount
  int choosePlanet;//何のplanetなのか

  //=================なんかみんなが使いそうなやつ
  float theta;//地球の時間の角度
  PVector centerEarth;//地球の真ん中
  PVector centerPlanets;//planetsの真ん中
  float diameter;//これは秒針みたいなイメージ
  float dayPlanets;
  PVector[]location=new PVector[8];//下のplanetの位置
  float[]dm=new float[8];//下の部分比を求める
  float[]dia=new float[8];//下の部分の直径を求める
  int dr=10;
  int fontSize=12; 
  boolean[] checklocation=new boolean[8];
  float planetTheta;
  //==================what planet;
  int planetNum;

  //=================imageをロードする
  PImage[]planetsImage=new PImage[8];
  PImage earthImage;

  //================hoverの音
  AudioSample hover;

  Clock(float _diam, AudioSample _hover) {
    diam=_diam;
    hover=_hover;
    count=0;
    //それぞれの惑星の色
    col[0]=20.8;
    col[1]=34.5;
    col[2]=19.6;
    col[3]=32.0;
    col[4]=54.1;
    col[5]=193;
    col[6]=221;
    col[7]=83.4;

    for (int i=0; i<Col.length; i++) {
      Col[i]=color(col[i], 50, 75); 
      backCol[i]=color(col[i], 50, 20);
      dia[i]=map(R[i]/R[3], 0, 1, 30, 60);
    }

    centerEarth=new PVector(width/4, height*3/5); 
    centerPlanets=new PVector(width*3/4, height*3/5);
    earthCol=226;
    earthColor=color(earthCol, 50, 75);
    diameter=width/8;

    //=============ここから下のplanetsの一覧
    for (int i=0; i<location.length; i++) {
      location[i]=new PVector(width*(i+1)/9, height*7/8);
    }

    //=============ここからは下のplanetsのdの一覧
    dm[0]=R[0]/earthR;
    dm[1]=R[1]/earthR;
    dm[2]=R[2]/earthR;
    dm[3]=R[3]/earthR;
    dm[4]=R[4]/earthR;
    dm[5]=R[5]/earthR;
    dm[6]=R[6]/earthR;
    dm[7]=R[7]/earthR;

    //=============下の円に被さってるか
    for (int i=0; i<checklocation.length; i++) {
      checklocation[i]=false;
    }

    //============ここからはimageの読み込み
    planetsImage[0]=loadImage("Mercury.png");
    planetsImage[1]=loadImage("Venus.png");
    planetsImage[2]=loadImage("Mars.png");
    planetsImage[3]=loadImage("Jupiter.png");
    planetsImage[4]=loadImage("Saturn-01.png");
    planetsImage[5]=loadImage("Uranus.png");
    planetsImage[6]=loadImage("Neptune.png");
    planetsImage[7]=loadImage("Moon.png");
    earthImage=loadImage("Earth.png");
  }

  void countup() {
    count++;
    //1秒で1日にするため
    day=count/float(60);
    theta=radians(day*float(6))-PI/2;
    dayPlanets=day*dDay[choosePlanet];
    planetTheta=radians((day*dDay[choosePlanet])*float(6))-PI/2;
  }

  //======================地球のbasicの実装
  void basicEarth() {
    imageMode(CENTER);
    tint(255, 255);
    image(earthImage, centerEarth.x, centerEarth.y, diam*2, diam*2);
  }

  //===================planetsのbasicの実装
  void basicPlanets() {
    float dm=R[choosePlanet]/earthR;
    imageMode(CENTER);
    tint(255, 255);
    image(planetsImage[choosePlanet], centerPlanets.x, centerPlanets.y, diam*2*dm, diam*2*dm);
  }
  //===================地球の時間の部分
  void drawEarth() {
    stroke(255);
    strokeWeight(4);
    for (int i=0; i<diameter*2/3; i+=4) {
      PVector locationPlanet=new PVector(centerEarth.x+i*cos(theta), centerEarth.y+i*sin(theta)); 
      point(locationPlanet.x, locationPlanet.y);
    }
  }

  //===============planetの時間の部分
  void drawPlanet() {
    stroke(255);
    strokeWeight(4);
    for (int i=0; i<diameter*2/3; i+=4) {
      PVector locationPlanet=new PVector(centerPlanets.x+i*cos(planetTheta), centerPlanets.y+i*sin(planetTheta)); 
      point(locationPlanet.x, locationPlanet.y);
    }
  }

  //==============なんかearthの目安の部分
  void earthNeedle() {
    stroke(255);
    strokeWeight(1);
    pushMatrix();
    translate(centerEarth.x, centerEarth.y);
    for (int i=0; i<12; i++) {
      PVector startPlanet=new PVector((diameter/2+20)*cos(radians(i*30)), (diameter/2+20)*sin(radians(i*30)));
      PVector endPlanet=new PVector((diameter/2+10)*cos(radians(i*30)), (diameter/2+10)*sin(radians(i*30)));
      line(startPlanet.x, startPlanet.y, endPlanet.x, endPlanet.y);
    }
    popMatrix();
  }

  //==============なんかearthの目安の部分
  void planetNeedle() {
    stroke(255);
    strokeWeight(1);
    pushMatrix();
    translate(centerPlanets.x, centerPlanets.y);
    for (int i=0; i<12; i++) {
      PVector startPlanet=new PVector((diameter/2+20)*cos(radians(i*30)), (diameter/2+20)*sin(radians(i*30)));
      PVector endPlanet=new PVector((diameter/2+10)*cos(radians(i*30)), (diameter/2+10)*sin(radians(i*30)));
      line(startPlanet.x, startPlanet.y, endPlanet.x, endPlanet.y);
    }
    popMatrix();
  }

  //=================地球のtext
  void textEarth() {
    String EarthTime=int(day)+" days";
    fill(earthCol, 50, 75);
    textAlign(CENTER);
    textSize(15);
    text("Earth", centerEarth.x, 70);
    textSize(30);
    text(EarthTime, centerEarth.x, centerEarth.y+150);
  }

  //===============planetsのtext
  void textPlanets() {
    String planetTime=int(dayPlanets)+" days";
    fill(col[choosePlanet], 50, 75);
    textAlign(CENTER);
    textSize(15);
    text(planet[choosePlanet], centerPlanets.x, 70);
    textSize(30);
    text(planetTime, centerPlanets.x, centerPlanets.y+150);
  }

  //==============地球のgui
  void guiEarth() {
    noStroke();
    Slider earthRadius;
    earthRadius=cp5.addSlider("The radius")
      .setPosition(200, 140)
      .setRange(0, R[3])
      .setValue(earthR)
      .setSize(100, 10)
      .setColorValueLabel(earthColor);

    //下の数字
    cp5.getController("The radius").getValueLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
    //上の文字も部分
    cp5.getController("The radius").getCaptionLabel().align(ControlP5.LEFT, ControlP5.TOP_OUTSIDE).setPaddingX(0);


    //=============地球の質量
    Slider earthMass;
    earthMass=cp5.addSlider("The mass")
      .setPosition(width/4+50, 140)
      .setRange(0, M[3])
      .setValue(earthM)
      .setSize(100, 10)
      .setColorValueLabel(earthColor);

    //下の数字
    cp5.getController("The mass").getValueLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
    //上の文字も部分
    cp5.getController("The mass").getCaptionLabel().align(ControlP5.LEFT, ControlP5.TOP_OUTSIDE).setPaddingX(0);


    //=============地球の重力
    Slider earthGravity;
    earthGravity=cp5.addSlider("The gravity")
      .setPosition(200, 210)
      .setRange(0, G[3])
      .setValue(earthG)
      .setSize(100, 10)
      .setColorValueLabel(earthColor);

    //下の数字
    cp5.getController("The gravity").getValueLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
    //上の文字も部分
    cp5.getController("The gravity").getCaptionLabel().align(ControlP5.LEFT, ControlP5.TOP_OUTSIDE).setPaddingX(0);

    //============地球の公転周期
    Slider earthRoC;
    earthRoC=cp5.addSlider("The revolution cycle")
      .setPosition(width/4+50, 210)
      .setRange(0, RC[6])
      .setValue(earthRC)
      .setSize(100, 10)
      .setColorValueLabel(earthColor);

    //下の数字
    cp5.getController("The revolution cycle").getValueLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
    //上の文字も部分
    cp5.getController("The revolution cycle").getCaptionLabel().align(ControlP5.LEFT, ControlP5.TOP_OUTSIDE).setPaddingX(0);


    //============地球の自転周期
    Slider earthrp;
    earthrp=cp5.addSlider("The rotation period")
      .setPosition(200, 280)
      .setRange(0, RP[1])
      .setValue(earthRP)
      .setSize(100, 10)
      .setColorValueLabel(earthColor);

    //下の数字
    cp5.getController("The rotation period").getValueLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
    //上の文字も部分
    cp5.getController("The rotation period").getCaptionLabel().align(ControlP5.LEFT, ControlP5.TOP_OUTSIDE).setPaddingX(0);

    //============地球の表面積
    Slider earthsa;
    earthsa=cp5.addSlider("The surface area")
      .setPosition(width/4+50, 280)
      .setRange(0, SA[1])
      .setValue(earthSA)
      .setSize(100, 10)
      .setColorValueLabel(earthColor);

    //下の数字
    cp5.getController("The surface area").getValueLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
    //上の文字も部分
    cp5.getController("The surface area").getCaptionLabel().align(ControlP5.LEFT, ControlP5.TOP_OUTSIDE).setPaddingX(0);
  }

  //==============planetsのgui的な部分
  void guiplanets() {
    //=============planetsの半径
    Slider planetRadius;
    planetRadius=cp5.addSlider("The radius ")
      .setPosition(width/2+200, 140)
      .setRange(0, R[3])
      .setValue(R[choosePlanet])
      .setSize(100, 10)
      .setColorForeground(Col[choosePlanet])
      .setColorBackground(backCol[choosePlanet])
      .setColorValueLabel(Col[choosePlanet]);
    //下の数字
    cp5.getController("The radius ").getValueLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
    //上の文字も部分
    cp5.getController("The radius ").getCaptionLabel().align(ControlP5.LEFT, ControlP5.TOP_OUTSIDE).setPaddingX(0);
    //=============planetsの質量
    Slider planetmass;
    planetmass=cp5.addSlider("The mass ")
      .setPosition(width*3/4+50, 140)
      .setRange(0, M[3])
      .setValue(M[choosePlanet])
      .setSize(100, 10)
      .setColorForeground(Col[choosePlanet])
      .setColorBackground(backCol[choosePlanet])
      .setColorValueLabel(Col[choosePlanet]);

    //下の数字
    cp5.getController("The mass ").getValueLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
    //上の文字も部分
    cp5.getController("The mass ").getCaptionLabel().align(ControlP5.LEFT, ControlP5.TOP_OUTSIDE).setPaddingX(0);

    //=============planetsの重力
    Slider planetgravity;
    planetgravity=cp5.addSlider("The gravity ")
      .setPosition(width/2+200, 210)
      .setRange(0, G[3])
      .setValue(G[choosePlanet])
      .setSize(100, 10)
      .setColorForeground(Col[choosePlanet])
      .setColorBackground(backCol[choosePlanet])
      .setColorValueLabel(Col[choosePlanet]);

    //下の数字
    cp5.getController("The gravity ").getValueLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
    //上の文字も部分
    cp5.getController("The gravity ").getCaptionLabel().align(ControlP5.LEFT, ControlP5.TOP_OUTSIDE).setPaddingX(0);

    //============planetsの公転周期
    Slider planetrc;
    planetrc=cp5.addSlider("The revolution cycle ")
      .setPosition(width*3/4+50, 210)
      .setRange(0, RC[6])
      .setValue(RC[choosePlanet])
      .setSize(100, 10)
      .setColorForeground(Col[choosePlanet])
      .setColorBackground(backCol[choosePlanet])
      .setColorValueLabel(Col[choosePlanet]);

    //下の数字
    cp5.getController("The revolution cycle ").getValueLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
    //上の文字も部分
    cp5.getController("The revolution cycle ").getCaptionLabel().align(ControlP5.LEFT, ControlP5.TOP_OUTSIDE).setPaddingX(0);

    //============planetsの自転周期
    Slider planetrp;
    planetrp=cp5.addSlider("The rotation period ")
      .setPosition(width/2+200, 280)
      .setRange(0, RP[1])
      .setValue(RP[choosePlanet])
      .setSize(100, 10)
      .setColorForeground(Col[choosePlanet])
      .setColorBackground(backCol[choosePlanet])
      .setColorValueLabel(Col[choosePlanet]);

    //下の数字
    cp5.getController("The rotation period ").getValueLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
    //上の文字も部分
    cp5.getController("The rotation period ").getCaptionLabel().align(ControlP5.LEFT, ControlP5.TOP_OUTSIDE).setPaddingX(0);

    //============planetsの表面積
    Slider planetsa;
    planetsa=cp5.addSlider("The surface area ")
      .setPosition(width*3/4+50, 280)
      .setRange(0, SA[3])
      .setValue(SA[choosePlanet])
      .setSize(100, 10)
      .setColorForeground(Col[choosePlanet])
      .setColorBackground(backCol[choosePlanet])
      .setColorValueLabel(Col[choosePlanet]);

    //下の数字
    cp5.getController("The surface area ").getValueLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0);
    //上の文字も部分
    cp5.getController("The surface area ").getCaptionLabel().align(ControlP5.LEFT, ControlP5.TOP_OUTSIDE).setPaddingX(0);
  }

  //======================上のtextのspeedが何倍かを表示
  void drawSpeed() {
    String speedX="×"+dDay[choosePlanet]+" days";
    textAlign(CENTER);
    fill(255);
    noStroke();
    textSize(20);
    text("speed", width/2, height*3/5-30);
    textSize(30);
    text(speedX, width/2, height*3/5+30);
  }

  //====================下のplanetsを頑張る
  void borderPlanets() {
    noFill();
    stroke(51);
    strokeWeight(1);
    line(0, height*7/8, width, height*7/8);
  }

  //===================下の部分のplanetsの実装
  void selectedPlanets() {
    imageMode(CENTER);
    //ここでmouseがplanetの上にいるかcheckする
    for (int i=0; i<checklocation.length; i++) {
      checklocation[i]=checkBoolean(location[i], dia[i]);
    }
    //mouseが上にきてたらhoverするように作る
    for (int i=0; i<location.length; i++) {
      if ((checklocation[i])||choosePlanet==i) { 
        tint(255, 255);
      } else {
        tint(255, 30);
      }
      //ellipse(location[i].x, location[i].y, dia[i], dia[i]);
      image(planetsImage[i], location[i].x, location[i].y, dia[i], dia[i]);
    }
    //mouseが下のplanetsの上に来たらplanetsが変わるようにする
    for (int i=0; i<checklocation.length; i++) {
      if (checklocation[i]&&mousePressed) {
        choosePlanet=i;
      }
    }
  }

  //=====================hoverしたら音が出るようにする
  void playAudio() {
    //planetの上に来てるかcheck
    for (int i=0; i<checklocation.length; i++) {
      checklocation[i]=checkBoolean(location[i], dia[i]);
    }
    //もしも上に来てたらplayする
    for (int i=0; i<checklocation.length; i++) {
      if (checklocation[i]&&mousePressed) {
        //hover.play();
        delay(40);
        hover.trigger();
      }
    }
  }

  //=====================mouseが上にきているかどうか
  boolean checkBoolean(PVector loc, float diam) {
    if (dist(mouseX, mouseY, loc.x, loc.y)<diam) {
      count=0;
      return true;
    } else {
      return false;
    }
  }

  //====================下の部分のそれぞれがどのplanetsかを表示
  void informPlanets() {
    textAlign(CENTER);
    textSize(fontSize);
    for (int i=0; i<location.length; i++) {
      fill(col[i], 50, 75);
      text(planet[i], location[i].x, location[i].y+dia[i]);
    }
  }
}
