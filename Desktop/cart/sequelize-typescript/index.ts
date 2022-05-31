import express from "express";
const { ApolloServer, gql } = require('apollo-server-express');
const {
  GraphQLUpload,
  graphqlUploadExpress, // A Koa implementation is also exported.
} = require('graphql-upload');

const resolvers = require("./graphql/resolvers");
const { typeDefs } = require("./graphql/typeDefs");
const { graphqlHTTP } = require("express-graphql");
const { makeExecutableSchema } = require("graphql-tools");
const cors = require("cors");
const port = process.env.PORT || 3000;

import db from "./models";

import { GraphQLSchema } from "graphql";

const app = express();
app.use(cors());
app.use(express.json({ limit: "50mb" }));

const schema = makeExecutableSchema({
  typeDefs,
  resolvers,
});

app.all("/", (_, res) => res.redirect("/graphql"));
app.use(
  "/graphql",
  graphqlHTTP({
    schema,
    graphiql: true, // creates playground
  })
);

app.listen(port, () => {
  console.log(`🚀  Server ready at ${port}`);
});

// app.get("/", (req, res) => {
//   db.User.findAll({
//     include: {
//       model: db.Project,
//     },
//   })
//     .then((result: object) => res.json(result))
//     .catch((err: object) => console.error(err));
// });

// var options = {
//   exclude: ["Users"],
// };

// const { generateSchema } = require("sequelize-graphql-schema")(options);

// app.use(
//   "/graphql",
//   graphqlHTTP({
//     schema: new GraphQLSchema(generateSchema(db)),
//     graphiql: true,
//   })
// );

// app.listen(8080, function () {
//   console.log("RUNNING ON 8080. Graphiql http://localhost:8080/graphql");
// });
