
/*
Class file not included!
SuperCollider Code to trigger network bubbles
 n = NetAddr("127.0.0.1", 12000);
 n.sendMsg("/something")
 */

import netP5.*;
import oscP5.*;

import java.util.concurrent.Semaphore;
import themidibus.*;
import javax.sound.midi.MidiMessage; 

MidiBus myBus;

Semaphore mutex;

;
ArrayList<Node> nodes;
ArrayList<Node> nodesToAdd;
ArrayList<Connection> connections;

OscP5 oscP5;
NetAddress junction;

boolean mode1 = true; 
boolean mode2 = false;
boolean mode3 = false;
boolean mode4 = false;

float radius_multiply = 1.0;
float can;
int frames = 30;
float translate_x;
float translate_y;


void setup() {
  size(640, 360);
  frameRate(frames);
  can = height * (1000.0 / 1080.0);
  println(can);
  translate_x = (width - can) * 0.5;
  translate_y= ((height -can) * 0.5);
  mutex = new Semaphore(1);
  oscP5 = new OscP5(this, 12000);
  junction = new NetAddress("127.0.0.1", 57140);

  //fullScreen(1);

  nodes = new ArrayList<Node>();
  nodesToAdd = new ArrayList<Node>(); // nodes to be added from OSC messages
  connections = new ArrayList<Connection>();

  MidiBus.list(); 
  myBus = new MidiBus(this, 0, 1);
}

void noteOn(int channel, int pitch, int velocity) {
  // Receive a noteOn


  if (pitch == 60) {

    //activate mode 1 -- turn mode one to true 
    mode1 = true; 
    mode2 = false;
    mode3 = false;
    mode4 = false;

    OscMessage msg = new OscMessage("/junction");
    msg.add(1);
    msg.add("test");
    oscP5.send(msg, junction);

    println();
    println("--------");
    println("Mode: 1 ");
    println("--------");
  }

  if (pitch == 62) {

    mode3 = false;
    mode4 = false;
    mode1 = true; 
    mode2 = true;

    OscMessage msg = new OscMessage("/junction");
    msg.add(2);
    println(msg);
    oscP5.send(msg, junction);


    println();
    println("--------");
    println("Mode: 2 ");
    println("--------");
  }

  if (pitch == 64) {
    println();
    println("--------");
    println("Mode: 3 ");
    println("--------");


    OscMessage msg = new OscMessage("/junction");
    msg.add(3);
    oscP5.send(msg, junction);
    println(msg);

    mode1 = true; 
    mode2 = false;
    mode3 = true;
    mode4 = false;
  }

  if (pitch == 65) {
    println();
    println("--------");
    println("Mode: 4 ");
    println("--------");

    OscMessage msg = new OscMessage("/junction");
    msg.add(4);
    oscP5.send(msg, junction);
    println(msg);
    mode1 = true; 
    mode2 = false;
    mode3 = true;
    mode4 = false;
  }
}



void removeOldEntities() {
  // remove dead entities
  // this works but see: https://www.netjstech.com/2015/08/how-to-remove-elements-from-arraylist-java.html
  for (int i = 0; i < nodes.size(); i++) { // loop until it reaches the size of the node array
    if (!nodes.get(i).isAlive()) { // was ist das ausrufezeichen für ein syntax ? was ist isAlive für eine Methode ? hat sie mit der LifeTimne entity zu tun also mit death = true ?
      nodes.remove(i);
    }
  }

  for (int i = 0; i < connections.size(); i++) {
    if (!connections.get(i).isAlive()) {
      connections.remove(i);
    }
  }
}


void draw() {


  // copy new nodes into our main data structure ...
  // ... this operation is guarded by a mutex.
  mutex.acquireUninterruptibly();
  translate( translate_x, translate_y);
  for (Node node : nodesToAdd) {
    nodes.add(node);
  }
  nodesToAdd.clear();
  mutex.release();

  removeOldEntities();

  // some fun stuff here; if more than 2 nodes are in the system
  // with a chance of 5% each frame we spawn a short new connection;
  // with 5% chance within that we spawn a red connection.
  /* 
   if(nodes.size() >= 2) {
   if(random(1.0) > 0.95) {
   Node a = nodes.get((int) random(nodes.size()));
   Node b = nodes.get((int) random(nodes.size()));
   Connection connection = new Connection(a, b, 1000);
   if(random(1.0) > 0.99) {
   connection = new RedConnection(a, b, 3000);
   }
   connections.add(connection);
   }
   }
   */
  // actual drawing
  background(0);

  blendMode(ADD);

  noFill();  
  strokeWeight(1);


 /* //Mode 2: 
  if (mode2) {
    if (nodes.size() >= 2) {
      for (int i = 0; i < nodes.size() - 1; i++) {
        Node a = nodes.get(i);
        Node b = nodes.get(i+1);
        stroke(b.getColor());
        if (a.u == b.u) { 
          line(a.x, a.y, b.x, b.y);
        }
      }
    }
  } 
*/
  if (mode2) {
    for (int u = 1; u < 4; u++) {
      if (nodes.size() >= 2) {
        Node b = null;
        for (int i = 0; i < nodes.size() - 1; i++) {
          Node a = nodes.get(i);
          if (a.u == u) {
            if (b != null) {
              stroke(b.getColor());
              line(a.x, a.y, b.x, b.y);  
              }
            b = a;
          }
        }
      }
    }
  }


  //Mode 3 make connection only between others
  if (mode3) {
    if (nodes.size() >= 2) {
      for (int i = 0; i < nodes.size() - 1; i++) {
        Node a = nodes.get(i);
        Node b = nodes.get(i+1);
        stroke(b.getColor());
        if (a.u != b.u) {
          line(a.x, a.y, b.x, b.y);
        }
      }
    }
  }





  //draw all connection objects ...
  //... these can be used for highlighting special connections

  for (Connection connection : connections) {
    for (int i=0; i< 2; i++) {
      connection.draw();
    }
  }


  for (Node node : nodes) {
    node.draw();
  }
}



void oscEvent(OscMessage theOscMessage) {
  mutex.acquireUninterruptibly();
  try {
    int u = theOscMessage.get(0).intValue();//~userNum;
    float x = theOscMessage.get(1).floatValue(); //x
    float y = can - theOscMessage.get(2).floatValue(); //y
    float size = theOscMessage.get(3).floatValue(); //amp
    nodesToAdd.add(new Node(u, x + 3, y, size + 2, 1000));
    println(x);
    println(y);
  } 
  catch(Exception e) {
    println(e.toString());
  }
  mutex.release();

  
  if (theOscMessage.checkAddrPattern("/junction") == true) {
   
   if (theOscMessage.get(0).intValue() == 1) {
   mode1 = true; 
   mode2 = false;
   mode3 = false;
   mode4 = false;
   
   
   }
   
   if (theOscMessage.get(0).intValue() == 2) {
   mode3 = false;
   mode4 = false;
   mode1 = true; 
   mode2 = true;
   
   }
   
   if (theOscMessage.get(0).intValue() == 3) {
   mode1 = true; 
   mode2 = false;
   mode3 = true;
   mode4 = false;
   
   }
   
   if (theOscMessage.get(0).intValue() == 4) {
   mode1 = true; 
   mode2 = false;
   mode3 = true;
   mode4 = false;
   
   }
   
   }
}
