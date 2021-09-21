 import fisica.*;
import processing.sound.*;
import oscP5.*;

OscP5 osc;

PFont pixel_font;

FWorld mundo;
FBox caja; //creamos una caja
FBox pileta;//creamos el borde de la pileta donde charly va a estar sentado
FBox botella;
FBox Charly;
FBox Brazo;
FCircle bola;
FCircle Mano;
FMouseJoint mousejoint;

float espera;
float timeLeft = 3000;

SoundFile abrirLata;
SoundFile abrirBotella;
SoundFile perdiste;
SoundFile ganaste;
SoundFile cancion;

float ancho = 36.5;
float altoBotella = 94;
float alto = 64;
FCircle[] dinosaurios = new FCircle[6];

int pantalla = 0;

int contador = 0;

int anchoPileta =100;
int altoPileta =350;

float anchoCharly = 74;
float altoCharly = 250 ;


int anchoBrazo =45;
int altoBrazo =10;

int anchoMano =2;
int altoMano =2;

int friccionB;
int densidadB;
float DampingB;

int friccionL;
int densidadL;
float DampingL;

int posXp = 100;
int posYp = 100;

int tiempo ;

PImage lata, bordePileta, botellaCoca, Charlyimg, 
  agua, Fondo, dinosaurioInflable, Inicio, Perdiste, 
  Ganaste, Boton, Flecha, Pelota;



float velocidad_agua = 0.2; //Velocidad gif
float velocidad_charly = 0.1; //Velocidad gif

float transparencia;


//---------CAMARA---------//
float amortiguacion = 0.9;
float umbralDistancia = 50;

PVector indice;
PVector pulgar;

PVector indiceFilt;
PVector pulgarFilt;

PVector puntero;

boolean seTocan = false;
boolean antesSeTocaban = false;

boolean down = false;
boolean up = false;
//-------------------------------//

/*-----------------------elementos cadena agua-------------------------------------*/

float frequency = 5;
float damping = 1;
float puenteY;
//si se modifica la cantidad de cuerpos que cuelguen de la soga, va a haber mas o menos
//peso que tire hacia abajo, que puede jugar a favor o en contra si queremos poner cosas arriba
FBody[] steps = new FBody[20];
FWorld world;

int boxWidth = 400/(steps.length) - 2;

int maxPngAgua = 47;
int maxPngCharly = 6;
int imageIndex = 0; //comienzo de imagenes gif agua
int imageIndex2=0; //comienzo de imagenes gif charly
PImage [] PngAgua = new PImage[maxPngAgua];
PImage [] PngCharly = new PImage[maxPngCharly];

int color_de_carga = 0;

void setup() {

  size(1000, 800, P3D);

  /*CAMARA*/
  osc = new OscP5(this, 8008);

  indice = new PVector(0, 0);
  pulgar = new PVector(0, 0);
  puntero = new PVector(0, 0);

  indiceFilt = new PVector(0, 0);
  pulgarFilt = new PVector(0, 0);

  /* inicializacion */

  Fisica.init(this);
  puenteY = altoPileta+45;
  mundo = new FWorld(); //creo el mundo
  mundo.setEdges();//crea unos bordes para que los elementos no se escapen del mundo
  //los bordes no se ven porque para actualizarse necesira llamar
  //a dos metodos en el draw

  agua = loadImage("agua.png");

  dinosaurioInflable = loadImage("dinosaurioInflable.png");

  pixel_font = createFont("FreePixel.ttf", 128);
  textFont(pixel_font);

  espera = second();

  /* Loop agua */

  for (int i = 0; i< PngAgua.length; i++) {
    PngAgua[i] = loadImage("Layer 1_agua_"+i+".png");
  }



  /* sonido */
  abrirBotella = new SoundFile(this, "abriendo_botella.wav");
  abrirLata = new SoundFile(this, "abriendo_lata.wav");
  perdiste = new SoundFile(this, "perder.wav");
  ganaste = new SoundFile(this, "ganar.wav");
  cancion = new SoundFile(this, "cancion.wav");
  /* caja > futura lata */

  lata = loadImage("lata.png");

  caja = new FBox(ancho, alto);
  caja.setPosition(100, 200);
  //que la incialice aca no significa que se dibuje porque no
  //agrege la caja al mundo 
  mundo.add(caja);
  caja.attachImage(lata);
  caja.setRestitution(0.8);
  caja.setFriction(3);
  caja.setDensity(3);
  caja.setName("botellaCoca");

  /* pileta donde charly se va a sentar*/


  bordePileta = loadImage("piletaBorde.png");

  pileta = new FBox(anchoPileta, altoPileta);
  pileta.setPosition(width-anchoPileta/2, height - altoPileta/2 ); 
  //le sumo el ancho de la pileta dividido dos porque la pos x del
  //cuadrao la determina el center mode, no corner> despues me di cuenta que 
  //restrle el ancho entero y despues sumarle la mitad , era lo mismo que directa-
  // solo sumarle la mitad
  mundo.add(pileta);
  pileta.attachImage(bordePileta);
  pileta.setStatic(true); //se queda dura pero se sigue moviendo si le hago click
  //como hago para que no pueda moverse al objeto con el mouse?
  pileta.setGrabbable(false);
  /* botella */

  botellaCoca = loadImage("botella.png");

  botella = new FBox(ancho, altoBotella);
  botella.setName("botellaCoca");
  botella.setPosition(200, 200);
  //que la incialice aca no significa que se dibuje porque no
  //agrege la caja al mundo 
  mundo.add(botella);
  botella.attachImage(botellaCoca);
  botella.setRestitution(0.1);
  botella.setFriction(6);
  botella.setDensity(6);
  /* Pelota */
  Pelota = loadImage("pelota.png");
  bola = new FCircle(100);
  bola.attachImage(Pelota);
  bola.setName("bola");
  bola.setPosition(100, 350); //importante
  mundo.add(bola);

  /*Charly*/

  /* Loop charly */

  for (int i=0; i < PngCharly.length; i++) {

    PngCharly[i] = loadImage("charly_"+i+".png");
  }


  //Charlyimg = loadImage("Charly.png");

  Charly = new FBox(anchoCharly, altoCharly);
  Charly.setPosition(977, 126); 
  //le sumo el ancho de la pileta dividido dos porque la pos x del
  //cuadrao la determina el center mode, no corner> despues me di cuenta que 
  //restrle el ancho entero y despues sumarle la mitad , era lo mismo que directa-
  // solo sumarle la mitad
  mundo.add(Charly);
  Charly.attachImage(Charlyimg);
  Charly.setStatic(true); //se queda dura pero se sigue moviendo si le hago click
  //como hago para que no pueda moverse al objeto con el mouse?
  Charly.setGrabbable(false);
  Charly.setNoStroke();
  Charly.setNoFill();
  Charly.setName("Charly");


  Brazo = new FBox(anchoBrazo, altoBrazo);
  Brazo.setPosition(924, 196);
  mundo.add(Brazo);
  Brazo.setNoStroke();
  Brazo.setNoFill();
  Brazo.setGrabbable(false);
  Brazo.setRotation(183);
  Brazo.setName("Brazo");
  Brazo.setStatic(true);

  Mano = new FCircle(10); 
  Mano.setStatic(true);
  Mano.setPosition(906, 181);
  Mano.setNoStroke();
  Mano.setNoFill();
  mundo.add(Mano);
  Mano.setGrabbable(false);
  Mano.setName("Mano");


  /*-----dinosaurios-----*/

  for (int i=0; i<dinosaurios.length; i++) {
    dinosaurios[i] = new FCircle(60); 
    dinosaurios[i].setPosition(width/2 + (i*20), puenteY-100);
    dinosaurios[i].setRestitution(0.1);
    dinosaurios[i].setFriction(0.5);
    Charly.setStatic(true);
    dinosaurios[i].setDensity(1);
    dinosaurios[i].attachImage(dinosaurioInflable);
    dinosaurios[i].setAngularDamping(4);

    mundo.add(dinosaurios[i]);
  }




  //estos son los circulitos que unen todas las lineas con los hilos


  FCircle left = new FCircle(10);
  left.setStatic(true);
  left.setPosition(0, puenteY);
  left.setDrawable(false);

  mundo.add(left);

  FCircle right = new FCircle(10);
  right.setStatic(true);
  right.setPosition(width-anchoPileta, puenteY);
  right.setDrawable(false);

  mundo.add(right);



  /*-------------------------------------------------*/



  for (int i=0; i<steps.length; i++) {
    steps[i] = new FBox(boxWidth, 10);
    steps[i].setPosition(map(i, 0, steps.length-1, boxWidth, width-boxWidth), puenteY);
    steps[i].setNoStroke();
    steps[i].setNoFill();
    mundo.add(steps[i]);
  }

  for (int i=1; i<steps.length; i++) {

    //construye la union entre los cuerpos del medio

    FDistanceJoint junta = new FDistanceJoint(steps[i-1], steps[i]);
    //junta.setAnchor1(1, 0);
    //junta.setAnchor2(-1, 0);
    // junta.setFrequency(frequency);
    // junta.setDamping(damping);
    junta.setNoStroke();
    junta.setNoFill();
    junta.setLength(0.2);
    mundo.add(junta);
  }


  //constituye la distancia de la soga de la izquierda y el primer cuerpo

  FDistanceJoint juntaPrincipio = new FDistanceJoint(steps[0], left);
  //juntaPrincipio.setAnchor1(-boxWidth/2, 0);
  //juntaPrincipio.setAnchor2(0, 0);
  juntaPrincipio.setFrequency(frequency);
  //juntaPrincipio.setDamping(damping);
  juntaPrincipio.setLength(0.2);
  juntaPrincipio.setNoFill();
  juntaPrincipio.setNoStroke(); 
  mundo.add(juntaPrincipio);


  //constituye la distancia de la soga de la derecha y el primer cuerpo

  FDistanceJoint juntaFinal = new FDistanceJoint(steps[steps.length-1], right);

  juntaFinal.setLength(30);


  //juntaFinal.setAnchor1(boxWidth/2, 0);
  //juntaFinal.setAnchor2(0, 0);
  // juntaFinal.setFrequency(frequency);
  //juntaFinal.setDamping(damping);
  juntaFinal.setLength(1);
  //juntaFinal.calculateLength();

  juntaFinal.setNoFill();
  juntaFinal.setNoStroke();
  mundo.add(juntaFinal);



  Fondo = loadImage("fondo.png");

  Inicio = loadImage("1.png");
  Perdiste = loadImage("2.png");
  Ganaste = loadImage("3.png");
  Boton = loadImage("4.png");

  Flecha= loadImage("flecha.png");

  //MOUSE JOINT

  mousejoint = new FMouseJoint(bola, 100, 350); //importante
  mousejoint.setFrequency(400000);
  mundo.add(mousejoint);
}


void draw() {
  //CAMARA


  indiceFilt.x = lerp(indiceFilt.x, indice.x, amortiguacion);
  indiceFilt.y = lerp(indiceFilt.y, indice.y, amortiguacion);

  pulgarFilt.x = lerp(pulgarFilt.x, pulgar.x, amortiguacion);
  pulgarFilt.y = lerp(pulgarFilt.y, pulgar.y, amortiguacion);

  puntero.x =  lerp(pulgarFilt.x, indiceFilt.x, 0.5);
  puntero.y =  lerp(pulgarFilt.y, indiceFilt.y, 0.5);



  //INTERACCIÓN CON PELOTA
  mousejoint.setTarget(puntero.x, constrain(puntero.y, 380, 600));



  if (pantalla == 0) {
    background(164, 65, 195);
    image(Inicio, 0, 0);
    rectMode(CENTER); //ESTE SORETE ERA EL DEL BUG DIOS, la solucion fue clavarle un corner mode en la pantalla siguiente
    fill(255);
    rect(width/2, height-200, 500, 50);
    fill(80, 196, 55, color_de_carga);
    rect(width/2, height-200, 500, 50);
    strokeWeight(4);



    if ( puntero.x>0) {
      color_de_carga++;
    }

    fill(0);
    textSize(24);
    text("Levantá la mano para empezar", width/2, height-195);
    println( puntero.x);

    if (color_de_carga==255) {
      pantalla=1;
      color_de_carga=0;
    }
    restart();


    if (mouseX>870 && mouseX<929 && mouseY>468 && mouseY<523) {

      image(Flecha, 0, 0);
    } 


    textSize(20);
    textAlign(CENTER);

    //     text("Pulsa s para iniciar", width/2, 50);
    
    
  } else if (pantalla==1) {
  
    rectMode(CORNER);
    
    // Fondo.resize(1000, 800);
    image(Fondo, 0, 0);
    
    //cambio color fondo
    
     fill(0,108,255,transparencia);
    rect(0,0,1000,800);
     transparencia = map(tiempo, 30, 0, 89.25, 0);
  
    //image(agua,0,0);

    mundo.step();//hace los calculos matematicos en los cuerpos que interactuan en 
    //frame
    mundo.draw(); //dibuja el mundo de fisica en el lugar


    int imageIndex = int( frameCount*velocidad_agua %PngAgua.length );

    PngAgua[imageIndex].resize(1000, 800);
    image(PngAgua[imageIndex], 0, 120);
    //println("index agua: "+ imageIndex);
    imageIndex= int(imageIndex+1)%PngAgua.length;

    //textSize(36);
    //fill(255,255,0);
    // noStroke();
    //ellipse(50,50,50,50);
    textSize(25);

/*
    if (tiempo>20 ) { //Texto titilando
      fill (255);
    } else if (tiempo<20 && tiempo%2==0) {
      fill (255, 0, 0);
    }

*/
    tiempo= round(timeLeft/100);
    text("Tiempo: "+tiempo, 100, 50);

    textSize(36);
    fill(255);
    textSize(30);
    text("Dale a Charly su gaseosa", width/2, 40);
    text("¡Sólo tenés 30 segundos!", width/2, 70);
    image(PngCharly[imageIndex2], 635, 20);
    imageIndex2=(imageIndex+1)%PngCharly.length;
    timeLeft--;

    if (timeLeft == 0 && pantalla == 1) {
      pantalla = 3;
      if (!perdiste.isPlaying()) {
        perdiste.amp(.3);
        perdiste.play();
        cancion.stop();
        //estoyVerde.pause();
        timeLeft = 3000;
      }
    }


    if ((tiempo>20 && tiempo%2==0)) { //Pantalla parpadeando

      fill(255, 0, 0, 50);
      rect(width/2, height/2, width, height);
    }
  } else if (pantalla==3) {

    image(Perdiste, 0, 0);

    if (mouseX>214 && mouseX<550 && mouseY>385 && mouseY<440) {

      image(Boton, 0, 0);
    }
  } else if (pantalla==2) {

    image(Ganaste, 0, 0);
    contador = 0;
    if (mouseX>214 && mouseX<550 && mouseY>385 && mouseY<440) {

      image(Boton, 0, 0);
    }
  }




  /* botella */

  botella.setRestitution(0.1);
  botella.setFriction(friccionB);
  botella.setDensity(densidadB);
  botella.setDamping(DampingB);
  botella.setAngularDamping(5);

  /* lata */

  caja.setRestitution(0.8);
  caja.setFriction(friccionL);
  caja.setDensity(densidadL);
  caja.setDamping(DampingL);
  caja.setAngularDamping(5);





  if ( botella.getY()>407) {


    friccionB = 30;
    densidadB = 1;

    DampingB = 5;
  } else {

    friccionB =30;
    densidadB = 6;
    DampingB = 2 ;
  }

  if ( caja.getY()>407) {


    friccionL = 30;
    densidadL = 1;
    DampingL = 4;
  } else {

    friccionL =30;
    densidadL = 5;
    DampingL = 2;
  }
}

void contactStarted(FContact contacto) {

  //nunca se cual es el uno y cual es el dos, por lo tanto puedo averiguar 
  //los nombres de los objetos
  FBody body1 = contacto.getBody1();
  FBody body2 =contacto.getBody2();



  if ((body1.getName() == "Mano" && body1.getName() == "botellaCoca") || body2.getName() == "Mano") {

    //println("body1= " + body1.getName());
    //println("body2= " + body2.getName());
    if (!abrirBotella.isPlaying()) {
      abrirBotella.play();
    }


    contador ++;
    //println(contador);
  }
  if (contador == 1) {
    timeLeft = 3000;
    if (!ganaste.isPlaying()) {
      ganaste.amp(.3);
      ganaste.play();
      cancion.stop();
      //estoyVerde.pause();
    }
    pantalla = 2;
  }


  FBody coca = null;
  if (contacto.getBody1() == Mano) {
    coca = contacto.getBody2();
  } else if (contacto.getBody2() == Mano) {
    coca = contacto.getBody1();
  }

  if (coca == null) {
    return;
  }

  //desaparece la coca
  mundo.remove(coca);
  //la vuelve a agregar al mundo
  mundo.add(coca);
}
void restart() {
  // bola.setPosition(800,350);
  caja.setPosition(300, 200);
  botella.setPosition(200, 200);
  for (int i=0; i<dinosaurios.length; i++) {
    dinosaurios[i].setPosition(500 + (i*50), puenteY-100);
  }
}

void oscEvent(OscMessage m) {

  //println(m);

  if (m.addrPattern().equals("/annotations/thumb")) {
    pulgar.x = map( m.get(9).floatValue(), 0, 800, width, 0 );
    pulgar.y = map( m.get(10).floatValue(), 0, 600, 0, height );
  }
  if (m.addrPattern().equals("/annotations/indexFinger")) {
    indice.x = map( m.get(9).floatValue(), 0, 800, width, 0 );
    indice.y = map( m.get(10).floatValue(), 0, 600, 0, height );
  }
}
void keyPressed() {


  if (pantalla==1) {

    if (keyCode == RIGHT) {
      bola.adjustPosition(15, 0);
    }  
    if (keyCode == LEFT) {
      bola.adjustPosition(-15, 0);
    }  


    if (millis() - espera >= 500) {
      // println(contador);
      if (key == ENTER)
        // botella.addImpulse(5000,-10000);
        bola.addImpulse(3000, -25000);
      espera = 0;
      espera = millis();
    } else {
      println("STOP");
    }
  }
}



void mouseClicked() {


  if (pantalla==2) {

    //ganaste

    if (mouseX>214 && mouseX<550 && mouseY>385 && mouseY<440) {
      cancion.stop();
      pantalla=0;
    }
  } else if (pantalla==3) {

    //perdiste

    if (mouseX>214 && mouseX<550 && mouseY>385 && mouseY<440) {
      cancion.stop();
      pantalla=0;
    }
  } else if (pantalla==0) {

    //inicio


    if (mouseX>870 && mouseX<929 && mouseY>468 && mouseY<523) {

      pantalla=1;
      cancion.loop();
    }
  }
}
