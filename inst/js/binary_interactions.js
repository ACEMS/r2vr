AFRAME.registerComponent("binary-button-controls", {
  init: function() {
    let canvas_3d = document.getElementById("canvas3d");
    const yesPlane = document.getElementById("yesPlane");
    const noPlane = document.getElementById("noPlane");

    const fileID = document.getElementById("fileID");
    const fileIDClass = fileID.getAttribute('class');

    let imageAnnotated = [];

    let controlsEl = document.querySelector("[button-controls]");
    controlsEl.addEventListener("buttondown", () => {
      image_file = canvas_3d.getAttribute('class').split("/").pop();
      image_id = image_file.split(".")[0];

      postBinaryResponse = binary => {
        let data = {
          image_id: image_id,
          image_file: image_file,
          binary_response: binary
        };

        if (!imageAnnotated.includes(image_id)) {
          imageAnnotated.push(image_id);
          console.log('imageAnnotated:', imageAnnotated);
        }
        
        const endPoint = fileIDClass === 'koala' ? "https://test-api-koala.herokuapp.com/koala" : "https://test-api-koala.herokuapp.com/reef"

        fetch(endPoint, {
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
      if (isYesSelected && !imageAnnotated.includes(image_id)) {
        postBinaryResponse(1);
        console.log(111, 'yes selected');
      } else if (isNoSelected && !imageAnnotated.includes(image_id)) {
        postBinaryResponse(0);
        console.log(112, 'no selected');
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
      // if question plane visible, then all planes visible => detect intersection.
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
