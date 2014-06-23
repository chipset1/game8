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
