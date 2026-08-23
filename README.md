
# 🎨 Scribble Crown — Who Inherited Who?

A real-time multiplayer drawing and guessing game built from scratch with **Flutter, Node.js, Socket.IO, and MongoDB**.

One player gets a word and draws it, while the other player has to figure out what it is in real time.

The project focuses on real-time multiplayer communication, game rooms, synchronized drawing events, player management, guessing, rounds, and score tracking.

---

## 🎮 How It Works

The game is designed around a simple idea:

> **One player gets the word, while the other has to figure it out in real time.**

### Game Flow

1. A player creates a game room.
2. The room receives a unique room ID.
3. Other players join using the room ID.
4. The game starts once the required players are present.
5. One player receives a secret word.
6. The player draws the word on the canvas.
7. The drawing is synchronized with the other players in real time.
8. Other players submit their guesses.
9. Correct guesses award points.
10. Players switch roles between rounds.
11. The scoreboard keeps track of the results.

---

## 🖥️ Screenshots / Demo
will provide soon

### 🎥 Gameplay Demo
will provide soon

The project is demonstrated through a multiplayer gameplay recording showing two clients connected to the same game.


---

## 🏗️ Architecture

The project uses a Flutter client connected to a Node.js server through Socket.IO, with MongoDB handling persistent data.


<img width="1672" height="941" alt="image" src="https://github.com/user-attachments/assets/5339207e-128c-4203-a07d-bc5d0283cc1e" />

```

### Technologies

| Technology     | Purpose                             |
| -------------- | ----------------------------------- |
| **Flutter**    | Cross-platform client application   |
| **Dart**       | Client-side programming             |
| **Node.js**    | Backend server                      |
| **Socket.IO**  | Real-time multiplayer communication |
| **MongoDB**    | Data persistence                    |
| **JavaScript** | Backend programming                 |

---

## ⚡ Real-Time Communication

The main feature of the project is real-time synchronization.

Instead of constantly requesting updates from the server, clients maintain a Socket.IO connection with the backend.

For example, when a player draws something:

```text
Player 1
   │
   │ Drawing event
   ▼
Socket.IO Server
   │
   │ Broadcast event
   ▼
Player 2
```

This allows drawing strokes, guesses, game state, player information, and other events to be synchronized between connected clients.

---

## 🧩 Main Features

### 👥 Multiplayer Rooms

Players can create and join rooms using a unique room ID.

### 🎨 Real-Time Drawing

Drawing actions are transmitted through Socket.IO so other players can see the drawing as it happens.

### 🔤 Word-Based Gameplay

A player receives a secret word while the other player attempts to identify it from the drawing.

### 🔄 Multiple Rounds

The game supports multiple rounds with players switching roles.

### 🏆 Scoreboard

Players receive points based on their performance and the scoreboard keeps track of the current game state.

### ⏱️ Real-Time Game State

Important game information is synchronized between connected clients.

### 👤 Player Management

The server keeps track of players connected to each room and manages joining, leaving, and game progression.

### 🏠 Room Configuration

The room creator can configure the game before starting it, including the number of rounds and room occupancy.

---

## 📁 Project Structure

The repository contains both the Flutter client and Node.js backend.

```text

```

# 🚀 Getting Started

## Prerequisites

Before running the project, make sure you have the following installed:

* Flutter SDK
* Dart SDK
* Node.js
* npm
* MongoDB
* Git
* Android Studio or another Flutter-compatible development environment

You can verify the installations with:

```bash
flutter --version
dart --version
node --version
npm --version
```

---

# 🔧 Backend Setup

Navigate to the server directory:

```bash
cd server
```

Install the required Node.js dependencies:

```bash
npm install
```

Configure the MongoDB connection according to the configuration used by the project.

Then start the server:

```bash
node server.js
```

If the project uses a different server entry file, run the entry file included in the repository.

Once started, the Node.js server will listen for Socket.IO connections from the Flutter clients.

---

# 📱 Flutter Setup

Open a new terminal and navigate to the Flutter project:

```bash
cd client
```

Install Flutter dependencies:

```bash
flutter pub get
```

Check that a device is available:

```bash
flutter devices
```

Then run the application:

```bash
flutter run
```

---

# 🌐 Connecting Multiple Players

For local multiplayer testing, both devices must be able to reach the computer running the Node.js server.

For example:

```text
Computer running Node.js
        │
        │ Local Network
        │
   ┌────┴────┐
   │         │
Player 1   Player 2
Flutter    Flutter
```

Do **not** use:

```text
localhost
```

from another physical device.

`localhost` refers to the device itself.

Instead, use the local IP address of the computer running the backend.

For example:

```text
192.168.1.47
```

The exact IP address will depend on the network.

---

# 🔌 Socket.IO Communication

The backend acts as the central real-time communication layer.

```text
Flutter Client
      │
      │ Socket.IO
      ▼
Node.js Server
      │
      ├── Room Management
      ├── Player Management
      ├── Drawing Events
      ├── Guess Events
      ├── Game State
      ├── Rounds
      └── Scoreboard
```

The server receives events from clients and broadcasts the appropriate updates to players in the same room.

This architecture allows multiple clients to interact with the same game state without directly communicating with each other.

---

# 🗄️ MongoDB

MongoDB is used as the project's database layer.

The backend communicates with MongoDB to store the data required by the application.

The database connection is handled by the Node.js backend rather than directly by the Flutter application.

```text
Flutter
   │
   │ Socket.IO
   ▼
Node.js
   │
   │ MongoDB Driver
   ▼
MongoDB
```

Keeping database access on the server prevents clients from directly accessing the database.

---

# 🧠 Why Socket.IO?

A normal HTTP request follows a simple request-response model:

```text
Client → Request → Server
Client ← Response ← Server
```

That approach is not ideal for a game where changes need to appear immediately.

Socket.IO provides persistent real-time communication:

```text
Client ←──────────────→ Server
       Real-time connection
```

This makes it possible to immediately send events such as:

* Player joined
* Player left
* Drawing updated
* Guess submitted
* Round started
* Round ended
* Score updated
* Game state changed

---

# 🎨 Drawing Synchronization

The drawing board is one of the main components of the game.

Instead of sending an entire image every time the player draws, drawing actions can be represented as events containing information about the drawing operation.

Conceptually:

```text
Player draws
     │
     ▼
Drawing event
     │
     ▼
Socket.IO
     │
     ▼
Server
     │
     ▼
Other players
     │
     ▼
Canvas updated
```

This allows the other player to see the drawing progressively rather than waiting for an entire image to be uploaded.

---

# 🔐 Game Rooms

Each game operates inside a room.

A simplified room structure looks like:

```text
Room: ABC123

├── Player 1
├── Player 2
├── Current Word
├── Current Round
├── Game State
└── Scores
```

Players connected to the same room receive the events belonging to that room.

This prevents events from one game from being broadcast to unrelated games.

---

# 🏆 Scoring

Players earn points based on successful guesses and game performance.

The server is responsible for maintaining the authoritative game state so that clients cannot simply modify their own scores locally.

```text
Guess
  │
  ▼
Server validates
  │
  ▼
Score updated
  │
  ▼
Scoreboard synchronized
```

---

# 🔄 Game State

The backend manages the important state of an active game.

This can include:

* Current players
* Current round
* Current drawer
* Current word
* Room information
* Scores
* Game status
* Drawing events
* Player guesses

The server acts as the source of truth while clients display the current state.

---

# 🛠️ Development

Clone the repository:

```bash
git clone <YOUR_REPOSITORY_URL>
```

Enter the project:

```bash
cd WhoInheritedWho
```

Install backend dependencies:

```bash
cd server
npm install
```

Install Flutter dependencies:

```bash
cd ../client
flutter pub get
```

Start the backend first, then launch the Flutter application.

---

# 🧪 Local Multiplayer Testing

You can test the game with two clients.

### Option 1 — Two physical devices

Connect both devices to the same Wi-Fi network.

Run the Node.js backend on your computer and configure both clients to connect to the computer's local IP address.

### Option 2 — Emulator + physical device

You can also use an Android emulator alongside a physical device, provided the networking configuration allows both clients to reach the backend.

### Option 3 — Multiple emulator instances

Multiple emulator instances can be used for testing if the required network configuration is available.

---

# ⚠️ Important

The Flutter application depends on the Node.js backend for multiplayer functionality.

Running only the APK is **not enough** to play the online multiplayer game.

The complete system is:

```text
Flutter App
     +
Node.js Server
     +
Socket.IO
     +
MongoDB
```

For this reason, the repository contains the complete project rather than relying on an APK alone.

---

# 🌍 Deployment

For production deployment, the Node.js backend needs to be hosted on a publicly accessible server.

The Flutter application can then connect to the deployed Socket.IO server instead of a local IP address.

```text
             Internet
                │
        ┌───────┴───────┐
        │               │
    Player 1         Player 2
    Flutter          Flutter
        │               │
        └───────┬───────┘
                │
             Socket.IO
                │
                ▼
        Node.js Server
                │
                ▼
             MongoDB
```

Once deployed, players can connect from different networks rather than requiring everyone to be connected to the same local Wi-Fi network.

---

# 📚 What I Learned

This project was mainly built to explore how a real-time multiplayer application works from the ground up.

Some of the key concepts explored during development include:

* Flutter application development
* Client-server architecture
* REST vs real-time communication
* WebSockets
* Socket.IO
* Event-based communication
* Multiplayer room management
* Real-time drawing synchronization
* Game state management
* MongoDB integration
* Node.js backend development
* Handling multiple connected clients
* Synchronizing state between clients
* Debugging network-related issues

---

# 🔮 Future Improvements

Some features that could be added in future versions:

* [ ] Public matchmaking
* [ ] Player authentication
* [ ] Custom avatars
* [ ] More drawing tools
* [ ] More word categories
* [ ] Improved anti-cheat validation
* [ ] Spectator mode
* [ ] Persistent player profiles
* [ ] Global leaderboard
* [ ] Production deployment
* [ ] Better mobile UI/UX
* [ ] Reconnection support
* [ ] Private invite links
* [ ] Fix Game end logic

---

# 👨‍💻 Author

**Muhammad Kahaf**

Software Engineering Student

---

# 📄 License

This project is available for educational and personal use.

If you use or modify the project, attribution is appreciated.

---

## ⭐ Support

If you found this project interesting, consider giving the repository a ⭐ on GitHub.

And if you have suggestions or improvements, feel free to open an issue or submit a pull request.




model files:

Room.js

```java

const mongoose = require('mongoose');


const roomSchema = new mongoose.Schema({

    word:{
        required: true,
        type:String
    },
     name:{
        required: true,
        type:String,
        unique:true,
        trim:true,
    },
    occupancy:{
        reuqired:true,
        type:Number,
        default:4,
    },
    maxRounds:{
        required:true,
        type:Number,
        

    },
    currentRound:{
        required:true,
        type:Number,
        default:1,
    },
    players:{playerSchema},
    isJoin:{
        type:Boolean,
        default:true,
    },
    turn:playerSchema,
    turnIndex:{
        type:Number,
        default:0
    }

}
)
```


Player.js
```java
const mongoose = require("mongoose");

const playerSchema = new mongoose.Schema({
  nickname: {
    type: String,
    trim: true,
  },
  socoketID: {
    type: String,
  },
  isPartyLeader: {
    type: Boolean,
    deault: false,
  },
  points: {
    type: Number,
    default: 0,
  },
});

const playerModel = mongoose.model("Player", playerSchema);

multiple.exports = {playerModel, playerSchema}


```
