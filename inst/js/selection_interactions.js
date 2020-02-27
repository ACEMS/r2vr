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
