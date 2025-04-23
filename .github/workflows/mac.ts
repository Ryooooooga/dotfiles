import { Job, Workflow } from "ghats";

const workflow = new Workflow("macOS", {
  on: "push",
});

workflow.addJob(
  new Job("macOS", {
    runsOn: "macOS-latest",
  })
    .run("curl -sL https://ryooooooga.github.io/dotfiles/install.sh | sh"),
);

export default workflow;
