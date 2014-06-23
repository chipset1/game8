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

