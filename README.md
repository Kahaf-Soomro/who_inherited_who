




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
