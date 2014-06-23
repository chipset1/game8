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
