// An example custom component to be served with scene
AFRAME.registerComponent('spin', {
  schema: {axis: {default: 'y'}, speed: {default: 3.14 }},
  init: function () {
    if (this.data.axis == 'x'){
      this.rotation_axis = new THREE.Vector3(1, 0, 0)
    } else if (this.data.axis == 'y'){
      this.rotation_axis = new THREE.Vector3(0, 1, 0)
    } else if (this.data.axis == 'z'){
      this.rotation_axis = new THREE.Vector3(0, 0, 1)
    } else{
      throw 'spin: can only spin around axis "x", "y", or "z'
    }
  },
  update: function () {},
  tick: function () {
    
    this.el.object3D.rotateOnAxis(this.rotation_axis, this.data.speed/60)
  },
  remove: function () {},
  pause: function () {},
  play: function () {}
});