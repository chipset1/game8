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
