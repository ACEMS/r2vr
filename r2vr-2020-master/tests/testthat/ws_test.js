var ws = new WebSocket("ws://localhost:8080");

ws.onopen = function() {
    ws.send(JSON.stringify({init: true}));
}

ws.onmessage = function(msg) {
    // var data0 = JSON.parse(msg.data);
    console.log(msg);
}

