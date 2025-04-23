import { action, Job, Workflow } from "ghats";

const workflow = new Workflow("Lint", {
  on: "push",
});

workflow.addJob(
  new Job("lint", {
    runsOn: "ubuntu-latest",
  })
    .uses(action("actions/checkout"))
    .run("sudo apt install -y shellcheck")
    .run("shellcheck ./install.sh ./scripts/*.bash"),
);

export default workflow;
