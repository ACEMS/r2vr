var debug = AFRAME.utils.debug;
var coordinates = AFRAME.utils.coordinates;

var warn = debug('components:look-at:warn');
var isCoordinates = coordinates.isCoordinate || coordinates.isCoordinates;

delete AFRAME.components['look-at'];

/**
 * Look-at component.
 *
 * Modifies rotation to either track another entity OR do a one-time turn towards a position
 * vector.
 *
 * If tracking an object via setting the component value via a selector, look-at will register
 * a behavior to the scene to update rotation on every tick.
 */
AFRAME.registerComponent('look-at', {
  schema: {
    default: '',

    parse: function (value) {
      // A static position to look at.
      if (isCoordinates(value) || typeof value === 'object') {
        return coordinates.parse(value);
      }
      // A selector to a target entity.
      return value;
    },

    stringify: function (data) {
      if (typeof data === 'object') {
        return coordinates.stringify(data);
      }
      return data;
    },
  },

  init: function () {
    this.target3D = null;
    this.vector = new THREE.Vector3();
  },

  /**
   * If tracking an object, this will be called on every tick.
   * If looking at a position vector, this will only be called once (until further updates).
   */
  update: function () {
    var self = this;
    var target = self.data;
    var object3D = self.el.object3D;
    var targetEl;

    // No longer looking at anything (i.e., look-at="").
    if (
      !target ||
      (typeof target === 'object' && !Object.keys(target).length)
    ) {
      return self.remove();
    }

    // Look at a position.
    if (typeof target === 'object') {
      return object3D.lookAt(new THREE.Vector3(target.x, target.y, target.z));
    }

    // Assume target is a string.
    // Query for the element, grab its object3D, then register a behavior on the scene to
    // track the target on every tick.
    targetEl = self.el.sceneEl.querySelector(target);
    if (!targetEl) {
      warn('"' + target + '" does not point to a valid entity to look-at');
      return;
    }
    if (!targetEl.hasLoaded) {
      return targetEl.addEventListener('loaded', function () {
        self.beginTracking(targetEl);
      });
    }
    return self.beginTracking(targetEl);
  },

  tick: function (t) {
    // Track target object position. Depends on parent object keeping global transforms up
    // to state with updateMatrixWorld(). In practice, this is handled by the renderer.
    var target;
    var target3D = this.target3D;
    var object3D = this.el.object3D;
    var vector = this.vector;

    if (target3D) {
      target = object3D.parent.worldToLocal(target3D.getWorldPosition());
      if (this.el.getObject3D('camera')) {
        // Flip the vector to -z, looking away from target for camera entities. When using
        // lookat from THREE camera objects, this is applied for you, but since the camera is
        // nested into a Object3D, we need to apply this manually.
        vector.subVectors(object3D.position, target).add(object3D.position);
      } else {
        vector = target;
      }
      object3D.lookAt(vector);
    }
  },

  beginTracking: function (targetEl) {
    this.target3D = targetEl.object3D;
  },
});
