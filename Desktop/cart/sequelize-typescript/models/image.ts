const { Model, Sequelize, DataTypes } = require("sequelize");
const client = require("../db");
class Image extends Model {}
Image.init(
  {
    file: {
      type: Sequelize.TEXT, // Allows for unlimited length of text
      allowNull: false,
    },
    name: {
      type: DataTypes.STRING,
      allowNull: false,
    },
    type: {
      type: DataTypes.STRING,
    },
  },
  {
    sequelize: client,
    modelName: "image",
  }
);
Image.sync();
module.exports = Image;
