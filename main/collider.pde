abstract class Collider {
  float x, y;
  
  Collider(float x, float y) {
    this.x = x;
    this.y = y;
  }
  
  abstract boolean checkCollision(Collider other);
}

class CircleCollider extends Collider {
  float radius;
  
  CircleCollider(float x, float y, float radius) {
    super(x, y);
    this.radius = radius;
  }
  
  @Override
  boolean checkCollision(Collider other) {
    if (other instanceof CircleCollider) {
      return circleCircleCollision(this, (CircleCollider) other);
    } else if (other instanceof SquareCollider) {
      return circleSquareCollision(this, (SquareCollider) other);
    }
    return false;
  }
  
  boolean circleCircleCollision(CircleCollider c1, CircleCollider c2) {
    float distSq = sq(c1.x - c2.x) + sq(c1.y - c2.y);
    float radiusSum = c1.radius + c2.radius;
    return distSq <= radiusSum * radiusSum;
  }
  
  boolean circleSquareCollision(CircleCollider c, SquareCollider s) {
    float closestX = constrain(c.x, s.x, s.x + s.size);
    float closestY = constrain(c.y, s.y, s.y + s.size);
    float distX = c.x - closestX;
    float distY = c.y - closestY;
    return (distX * distX + distY * distY) <= (c.radius * c.radius);
  }
  
  void display() {
    fill(0, 0, 255, 150);
    ellipse(x, y, radius * 2, radius * 2);
  }
}

class SquareCollider extends Collider {
  float size;
  
  SquareCollider(float x, float y, float size) {
    super(x, y);
    this.size = size;
  }
  
  @Override
  boolean checkCollision(Collider other) {
    if (other instanceof SquareCollider) {
      return squareSquareCollision(this, (SquareCollider) other);
    } else if (other instanceof CircleCollider) {
      return ((CircleCollider) other).circleSquareCollision((CircleCollider) other, this);
    }
    return false;
  }
  
  boolean squareSquareCollision(SquareCollider s1, SquareCollider s2) {
    return !(s1.x + s1.size < s2.x || s1.x > s2.x + s2.size ||
             s1.y + s1.size < s2.y || s1.y > s2.y + s2.size);
  }
  
  void display() {
    fill(255, 0, 0, 150);
    rect(x, y, size, size);
  }
}