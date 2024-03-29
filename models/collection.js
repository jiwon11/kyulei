module.exports = (sequelize, DataTypes) => (
    sequelize.define('collection',{
        name: {
            type: DataTypes.STRING(100),
            allowNull: false,
            unique: true,
        },
        private: {
            type: DataTypes.BOOLEAN(),
            allowNull: false,
            unique: false,
        }
    },{
        timestamps: true,
        paranoid: true,
    })
);