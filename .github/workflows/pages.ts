import { action, Job, Workflow } from "ghats";

const workflow = new Workflow("Pages", {
  on: "push",
});

workflow.addJob(
  new Job("pages", {
    runsOn: "ubuntu-latest",
  })
    .uses(action("actions/checkout"))
    .run("mkdir -p out")
    .run("cp -f install.sh out/")
    .uses(action("peaceiris/actions-gh-pages", {
      with: {
        github_token: "${{ secrets.GITHUB_TOKEN }}",
        publish_dir: "out",
      },
      if: "github.ref == 'refs/heads/main'",
    })),
);

export default workflow;
