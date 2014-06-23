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
