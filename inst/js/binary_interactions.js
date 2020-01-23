document.addEventListener("DOMContentLoaded", e => {
  const image_id_el = document.getElementById("img1");
  image_file = image_id_el.src.split("/").pop();
  image_id = image_file.split(".")[0];
});

AFRAME.registerComponent("button-controls-test", {
  init: function() {
    const kyp = document.getElementById("koalaYesPlane");
    const knp = document.getElementById("koalaNoPlane");

    let controlsEl = document.querySelector("[button-controls]");
    controlsEl.addEventListener("buttondown", () => {

      postKoalaSighting = isKoalaSighted => {
        let data = {
          image_id: image_id,
          image_file: image_file,
          is_koala: isKoalaSighted
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
              kyp.setAttribute("color", "green");
            } else if (isNoSelected) {
              knp.setAttribute("color", "yellow");
            }
          })
          .catch(err => {
            console.log(err);
          });
      };
      if (isYesSelected) {
        postKoalaSighting(1);
      } else if (isNoSelected) {
        postKoalaSighting(0);
      }
    });
  }
});

let isYesSelected = false;
let isNoSelected = false;

AFRAME.registerComponent("intersection", {
  init: function() {
    // TODO: change somewhere more generic
    const kyp = document.getElementById("koalaYesPlane");
    const knp = document.getElementById("koalaNoPlane");

    this.el.addEventListener("raycaster-intersection", evt => {
      console.log("intersection occurred!");
      if (evt) {
        let els = evt.detail.els;
        console.log("all intersected elements: ", els);
        // TODO: less arbitrary based on total dom els with ID's
        if (els.length > 4) {
          els = [];
        }
        if (els.some(el => el.id === "koalaNoPlaneBoundary") || els.some(el => el.id === "koalaYesPlaneBoundary")) {
          isNoSelected = false;
          isYesSelected = false;
        } else if (
          els.some(el => el.id === "koalaYesPlane" || el.id === "koalaYesText")
        ) {
          isNoSelected = false;
          isYesSelected = true;
          kyp.setAttribute("isYesSelected", true);
        } else if (
          els.some(el => el.id === "koalaNoPlane" || el.id === "koalaNoText")
        ) {
          isYesSelected = false;
          isNoSelected = true;
          knp.setAttribute("isNoSelected", true);
        } else {
          isYesSelected = false;
          isNoSelected = false;
          kyp.setAttribute("isYesSelected", false); // TODO: rename kyp
          knp.setAttribute("isNoSelected", false);
        }
      }
    });
  }
});