AFRAME.registerComponent("binary-button-controls", {
  init: function() {
    let canvas_3d = document.getElementById("canvas3d");
    const waterPlane = document.getElementById("waterPlane");
    const preyPlane = document.getElementById("preyPlane");
    const treesPlane = document.getElementById("treesPlane");
    const vegetationPlane = document.getElementById("vegetationPlane");

    let isWaterSelected = false;
    let isPreySelected = false;
    let isTreesSelected = false;
    let isVegetationSelected = false;

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
          water: res.water,
          trees: res.trees,
          vegetation: res.vegetation,
          prey: res.prey
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
          water: isWaterSelected ? 1 : 0,
          trees: isTreesSelected ? 1 : 0,
          vegetation: isVegetationSelected ? 1 : 0,
          prey: isPreySelected ? 1 : 0
        }
        postResponse(responses);
      }
      if (isWaterHovered && !imageAnnotated.includes(image_id)) {
        waterPlane.setAttribute("color", "green");
        console.log("WATER SELECTED!");
        isWaterSelected = true;
      }
      if (isPreyHovered && !imageAnnotated.includes(image_id)) {
        preyPlane.setAttribute("color", "green");
        console.log("PREY SELECTED!");
        isPreySelected = true;
      }
      if (isTreesHovered && !imageAnnotated.includes(image_id)) {
        treesPlane.setAttribute("color", "green");
        console.log("TREES SELECTED!");
        isTreesSelected = true;
      }
      if (isVegetationHovered && !imageAnnotated.includes(image_id)) {
        vegetationPlane.setAttribute("color", "green");
        console.log("VEGETATION SELECTED!");
        isVegetationSelected = true;
      }
    });
  }
});

let isWaterHovered = false;
let isPreyHovered = false;
let isTreesHovered = false;
let isVegetationHovered = false;
let isPostHovered = false;

AFRAME.registerComponent("intersection", {
  init: function() {
    // TODO: change somewhere more generic
    const questionPlane = document.getElementById("questionPlane");
    const waterPlane = document.getElementById("waterPlane");
    const preyPlane = document.getElementById("preyPlane");
    const treesPlane = document.getElementById("treesPlane");
    const vegetationPlane = document.getElementById("vegetationPlane");

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
            els.some(el => el.id === "waterPlaneBoundary") ||
            els.some(el => el.id === "treesPlaneBoundary") ||
            els.some(el => el.id === "vegetationPlaneBoundary") ||
            els.some(el => el.id === "preyPlaneBoundary") ||
            els.some(el => el.id === "postPlaneBoundary")
          ) {
            isWaterHovered = false;
            isPreyHovered = false;
            isTreesHovered = false;
            isVegetationHovered = false;
            isPostHovered = false;
          } else if (
            els.some(el => el.id === "waterPlane") ||
            els.some(el => el.id === "waterText")
          ) {
            isWaterHovered = true;
            isPreyHovered = false;
            isTreesHovered = false;
            isVegetationHovered = false;
            waterPlane.setAttribute("isWaterHovered", true);
            isPostHovered = false;
          } else if (
            els.some(el => el.id === "preyPlane") ||
            els.some(el => el.id === "preyText")
          ) {
            isWaterHovered = false;
            isPreyHovered = true;
            isTreesHovered = false;
            isVegetationHovered = false;
            preyPlane.setAttribute("isPreyHovered", true);
            isPostHovered = false;
          } else if (
            els.some(el => el.id === "treesPlane") ||
            els.some(el => el.id === "treesText")
          ) {
            isWaterHovered = false;
            isPreyHovered = false;
            isTreesHovered = true;
            isVegetationHovered = false;
            treesPlane.setAttribute("isTreesHovered", true);
            isPostHovered = false;
          } else if (
            els.some(el => el.id === "vegetationPlane") ||
            els.some(el => el.id === "vegetationText")
          ) {
            isWaterHovered = false;
            isPreyHovered = false;
            isTreesHovered = false;
            isVegetationHovered = true;
            vegetationPlane.setAttribute("isVegetationHovered", true);
            isPostHovered = false;
          } else if (
            els.some(el => el.id === "postPlane") ||
            els.some(el => el.id === "postText")
          ) {
            isWaterHovered = false;
            isPreyHovered = false;
            isTreesHovered = false;
            isVegetationHovered = false;
            isPostHovered = true;
            postPlane.setAttribute("isPostHovered", true);
          } else {
            isWaterHovered = false;
            isPreyHovered = false;
            isTreesHovered = false;
            isVegetationHovered = false;
            isPostHovered = false;
            waterPlane.setAttribute("isWaterHovered", false);
            vegetationPlane.setAttribute("isVegetationHovered", false);
            treesPlane.setAttribute("isTreesHovered", false);
            preyPlane.setAttribute("isPreyHovered", false);
            postPlane.setAttribute("isPostHovered", false);
          }
        }
      }
    });
  }
});
