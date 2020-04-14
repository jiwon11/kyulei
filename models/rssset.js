module.exports = (sequelize, DataTypes) => (
    sequelize.define('rssset',{
        url : {
            type: DataTypes.STRING(500),
            allowNull: false,
            unique: false,
        },
    },{
        timestamps: true,
        paranoid: true,
    })
);