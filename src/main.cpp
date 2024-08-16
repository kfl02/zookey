#include "HID-Project.h"
#include "AceButton.h"

// pins for buttons and the respective LEDs
const int button_left_pin = A1;
const int led_left_pin = A2;
const int button_middle_pin = A3;
const int led_middle_pin = A4;
const int button_right_pin = A5;
const int led_right_pin = A6;

// configure buttons
ace_button::AceButton button_left(button_left_pin);
ace_button::AceButton button_middle(button_middle_pin);
ace_button::AceButton button_right(button_right_pin);

// event handler for buttons
void handleEvent(ace_button::AceButton *, uint8_t, uint8_t);

void setup() {
  // setup pins
  pinMode(button_left_pin, INPUT_PULLUP);
  pinMode(button_middle_pin, INPUT_PULLUP);
  pinMode(button_right_pin, INPUT_PULLUP);
  pinMode(led_left_pin, OUTPUT);
  pinMode(led_middle_pin, OUTPUT);
  pinMode(led_right_pin, OUTPUT);

  // setup the keyboard. Has to be a BootKeyboard in order to handle caps, num and sroll lock
  BootKeyboard.begin();

  // set button event handlers
  button_left.setEventHandler(handleEvent);
  button_middle.setEventHandler(handleEvent);
  button_right.setEventHandler(handleEvent);
}

void loop() {
  // query state of caps, num and scroll lock and turn on/off LEDs accordingly
  digitalWrite(led_left_pin, (BootKeyboard.getLeds() & LED_NUM_LOCK) ? HIGH : LOW);
  digitalWrite(led_middle_pin, (BootKeyboard.getLeds() & LED_CAPS_LOCK) ? HIGH : LOW);
  digitalWrite(led_right_pin, (BootKeyboard.getLeds() & LED_SCROLL_LOCK) ? HIGH : LOW);
  
  // check button states
  button_left.check();
  button_middle.check();
  button_right.check();
}

void handleEvent(ace_button::AceButton *button, uint8_t eventType, uint8_t buttonState) {
  KeyboardKeycode k;

  // choose comma, space or period accoding to which button is vbeing used
  switch(button->getPin()) {
    case button_left_pin:
      k = KEY_COMMA;
      break;

    case button_middle_pin:
      k = KEY_SPACE;
      break;

    case button_right_pin:
      k = KEY_PERIOD;
      break;
  }

  // send press or release keyboard events according to button event
  if(eventType == ace_button::AceButton::kEventPressed) {
    BootKeyboard.press(k);
  } else if(eventType == ace_button::AceButton::kEventReleased) {
    BootKeyboard.release(k);
  }

  // make sure events get sent
  BootKeyboard.flush();
}
