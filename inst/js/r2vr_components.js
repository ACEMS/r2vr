// r2vr-message-router adds a websocket connection to the host entity. It assumes
// incoming messages contain either:
//   events to be emitted on scene entities identified by the 'id' field or field(s)
// OR
//   updates to be applied to component attributes on entities identified by the 'id' field.
// [
//     {
//         // Event
//         "class": 'event'
//         "id": 'box1',
//         "eventName": 'turn',
//         "eventDetail": {"rotation": [45, 0 ,0]},
//         "bubbles": true,
//     },
//     {
//         // Update
//         "class": 'update'
//         "component": 'position',
//         "attributes": {x: 1, y: 2, z: 3},
//         "replaces_component": false
//     },
//     {...},
//     ...
// ]
AFRAME.registerComponent('r2vr-message-router', {

    schema: {
        host: {type: 'string', default: 'localhost'},
        port: {type: 'number', default: 8080}
    },

    init: function() {
        this.ws = new WebSocket("ws://" + this.data.host + ":" + this.data.port);
        var sceneEl = this.el.sceneEl;
        var ws = this.ws;

        //notify that the connection was opened.
        ws.onopen = function(){
            console.log('r2vr-message-router: Established connection with server session.');
        };

        //setup incoming channel.
        ws.onmessage = function(msg) {
            console.log(msg);

            //parse out message
            var payload = JSON.parse(msg.data);

            //Assume payload is a list of events
            payload.map((r2vr_message) => {
                //find target by id
                // var target = sceneEl.querySelector("#" + r2vr_message.id);

                // if (target === null){
                //     throw new Error("r2vr-message-router received a message for entity with id '" +
                //                     target + "', but no entity with this id was found.");
                // }

                if (r2vr_message.class == "event"){
                    //emit message
                    sceneEl.querySelector("#" + r2vr_message.id).emit(r2vr_message.message.eventName,
                                r2vr_message.message.eventDetail,
                                r2vr_message.message.bubbles);
                }
                else if (r2vr_message.class == "update"){
                    // core properties should be set at three.js level
                    // as advised in: https://github.com/aframevr/aframe/blob/master/docs/introduction/javascript-events-dom-apis.md
                    // You would write custom message handler if you need this
                    // level of performance.

                    sceneEl.querySelector("#" + r2vr_message.id).setAttribute(r2vr_message.component,
                                        r2vr_message.attributes,
                                        r2vr_message.replaces_component);
                }
                else if (r2vr_message.class == "remove_component"){
                    sceneEl.querySelector("#" + r2vr_message.id).removeAttribute(r2vr_message.component);
                }
                else if (r2vr_message.class == "remove_entity"){
                    sceneEl.querySelector("#" + r2vr_message.id).removeFromParent();
                }
                else if (r2vr_message.class == "add_entity"){
                    var sceneEl = document.querySelector('a-scene');
                    var entityEl = document.createElement('a-entity');
                    entityEl.id = r2vr_message.id
                    sceneEl.appendChild(entityEl);
                }
                else{
                    throw new Error("r2vr-message-router received a message of unknown class.");
                }
            });

        };
        // setup outgoing channel.
        // add handler for an external message type that will be routed to the R
        // scene with id of the caller and data.
        function handle_r_server_message(event){
            ws.send(event.detail);
        }

        this.el.addEventListener('r_server_message', handle_r_server_message);
    }
});
