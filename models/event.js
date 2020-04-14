module.exports = (sequelize, DataTypes) => (
    sequelize.define('event',{
        title: {
            type: DataTypes.STRING(100),
            allowNull: false,
            unique: false,
        },
        description: {
            type: DataTypes.STRING(500),
            allowNull: false,
            unique: false,
        },
        url: {
            type: DataTypes.STRING(300),
            allowNull: false,
            unique: true,
        },
        updated_time: {
            type: DataTypes.STRING(100),
            allowNull: false,
            unique: false,
        },
        end_time: {
            type: DataTypes.STRING(100),
            allowNull: false,
            unique: false,
        },
        local: {
            type: DataTypes.STRING(20),
            allowNull: true,
            unique: false,
        },
    },{
        timestamps: true,
        paranoid: true,
    })
);