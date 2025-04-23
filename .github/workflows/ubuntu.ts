import { Job, Workflow } from "ghats";

const workflow = new Workflow("Ubuntu", {
  on: "push",
});

workflow.addJob(
  new Job("ubuntu", {
    runsOn: "ubuntu-latest",
  })
    .run("curl -sL https://ryooooooga.github.io/dotfiles/install.sh | sh"),
);

export default workflow;
