
const dns = require('dns');

dns.setServers(['8.8.8.8', '8.8.4.4']);
dns.setDefaultResultOrder('ipv4first');
const { log } = require("console");
const { Server } = require('socket.io');

const express = require("express");
var http = require("http");
const app = express();
const port = process.env.PORT || 3000;
const mongoose = require("mongoose")
const server = http.createServer(app);

//schemas:
const Room = require('./models/Room')
const Player = require('./models/Player')
const getWords = require('./api/getWords');
const getWordsForSWEStudents = require('./api/getWordsForSWEStudents');


const io = new Server(server, {
  cors: {
    origin: '*',
    methods: ['GET', 'POST'],
  },
});

var socket = require("socket.io");
const { Socket } = require('dgram');



//middleware here
app.use(express.json());


//connect to db

const DB = 'mongodb+srv://yourMongoDBServer@cluster0.ahmhpyr.mongodb.net/?appName=Cluster0';

mongoose.connect(DB).then(()=>{
    console.log('Connection successful');   
}).catch((e)=>{
    console.log(e);

    
})

io.on('connection',  (socket)=>{
  console.log('io connected');
//socket.on for create game
  socket.on("create-game", async(data) => {
    try {
      console.log("trying to create-game");
      console.log(data);
      const { nickname, name, maxRounds, occupancy } = data;
        const existingRoom = await Room.findOne({name});
        if(existingRoom){
              socket.emit('notCorrectGame', "Room w that name already exists!")
            return;

            }
            
            let room = new Room();
            const word  = getWordsForSWEStudents();
            console.log("Random word: ", word);
            
            room.word = word;
            room.name = name;
            room.maxRounds = maxRounds;

            room.occupancy = occupancy;
//creating room Admin player
            let player= {
              socketID : socket.id,
              nickname:nickname,
              isPartyLeader:true
            };
            room.players.push(player);
            console.log('Player pushed in players');
            room = await room.save();
            console.log('room created in db');


            socket.join(room.name);
            io.to(name).emit('updateRoom', room);
            console.log('Room Created,');
            console.log(room.word);
            
            
    } catch (error) {
        console.log(error);
        
    }
  })
  //socket.on for joining the game
   socket.on("join-game", async(data) => {
    try {
      console.log("trying to join-game");
     console.log("JOIN DATA:", data);
      const { nickname, name} = data;
      let room = await Room.findOne({name});
      
      if(!room){
        socket.emit('notCorrectGame', "Room w that name does not exists!")
        return;
        
      }
      console.log("Room Found:", room?.name);
      if(room.isJoin){
              console.log("Players:", room?.players.length);
              console.log("Occupancy:", room?.occupancy);
                let player= {
              socketID : socket.id,
              nickname:nickname,
              isPartyLeader:false
            };
            const existingPlayer = room.players.find(
  (player) => player.nickname === nickname);

if (existingPlayer) {
  socket.emit(
    'notCorrectGame',
    'Player with this Nickname already in this room.'
  );
  return;
}
            room.players.push(player)
            console.log('Player pushed in players');
            socket.join(name);
            console.log('Room joined');

      if(room.players.length == room.occupancy){
        room.isJoin = false; //so next player wont be able to join


      }
      room.turn = room.players[room.turnIndex];
      room = await room.save();
      io.to(name).emit('updateRoom', room);
      
      
      
    }else if(!room.isJoin){
    socket.emit(
    'notCorrectGame',
    'Room is private'
  );
    }
          else{
              socket.emit(
    'notCorrectGame',
    'Game is already in progress, please try later.'
  );
  return;
          }

          
            


     
            
    } catch (error) {
        console.log(error);
        
    }
  }
)
  //PAINT 
  socket.on('paint', (data)=>{
    io.to(data.roomName).emit('points', {details:data.details});
    console.log("paint called through index.js");
    console.log("Room name: "+ data.roomName );
  })
  //msg-recieve
  socket.on("msg-recieve", async (data) => {
  console.log(data);

  try {
    // Wrong guess
    if (data.msg !== data.word) {
      return io.to(data.roomName).emit("msg-recieve", {
        username: data.username,
        msg: data.msg,
        guessedUserCtr: data.guessedUserCtr,
      });
    }

    // Correct guess
    const room = await Room.findOne({ name: data.roomName });
    if (!room) return;

    const player = room.players.find(
      (p) => p.nickname === data.username
    );

    if (player && data.timeTaken > 0) {
      const maxScore = 200;
      const minScore = 20;
      const roundLength = 60;

      const earnedPoints = Math.round(
        minScore +
          ((roundLength - data.timeTaken) / roundLength) *
            (maxScore - minScore)
      );

      player.points += earnedPoints;
      await room.save();
    }

    console.log("Correct Guess:", data);
    const guessedPlayers = data.guessedUserCtr + 1;

    io.to(room.name).emit("msg-recieve", {
      username: data.username,
      msg: "Guessed it!",
      guessedUserCtr: guessedPlayers,
    });

if (guessedPlayers >= room.players.length - 1) {
  console.log("All players guessed the word");
  
    socket.emit("change-turn", room.name);
}

  } catch (err) {
    console.log(err);
  }
});
  socket.on('change-turn', async(name)=>{
    try{

      let room = await Room.findOne({name});
      if(!room){
        console.log('room not found: ', name);
        return;
      }
      let index = room.turnIndex;
      if(index+1 == room.players.length)
      {
        room.currentRound+=1;

      }
      if(room.currentRound<=room.maxRounds)
          {
            console.log('previous word: '+ room.word);
            
             const word  = getWordsForSWEStudents();
             room.word = word;
            console.log("New Random word: ", word);
            room.turnIndex = (index+1) % room.players.length;
            room.turn = room.players[room.turnIndex] 
            room = await room.save()
            io.to(name).emit('change-turn', room)
            io.to(name).emit('updateRoom', room);
          } else{
            //show results tab
          }

      }catch(e){
        console.log(e)

    }
  })
  //color socket here
socket.on('color-change', ({color, roomName}) =>{
  io.to(roomName).emit('color-change', color)
});
  //color socket here
socket.on('change-weight', ({value, roomName}) =>{
  io.to(roomName).emit('change-weight', value)

});

//for clear creen socket
socket.on('clear-screen', (roomName) => {
  io.to(roomName).emit('clear-screen', '');
} )

})




//start the server
server.listen(port, '0.0.0.0', ()=>{
console.log("Server has Started and running on Port: "+ port);

})