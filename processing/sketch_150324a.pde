import java.awt.Point;
import java.awt.event.MouseEvent;
import java.awt.event.MouseWheelEvent;
import java.awt.event.MouseListener;
import java.awt.event.MouseMotionListener;
import java.util.ArrayList;
import java.util.List;
import java.util.Collections;
import java.util.Comparator;
import net.foxtail.file.FTFile;
import net.foxtail.file.FTReadCSV;
import net.foxtail.utils.FTUtil;

Point mp;
Point drag;
Point present;
boolean dragging;
PShape bg;
PShape btn1;
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


//  String readAll = FTFile.Read("https://JinkiKim.github.io/stations/"+ "가락시장"+".csv","csv");
//  FTReadCSV Acsv = new FTReadCSV();
//  Acsv.StringToCsv(readAll);
//  
//  Table table = loadTable("https://JinkiKim.github.io/stations/"+ "가락시장"+".csv");

class Station{
    
    Point pos;
    int line;
    int value;
    int v1;
    int v2;
    String sName;
    boolean mouseOn;
    
    
      Station(Point p,String name,int l,int val,int val2){
        pos = p;
        line = l;
        v1 = val;
        v2 = val2;
        if(drawData.equals(0)){
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
      //  mouseOn=false;
      }
     
  }

void setup(){
  
  //-------- background Image --------//
  size(1600,1100);
  bg = loadShape("./bgimg.svg");
  btn1 = loadShape("./event.svg");
  btn2 = loadShape("./monthday.svg");
  btn3 = loadShape("./time.svg");
  xs = 0;
  ys = 0;
  xo = width;
  yo = height;
  transX = 0;
  transY = 0;
  dragging = false;
  drag = new Point(0,0);  
  present = new Point(0,0);
  //----------------- font ------------------//
 
  font = createFont("NanumGothicBold",48);
  textFont(font);

  
//-------------------------- initialize --------------------------//

        int b;
        int a0,a1;
        String a2;
        int a3,a5;
        String a6 = null;
       
         csv = loadTable("./stationT.csv");
       
       for(int i = 0; i < csv.getRowCount(); i++){  
    
       a0 = (int)csv.getFloat(i,0);
       a1 = (int)csv.getFloat(i,1);
       a2 = csv.getString(i,2);
       a3 = csv.getInt(i,3);
       a5 = csv.getInt(i,5);
       
           while( a6.equals(null)){
             a6= csv.getString(i,6);
           }
         
         if(a6.length().equals(3)){
           a6 = "0" + a6;
         }
         else if(a6.length().equals(2)){
           a6 = "00" + a6;
         }
         
         b = Integer.parseInt(a6);
         
         try{
         stations.add(new Station( new Point( a0, a1), a2, a3, a5, b ) );
         }
         catch(NumberFormatException e){
           System.out.println(i);
         }
       }
       
 // -- date select test -- //
 
 dateSelect(3,1,12);
 
 //------------ sort -------------//
 
 List bbs = stations;
 List stts = new ArrayList<Station>(); 
 
 Collections.sort(bbs, new NoAscCompare());
 for(Station stt : stations){
    stts.add(stt);
 }
 stations = (ArrayList)stts;
 
 //------------ MouseListener --------------//
 addMouseWheelListener(new java.awt.event.MouseWheelListener(){
 public void mouseWheelMoved(java.awt.event.MouseWheelEvent evt){
   mouseWheel(evt);
 }});
 
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
static class NoAscCompare implements Comparator<Station> {
 
    /**
     * 오름차순(ASC)
     */
    @Override
    public int compare(Station arg0, Station arg1) {
      // TODO Auto-generated method stub
      return arg0.value < arg1.value ? -1 : arg0.value > arg1.value ? 1:0;
    }
 
}
void draw(){
    
  //--------------- Zoom ----------------//
    scale(zoom);
    rotate (angle);
 
  //-------------- Station --------------//
  
  background(0);
  shape(bg, transX + xs, transY + ys , xo, yo);
 // image(btn1, transX + 247.896, transY + 48.152 , 179, 34);
 // image(btn2, transX + 471.118, transY + 48.152 , 179, 34);
 // image(btn3, transX + 664.479, transY + 48.152 , 179, 34);
 shape(btn1, transX + 247.896, transY + 48.152 , 179, 34);
 shape(btn2, transX + 471.118, transY + 48.152 , 179, 34);
 shape(btn3, transX + 664.479, transY + 48.152 , 179, 34);


  for(int ii = 0; ii< stations.size(); ii++){
    
    drawStroke(stations.get(ii).pos.x,stations.get(ii).pos.y,stations.get(ii).value+2,stations.get(ii).line,150,5);
    drawGradient(stations.get(ii).pos.x,stations.get(ii).pos.y,stations.get(ii).value,0);
  
  }
  
   for(int ii = 0; ii< stations.size(); ii++){
     
  
     
  //--------- mouse hover ----------//
  
  if(overCircle(stations.get(ii).pos.x-1,stations.get(ii).pos.y,stations.get(ii).value*2*zoom+3) & !on){
    
      on = true;
    drawStroke(stations.get(ii).pos.x,stations.get(ii).pos.y,stations.get(ii).value+3,stations.get(ii).line,255,5);
    drawGradient(stations.get(ii).pos.x,stations.get(ii).pos.y,stations.get(ii).value,1);
    
  
  rectMode(CENTER);
  stroke(190);
  fill(200);
  rect(transX + stations.get(ii).pos.x,transY + stations.get(ii).pos.y -stations.get(ii).value-25 ,100,50,12,12,12,12 );          
  
  
  pushMatrix();
  translate(transX + stations.get(ii).pos.x,transY + stations.get(ii).pos.y -stations.get(ii).value-25);
  stroke(0);
  popMatrix();
    
  fill(#000000);
  textAlign(CENTER);
  textSize(12);
  
  if(drawData.equals(0)){
  text(stations.get(ii).sName+"\n"+stations.get(ii).v1+""+stations.get(ii).v2+"명",transX + stations.get(ii).pos.x,transY + stations.get(ii).pos.y -stations.get(ii).value-25);
  }
  else{
    text(stations.get(ii).sName+"\n"+stations.get(ii).v1+"명",transX + stations.get(ii).pos.x,transY + stations.get(ii).pos.y -stations.get(ii).value-25);
  }
  }
  
}
   
  //--------------- Clock ----------------//
  
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
       
       ncsv = loadTable("./date/"+clickDate + ".csv");
         
         stations.clear();
         
         for( int i=0; i<ncsv.getRowCount(); i++){
           meanVal += ncsv.getInt(i,clickTime+1)/ncsv.getRowCount();
         }
           
           System.out.println(meanVal+"");
           
         for( int i =0; i<ncsv.getRowCount();i++){
           //Point p,String name,int l,int val,int val2
           
          int valK = ncsv.getInt(i,clickTime+1);
          
           stations.add(
             new Station(
               new Point((int)ncsv.getFloat(i,26),(int)ncsv.getFloat(i,27)),
               ncsv.getString(i,0),
               ncsv.getInt(i,28),
               valK,
               (int)meanVal));
         }
         
         
}
//void drawStation(float x, float y, float radius){
//  
//  noStroke();
//  fill(radius*4+100,radius*4+80,radius*4+60,200);
//  ellipseMode(RADIUS);
//  ellipse(x, y,radius,radius); 
// // 253 227 144
//}
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

  for (int r = (int)radius; r > 0; r--) {
    
    if(col <0){
      col = 0;
    }
    else
      col -= 110/radius;
  
    if(mode.equals(0)){
      if(0 < radius & radius <= 10){
        drawStroke(x , y , r,-2 , (int)col,3);
      }
      else if(10< radius & radius <= 25){
        drawStroke(x , y , r,-3 , (int)col,3);
      }
      else if(25 < radius & radius <= 40){
        drawStroke(x , y, r, -4 , (int)col, 3);
      }
      else if(radius >40){
        drawStroke(x,y,r,-5,(int)col,3);
      }
    }
    else if(mode.equals(1)){
      drawStroke(x , y , r,-1, (int)col,3);
    }
    
    
  }
}
void mouseWheel(MouseWheelEvent event) {
  
  //--------------- Zoom ---------------//
      zoom += event.getWheelRotation()*.02;
 
      if(zoom <0.7)
        zoom = 0.7;
        
  // xs = (1- zoom) * mouseX;
  // ys = (1- zoom) * mouseY;
 
}

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
    drag.x = mouseX;
    drag.y = mouseY;
  }
  
  transX = present.x + (mouseX - drag.x);
  transY = present.y + (mouseY - drag.y);
  
  if(transX > 0){
    transX = 0;
    drag.x = mouseX;
  }
  if(transY > 0){
    transY = 0;
    drag.y = mouseY;
  } 
  
    
//  if(transX < 1600*(1-zoom)){
//    transX = (int)(1600*(1-zoom));
//    drag.x = mouseX;
//  }
//  
//  if(transY < 1100*(1-zoom)){
//    transY = (int)(1100*(1-zoom));  
//    drag.y = mouseY;
//  }
  
}
void mouseClicked(){
   dragging = true;
}
void mouseReleased(){
  present.x = transX;
  present.y = transY;
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
//int milTime(int h, int m, int s){
// 
// int mills = h*60*60 + m*60 + s;
// 
//return mills;  
//}
//
//float timeCheck(String x , String y){
//
//  int gap = 0;
//  
//  String[] times1 = splitTokens(x, ":");
//  String[] times2 = splitTokens(y, ":");
// 
//  int mills1 = milTime(Integer.parseInt(times1[0]),Integer.parseInt(times1[1]),Integer.parseInt(times1[2]));
//  int mills2 = milTime(Integer.parseInt(times2[0]),Integer.parseInt(times2[1]),Integer.parseInt(times2[2]));
//  
//  gap = mills2 - mills2;
//  
//  return gap;
//}
//void menuSelect(){
//   if(overRect()){
//   }
//   else if(overRect()){
//   }
//   else if(over 
//}

