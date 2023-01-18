
const express = require("express");
var http = require("http");
const app = express();
const port = process.env.PORT || 5000;
var server = http.createServer(app);
var io = require("socket.io")(server);

//middlewre
app.use(express.json());
var clients = {};


io.on("connection", (socket) => {
  console.log("connetetd");
  console.log(socket.id, "has joined");

  socket.on("data",(mess)=>{
    console.log("Message in server " + mess.message)

    console.log(clients);
    if(mess.mobile=='1')
    {
      console.log("mobile if sending");
      console.log(clients[mess.email].desktop.id);
      console.log("sending ... if .....");
      //send to desktop
      clients[mess.email].desktop.emit("res",mess.message);
    }
    else
    {
      console.log("desktop else sending");
      console.log(clients[mess.email].mobile.id);
      console.log("sending ... else .....");
      //send to mobile

      clients[mess.email].mobile.emit("res",mess.message);

    }

   // socket.emit("res",`Connection stable : active count ${mess}`)
  })

  socket.on("signin", (user) => {

    console.log(user);

    if(clients[user.email] != null)
    {
      var mobSocket = null;
      var desSocket = null;

      if(clients[user.email].mobile != null)
      {
        //add 
        mobSocket = clients[user.email].mobile;
      }
      if(clients[user.email].desktop != null)
      { 
        desSocket = clients[user.email].desktop;
      }

      console.log("has key");
      if(user.mobile=='1')
      {
        console.log("mobile if");
        clients[user.email] = {mobile:socket, desktop:desSocket};
      }
      else{
        console.log("mobile else");
        clients[user.email] = {mobile:mobSocket, desktop:socket};
      }
    }
    else{
      console.log("no key");
      if(user.mobile=='1')
      {
        console.log("mobile if");
        clients[user.email] = {mobile:socket};
      }
      else{
        console.log("mobile else");
        clients[user.email] = {desktop:socket};
      }
    }
    
    console.log(clients);
  });


  socket.on("message", (msg) => {
    console.log(msg);
    let targetId = msg.targetId;
    if (clients[targetId]) clients[targetId].emit("message", msg);
  });
});

server.listen(port, "0.0.0.0", () => {
  console.log("server started");
});




class ActiveSession {
  constructor(desktop, mobile) {
    this.desktop = desktop;
    this.mobile = mobile;
  }
}


