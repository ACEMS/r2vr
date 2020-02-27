console.log('changed this file');

// TODO: REFACTOR 

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

// START BUTTON CONTROLS

AFRAME.registerComponent("selection-button-controls", {
  init: function() {
    let canvas_3d = document.getElementById("canvas3d");
    const option1Plane = document.getElementById("option1Plane");
    const option2Plane = document.getElementById("option2Plane");
    const option3Plane = document.getElementById("option3Plane");
    const option4Plane = document.getElementById("option4Plane");

    let isOption1Selected = false;
    let isOption2Selected = false;
    let isOption3Selected = false;
    let isOption4Selected = false;

    let imageAnnotated = [];

    let controlsEl = document.querySelector("[button-controls]");
    controlsEl.addEventListener("buttondown", () => {
      image_file = canvas_3d
        .getAttribute("class")
        .split("/")
        .pop();
      image_id = image_file.split(".")[0];

      postResponse = res => {
        // TODO: dynamic
        let data = {
          image_id: image_id,
          image_file: image_file,
          option_1: res.option_1,
          option_3: res.option_3,
          option_4: res.option_4,
          option_2: res.option_2
        };

        const endPoint = "https://test-api-koala.herokuapp.com/jaguar";

        fetch(endPoint, {
          method: "POST",
          body: JSON.stringify(data),
          headers: {
            "Content-Type": "application/json"
          }
        })
          .then(res => {
            console.log("Record added!", res);
            isPostHovered = false; // // // NEW
            console.log("isPostHovered reset to false to ensure the user will not POST the next image"); // // // NEW
            isOption1Selected = false;
            isOption2Selected = false;
            isOption3Selected = false;
            isOption4Selected = false;
          })
          .catch(err => {
            console.log(err);
          });
      };

      if (isPostHovered && !imageAnnotated.includes(image_id)) {
        imageAnnotated.push(image_id);
        console.log('imageAnnotated:', imageAnnotated);
        postPlane.setAttribute("color", "green");
        console.log("POST SELECTED!");
        let responses = {
          option_1: isOption1Selected ? 1 : 0,
          option_3: isOption3Selected ? 1 : 0,
          option_4: isOption4Selected ? 1 : 0,
          option_2: isOption2Selected ? 1 : 0
        }
        postResponse(responses);
      }
      if (isOption1Hovered && !imageAnnotated.includes(image_id)) {
        option1Plane.setAttribute("color", "green");
        console.log("OPTION 1 SELECTED!");
        isOption1Selected = true;
      }
      if (isOption2Hovered && !imageAnnotated.includes(image_id)) {
        option2Plane.setAttribute("color", "green");
        console.log("OPTION 2 SELECTED!");
        isOption2Selected = true;
      }
      if (isOption3Hovered && !imageAnnotated.includes(image_id)) {
        option3Plane.setAttribute("color", "green");
        console.log("OPTION 3 SELECTED!");
        isOption3Selected = true;
      }
      if (isOption4Hovered && !imageAnnotated.includes(image_id)) {
        option4Plane.setAttribute("color", "green");
        console.log("OPTION 4 SELECTED!");
        isOption4Selected = true;
      }
    });
  }
});

let isOption1Hovered = false;
let isOption2Hovered = false;
let isOption3Hovered = false;
let isOption4Hovered = false;
let isPostHovered = false;

AFRAME.registerComponent("intersection", {
  init: function() {
    // TODO: change somewhere more generic
    const questionPlane = document.getElementById("questionPlane");
    const option1Plane = document.getElementById("option1Plane");
    const option2Plane = document.getElementById("option2Plane");
    const option3Plane = document.getElementById("option3Plane");
    const option4Plane = document.getElementById("option4Plane");

    this.el.addEventListener("raycaster-intersection", evt => {
      // if question plane visible, then all planes visible => detect intersection
      if (questionPlane.getAttribute("visible")) {
        console.log("intersection occurred!");
        if (evt) {
          let els = evt.detail.els;
          console.log("all intersected elements: ", els);
          // TODO: less arbitrary based on total dom els with ID's
          if (els.length > 4) {
            els = [];
          }
          // TODO: Refactor
          if (
            els.some(el => el.id === "option1PlaneBoundary") ||
            els.some(el => el.id === "option3PlaneBoundary") ||
            els.some(el => el.id === "option4PlaneBoundary") ||
            els.some(el => el.id === "option2PlaneBoundary") ||
            els.some(el => el.id === "postPlaneBoundary")
          ) {
            isOption1Hovered = false;
            isOption2Hovered = false;
            isOption3Hovered = false;
            isOption4Hovered = false;
            isPostHovered = false;
          } else if (
            els.some(el => el.id === "option1Plane") ||
            els.some(el => el.id === "option1Text")
          ) {
            isOption1Hovered = true;
            isOption2Hovered = false;
            isOption3Hovered = false;
            isOption4Hovered = false;
            option1Plane.setAttribute("isOption1Hovered", true);
            isPostHovered = false;
          } else if (
            els.some(el => el.id === "option2Plane") ||
            els.some(el => el.id === "option2Text")
          ) {
            isOption1Hovered = false;
            isOption2Hovered = true;
            isOption3Hovered = false;
            isOption4Hovered = false;
            option2Plane.setAttribute("isOption2Hovered", true);
            isPostHovered = false;
          } else if (
            els.some(el => el.id === "option3Plane") ||
            els.some(el => el.id === "option3Text")
          ) {
            isOption1Hovered = false;
            isOption2Hovered = false;
            isOption3Hovered = true;
            isOption4Hovered = false;
            option3Plane.setAttribute("isOption3Hovered", true);
            isPostHovered = false;
          } else if (
            els.some(el => el.id === "option4Plane") ||
            els.some(el => el.id === "option4Text")
          ) {
            isOption1Hovered = false;
            isOption2Hovered = false;
            isOption3Hovered = false;
            isOption4Hovered = true;
            option4Plane.setAttribute("isOption4Hovered", true);
            isPostHovered = false;
          } else if (
            els.some(el => el.id === "postPlane") ||
            els.some(el => el.id === "postText")
          ) {
            isOption1Hovered = false;
            isOption2Hovered = false;
            isOption3Hovered = false;
            isOption4Hovered = false;
            isPostHovered = true;
            postPlane.setAttribute("isPostHovered", true);
          } else {
            isOption1Hovered = false;
            isOption2Hovered = false;
            isOption3Hovered = false;
            isOption4Hovered = false;
            isPostHovered = false;
            option1Plane.setAttribute("isOption1Hovered", false);
            option4Plane.setAttribute("isOption4Hovered", false);
            option3Plane.setAttribute("isOption3Hovered", false);
            option2Plane.setAttribute("isOption2Hovered", false);
            postPlane.setAttribute("isPostHovered", false);
          }
        }
      }
    });
  }
});
