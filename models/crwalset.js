module.exports = (sequelize, DataTypes) => (
    sequelize.define('crawlset',{
        url : {
            type: DataTypes.STRING(500),
            allowNull: false,
            unique: false,
        },
        selector : {
            type: DataTypes.STRING(500),
            allowNull: false,
            unique: false,
        },
    },{
        timestamps: true,
        paranoid: true,
    })
);