import fisica.*;
FWorld mundo;
FBox caja; //creamos una caja
FBox pileta;//creamos el borde de la pileta donde charly va a estar sentado
FBox botella;
FBox Charly;
FBox Brazo;
FCircle Mano;

float ancho = 36.5;
float altoBotella = 94;
float alto = 64;

int contador = 0;

int anchoPileta =301;
int altoPileta =350;

float anchoCharly = 74;
float altoCharly = 175 ;

int anchoBrazo =100;
int altoBrazo =10;

int anchoMano =40;
int altoMano =40;

PImage lata;

PImage bordePileta;

PImage botellaCoca;

PImage Charlyimg;

PImage agua;


/*-----------------------elementos cadena agua-------------------------------------*/

float frequency = 5;
float damping = 1;
float puenteY;
//si se modifica la cantidad de cuerpos que cuelguen de la soga, va a haber mas o menos
//peso que tire hacia abajo, que puede jugar a favor o en contra si queremos poner cosas arriba
FBody[] steps = new FBody[20];
FWorld world;

int boxWidth = 400/(steps.length) - 2;



void setup(){
  

size(1000,600);

/* inicializacion */

Fisica.init(this);
puenteY = altoPileta+45;
mundo = new FWorld(); //creo el mundo
mundo.setEdges();//crea unos bordes para que los elementos no se escapen del mundo
//los bordes no se ven porque para actualizarse necesira llamar
//a dos metodos en el draw
 agua = loadImage("agua.png");

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

/*Charly*/


Charlyimg = loadImage("Charly.png");

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


Brazo = new FBox(anchoBrazo,altoBrazo);
Brazo.setPosition(685,140);
mundo.add(Brazo);
Brazo.setGrabbable(false);
Brazo.setRotation(180);
Brazo.setName("Brazo");
Brazo.setStatic(true);

Mano = new FCircle(30); 
Mano.setStatic(true);
Mano.setPosition(656,99);
mundo.add(Mano);
Mano.setGrabbable(false);
Mano.setName("Mano");




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
  









}


void draw(){
  
  println("X: " + mouseX + "Y:" + mouseY);
  background(255);
  image(agua,0,0);
  mundo.step();//hace los calculos matematicos en los cuerpos que interactuan en 
  //frame
  mundo.draw(); //dibuja el mundo de fisica en el lugar
  textSize(36);
  fill(0);
  text(contador,50,50);
  
 /* if(<altoPileta){

mundo.setGravity(0,0);

} */
  
  
}

void contactStarted(FContact contacto){

//nunca se cual es el uno y cual es el dos, por lo tanto puedo averiguar 
//los nombres de los objetos
FBody body1 = contacto.getBody1();
FBody body2 =contacto.getBody2();



if (body1.getName() == "Mano" || body2.getName() == "Mano"){

//println("body1= " + body1.getName());
//println("body2= " + body2.getName());

contador ++;
println(contador);

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
