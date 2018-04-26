var xhttp = new XMLHttpRequest();
xhttp.onreadystatechange = function() {
    if (this.readyState == 4 && this.status == 200) {
       // Typical action to be performed when the document is ready:
       document.getElementById("test").innerHTML = xhttp.responseText;
    }
};
xhttp.open("GET", "test.json", true);
xhttp.send();