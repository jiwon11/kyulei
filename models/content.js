module.exports = (sequelize, DataTypes) => (
    sequelize.define('content',{
        content: {
            type: DataTypes.STRING(50000),
            allowNull: false,
            unique: false,
        }
    },{
        timestamps: false,
        paranoid: true,
    })
);