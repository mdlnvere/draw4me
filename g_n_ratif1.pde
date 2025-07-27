int num = 200;
float range = 2.5;
int margin = 50;

ArrayList<PVector[]> paths = new ArrayList<PVector[]>();
ArrayList<Float> noiseOffsetsX = new ArrayList<Float>();
ArrayList<Float> noiseOffsetsY = new ArrayList<Float>();
ArrayList<PVector> directions = new ArrayList<PVector>();

boolean drawing = true;

void setup() {
  size(800, 800);
  background(0);
  frameRate(60);

  addNewPath(width/2, height/2);
}

void draw() {
  if (drawing) {
    //background(0, 20);
    for (int p = 0; p < paths.size(); p++) {
      updatePath(paths.get(p), p);
      drawPath(paths.get(p));
    }
  }
  // Si drawing == false, on ne met rien à jour ni n'efface l'écran, donc le dessin reste figé
}

void mousePressed() {
  addNewPath(width/2, height/2);
}

void keyPressed() {
  if (key == ' ') {  
    drawing = !drawing;
    if (drawing) {
      addNewPath(width/2, height/2); 
    }
  }
}

void addNewPath(float startX, float startY) {
  PVector[] path = new PVector[num];
  for (int i = 0; i < num; i++) {
    path[i] = new PVector(startX, startY);
  }
  paths.add(path);
  
  float angle = random(TWO_PI);
  directions.add(new PVector(cos(angle), sin(angle)).mult(range));
  
  noiseOffsetsX.add(random(1000));
  noiseOffsetsY.add(random(2000));
}

void updatePath(PVector[] path, int index) {
  for (int i = 1; i < num; i++) {
    path[i - 1].set(path[i]);
  }

  PVector last = path[num - 2].copy();
  PVector dir = directions.get(index);

  float t = frameCount * 0.01;
  float offsetX = noiseOffsetsX.get(index);
  float offsetY = noiseOffsetsY.get(index);

  float angleX = map(noise(offsetX + t), 0, 1, -PI/4, PI/4);
  float angleY = map(noise(offsetY + t), 0, 1, -PI/4, PI/4);

  float currentAngle = dir.heading();
  currentAngle += angleX;
  dir = PVector.fromAngle(currentAngle).mult(range);
  directions.set(index, dir);

  PVector next = PVector.add(last, dir);

  boolean bounced = false;
  if (next.x < margin) {
    next.x = margin + (margin - next.x);
    dir.x *= -1;
    bounced = true;
  } else if (next.x > width - margin) {
    next.x = (width - margin) - (next.x - (width - margin));
    dir.x *= -1;
    bounced = true;
  }
  if (next.y < margin) {
    next.y = margin + (margin - next.y);
    dir.y *= -1;
    bounced = true;
  } else if (next.y > height - margin) {
    next.y = (height - margin) - (next.y - (height - margin));
    dir.y *= -1;
    bounced = true;
  }

  if (bounced) {
    directions.set(index, dir);
  }

  path[num - 1] = next;
}

void drawPath(PVector[] path) {
  noFill();
  stroke(255, 180);
  beginShape();
  for (int i = 0; i < num; i++) {
    curveVertex(path[i].x, path[i].y);
  }
  endShape();
}
