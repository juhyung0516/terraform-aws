const Image = require("../../models/Image2");
import { Op } from "sequelize";
/**
 Resolvers Map
 Define's the technique for fetching the types defined in the schema. 
 The map below corresponds the the schema declarations in the typeDefs file.
 Supported fields include Query, Mutation, Subscription keys. See [https://graphql.org/](graphql docs) for further info.
 */
const resolvers = {
  Query: {
    images: async () => {
      try {
        const images = await Image.findAll();
        return images;
      } catch (error: any) {
        throw new Error(error);
      }
    },
    search: async (_: any, query: any) => {
      try {
        const { terms } = query;
        const images = await Image.findAll({
          where: {
            name: {
              [Op.iLike]: `%${terms}%`,
            },
          },
        });
        return images;
      } catch (error: any) {
        throw new Error(error);
      }
    },
  },
  Mutation: {
    addImage: async (_: any, file: any) => {
      try {
        const image = new Image(file);
        await image.save();
        return image;
      } catch (error: any) {
        throw new Error(error);
      }
    },
  },
};
module.exports = resolvers;
