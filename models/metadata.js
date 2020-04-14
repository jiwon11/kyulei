module.exports = (sequelize, DataTypes) => (
    sequelize.define('metadata',{
        title: {
            type: DataTypes.STRING(100),
            allowNull: false,
            unique: true,
        },
        description: {
            type: DataTypes.STRING(500),
            allowNull: false,
            unique: true,
        },
        image: {
            type: DataTypes.STRING(300),
            allowNull: false,
            unique: true,
        },
        url: {
            type: DataTypes.STRING(300),
            allowNull: false,
            unique: true,
        },
        site: {
            type: DataTypes.STRING(100),
            allowNull: false,
            unique: true,
        },
        updated_time: {
            type: DataTypes.STRING(100),
            allowNull: false,
            unique: true,
        },
        local: {
            type: DataTypes.STRING(20),
            allowNull: false,
            unique: true,
        },
    },{
        timestamps: true,
        paranoid: true,
    })
);