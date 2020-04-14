const express = require('express');
const { isLoggedIn, isNotLoggedIn } = require('./middlewares');
const { User,Collection,Crwalset,Post,Rssset,Calender,Error } = require('../models');

const router = express.Router();

router.get('/:collectionId', isLoggedIn, async(req,res,next) => {
    const collectionId = req.params.collectionId;
    if(!collectionId) {
        return res.redirect('/');
    }
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
            }
        ],
         });
        const post = await Post.findAll({
            limit:20,
            include:[{
                model: Collection,
                where: {id: collectionId}
            }],
            order:[['updated_time','DESC']]
        });
        const error = await Error.findAll({
            where: {collection_id: collectionId},
            include:[{
                model: Collection,
            },{
                model: Crwalset,
            }],
        });
        return res.render('collection', {
            title: `${collection.name} - My Collection`,
            collection: collection,
            userCollectionList: userCollectionList.collections,
            user : req.user,
            Crawl_error : error,
            posts: post,
            loginError : req.flash('loginError'),
        });
    } catch (error){
        console.error(error);
        return next(error);
    }
});


router.post('/add', isLoggedIn, async (req, res, next) => {
    console.log(req.body);
    try {
        const collection = await Collection.create({
            name: req.body.colName,
            private: false
        });
        await Calender.create({
            name: req.body.colName,
            private: false,
            collection_id: collection.id,
        });
        await collection.addUsers(req.user.id);
        res.redirect('/');
    } catch (error) {
        console.error(error);
        next(error);
    }
});
router.post('/:id/delete', isLoggedIn, async (req, res, next) => {
    console.log(`Delete Page id : ${req.body.id}`);
    Collection.destroy({ where : { id : req.body.id } })
    .then((result) => {
        res.redirect('/');
    })
    .catch((err) => {
        console.err(err);
        next(err);
    });
});
router.delete('/error/delete/:errorId',isLoggedIn, async(req, res, next) => {
    Error.destroy({where : {id : req.params.errorId}})
    .then((result) => {
        res.redirect('/');
    })
    .catch((err) => {
        console.err(err);
        next(err);
    });
});

router.post('/:collectionId/post/more/:page',isLoggedIn,async(req, res, next) => {
    var collectionId = req.params.collectionId;
    var postNum = parseInt(req.params.page) * 20;
    var prevPostNum = (parseInt(req.params.page)-1) * 20;
    const post = await Post.findAll({
        limit:postNum,
        offset:prevPostNum,
        include:[{
            model: Collection,
            where: {id: collectionId}
        }],
        order:[['updated_time','DESC']]
    });
    console.log(`collection id - ${collectionId} : require post ${prevPostNum}~${postNum}`);
    res.json({posts : post});
});
module.exports = router;
