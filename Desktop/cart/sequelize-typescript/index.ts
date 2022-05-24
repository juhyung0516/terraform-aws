import express from "express";
const app = express();
const port = process.env.PORT || 3000;
import db from "./models";
// import { users } from "./seeders/users";
// import { projects } from "./seeders/projects";
// import { projectAssignments } from "./seeders/projectAssignments";

// const createUsers = () => {
//   users.map((user) => {
//     db.User.create(user);
//   });
// };
// createUsers();

// const createProjects = () => {
//   projects.map((project) => {
//     db.Project.create(project);
//   });
// };
// createProjects();

// const createProjectAssignments = () => {
//   projectAssignments.map((projectAssignment) => {
//     db.ProjectAssignment.create(projectAssignment);
//   });
// };
// createProjectAssignments();

// db.ProjectAssignment.create({
//   ProjectId: 1,
//   UserId: "3096eef5-773b-4257-9085-2a5dbe5d4550",
// });

app.get("/", (req, res) => {
  db.User.findAll({
    include: {
      model: db.Project,
    },
  })
    .then((result: object) => res.json(result))
    .catch((err: object) => console.error(err));
});

db.sequelize.sync().then(() => {
  app.listen(port, () => {
    console.log(`app listening on port ${port}`);
  });
});
