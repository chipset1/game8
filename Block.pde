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
