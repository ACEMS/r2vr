document.addEventListener("DOMContentLoaded", e => {
  const image_id_el = document.getElementById("img1");
  image_file = image_id_el.src.split("/").pop();
  image_id = image_file.split(".")[0];
});

AFRAME.registerComponent("binary-button-controls", {
  init: function() {
    const yesPlane = document.getElementById("yesPlane");
    const noPlane = document.getElementById("noPlane");

    let controlsEl = document.querySelector("[button-controls]");
    controlsEl.addEventListener("buttondown", () => {
      postBinaryResponse = binary => {
        let data = {
          image_id: image_id,
          image_file: image_file,
          is_koala: binary // TODO: rename is_present
        };
        fetch("https://test-api-koala.herokuapp.com/koala", {
          method: "POST",
          body: JSON.stringify(data),
          headers: {
            "Content-Type": "application/json"
          }
        })
          .then(res => {
            console.log("Record added!", res);
            if (isYesSelected) {
              yesPlane.setAttribute("color", "green");
            } else if (isNoSelected) {
              noPlane.setAttribute("color", "yellow");
            }
          })
          .catch(err => {
            console.log(err);
          });
      };
      if (isYesSelected) {
        postBinaryResponse(1);
      } else if (isNoSelected) {
        postBinaryResponse(0);
      }
    });
  }
});

let isYesSelected = false;
let isNoSelected = false;

AFRAME.registerComponent("intersection", {
  init: function() {
    // TODO: change somewhere more generic
    const questionPlane = document.getElementById("questionPlane");
    const yesPlane = document.getElementById("yesPlane");
    const noPlane = document.getElementById("noPlane");

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
          if (
            els.some(el => el.id === "noPlaneBoundary") ||
            els.some(el => el.id === "yesPlaneBoundary")
          ) {
            isNoSelected = false;
            isYesSelected = false;
          } else if (
            els.some(el => el.id === "yesPlane" || el.id === "yesText")
          ) {
            isNoSelected = false;
            isYesSelected = true;
            yesPlane.setAttribute("isYesSelected", true);
          } else if (
            els.some(el => el.id === "noPlane" || el.id === "noText")
          ) {
            isYesSelected = false;
            isNoSelected = true;
            noPlane.setAttribute("isNoSelected", true);
          } else {
            isYesSelected = false;
            isNoSelected = false;
            yesPlane.setAttribute("isYesSelected", false);
            noPlane.setAttribute("isNoSelected", false);
          }
        }
      }
    });
  }
});
