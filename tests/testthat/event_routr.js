AFRAME.registerComponent('ws-event-router', {

    schema: {
        host: {type: 'string', default: 'localhost'},
        port: {type: 'number', default: 8080}
    },

    init: function() {
        this.ws = new WebSocket("ws://" + this.data.host + ":" + this.data.port);
        var sceneEl = this.el.sceneEl
        var ws = this.ws

        //setup incoming channel.
        this.ws.onmessage = function(msg) {
            console.log(msg);

            //parse out message
            var payload = JSON.parse(msg.data);

            //find target by id
            var target = sceneEl.querySelector("#" + payload.id);
            if(target === null){
                throw new Error("ws-event-router received a message for entity with id '" +
                                target + "', but no entity with this id was found.");
            }

            //emit message
            target.emit(payload.message.eventName,
                        payload.message.eventDetail,
                        payload.message.bubbles);
        }
        // setup outgoing channel.
        // add handler for an external message type that will be routed to the R
        // scene with id of the caller and data.
        function handle_r_server_message(event){
            ws.send(event.detail)
        }

        this.el.addEventListener('r_server_message', handle_r_server_message) 
    }
})
