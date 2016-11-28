// Written by Miquel Rigo - 2016
// Server to handle incoming data from Engduino and display it in real time.

var app = require('express')();
var express = require('express');

var http = require('http').Server(app);
var io = require('socket.io')(http);
var bodyParser = require('body-parser')

app.use( bodyParser.json());       // to support JSON-encoded bodies
app.use(bodyParser.urlencoded({     // to support URL-encoded bodies
  extended: true
}));

app.use('/static', express.static('public'));


app.get('/', function(req, res){
  res.sendFile(__dirname + '/index.html');
});

io.on('connection', function(socket){
	console.log('a user connected');
  	socket.on('disconnect', function(){
    console.log('user disconnected');
  	});

});

app.post("/", function(req, res) {
    io.emit("message", req.body);
	res.end();
});


http.listen(8080, function(){
  console.log('listening on *:8080');
});
