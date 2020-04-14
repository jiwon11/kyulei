const express = require('express');
const { isLoggedIn, isNotLoggedIn } = require('./middlewares');
const { User,Collection,Post,Calender,Event } = require('../models');

const router = express.Router();

router.get('/profile',isLoggedIn ,(req,res) => {
    res.render('profile',{title: '내 정보 - netrigger', user: req.user });
});

router.get('/login',isNotLoggedIn,(req, res) => {
    res.render('login', {
        title: '로그인 - netrigger',
        user: req.user,
        loginError: req.flash('loginError'),
    });
});
router.get('/signup',isNotLoggedIn,(req, res) => {
    res.render('layout', {
        title: '회원가입 - netrigger',
        user: req.user,
        loginError: req.flash('loginError'),
    });
});
router.get('/',isLoggedIn,async(req, res, next)=> {
    try{
        const user= await User.findOne({
            where: {id: req.user.id},
            include : [{
                model : Collection,
                include:[{
                    model: Calender,
                    include:[{
                        model: Event,
                    },]
                },{
                    model : Post,
                    attributes : ['id'],
                },]
            }],
            order : [['createdAt','DESC']],
        });
        return res.render('layout', {
            title : 'Netrigger',
            collections : user.collections,
            user : req.user,
            loginError : req.flash('loginError'),
        });
    }catch (error){
        console.error(error);
        next(error);
    }
});

module.exports = router;