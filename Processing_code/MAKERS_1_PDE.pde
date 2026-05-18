import processing.serial.*;

Serial myPort;

String data = "";

int angle = 0;
int distance = 0;

void setup() {

  size(1200, 700);

  smooth();

  // SHOW AVAILABLE PORTS
  printArray(Serial.list());

  /*
    CHANGE THE NUMBER BELOW
    Example:
    If your Arduino is COM10,
    use Serial.list()[0] or [1] depending
    on what appears in the console.
  */

  myPort = new Serial(this, Serial.list()[0], 9600);

  myPort.bufferUntil('\n');
}

void draw() {

  background(0);

  drawRadar();

  drawSweepLine();

  drawObject();

  drawText();
}

void serialEvent(Serial myPort) {

  data = myPort.readStringUntil('\n');

  if (data != null) {

    data = trim(data);

    String[] values = split(data, ',');

    // Arduino sends ONLY angle and distance
    if (values.length == 2) {

      angle = int(values[0]);

      distance = int(values[1]);
    }
  }
}

void drawRadar() {

  pushMatrix();

  translate(width/2, height - 50);

  stroke(0, 255, 0);

  strokeWeight(2);

  noFill();

  // Radar arcs
  arc(0, 0, 1000, 1000, PI, TWO_PI);
  arc(0, 0, 800, 800, PI, TWO_PI);
  arc(0, 0, 600, 600, PI, TWO_PI);
  arc(0, 0, 400, 400, PI, TWO_PI);
  arc(0, 0, 200, 200, PI, TWO_PI);

  // Radar angle lines
  line(-500, 0, 500, 0);

  line(0, 0,
       -500*cos(radians(30)),
       -500*sin(radians(30)));

  line(0, 0,
       -500*cos(radians(60)),
       -500*sin(radians(60)));

  line(0, 0,
       500*cos(radians(30)),
       -500*sin(radians(30)));

  line(0, 0,
       500*cos(radians(60)),
       -500*sin(radians(60)));

  popMatrix();
}

void drawSweepLine() {

  pushMatrix();

  translate(width/2, height - 50);

  stroke(0, 255, 0);

  strokeWeight(4);

  float x = 500 * cos(radians(angle));

  float y = -500 * sin(radians(angle));

  line(0, 0, x, y);

  popMatrix();
}

void drawObject() {

  // Detect object if within 20 cm
  if (distance > 0 && distance < 20) {

    pushMatrix();

    translate(width/2, height - 50);

    stroke(255, 0, 0);

    strokeWeight(10);

    float mappedDistance = map(distance, 0, 50, 0, 500);

    float x = mappedDistance * cos(radians(angle));

    float y = -mappedDistance * sin(radians(angle));

    point(x, y);

    popMatrix();
  }
}

void drawText() {

  fill(0, 255, 0);

  textSize(24);

  text("ANGLE: " + angle, 50, 50);

  text("DISTANCE: " + distance + " cm", 50, 90);

  // Detection status
  if (distance > 0 && distance < 20) {

    fill(255, 0, 0);

    textSize(30);

    text("OBJECT DETECTED", 800, 50);

  } else {

    fill(0, 255, 0);

    textSize(30);

    text("NO OBJECT", 850, 50);
  }
}
