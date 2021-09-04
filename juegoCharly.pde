import fisica.*;
import processing.sound.*;

PFont pixel_font;

FWorld mundo;
FBox caja; //creamos una caja
FBox pileta;//creamos el borde de la pileta donde charly va a estar sentado
FBox botella;
FBox Charly;
FBox Brazo;
FCircle periodista;
FCircle Mano;

float espera;
float timeLeft = 3000;

SoundFile abrirLata;
SoundFile abrirBotella;
SoundFile perdiste;
SoundFile ganaste;
SoundFile estoyVerde;

float ancho = 36.5;
float altoBotella = 94;
float alto = 64;
FCircle[] dinosaurios = new FCircle[3];

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

PImage lata;

PImage bordePileta;

PImage botellaCoca;

PImage Charlyimg;

PImage agua;

PImage Fondo;

PImage dinosaurioInflable;

PImage Inicio;
PImage Perdiste;
PImage Ganaste;
PImage Boton;
PImage Flecha;
PImage Pelota;



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
int imageIndex = 0;
PImage [] PngAgua = new PImage[maxPngAgua];
PImage [] PngCharly = new PImage[maxPngCharly];

void setup(){
  
//frameRate(10);

size(1000,600);

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

for (int i = 0; i< PngAgua.length; i++){
  println(i);
PngAgua[i] = loadImage("Layer 1_agua_"+i+".png");
}


 
 /* sonido */
abrirBotella = new SoundFile(this,"abriendo_botella.wav");
abrirLata = new SoundFile(this,"abriendo_lata.wav");
perdiste = new SoundFile(this,"perder.wav");
ganaste = new SoundFile(this,"ganar.wav");
estoyVerde = new SoundFile(this,"estoy_verde_8bits.wav");

/* caja > futura lata */

lata = loadImage("lata.png");

caja = new FBox(ancho,alto);
caja.setPosition(100,200);
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

pileta = new FBox(anchoPileta,altoPileta);
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

botella = new FBox(ancho,altoBotella);
botella.setName("botellaCoca");
botella.setPosition(200,200);
//que la incialice aca no significa que se dibuje porque no
//agrege la caja al mundo 
mundo.add(botella);
botella.attachImage(botellaCoca);
botella.setRestitution(0.1);
botella.setFriction(6);
botella.setDensity(6);
/* Periodista */
Pelota = loadImage("pelota.png");
periodista = new FCircle(100);
periodista.attachImage(Pelota);
periodista.setName("periodista");
periodista.setPosition(posXp,height-posYp);
mundo.add(periodista);

/*Charly*/

 /* Loop charly */

PngCharly[1] = loadImage("charly_1.png");


//Charlyimg = loadImage("Charly.png");

Charly = new FBox(anchoCharly,altoCharly);
Charly.setPosition(977 ,126); 
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


Brazo = new FBox(anchoBrazo,altoBrazo);
Brazo.setPosition(924,196);
mundo.add(Brazo);
Brazo.setNoStroke();
Brazo.setNoFill();
Brazo.setGrabbable(false);
Brazo.setRotation(183);
Brazo.setName("Brazo");
Brazo.setStatic(true);

Mano = new FCircle(10); 
Mano.setStatic(true);
Mano.setPosition(906,181);
Mano.setNoStroke();
Mano.setNoFill();
mundo.add(Mano);
Mano.setGrabbable(false);
Mano.setName("Mano");


/*-----dinosaurios-----*/
 
    for (int i=0; i<dinosaurios.length; i++) {
    dinosaurios[i] = new FCircle(60); 
    dinosaurios[i].setPosition(width/2 + (i*4), puenteY-100);
    dinosaurios[i].setRestitution(0.1);
    dinosaurios[i].setFriction(1);
    dinosaurios[i].setDensity(1);
    dinosaurios[i].attachImage(dinosaurioInflable);
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
  


Fondo = loadImage("Fondo.png");

Inicio = loadImage("1.png");
Perdiste = loadImage("2.png");
Ganaste = loadImage("3.png");
 Boton = loadImage("4.png");

Flecha= loadImage("flecha.png");


}


void draw(){
 // println("X: " + mouseX + " Y:" + mouseY);
// println(startTime);
    
  if(pantalla == 0){
     image(Inicio,0,0);
     restart();
     
     if (!estoyVerde.isPlaying()){
//estoyVerde.amp(0.5);
//estoyVerde.play();
     }       
     if(mouseX>870 && mouseX<929 && mouseY>468 && mouseY<523){
            
           image(Flecha,0,0);
          
           } 
     
     
     fill(0);
     textSize(20);
     textAlign(CENTER);
//     text("Pulsa s para iniciar", width/2, 50);
    
    
  }else if(pantalla==1){
   Fondo.resize(1000,600);
  image(Fondo,0,0);
  //image(agua,0,0);
  
  mundo.step();//hace los calculos matematicos en los cuerpos que interactuan en 
  //frame
  mundo.draw(); //dibuja el mundo de fisica en el lugar
  
  PngAgua[imageIndex].resize(1000,600);
   image(PngAgua[imageIndex],0,120);
   //println("index agua: "+ imageIndex);
  imageIndex=(imageIndex+1)%PngAgua.length;
  
  //textSize(36);
  //fill(255,255,0);
 // noStroke();
  //ellipse(50,50,50,50);
  textSize(25);
  fill(255);
  text("Tiempo: "+round(timeLeft/100),100,50);
  fill(0);
   textSize(36);
 // text(contador,50,60);
 //textSize(25);
 //fill(255,0,0);
 //text("Tiempo: "+round(timeLeft/100),width-150,50);
  fill(255);
  textSize(30);
  text("Dale a Charly su gaseosa", width/2, 40);
  text("¡Sólo tenés 30 segundos!", width/2, 70);
  //PngCharly[imageIndex].resize(400,100);
  image(PngCharly[1],635,20);
  imageIndex=(imageIndex+1)%PngCharly.length;
  timeLeft--;
 // println(timeLeft/100);
  if (timeLeft == 0 && pantalla == 1){
    pantalla = 3;
     if (!perdiste.isPlaying()){
perdiste.amp(.3);
perdiste.play();
estoyVerde.pause();
 timeLeft = 3000;

}
    } 
    
  }else if(pantalla==3){
            
    image(Perdiste,0,0);
    
       if(mouseX>214 && mouseX<550 && mouseY>385 && mouseY<440){
            
           image(Boton,0,0);
        
           }   
    
    
  }else if(pantalla==2){
        
     image(Ganaste,0,0);
     contador = 0;
       if(mouseX>214 && mouseX<550 && mouseY>385 && mouseY<440){
            
          image(Boton,0,0);
           
          
           }  
    
    
  }
  
  


    /* botella */

  botella.setRestitution(0.1);
  botella.setFriction(friccionB);
  botella.setDensity(densidadB);
  botella.setDamping(DampingB);

/* lata */

   caja.setRestitution(0.8);
   caja.setFriction(friccionL);
   caja.setDensity(densidadL);
  caja.setDamping(DampingL);
  
 
  
  
 if( botella.getY()>407){
   
   
friccionB = 30;
densidadB = 2;
 DampingB = 5;


}else{
     
friccionB =30;
densidadB = 6;
 DampingB = 0 ;

  
}

 if( caja.getY()>407){
   
   
friccionL = 30;
densidadL = 3;
 DampingL = 5;


}else{
     
friccionL =3;
densidadL = 5;
 DampingL = 0;

  
}

  
  
}

void contactStarted(FContact contacto){

//nunca se cual es el uno y cual es el dos, por lo tanto puedo averiguar 
//los nombres de los objetos
FBody body1 = contacto.getBody1();
FBody body2 =contacto.getBody2();



if ((body1.getName() == "Mano" && body1.getName() == "botellaCoca") || body2.getName() == "Mano"){

//println("body1= " + body1.getName());
//println("body2= " + body2.getName());
if (!abrirBotella.isPlaying()){
abrirBotella.play();
}


contador ++;
println(contador);


}
if (contador == 1){
  timeLeft = 3000;
      if (!ganaste.isPlaying()){
ganaste.amp(.3);
ganaste.play();
estoyVerde.pause();
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
void restart(){
  periodista.setPosition(100,height-100);
  caja.setPosition(100,200);
  botella.setPosition(200,200);
  for (int i=0; i<dinosaurios.length; i++) {
    dinosaurios[i].setPosition(width/2 + (i*4), puenteY-100);
  }
}


void keyPressed(){
 
  
  if(pantalla==1){
    
  if(keyCode == RIGHT){
periodista.adjustPosition(15,0);
}  
    if(keyCode == LEFT){
periodista.adjustPosition(-15,0);
}  
    
    
   if (millis() - espera >= 500){
    // println(contador);
   if(key == ENTER)
     // botella.addImpulse(5000,-10000);
    periodista.addImpulse(3000,-25000);
    espera = 0;
    espera = millis();

    } else {
    println("STOP");
    }
  }    
 }
 
 
  
 void mouseClicked(){
 
 
  if(pantalla==2){
      
      //ganaste
        
            if(mouseX>214 && mouseX<550 && mouseY>385 && mouseY<440){
            
            pantalla=0;
           
            
            }   
    
    }else if(pantalla==3){
    
    //perdiste
    
           if(mouseX>214 && mouseX<550 && mouseY>385 && mouseY<440){
            
           pantalla=0;
          
           }   
    
    
    }else if(pantalla==0){
    
    //inicio
    
            
     if(mouseX>870 && mouseX<929 && mouseY>468 && mouseY<523){
            
           pantalla=1;
          
           }    
    
    
    }
 
 
 
 
 
 
 }
