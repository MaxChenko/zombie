class Wall extends SquareCollider {
  Wall(float x, float y, float size) {
    super(x, y, size);
  }

  void display() {
    fill(100, 100, 100); // Gray color for walls
    rect(x, y, size, size);
  }
}
