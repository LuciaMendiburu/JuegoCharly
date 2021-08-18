import fisica.*;
import processing.sound.*;

SoundFile abrirLata;
SoundFile abrirBotella;

FWorld mundo;
FBox caja; //creamos una caja
FBox pileta;//creamos el borde de la pileta donde charly va a estar sentado
FBox botella;
FBox Charly;
float ancho = 36.5;
float altoBotella = 94;
float alto = 64;

int contador = 0;

int anchoPileta =301;
int altoPileta =350;

float anchoCharly = 70;
float altoCharly = 145 ;

PImage lata;

PImage bordePileta;

PImage botellaCoca;

PImage Charlyimg;

PImage agua;

int maxPngAgua = 10;
int maxPngCharly = 6;
int imageIndex = 0;
PImage [] PngAgua = new PImage[maxPngAgua];
PImage [] PngCharly = new PImage[maxPngCharly];


void setup(){

size(1000,600);
frameRate(10);

/* inicializacion */

Fisica.init(this);
mundo = new FWorld(); //creo el mundo
mundo.setEdges();//crea unos bordes para que los elementos no se escapen del mundo
//los bordes no se ven porque para actualizarse necesira llamar
//a dos metodos en el draw
// agua = loadImage("agua.png");
 
 /* Loop agua */
for (int i = 0; i< PngAgua.length; i++){
PngAgua[i] = loadImage("Layer 1_agua_0"+i+".png");
}


/* sonido */
abrirBotella = new SoundFile(this,"abriendo_botella.wav");
abrirLata = new SoundFile(this,"abriendo_lata.wav");

/* caja > futura lata */

lata = loadImage("lata.png");

caja = new FBox(ancho,alto);
caja.setPosition(0+ancho*3,height-alto);
//que la incialice aca no significa que se dibuje porque no
//agrege la caja al mundo 
mundo.add(caja);
caja.attachImage(lata);
caja.setRestitution(0.8);
caja.setFriction(3);
caja.setDensity(3);
caja.setName("lataCoca");

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
botella.setPosition(0+ancho*3.5,height-altoBotella);
//que la incialice aca no significa que se dibuje porque no
//agrege la caja al mundo 
mundo.add(botella);
botella.attachImage(botellaCoca);
botella.setRestitution(0.1);
botella.setFriction(6);
botella.setDensity(6);
botella.addImpulse(50, 50);

/*Charly*/

 /* Loop charly */
for (int i = 0; i< PngCharly.length; i++){
PngCharly[i] = loadImage("charly_"+i+".png");
}

//Charlyimg = loadImage("Charly.png");

Charly = new FBox(anchoCharly,altoCharly);
Charly.setPosition(width-(anchoPileta/2 + anchoCharly + anchoCharly/2) , height - (altoPileta/2+ altoCharly + altoCharly/2) ); 
//le sumo el ancho de la pileta dividido dos porque la pos x del
//cuadrao la determina el center mode, no corner> despues me di cuenta que 
//restrle el ancho entero y despues sumarle la mitad , era lo mismo que directa-
// solo sumarle la mitad
mundo.add(Charly);
Charly.attachImage(Charlyimg);
Charly.setStatic(true); //se queda dura pero se sigue moviendo si le hago click
//como hago para que no pueda moverse al objeto con el mouse?
Charly.setGrabbable(false);
Charly.setName("Charly");


}


void draw(){
  background(255);
  //image(agua,0,0);
  image(PngAgua[imageIndex],0,0);
  imageIndex=(imageIndex+1)%PngAgua.length;
  

  mundo.step();//hace los calculos matematicos en los cuerpos que interactuan en 
  //frame
  mundo.draw(); //dibuja el mundo de fisica en el lugar

  textSize(36);
  fill(0);
  text(contador,50,50);
    image(PngCharly[imageIndex],400,20);
  imageIndex=(imageIndex+1)%PngCharly.length;
  
 /* if(<altoPileta){

mundo.setGravity(0,0);

} */
  
  
}

void contactStarted(FContact contacto){

//nunca se cual es el uno y cual es el dos, por lo tanto puedo averiguar 
//los nombres de los objetos
FBody body1 = contacto.getBody1();
FBody body2 =contacto.getBody2();



if (body1.getName() == "Charly" || body2.getName() == "Charly"){

//println("body1= " + body1.getName());
//println("body2= " + body2.getName());
if (!abrirBotella.isPlaying()){
abrirBotella.play();
}

contador ++;
println(contador);
}

}
void keyPressed()
{
  if (key == ENTER){
    botella.addImpulse(5000,-10000);
    caja.addImpulse(5000,-10000);
    background(55);
  
 }

}
