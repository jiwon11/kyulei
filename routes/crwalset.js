const express = require('express');
const request = require('request');
const cheerio = require('cheerio');
const url = require('url');
const Parser = require('rss-parser');
const xml2js = require('xml2js');
const { isLoggedIn, isNotLoggedIn } = require('./middlewares');
const { User,Collection,Crwalset,Rssset } = require('../models');


const router = express.Router();

let parser = new Parser();
var xmlparser = new xml2js.Parser();
function downloadPage(url){
    return new Promise((resolve, reject) => {
        let options = {
            uri: url,
            method: 'GET',
            headers: {
                'User-Agent': 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/27.0.1453.110 Safari/537.36',
                'Content-Type': 'text/html',
            },
            json:true 
        };
        request.defaults(options);
        request.get({url: url, encoding: null}, function(error, response, body){
            if (error) reject(error);
            if (response.statusCode != 200) {
                reject('Invalid status code <' + response.statusCode + '>');
            }
            resolve(body);
        });
    });
}
async function getiframe(iframes, urlparse, res){
    for(let i = 0; i < iframes.length; i++){
        var ogs=[];
        var iframeurl = urlparse.protocol+'//'+urlparse.host+iframes[i].attribs.src;
        var iframebody = await downloadPage(iframeurl);
        const $ = cheerio.load(iframebody);
        var metadatas = $("html > head > meta");
        var re = new RegExp('(og:)');
        for(let i=0; i<metadatas.length; i++) {
            if(metadatas[i].attribs.property != undefined){
                ogs.push(metadatas[i].attribs);
            }
        }
        if(ogs.length>2){
            iframebodyString = iframebody.toString();
            iframeInfo = {
                'url' : iframeurl,
                'body' : iframebodyString,
                'status' : 200
            };
            res.json(iframeInfo);
        }
    }
}
router.post('/add', isLoggedIn, async (req, res, next) => {
    console.log(req.body);
    if(req.body.selector !== ''){
        try{
            const crwalset = await Crwalset.create({
                url: req.body.url,
                selector: req.body.selector,
            });
            await crwalset.addUsers(req.user.id);
            await crwalset.addCollections(req.body.collectionId);
            res.redirect('/');
        } catch(error){
            console.error(error);
            return next(error);
        }
    } else{
        try{
            const rssset = await Rssset.create({
                url: req.body.url,
            });
            await rssset.addUsers(req.user.id);
            await rssset.addCollections(req.body.collectionId);
            res.redirect('/');
        } catch(error){
            console.error(error);
            return next(error);
        }
    }
});

router.post('/url', isLoggedIn, async(req, res, next) => {
    console.log(req.body.url);
    let options = {
        uri: req.body.url,
        method: 'GET',
        headers: {
            'User-Agent': 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/27.0.1453.110 Safari/537.36',
            'Content-Type': 'text/html',
        },
        json:true 
    };
    request.defaults(options);
    request.get({url: req.body.url, encoding: null}, function(error, response, body){
        if(error || response.statusCode === 404){
            errorInfo = {
                'error': error,
                'status': 404
            };
            res.json(errorInfo);
        }
        var urlparse = url.parse(req.body.url);
        const $ = cheerio.load(body);
        let iframes = $("html > body > iframe");
        let bodytext = $("html > body > p");
        let bodylist = $("html > body > li");
        if(bodylist.length ==0 && bodytext.length==0 && iframes.length != 0){
            getiframe(iframes, urlparse, res);
        }else{
            console.log('statusCode:', response && response.statusCode);
            if(response && response.statusCode === 200 && error == undefined){
                bodyString = body.toString();
                htmlInfo = {
                    'url' : req.body.url,
                    'body' : bodyString,
                    'status' : 200
                };
                res.json(htmlInfo);
            }
        }
    });
});
router.post('/rss', isLoggedIn, async(req, res, next) => {
    console.log(req.body.url);
    if(req.body.url.indexOf('xml') === -1){
        try {
            parser.parseURL(req.body.url, (err, feed) => {
                console.log(feed);
                if(feed !== undefined){
                    res.json({'url' : feed.link});
                } else{
                    console.log(err);
                }
            });
          } catch (error){
            console.log(error);
            next(error);
        }
    } else {
        request(req.body.url, function(error, response, body) {
            xmlparser.parseString(body, function(err,result){
              console.log(result.rss.channel);
              console.log(err);
              if(err === null){
                console.log(result.rss.channel[0].link);
                res.json({'url' : result.rss.channel[0].link});
              }
              });
          });
    }
});

router.post('/selectorInspect', isLoggedIn, async(req, res, next) => {
    console.log(req.body);
    let options = {
        uri: req.body.url,
        method: 'GET',
        headers: {
            'User-Agent': 'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/27.0.1453.110 Safari/537.36',
            'Content-Type': 'text/html',
        },
        json:true 
    };
    request.defaults(options);
    request.get({url: req.body.url, encoding: null}, function(error, response, body){
        console.log('error:', error);
        console.log('statusCode:', response && response.statusCode);
        var urlParsedObj = url.parse(req.body.url);
        console.log(urlParsedObj);
        var html = body.toString('utf-8');
        var $ = cheerio.load(html);
        lists=[];
        $('*').find(req.body.selector).each(function (index, element) {
            list = {};
            list.url = $(element).attr('href');
            list.title = $(element).text();
            lists.push(list);
        });
        console.log(lists);
        var crawl_url = lists[0].url;
        console.log(crawl_url);
        if(urlParsedObj.protocol ==='https:' || urlParsedObj.protocol ==='http:'){
            res.json({
                'url' : crawl_url,
                });
        } else{
            res.json({
                'url' : urlParsedObj.protocol+'//'+urlParsedObj.hostname+crawl_url,
        });
        }
    });
});

router.post('/update',isLoggedIn, async(req, res, next) => {
    console.log(req.body);
    try {
        const crwalset = await Crwalset.findOne({
            where : {id : req.body.crwalsetId }
        });
        crwalset.update({
            url : req.body.url,
            selector : req.body.selector,
        })
        .then(async (crwalset) => {
            res.redirect(`/collections/${req.body.collectionId}`);
        })
        .catch((error) => {
            console.log(error);
            next(error);
        });
    } catch (error){
        console.log(error);
        next(error);
    }
});
router.post('/delete', isLoggedIn, async(req, res, next) => {
    console.log(req.body);
    if(req.body.urltype==='url'){
        Crwalset.destroy({ where : {id : req.body.crwalsetId}})
        .then((result)=> {
            res.redirect(`/collections/${req.body.collectionId}`);
        })
        .catch((error) => {
            console.err(err);
            next(err);
        });
    }else{
        Rssset.destroy({ where : {id : req.body.crwalsetId}})
        .then((result)=> {
            res.redirect(`/collections/${req.body.collectionId}`);
        })
        .catch((error) => {
            console.err(err);
            next(err);
        });
    }
});
/*
*/
module.exports = router;
