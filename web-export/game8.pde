/* @pjs preload="healthTut.jpg, shotTut.jpg, square1.jpg"; 
 */

Player player;
Keyboard keyboard;
Camera camera;

PVector playerStart;

int frames = 50;

// rename to screen width and height
int game_width = 720;
int game_height = 512;

int level_width ,level_height;

// background made from http://www.openprocessing.org/sketch/50076
//2592 × 1936
PImage bImage;

PImage health;
PImage enemy;

ArrayList<Entity> entities;
// player bullets
ArrayList<Bullet> pBullets;

boolean showStart = true;

void setup() {
	size(712, 512);
	playerStart = new PVector(game_width / 2, game_height/2);
	player = new Player(playerStart.x, playerStart.y);
	keyboard = new Keyboard();

	bImage = loadImage("square1.jpg");

	health = loadImage("healthTut.jpg");
	enemy = loadImage("shotTut.jpg");

	PFont guiFont = createFont("Anonymous Pro Minus", 18);
	textFont(guiFont);

	level_width = bImage.width;
	level_height = bImage.height;

	camera = new Camera();

	entities = new ArrayList<Entity>();
	pBullets = new ArrayList<Bullet>();

	addBlocks();
	addCoins();
	addEnemies();
}


void reStart(){
	entities.clear();
	pBullets.clear();

	player.position.set(playerStart);
	player.currentHealth = Player.MAX_HEALTH;
	addCoins();
	addEnemies();
	addBlocks();
}

void addEnemies(){
	for (int i = 0; i < 40; ++i) {
		float x = random(0, level_width);
		float y = random(0, level_height);
		addEntity(new Enemy( new PVector(x, y)));	
	}
}

void addCoins(){
	for (int i = 0; i < 5; ++i) {
		float x = i % (level_width / 10);	
		float y = floor(i / (level_height/ 10));
		addEntity(new Coin(random(x, level_width), random(y, level_height)));
	}
}

void addBlocks(){
	int numBlock = 30;
	for (int i = 0; i < numBlock; ++i) {
		float x = i % (level_width / (numBlock/2));	
		float y = floor(i / (level_height/ (numBlock/2)));
		float size = random(Block.MIN_SIZE, Block.MAX_SIZE);
		addEntity( new Block(new PVector(random(x, level_width - size),random(y, level_height - size)),size));
	}
}

float lastMillis = 0;

void draw() {

	if(showStart){
		startScreen();
		fill(0);
		textSize(18);
		text("click to start", 20 ,60);
		if(mousePressed){
			showStart = false;
		}
		return;
	}

	background(255);
	translate(-camera.offsetX, -camera.offsetY);
	camera.updatePosition();

	image(bImage,0,0);
	
    float deltaTime;
    long nextMillis = millis();
    if (0 == lastMillis) {
      deltaTime = 0;
    } else {
      deltaTime = (nextMillis - lastMillis)/1000;
    }
    lastMillis = nextMillis;
    // fill(0,200,0,180);
    // rect(camera.offsetX , camera.offsetY , game_width, game_height);
    if(player.currentHealth <= 0 ) reStart();
	player.display();
	player.update(deltaTime);

	updateEntities(deltaTime);
	updatePlayerBullets(deltaTime);
}

void startScreen(){
	// tutorial screen
	image(enemy, 0,0);
	image(health, (game_width - (health.width)),(game_height - (health.height)));
	// startScreen();
}

void updatePlayerBullets(float dt){
	for (int i = pBullets.size() - 1; i > 0; i--) {
		Bullet b = pBullets.get(i);	

		if(b.isDead) pBullets.remove(i);

		b.display();
		b.update(dt);
	}
}

void addBullet(Bullet b){
	pBullets.add(b);
}

void addEntity(Entity e){
	entities.add(e);
}

void updateEntities(float dt){
	for (int i = entities.size() - 1; i > 0; i--) {
		Entity e = entities.get(i);		
		if(e.isDead) entities.remove(i);

		e.display();
		e.update(dt);
		if(!(e instanceof Bullet || e instanceof Block)  ){
			player.drawMarker(e , e.fillColor);
		}
		if(e.collidesBox(player)){
			e.collidesWith(player);
		}
		// if not on screen continue
		if( !e.isOnScreen() ) continue;
		// enemies bullet collision only checked when on screen
		if(e instanceof Enemy){
			bulletCollision(e);
		}

	}
}

void bulletCollision(Entity e){
	for (Bullet b : pBullets) {
		if(b.collidesBox(e)){
			e.isDead = true;
		}
	}
}

PVector randomVector(){
  PVector pvec = new PVector(random(-1,1), random(-1,1), 0);
  pvec.normalize();
  return pvec;
}

PVector randomVector(float range){
  PVector pvec = new PVector(random(-range,range), random(-range,range), 0);
  pvec.normalize();
  return pvec;
}


void keyPressed(){
	keyboard.pressKey(key, keyCode);
}

void keyReleased(){
	keyboard.releaseKey(key, keyCode);
}
class Block extends Entity{

	color[]palette = {#D59891,#D9A8A4,#DFA89D,#EBA59E,#DEAAAA,#C7B4B5,#D8AFAD,#DBAFAA,#E3B0A8,#E0B2B2,#E3B4B4,#DCB8B0,#E7B6AC,#DCBEBA,#E8BDB9,#D3C5C4,#EFBCBA,#CDCFC3,#E6C8C2,#D9CCD1,#D1D1C9,#EDC9C9,#E4CFCE,#E7CFD1,#D9DAD2,#F0D4CD,#DBDBD3,#EAD9D6,#E2DDE1,#D9E3DA,#E8E3E8,#F3E2E2,#E6E8DE,#F6E4E1,#E9E9E2,#F7E5E6,#E9EDE1,#F1ECEB,#EEF0EE,#F7EEEF,#ECF2EC,#F0F6F0};
	static final int MAX_SIZE = 200;
	static final int MIN_SIZE = 100;

	float velScale = 0;
	color strokeColor;

	Block(PVector pos, float size){
		position = pos;
		acceleration = new PVector(random(-0.01,0.01), random(-0.01,0.01));
		velocity = new PVector();
		velScale = map(size, MIN_SIZE, MAX_SIZE, 0.98, 0.7);
		setSize(size, size);
		fillColor = palette[(int) random(0, palette.length)];
		strokeColor = palette[(int) random(0, palette.length)];
	}

	void collidesWith(Player player){
		player.velocity.mult(velScale);
	}

	void display(){
		// fill(fillColor, 180);
		strokeWeight(10);
		stroke(strokeColor);
		fill(fillColor, 220);
		rect(position.x, position.y, width, height);
	}

	void update(float dt){
		// warpLevelBounds(width);
		// acceleration.mult(2);
		// acceleration.mult(dt);
		// velocity.add(acceleration);
		// position.add(velocity);
		// velocity.mult(0);
	}

}
class Bullet extends Entity{
	
	boolean playerBullet = true;
	
	int currentLife;

	float minSizeOffset = 0.3;
	float maxSizeOffset = 0.7;

	int MAX_SIZE = 100;

	int lifeTime = 100;

	int strokeColor;
	float mass;

	Bullet(PVector pos, PVector acc){
		position = pos.get();
		velocity = new PVector(0,0);
		acceleration = acc;
		mass = 1;
		setSize(5, 5);
		strokeColor = color(random(120, 200), random(120, 200), 255);

		currentLife = lifeTime;
	}

	Bullet(PVector pos, PVector acc, color c){
		position = pos.get();
		velocity = new PVector(0,0);
		acceleration = acc;
		mass = 1;
		setSize(5, 5);
		strokeColor = c;	

		currentLife = lifeTime;
	}

	void display(){
		// map life
		float ml = map(currentLife, lifeTime, 0, minSizeOffset, maxSizeOffset);
		// plus size 
		float ps = constrain(ml, minSizeOffset, maxSizeOffset);
		width += ps;
		height+= ps;
		// higher width = lower alpha	
		float alpha = map(width, 0, MAX_SIZE, 255, 100);
		noStroke();
		fill(strokeColor, alpha);
		rect(position.x , position.y, width, height);
	}

	void collidesWith(Player player){
		if(playerBullet) return;
		player.currentHealth -= 10;
		isDead = true;
	}

	void update(float dt){
		
		if(width > MAX_SIZE) isDead = true;

		velocity.add(acceleration);

		velocity.mult(dt);
		velocity.mult(0.98);
		position.add(velocity);
		velocity.mult(0);
		currentLife -=1;
	}

}
class Camera {

	float offsetX, offsetY;
  	int rightEdge  = level_width - game_width;
	int bottomEdge = level_height - game_height;

	Camera(){

	}

	void updatePosition() {
	  offsetX = player.position.x - game_width/2;
	  offsetY = player.position.y - game_height/2;

	  if(offsetX < 0) {
	    offsetX= 0;
	  }
	  if(offsetY < 0) {
	    offsetY = 0;
	  }
	  if(offsetX > rightEdge) {
	    offsetX = rightEdge;
	  }
	  if(offsetY > bottomEdge) {
	   offsetY = bottomEdge;
	  }
	}
}
class Coin extends Entity{

	Coin(float x, float y){
		position = new PVector(x,y);
		fillColor = color(0, random(200, 255), 10);
	}

	void collidesWith(Player player){
		player.currentHealth+=20;
		isDead = true;
	}

	void display(){
		fill(fillColor);
		ellipse(position.x, position.y, 10, 10);
	}

	void update(float dt){

	}

}
class Enemy extends Entity{

	Timer moveTimer;
	Timer shotTimer;

    float moveRadius = 200;
	float wandertheta = 0;

	// for steering 
	float maxSpeed = 5;
	float maxForce = 0.45;
	
	Enemy(PVector pos){
		acceleration = new PVector();
		velocity = new PVector(0,0);
		setSize(20, 20);
		position = pos;		
		fillColor = color(#408CDE);

		moveTimer = new Timer(500,0);
		shotTimer = new Timer(4200, 0);
	}		

	void collidesWith(Player player){
		super.collidesWith(player);
	}

	void update(float dt){
		if( PVector.dist(player.position, position) > game_width ){
			return;
		}
		if(moveTimer.canRun()){
			wandertheta = random(-PI/2, PI/2);
		}
		if( PVector.dist(player.position, position) < 150){
			wandertheta = random(-PI, PI);
		}

		wander();
		acceleration.mult(50);
		acceleration.mult(dt);
		velocity.add(acceleration);
		velocity.mult(0.98);
		position.add(velocity);
		acceleration.mult(0);
	}

	void wander() {
		//modified from Nature of Code agent wander example
	    float wanderR = 25;         // Radius for our "wander circle"
	    float wanderD = 50;         // Distance for our "wander circle"

	    PVector circleloc = velocity.get();    // Start with velocity
	    circleloc.normalize();            // Normalize to get heading
	    circleloc.mult(wanderD);          // Multiply by distance
	    circleloc.add(position);               // Make it relative to boid's location
	    
	    // head towards player
	    float h = PVector.sub(player.position, position).heading2D();    

	    PVector circleOffSet = new PVector(wanderR*cos(wandertheta+h), wanderR*sin(wandertheta+h));
	    PVector target = PVector.add(circleloc,circleOffSet);
	    seek(target);

	    // drawWanderStuff(position,circleloc,target,wanderR);
    }  

    void drawWanderStuff(PVector location, PVector circle, PVector target, float rad) {
	  stroke(0); 
	  noFill();
	  ellipseMode(CENTER);
	  ellipse(circle.x,circle.y,rad*2,rad*2);
	  ellipse(target.x,target.y,4,4);
	  line(position.x,position.y,circle.x,circle.y);
	  line(circle.x,circle.y,target.x,target.y);
	}


	void seek(PVector target) {
		//modified from Nature of Code agent wander example
	    PVector desired = PVector.sub(target, position);  
	    // Scale to maximum speed
	    desired.normalize();
	    desired.mult(maxSpeed);
	    shoot(desired);
	    // Steering = Desired minus velocity
	    PVector steer = PVector.sub(desired,velocity);
	    steer.limit(maxForce);  // Limit to maximum steering force
	    
	    acceleration.add(steer);
	}

  	void shoot(PVector target){
  		if( !(shotTimer.canRun()) ) return; 
  		PVector t = target.get();
  		t.normalize();
  		t.mult(200);
  		Bullet b = new Bullet(position, t, color(255,0,0));
  		b.minSizeOffset = 0.4;
  		b.playerBullet = false;
		addEntity(b);  		
  	}

	void display(){
		noStroke();
		fill(fillColor);
		rect(position.x, position.y, width, height);
	}
}

// 
abstract class Entity{
	PVector position, velocity, acceleration;

	float width = -1;
	float height = -1;
	
	boolean isDead = false;

	float mass = -1;

	color fillColor;

	abstract void display();
	abstract void update(float dt);

	// fix
	void collidesWith(Player player){

	}

	void setSize(float w, float h){
		width = w;
		height = h;
	}

	boolean collidesBox(Entity e){
		// edges for A
		float a_left= position.x; 
  		float a_right = position.x + width;
  		float a_top = position.y;
  		float a_bottom = position.y + height;
		// edges for B
  		float b_left= e.position.x; 
  		float b_right = e.position.x + e.width;
  		float b_top = e.position.y;
  		float b_bottom = e.position.y + e.height;

  		if(a_right >= b_left && a_left <= b_right && a_bottom >= b_top && a_top <= b_bottom){
  			return true;
  		}
  		return false;
	}

	void levelBounds(){
		if(position.x > level_width - width){
			velocity.x *= -1;
		}
		if(position.x < 0 ){
			velocity.x *= -1;
		}
		if(position.y > level_height - height ){
			velocity.y *= -1;
		}
		if(position.y <  0){
			velocity.y *= -1;
		}
	}

	void warpLevelBounds(float b){
		float buffer = b;
		if(position.x > level_width + buffer){
			position.x = -buffer;
		}
		if(position.x < 0 - buffer){
			position.x = level_width;
		}
		if(position.y > level_height + buffer){
			position.y = -buffer;
		}
		if(position.y <  0 -  buffer){
			position.y = level_height ; 
		}
	}

	void warpBounds(float b){
		float buffer = b;
		if(position.x > game_width + buffer){
			position.x = -buffer;
		}
		if(position.x < 0 - buffer){
			position.x = game_width;
		}
		if(position.y > game_height + buffer){
			position.y = -buffer;
		}
		if(position.y <  0 -  buffer){
			position.y = game_height ; 
		}
	}

	boolean isOnScreen(){ 
	    float buffer = width;
	    if(position.x < camera.offsetX + game_width + buffer && 
	    		position.x > camera.offsetX - buffer && 
	    		position.y < camera.offsetY + game_height + buffer && 
	    		position.y > camera.offsetY - buffer){
	    		// println("yes");
	    		return true;
	    }
	    return false;
	}

}
class Keyboard {
  Boolean holdingUp,holdingRight,holdingLeft,holdingDown,holdingZ,
  holdingW,holdingA,holdingS,holdingD,holdingM, holdingSpace;
  
  Keyboard() {
    holdingUp=holdingRight=holdingLeft=holdingDown=holdingZ=holdingW=holdingA=holdingS=holdingD=holdingM=holdingSpace=false;
  }

  void pressKey(int key,int keyCode) {
    if (keyCode == UP) {
      holdingUp = true;
    }
    if (keyCode == LEFT) {
      holdingLeft = true;
    }
    if (keyCode == RIGHT) {
      holdingRight = true;
    }
    if (keyCode == DOWN) {
      holdingDown = true;
    }
    if(key == ' '){
      holdingSpace = true;
    }
    if (key == 'z' || key == 'Z') {
      holdingZ = true;      
    }
    if (key == 'w' || key == 'W') {
      holdingW = true;      
    }
    if (key == 'a' || key == 'A') {
      holdingA = true;      
    }
    if (key == 's' || key == 'S') {
      holdingS = true;      
    }
    if (key == 'd' || key == 'D') {
      holdingD = true;      
    }
    if (key == 'm' || key == 'M') {
      holdingM = true;      
    }
   
    /* // reminder: for keys with letters, check "key"
       // instead of "keyCode" !
    if (key == 'r') {
      // reset program?
    }
    if (key == ' ') {
      holdingSpace = true;
    }*/
  }
  void releaseKey(int key,int keyCode) {
    if (keyCode == UP) {
      holdingUp = false;
    }
    if (keyCode == LEFT) {
      holdingLeft = false;
    }
    if (keyCode == RIGHT) {
      holdingRight = false;
    }
    if (keyCode == DOWN) {
      holdingDown = false;
    }
    if(key == ' '){
      holdingSpace = false;
    }
    if (key == 'z' || key == 'Z') {
      holdingZ = false;      
    }
    if (key == 'w' || key == 'W') {
      holdingW = false;      
    }
    if (key == 'a' || key == 'A') {
      holdingA = false;      
    }
    if (key == 's' || key == 'S') {
      holdingS = false;      
    }
    if (key == 'd' || key == 'D') {
      holdingD = false;      
    }
    if (key == 'm' || key == 'M') {
      holdingD = false;      
    }
  }
}
class Player extends Entity{

  int points = 0;

  float damping = 0.98;
  float speed = 15;
  float maxspeed = 8;

  float bulletSpeed = 200;

  static final int MAX_HEALTH = 150;
  int currentHealth = MAX_HEALTH;

  Timer bulletTimer;

  int markerSize = 7;

  Player(float x, float y) {
    position = new PVector(x, y);
    velocity = new PVector(0, 0);
    acceleration = new PVector(0,0);
    mass = 0.5;
    setSize(20, 20);

    bulletTimer = new Timer(500,0);
  }

  void update(float dt) {
    textSize(15);
    fill(0);
    if(mousePressed && bulletTimer.canRun() ){
      fire();
    } 

    checkInput();
    levelBounds();

    acceleration.mult(dt);
    velocity.add(acceleration);
    velocity.mult(damping);
    velocity.limit(maxspeed);
    position.add(velocity);
    acceleration.mult(0);
  }

  void drawMarker(Entity e, color c){

    float markerOffset = (game_width /2);
    PVector markerTarget = PVector.sub(e.position, player.position);

    if(markerTarget.mag() > markerOffset){
      markerTarget.normalize();  
      markerTarget.mult( markerOffset );
    }
    noStroke();
    fill(c);
    rect(player.position.x + markerTarget.x  * 0.6, player.position.y + markerTarget.y * 0.6, markerSize, markerSize);
  }


  void fire(){
    PVector acc = PVector.sub(new PVector(mouseX + camera.offsetX, mouseY + camera.offsetY), position);
    acc.normalize();
    acc.mult(bulletSpeed);
    addBullet( new Bullet(position, acc));
  }

  void drawHealthBar(){
    // health bar width and height
    float w = 50;
    float h = 50;
    
    //map stop angle 
    float stop = map(currentHealth, 0, MAX_HEALTH, 0, TWO_PI);
    noStroke();
    fill(0,200,0, 180);
    arc(position.x + width / 2, position.y + height / 2, width + w, height + h, 0, stop);
  }

  void display() {
    drawHealthBar();
    noStroke();

    fill(0, 80);
    rect(position.x + 3, position.y + 3, width, height);
    
    strokeWeight(1);
    stroke(0);
    fill(255);
    rect(position.x, position.y, width, height);
    
  }

  void checkInput() {
    //arrows input check
    if (keyboard.holdingLeft || keyboard.holdingA) {
        acceleration.x -= speed;
    } 
    else if ( keyboard.holdingRight || keyboard.holdingD) {
      acceleration.x += speed;
    }
    if (keyboard.holdingUp || keyboard.holdingW) {
      acceleration.y -= speed;
    }
    else if (keyboard.holdingDown ||keyboard.holdingS) {
      acceleration.y += speed;
    }
  }

}// end of player class

//HTIMER 
class Timer {
	private int lastInterval, interval, cycleCounter, numCycles;
	private boolean usesFrames = false;

	public Timer(int timerInterval, int numberOfCycles) {
		interval = timerInterval;
		numCycles = numberOfCycles;
	}
	
	public void useFrames() {
		usesFrames = true;
	}

	// find better name
	public boolean canRun() {
		int curr = (usesFrames)? frameCount : millis();
		if(lastInterval < 0) lastInterval = curr;
		if(curr-lastInterval >= interval) {
			lastInterval = curr;
			if(numCycles > 0 && ++cycleCounter >= numCycles) stop();
			return true;
		}
		return false;
	}

	public void stop() {
		numCycles = 0;
		lastInterval = -1;
	}

}

