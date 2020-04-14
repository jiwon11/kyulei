module.exports = (sequelize, DataTypes) => (
    sequelize.define('user', {
        email: {
            type: DataTypes.STRING(40),
            allowNull: false,
            unique: true,
        },
        nick: {
            type: DataTypes.STRING(30),
            allowNull: false,
        },
        password: {
            type: DataTypes.STRING(100),
            allowNull: true,
        },
        gender: {
            type: DataTypes.STRING(10),
            allowNull: false,
        },
        birthday: {
            type: DataTypes.DATE,
            get: function(fieldName) {
                const rawValue = this.getDataValue('loaned_on');
                // parse raw value using whatever logic you want
                // this won't work, but you get the idea
                return moment(rawValue).toISOString();
                },
            allowNull: false,
            },
        }, {
        timestamps: true,
        paranoid: true,
    })
);