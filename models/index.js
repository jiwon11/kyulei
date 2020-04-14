const Sequelize = require('sequelize');
const env = process.env.NODE_ENV || 'development';
const config = require('../config/config.json')[env];
const db = {};

const sequelize = new Sequelize(
  config.database, config.username, config.password, config,
);

db.sequelize = sequelize;
db.Sequelize = Sequelize;
db.User = require('./user')(sequelize,Sequelize);
db.Collection = require('./collection')(sequelize,Sequelize);
db.Crwalset = require('./crwalset')(sequelize,Sequelize);
db.Keyword = require('./keyword')(sequelize,Sequelize);
db.Metadata = require('./metadata')(sequelize,Sequelize);
db.Post = require('./post')(sequelize,Sequelize);
db.Rssset = require('./rssset')(sequelize,Sequelize);
db.Calender = require('./calender')(sequelize,Sequelize);
db.Event = require('./event')(sequelize,Sequelize);
db.Error = require('./error')(sequelize,Sequelize);
db.Content = require('./content')(sequelize,Sequelize);

db.User.belongsToMany(db.Collection, {through:'UserCollection'});
db.Collection.belongsToMany(db.User, {through:'UserCollection'});
db.User.belongsToMany(db.Crwalset, {through:'UserCrwalset'});
db.Crwalset.belongsToMany(db.User, {through:'UserCrwalset'});
db.User.belongsToMany(db.Keyword, {through:'UserKeyword'});
db.Keyword.belongsToMany(db.User, {through:'UserKeyword'});
db.User.belongsToMany(db.Rssset, {through:'UserRssset'});
db.Rssset.belongsToMany(db.User, {through:'UserRssset'});

db.Crwalset.belongsToMany(db.Collection, {through:'CollectionCrwalset'});
db.Collection.belongsToMany(db.Crwalset, {through:'CollectionCrwalset'});
db.Rssset.belongsToMany(db.Collection, {through:'CollectionRss'});
db.Collection.belongsToMany(db.Rssset, {through:'CollectionRss'});

db.Crwalset.hasMany(db.Metadata, { foreignKey: 'OGcontent', sourceKey: 'id' });    
db.Metadata.belongsTo(db.Crwalset, { foreignKey: 'OGcontent', sourceKey: 'id' });
db.Post.hasOne(db.Metadata, {foreignKey:'post_id', sourceKey:'id'});
db.Metadata.belongsTo(db.Post, {foreignKey:'post_id', sourceKey:'id'});

db.Post.belongsToMany(db.User, {through:'PostUser'});
db.User.belongsToMany(db.Post, {through:'PostUser'});
db.Post.belongsToMany(db.Collection, {through:'PostCollection'});
db.Collection.belongsToMany(db.Post, {through:'PostCollection'});
db.Post.belongsToMany(db.Keyword, {through:'PostKeyword'});
db.Keyword.belongsToMany(db.Post, {through:'PostKeyword'});
db.Post.hasOne(db.Content, {foreignKey:'post_id', sourceKey:'id'});
db.Content.belongsTo(db.Post, {foreignKey:'post_id', sourceKey:'id'});

db.Collection.hasOne(db.Calender, {foreignKey:'collection_id', sourceKey:'id'});
db.Calender.belongsTo(db.Collection, {foreignKey:'collection_id', sourceKey:'id'});
db.Calender.belongsToMany(db.Event, {through:'CalenderEvent'});
db.Event.belongsToMany(db.Calender, {through:'CalenderEvent'});

db.Collection.hasOne(db.Error, {foreignKey:'collection_id', sourceKey:'id'});
db.Error.belongsTo(db.Collection, {foreignKey:'collection_id', sourceKey:'id'});
db.Crwalset.hasOne(db.Error, {foreignKey:'crawlset_id', sourceKey:'id'});
db.Error.belongsTo(db.Crwalset, {foreignKey:'crawlset_id', sourceKey:'id'});
module.exports = db;