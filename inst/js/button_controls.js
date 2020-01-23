function GamepadButtonEvent(type, controllerId, index, details) {
  this.type = type;
  this.controllerId = controllerId;
  this.index = index;
  this.pressed = details.pressed;
  this.value = details.value;
}

AFRAME.registerComponent("button-controls", {
  schema: {
    enabled: { default: true },
    poll: { default: false }, // shouldn't be changed after init
    debug: { default: false }
  },

  init: function() {
    this.xrGamepads = [];
    this.addSessionEventListeners = this.addSessionEventListeners.bind(this);
    this.updateControllers = this.updateControllers.bind(this);
    this.emitButton0UpEvent = this.emitButtonUpEvent.bind(this, 0);
    this.emitButton0DownEvent = this.emitButtonDownEvent.bind(this, 0);
    this.emitButton1UpEvent = this.emitButtonUpEvent.bind(this, 1);
    this.emitButton1DownEvent = this.emitButtonDownEvent.bind(this, 1);

    let component = this;
    this.buttons = {}; // keys are controller ids, values are array of booleans

    // There's no gamepad event for non-Chrome browsers in VR mode, any browser in flat mode, mobile nor destop
    let sceneEl = this.el.sceneEl;
    if ("PointerEvent" in window) {
      console.log("Using Pointer events for button-controls");
      addListeners("pointerdown", "pointerup");
    } else if ("TouchEvent" in window) {
      console.log("No Pointer events, falling back to Touch events");
      addListeners("touchstart", "touchend");
    } else {
      console.log("No Pointer nor Touch events, falling back to mouse events");
      addListeners("mousedown", "mouseup");
    }

    function addListeners(downEventName, upEventName) {
      sceneEl.addEventListener(downEventName, function(evt) {
        // TODO: remove next line when no one's on A-Frame 0.8.0 or below
        if (evt.target.classList.contains("a-enter-vr-button")) {
          return;
        }
        component.el.emit(
          "buttondown",
          new GamepadButtonEvent("buttondown", "screen", 0, {
            pressed: true,
            value: 1.0
          })
        );
        if (downEventName !== "mousedown") {
          evt.stopPropagation();
        }
      });
      sceneEl.addEventListener(upEventName, function(evt) {
        // TODO: remove next line when no one's on A-Frame 0.8.0 or below
        if (evt.target.classList.contains("a-enter-vr-button")) {
          return;
        }
        component.el.emit(
          "buttonup",
          new GamepadButtonEvent("buttonup", "screen", 0, {
            pressed: false,
            value: 0.0
          })
        );
        if (upEventName !== "mouseup") {
          evt.stopPropagation();
        }
      });
    }

    if (this.data.debug) {
      console.log("button-controls init - this.data:", this.data);
      window.addEventListener("vrdisplaypresentchange", event => {
        console.log(
          "vrdisplaypresentchange",
          event.display && event.display.isPresenting
        );
        this.gamepadsListed = false;
      });

      window.addEventListener("gamepadconnected", function(e) {
        console.log(
          "Gamepad connected at index %d: %s. %d buttons, %d axes.",
          e.gamepad.index,
          e.gamepad.id,
          e.gamepad.buttons.length,
          e.gamepad.axes.length
        );
      });
      window.addEventListener("gamepaddisconnected", function(e) {
        console.log(
          "Gamepad disconnected from index %d: %s",
          e.gamepad.index,
          e.gamepad.id
        );
      });

      let gamepads = navigator.getGamepads();
      console.log("regular gamepads:", gamepads);
    }
  },

  play: function() {
    let sceneEl = this.el.sceneEl;
    if (this.data.poll) {
      this.updateControllers({});
      sceneEl.addEventListener("controllersupdated", this.updateControllers);
    } else {
      this.addSessionEventListeners();
      sceneEl.addEventListener("enter-vr", this.addSessionEventListeners);
    }
  },

  pause: function() {
    let sceneEl = this.el.sceneEl;
    if (this.data.poll) {
      sceneEl.removeEventListener("controllersupdated", this.updateControllers);
    } else {
      this.removeSessionEventListeners();
      sceneEl.removeEventListener("enter-vr", this.addSessionEventListeners);
    }
  },

  addSessionEventListeners: function() {
    let sceneEl = this.el.sceneEl;
    if (!sceneEl.xrSession) {
      return;
    }
    sceneEl.xrSession.addEventListener(
      "selectstart",
      this.emitButton0DownEvent
    );
    sceneEl.xrSession.addEventListener("selectend", this.emitButton0UpEvent);
    sceneEl.xrSession.addEventListener(
      "squeezestart",
      this.emitButton1DownEvent
    );
    sceneEl.xrSession.addEventListener("squeezeend", this.emitButton1UpEvent);
  },

  removeSessionEventListeners: function() {
    let sceneEl = this.el.sceneEl;
    if (!sceneEl.xrSession) {
      return;
    }
    sceneEl.xrSession.removeEventListener(
      "selectstart",
      this.emitButton0DownEvent
    );
    sceneEl.xrSession.removeEventListener("selectend", this.emitButton0UpEvent);
    sceneEl.xrSession.removeEventListener(
      "squeezestart",
      this.emitButton1DownEvent
    );
    sceneEl.xrSession.removeEventListener(
      "squeezeend",
      this.emitButton1UpEvent
    );
  },

  emitButtonDownEvent: function(buttonInd, evt) {
    if (this.data.debug) {
      console.log("emitButtonDownEvent", buttonInd, evt);
    }
    let gamepad = this.syntheticGamepad(evt.inputSource);
    this.el.emit(
      "buttondown",
      new GamepadButtonEvent(
        "buttondown",
        gamepad.id,
        buttonInd,
        gamepad.buttons[buttonInd]
      )
    );
  },

  emitButtonUpEvent: function(buttonInd, evt) {
    if (this.data.debug) {
      console.log("emitButtonUpEvent", buttonInd, evt);
    }
    let gamepad = this.syntheticGamepad(evt.inputSource);
    this.el.emit(
      "buttonup",
      new GamepadButtonEvent(
        "buttonup",
        gamepad.id,
        buttonInd,
        gamepad.buttons[buttonInd]
      )
    );
  },

  syntheticGamepad: function(inputSource) {
    let gamepad;
    if (inputSource && inputSource.gamepad) {
      gamepad = {
        id: inputSource.gamepad.id,
        buttons: inputSource.gamepad.buttons
      };
    } else {
      gamepad = {
        buttons: [
          { pressed: true, value: 0.75 },
          { pressed: false, value: 0.25 }
        ]
      };
    }
    if (!gamepad.id && inputSource.profiles[0]) {
      // 1st profile may be undefined
      gamepad.id =
        inputSource.profiles[0] +
        (inputSource.handedness !== "none" ? " " + inputSource.handedness : "");
    }
    if (!gamepad.id && inputSource.targetRayMode) {
      gamepad.id =
        inputSource.targetRayMode +
        (inputSource.handedness !== "none" ? " " + inputSource.handedness : "");
    }
    return gamepad;
  },

  /**
   * WebXR controller added or removed
   */
  updateControllers: function(evt) {
    console.log("updateControllers", evt);
    this.gamepadsListed = false;

    let sceneEl = this.el.sceneEl;
    if (!sceneEl.xrSession) {
      return;
    }
    this.xrGamepads = [];
    for (let i = 0; i < sceneEl.xrSession.inputSources.length; ++i) {
      this.xrGamepads.push(
        this.syntheticGamepad(sceneEl.xrSession.inputSources[i])
      );
    }
    console.log("xrGamepads:", this.xrGamepads);
  },

  tick: function(time, deltaTime) {
    let component = this;

    if (component.data.enabled) {
      let regularGamepads = navigator.getGamepads(); // non-WebXR
      if (component.data.debug && !component.gamepadsListed) {
        console.log(
          "XR gamepads:",
          component.xrGamepads,
          "   regular:",
          regularGamepads
        );
        component.gamepadsListed = true;
      }
      scan(component.xrGamepads);
      scan(regularGamepads);
    }

    function scan(gamepads) {
      for (let i = 0; i < gamepads.length; ++i) {
        let gamepad = gamepads[i];
        if (gamepad) {
          if (component.buttons[gamepad.id]) {
            for (let j = 0; j < gamepad.buttons.length; ++j) {
              let buttonPressed = gamepad.buttons[j].pressed;
              let oldButtonPressed = component.buttons[gamepad.id][j];
              if (buttonPressed && !oldButtonPressed) {
                component.el.emit(
                  "buttondown",
                  new GamepadButtonEvent(
                    "buttondown",
                    gamepad.id,
                    j,
                    gamepad.buttons[j]
                  )
                );
              } else if (!buttonPressed && oldButtonPressed) {
                component.el.emit(
                  "buttonup",
                  new GamepadButtonEvent(
                    "buttonup",
                    gamepad.id,
                    j,
                    gamepad.buttons[j]
                  )
                );
              }
              component.buttons[gamepad.id][j] = buttonPressed;
            }
          } else if (gamepad.buttons && gamepad.buttons.length) {
            if (component.data.debug) {
              console.log("setting up gamepad", gamepad.id, gamepad.buttons);
            }

            let buttonsPressed = [];
            for (let j = 0; j < gamepad.buttons.length; ++j) {
              buttonsPressed.push(gamepad.buttons[j].pressed);
              if (gamepad.buttons[j].pressed) {
                component.el.emit(
                  "buttondown",
                  new GamepadButtonEvent(
                    "buttondown",
                    gamepad.id,
                    j,
                    gamepad.buttons[j]
                  )
                );
              } else {
                component.el.emit(
                  "buttonup",
                  new GamepadButtonEvent(
                    "buttonup",
                    gamepad.id,
                    j,
                    gamepad.buttons[j]
                  )
                );
              }
            }
            component.buttons[gamepad.id] = buttonsPressed;
          }
        }
      }
    }
  },

  remove: function() {}
});
