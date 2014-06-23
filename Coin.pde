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
