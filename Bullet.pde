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
