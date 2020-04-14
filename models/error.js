module.exports = (sequelize, DataTypes) => (
    sequelize.define('error',{
        error_keyword : {
            type: DataTypes.STRING(100),
            allowNull: false,
            unique: false,
        },
    },{
        timestamps: true,
        paranoid: true,
    })
);