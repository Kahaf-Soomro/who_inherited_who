




model files:

Room.js``

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
``
