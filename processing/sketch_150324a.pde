//import java.awt.event.MouseWheelEvent;

int dragX;
int dragY;
int presentX;
int presentY;
boolean dragging;
PShape bg;
PShape btn1;
PShape btnE;
PShape btn2;
PShape btn3;
PFont font;
int d= 40;
float xo;
float yo;
float angle = 0;
float xs = 0;
float ys = 0;
float zoom= 1;
float degree = 0;
float x6;
float y6;
static final int UP = 1;
static final int DOWN = 2;
int x, y;
float s=0;
int m=28;
int h=5;
float a;
float rectX, rectY;      // Position of square button
float circleX, circleY;  // Position of circle button
int n=0;
boolean rectOver = false;
boolean circleOver = false;
boolean on = false;
int rectSize  = 30;
int circleSize= 20;
boolean isClickedCalendarMonth = false;
boolean isClickedCalendarDay = false;
int drawData = 0;
String clickDate;
ArrayList<Station> stations = new ArrayList<Station>();
Table csv;
int transX;
int transY;
boolean eventClick;
int eventSelect;

//  String readAll = FTFile.Read("https://JinkiKim.github.io/stations/"+ "가락시장"+".csv","csv");
//  FTReadCSV Acsv = new FTReadCSV();
//  Acsv.StringToCsv(readAll);
//  
//  Table table = loadTable("https://JinkiKim.github.io/stations/"+ "가락시장"+".csv");

class Station{
    
    int posX;
    int posY;
    int line;
    int value;
    int v1;
    int v2;
    String sName;
    boolean mouseOn;
    
    
      Station(int px,int py,String name,int l,int val,int val2){
        posX = px;
        posY = py;
        line = l;
        v1 = val;
        v2 = val2;
        if(drawData ==0){
          value = (int)(val/250);
        }
        else{
            if( val2 != 0){
              value = (int)(val*10/val2);
            }
            else{
              val2 = 0;
            }
        }
        sName = name;
      }
     
  }

void setup(){
  
  //-------- background Image --------//
  size(1600,1100);
 String url = "https://JinkiKim.github.io/processing/svg/bgimg.svg";
  bg = loadShape(url,"svg");
 String urlbtn1 = "https://JinkiKim.github.io/processing/svg/event.svg";
 String urlbtnE = "https://JinkiKim.github.io/processing/svg/eventE.svg";
 String urlbtn2 = "https://JinkiKim.github.io/processing/svg/monthday.svg";
 String urlbtn3 = "https://JinkiKim.github.io/processing/svg/time.svg";

  btn1 = loadShape(urlbtn1,"svg");
  btnE = loadShape(urlbtnE,"svg");
  btn2 = loadShape(urlbtn2,"svg");
  btn3 = loadShape(urlbtn3,"svg");
  xs = 0;
  ys = 0;
  xo = width;
  yo = height;
  transX = 0;
  transY = 0;
  dragging = false;
  dragX=0;
  dragY=0;  
  presentX = 0;
  presentY = 0;
  eventClick = false;
  eventSelect = -1;
  //----------------- font ------------------//
 
  font = createFont("NanumGothicBold",48);
  textFont(font);

  
//-------------------------- initialize --------------------------//

        int b;
        int a0,a1;
        String a2;
        int a3,a5;
        String a6 = null;
        String urlsT = "https://JinkiKim.github.io/processing/stationT.csv";
         csv = loadTable(urlsT,"csv");
       
       for(int i = 0; i < csv.getRowCount(); i++){  
    
       a0 = (int)csv.getFloat(i,0);
       a1 = (int)csv.getFloat(i,1);
       a2 = csv.getString(i,2);
       a3 = csv.getInt(i,3);
       a5 = csv.getInt(i,5);
       
           while( a6==null){
             a6= csv.getString(i,6);
           }
         
         if(a6.length()==3){
           a6 = "0" + a6;
         }
         else if(a6.length()==2){
           a6 = "00" + a6;
         }
         
         b = int(a6);
         
         try{
         stations.add(new Station( a0, a1, a2, a3, a5, b ) );
         }
         catch(NumberFormatException e){
           
         }
       }
       
 // -- date select test -- //
 
 dateSelect(3,1,14);
 
 //------------ sort -------------//
 
 ArrayList<Station> bbs = new ArrayList<Station>();
 IntDict ind = new IntDict();
 for(Station s : stations){
   ind.set(s.sName, s.value);
 }
   ind.sortValues();
   String[] strL = ind.keyArray();
   
   for(String str : strL){
     for( int i =0; i< stations.size(); i++){
       if(stations.get(i).sName.equals(str)){
         bbs.add(stations.get(i));
         break;
       }
     }
   }
   
   stations = bbs;
 
 //------------ MouseListener --------------//
// addMouseWheelListener(new java.awt.event.MouseWheelListener(){
// public void mouseWheelMoved(java.awt.event.MouseWheelEvent evt){
//   mouseWheel(evt);
// }});
// 
 //-------------- Clock ---------------//
  x=900;
  y=50;
  smooth();
  a=0.2;
  circleX = 30;
  circleY = 15;
  rectX = 10;
  rectY = 10;
 
 //-------------- Station -------------//
 
}
//static class NoAscCompare implements Comparator<Station> {
// 
//    /**
//     * 오름차순(ASC)
//     */
//    @Override
//    public int compare(Station arg0, Station arg1) {
//      // TODO Auto-generated method stub
//      return arg0.value < arg1.value ? -1 : arg0.value > arg1.value ? 1:0;
//    }
// 
//}
void draw(){
    
  //--------------- Zoom ----------------//
  
    scale(zoom);
    rotate (angle);

  //------------ background -------------//
 
   background(0);
   shape(bg, transX + xs, transY + ys , xo, yo);

  //-------------- Station --------------//
 

  for(int ii = 0; ii< stations.size(); ii++){
    
    drawStroke(stations.get(ii).posX,stations.get(ii).posY,stations.get(ii).value+2,stations.get(ii).line,150,5);
    drawGradient(stations.get(ii).posX,stations.get(ii).posY,stations.get(ii).value,0);
  
  }
  
   for(int ii = 0; ii< stations.size(); ii++){
     
  //--------- mouse hover ----------//
  
  if(overCircle(stations.get(ii).posX-1,stations.get(ii).posY,stations.get(ii).value*2*zoom+3) & !on){
    
      on = true;
    drawStroke(stations.get(ii).posX,stations.get(ii).posY,stations.get(ii).value+3,stations.get(ii).line,255,5);
    drawGradient(stations.get(ii).posX,stations.get(ii).posY,stations.get(ii).value,1);
    
  
    rectMode(CENTER);
    stroke(190);
    fill(200);
    rect(transX + stations.get(ii).posX,transY + stations.get(ii).posY -stations.get(ii).value-25 ,100,50,12,12,12,12 );          
    
    
    pushMatrix();
    translate(transX + stations.get(ii).posX,transY + stations.get(ii).posY -stations.get(ii).value-25);
    stroke(0);
    popMatrix();
      
    fill(#000000);
    textAlign(CENTER);
    textSize(12);
    
    if(drawData==0){
    text(stations.get(ii).sName+"\n"+stations.get(ii).v1+""+stations.get(ii).v2+"명",transX + stations.get(ii).posX,transY + stations.get(ii).posY -stations.get(ii).value-25);
    }
    else{
      text(stations.get(ii).sName+"\n"+stations.get(ii).v1+"명",transX + stations.get(ii).posX,transY + stations.get(ii).posY -stations.get(ii).value-25);
    }
    }
    
  }
  
 //----------- event Click -----------//

 if(eventClick){
  shape(btnE, transX + 246.5, transY + 82, 180,557); 
 }
 
 if(eventSelect == -1){
     shape(btn1, transX + 247.896, transY + 48.152 , 179, 34);
 }
 else{
   PShape btnSelect = loadShape("https://JinkiKim.github.io/processing/svg/event" + eventSelect + ".svg", "svg");
     shape(btnSelect, transX + 247.896, transY + 48.152,179,34);
 }
  shape(btn2, transX + 471.118, transY + 48.152 , 179, 34);
  shape(btn3, transX + 664.479, transY + 48.152 , 179, 34);

 update(mouseX, mouseY);
}
void dateSelect(int clickMonth, int clickDay, int clickTime){
         
 
         Table ncsv;
        String clickDate;

         if( 0 < clickMonth & clickMonth <10 ){
         
           if( 0< clickDay & clickDay < 10){
             clickDate = "2013-0" + clickMonth + "-0" + clickDay;
           }
           else{
             clickDate = "2013-0" + clickMonth + "-" + clickDay;  
           }  
         }
         else{
         
           if( 0< clickDay & clickDay < 10){
               clickDate = "2013-" + clickMonth + "-0" + clickDay;   
           }
           else{
               clickDate = "2013-" + clickMonth + "-" + clickDay;  
         }
       }
       
       drawData=1;
       float meanVal = 0;
       
       clickDate = "https://JinkiKim.github.io/processing/date/" + clickDate + ".csv";

       ncsv = loadTable(clickDate, "csv");
         
         stations.clear();
         
         for( int i=0; i<ncsv.getRowCount(); i++){
           meanVal += ncsv.getInt(i,clickTime+1)/ncsv.getRowCount();
         }
                      
         for( int i =0; i<ncsv.getRowCount();i++){

          int valK = ncsv.getInt(i,clickTime+1);
          
           stations.add(
             new Station(
               (int)ncsv.getFloat(i,26),
               (int)ncsv.getFloat(i,27),
               ncsv.getString(i,0),
               ncsv.getInt(i,28),
               valK,
               (int)meanVal));
         }
         
         
}
void drawStroke(float x, float y, float radius, int li,int alpha,int weight){
  
     ellipseMode(RADIUS);
     if(li<10){
     strokeCheck(li,alpha,weight);
     ellipse(transX+x,transY+y,radius,radius);
     }
     else
       drawArc(x,y,radius,li,alpha);
}
void strokeCheck(int li, int alpha ,int weight){
      
  switch(li){
      case 1:
      stroke(17,24,139,alpha);
      strokeWeight(weight);
      fill(17, 24, 139,0);
      break;
      case 2:
      stroke(28,76,35,alpha);
      strokeWeight(weight);
      fill(28, 76, 35,0);
      break;
      case 3:
      stroke(240,93,8,alpha);
      strokeWeight(weight);
      fill(240, 93, 8,0);
      break;
      case 4:
      stroke(14,120,200,alpha);
      strokeWeight(weight);
      fill(14, 120, 200,0);
      break;
      case 5:
      stroke(83,38,118,alpha);
      strokeWeight(weight);
      fill(83, 38, 118,0);
      break;
      case 6:
      stroke(99,39,19,alpha);
      strokeWeight(weight);
      fill(99, 39, 19,0);
      break;
      case 7:
      stroke(62,69,39,alpha);
      strokeWeight(weight);
      fill(62, 69, 39,0);
      break;
      case 8:
      stroke(204,25,128,alpha);
      strokeWeight(weight);
      fill(204, 25, 128,0);
      break;
      case 9:
      stroke(200,200,200,alpha);
      strokeWeight(weight);
      fill(240, 93, 8,0);
      break;
      case -1:
      stroke(225,79,95,alpha);
      strokeWeight(weight);
      fill(0,0,0,0);
      break;  
      case -2:
      stroke(136,108,86,alpha);
      strokeWeight(weight);
      fill(0,0,0,0);
      break;
      case -3:
      stroke(211,188,128,alpha);
      strokeWeight(weight);
      fill(0,0,0,0);
      break;
      case -4:
      stroke(255,255,194,alpha);
      strokeWeight(weight);
      fill(0,0,0,0);
      break;
      case -5:
      stroke(255,255,230,alpha);
      strokeWeight(weight);
      fill(0,0,0,0);
      break;  
}
    
}
void drawArc(float x, float y, float radius, int line, int alpha){
  
    if(line>100){
    int firstLine= (int)(line/100);
    int secondLine= (int)( line/10) - firstLine*10;
    int thirdLine = (int)(line % 10);
    noFill();
    strokeCheck(firstLine,alpha,5);
    arc(transX+x,transY+y,radius,radius,0,TWO_PI/3);
    strokeCheck(secondLine,alpha,5);
    arc(transX+x,transY+y,radius,radius,TWO_PI/3,TWO_PI*2/3);
    strokeCheck(thirdLine,alpha,5);
    arc(transX+x,transY+y,radius,radius,TWO_PI*2/3,TWO_PI);
  }
  else{
    int firstLine = (int)(line/10);
    int secondLine = (int)(line%10);
    noFill();
    strokeCheck(firstLine,alpha,5);
    arc(transX+x,transY+y,radius,radius,QUARTER_PI,PI+QUARTER_PI);
    strokeCheck(secondLine,alpha,5);
    arc(transX+x,transY+y,radius,radius,PI+QUARTER_PI,TWO_PI+QUARTER_PI);
  }
}
void drawGradient(float x, float y, float radius, int mode) {
  
  /*
  colorMode(HSB,360,100,100);
  stroke(240,93,8);
  */

 float col = 110;

  for (int r = (int)radius; r > 0; r-=1) {
    
    if(col <0){
      col = 0;
    }
    else
      col -= 110/radius;
  
    if(mode==0){
      if(0 < radius & radius <= 10){
        drawStroke(x , y , r,-2 , (int)col,3);
      }
      else if(10< radius & radius <= 25){
        drawStroke(x , y , r,-3 , (int)col,3);
      }
      else if(25 < radius & radius <= 40){
        drawStroke(x , y, r, -4 , (int)col,3);
      }
      else if(radius >40){
        drawStroke(x,y,r,-5,(int)col,3);
      }
    }
    else if(mode==1){
      drawStroke(x , y , r,-1, (int)col,3);
    }
    
    
  }
}
//void mouseWheel(MouseWheelEvent event) {
//  
//  //--------------- Zoom ---------------//
//      zoom += event.getWheelRotation()*.02;
// 
//      if(zoom <0.7)
//        zoom = 0.7;
//        
//  // xs = (1- zoom) * mouseX;
//  // ys = (1- zoom) * mouseY;
// 
//}

void update(int x, int y) {
  
  if ( overCircle(circleX, circleY, circleSize) ) {
    circleOver = true;
    rectOver = false;
  } else if ( overRect(rectX, rectY, rectSize, rectSize) ) {
    rectOver = true;
    circleOver = false;
  } 
  else {
    on = false;
    circleOver = rectOver = false;
  }
}
void mousePressed() {
  
  if (circleOver) {
    a -= 0.1;
  }
  if (rectOver) {
    a += 0.1;
  }
  
}
void mouseDragged(){
  
  if(!dragging){
    dragging = true;
    dragX = mouseX;
    dragY = mouseY;
  }
  
  transX = presentX + (mouseX - dragX);
  transY = presentY + (mouseY - dragY);
  
  if(transX > 0){
    transX = 0;
    dragX = mouseX;
  }
  if(transY > 0){
    transY = 0;
    dragY = mouseY;
  }
}
void mouseClicked(){
   dragging = true;
   
   if(overRect(transX+247.896,transY+48.152,179,34) & !eventClick){
     eventClick = true;
   }
   else if(!overRect(transX+247.896,transY+82,180,557) & eventClick){
     eventClick = false;
     eventSelect = -1;
   }
   
   for( int i = 0; i<16; i++){
     if(overRect(transX+247.896, transY+82+34*i,179,34) & eventClick){
        eventSelect = i;
        eventClick = false;
     }
   }
//   else if(overRect(transX+247.896,transY+48.152,179,34) & eventClick){

   
//   if(overRect(
//   {
//     
//   }
}
void mouseReleased(){
  presentX = transX;
  presentY = transY;
  dragging = false;
}
boolean overRect(float x, float y, int width, int height)  {
  x = transX + x;
  y = transY + y;
  if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}

boolean overCircle(float x, float y, float diameter) {
    x = (transX + x)*zoom;
    y = (transY + y)*zoom;
    float disX = x - mouseX;
    float disY = y - mouseY;
    if (sqrt(sq(disX) + sq(disY)) < diameter/2 ) {
      return true;
    } else {
      return false;
    }
}

