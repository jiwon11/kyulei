module.exports = (sequelize, DataTypes) => (
    sequelize.define('keyword',{
        kryword : {
            type: DataTypes.STRING(100),
            allowNull: false,
            unique: true,
        },
    },{
        timestamps: true,
        paranoid: true,
    })
);