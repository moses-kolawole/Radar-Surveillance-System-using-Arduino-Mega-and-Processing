#include <Servo.h>
#include <FastLED.h>

#define trigPin 7
#define echoPin 6
#define servoPin 9
#define ledPin 5

int buzzpin = 11;

#define NUM_LEDS 16   // change if your ring is different

Servo radarServo;
CRGB leds[NUM_LEDS];

int distance;

void setup() {

  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);
  pinMode(buzzpin, OUTPUT);

  radarServo.attach(servoPin);

  FastLED.addLeds<WS2812, ledPin, GRB>(leds, NUM_LEDS);

  Serial.begin(9600);
}

void loop() {

  for (int angle = 15; angle <= 165; angle++) {

    radarServo.write(angle);

    distance = getDistance();

    Serial.print(angle);
    Serial.print(",");
    Serial.println(distance);

    updateLED(distance);

    delay(8);
  }

  for (int angle = 165; angle >= 15; angle--) {

    radarServo.write(angle);

    distance = getDistance();

    Serial.print(angle);
    Serial.print(",");
    Serial.println(distance);

    updateLED(distance);

    delay(8);
  }
}

int getDistance() {

  digitalWrite(trigPin, LOW);
  delayMicroseconds(5);

  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);

  long duration = pulseIn(echoPin, HIGH, 30000);

  if (duration == 0) return -1;

  return duration * 0.034 / 2;
}


  void updateLED(int dist) {

  for (int i = 0; i < NUM_LEDS; i++) {
    leds[i] = CRGB::Black;
  }

  if (dist > 0 && dist < 20) {

    for (int i = 0; i < NUM_LEDS; i++) {
      leds[i] = CRGB::Red;
    }

    digitalWrite(buzzpin, HIGH);

  } else {

    for (int i = 0; i < NUM_LEDS; i++) {
      leds[i] = CRGB::Green;
    }

    digitalWrite(buzzpin, LOW);
  }
  FastLED.show();
}

