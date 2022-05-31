"use strict";
import { Model } from "sequelize";

interface ImageAttributes {
  file: string;
  name: string;
  type: string;
}

module.exports = (sequelize: any, DataTypes: any) => {
  class Image extends Model<ImageAttributes> implements ImageAttributes {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    file!: string;
    name!: string;
    type!: string;
    static associate(models: any) {
      // define association here
    }
  }
  Image.init(
    {
      file: {
        type: DataTypes.STRING,
        allowNull: false,
        primaryKey: true,
      },
      name: {
        type: DataTypes.STRING,
        allowNull: false,
      },
      type: {
        type: DataTypes.STRING,
        allowNull: false,
      },
    },
    {
      sequelize,
      modelName: "Image",
    }
  );
  return Image;
};
