#!/usr/bin/env bun

/**
 * Script to enable disabled workflows for all non-archived repositories
 *
 * Usage: bun scripts/enable-workflows.ts
 */

import {
  fetchActiveRepositories,
  type Repository,
  ORGANIZATION,
} from "./utils";

interface Workflow {
  id: number;
  name: string;
  state: string;
}

interface WorkflowsResponse {
  workflows: Workflow[];
}

async function listWorkflows(repoName: string): Promise<Workflow[]> {
  const proc = Bun.spawn(
    ["gh", "api", `repos/${ORGANIZATION}/${repoName}/actions/workflows`],
    { stdout: "pipe", stderr: "pipe" }
  );

  const stdout = await new Response(proc.stdout).text();
  const exitCode = await proc.exited;

  if (exitCode !== 0) {
    return [];
  }

  const response = JSON.parse(stdout) as WorkflowsResponse;
  return response.workflows || [];
}

async function enableWorkflow(repoName: string, workflowId: number): Promise<boolean> {
  const proc = Bun.spawn(
    ["gh", "api", "-X", "PUT", `repos/${ORGANIZATION}/${repoName}/actions/workflows/${workflowId}/enable`],
    { stdout: "pipe", stderr: "pipe" }
  );

  const exitCode = await proc.exited;
  return exitCode === 0;
}

async function processRepository(repo: Repository): Promise<number> {
  const workflows = await listWorkflows(repo.name);
  const disabledWorkflows = workflows.filter((w) => w.state !== "active");

  let enabledCount = 0;

  for (const workflow of disabledWorkflows) {
    const success = await enableWorkflow(repo.name, workflow.id);
    if (success) {
      console.log(`  Enabled: ${workflow.name} (${workflow.id})`);
      enabledCount++;
    } else {
      console.log(`  Failed to enable: ${workflow.name} (${workflow.id})`);
    }
  }

  return enabledCount;
}

async function main() {
  const repos = await fetchActiveRepositories();

  console.log(`Processing ${repos.length} active repositories...\n`);

  let totalEnabled = 0;

  for (const repo of repos) {
    const enabledCount = await processRepository(repo);
    if (enabledCount > 0) {
      console.log(`${repo.name}: enabled ${enabledCount} workflow(s)\n`);
      totalEnabled += enabledCount;
    }
  }

  console.log("---");
  console.log(`Done. Enabled ${totalEnabled} workflow(s) across ${repos.length} repositories.`);
}

main();
