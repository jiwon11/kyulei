const express = require('express');
const { isLoggedIn, isNotLoggedIn } = require('./middlewares');
const { User,Collection,Crwalset,Rssset,Post,Calender,Event } = require('../models');

const router = express.Router();

router.get('/:collectionName&:collectionId', isLoggedIn, async (req, res, next) => {
    console.log(req.params);
    const collectionId = req.params.collectionId;
    const collectionName = req.params.collectionName;
    try{
        const userCollectionList = await User.findOne({
            where: {id: req.user.id},
            include : [{
                model : Collection,
                attributes : ['id', 'name'],
                },
            ], 
        });
        const collection = await Collection.findOne({ 
            where : { id : collectionId },
            include : [{
                model : User,
                attributes : ['id', 'nick'],
            },{
                model : Crwalset,
                attributes : ['id','url', 'selector'],
            },{
                model : Rssset,
                attributes : ['id','url'],
            },{
                model : Post,
            },
        ],
         });
        const calender = await Calender.findOne({
            where: {collection_id : collectionId},
            include: [{
                model: Event,
            }]
        });
        return res.render('calender', {
            title: `${collectionName}'s Calender - netrigger`,
            user: req.user,
            collection: collection,
            calender: calender,
            userCollectionList: userCollectionList.collections,
            loginError: req.flash('loginError'),
        });
    } catch (error){
        console.error(error);
        return next(error);
    }
});

module.exports = router;