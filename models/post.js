module.exports = (sequelize, DataTypes) => (
    sequelize.define('post',{
        title: {
            type: DataTypes.STRING(100),
            allowNull: false,
            unique: false,
        },
        description: {
            type: DataTypes.STRING(50000),
            allowNull: false,
            unique: false,
        },
        image: {
            type: DataTypes.STRING(300),
            allowNull: false,
            unique: false,
        },
        url: {
            type: DataTypes.STRING(300),
            allowNull: false,
            unique: true,
        },
        site: {
            type: DataTypes.STRING(100),
            allowNull: false,
            unique: false,
        },
        updated_time: {
            type: DataTypes.STRING(100),
            allowNull: false,
            unique: false,
        },
        local: {
            type: DataTypes.STRING(20),
            allowNull: false,
            unique: false,
        },
    },{
        timestamps: false,
        paranoid: true,
    })
);