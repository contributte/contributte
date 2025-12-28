const path = require("path");
const fs = require("fs");

const ROOT_FOLDERS = [
	"vcs/active",
	"vcs/archive",
];

const getDirectories = async (source) =>
	(await fs.promises.readdir(source, { withFileTypes: true }))
		.filter((dirent) => dirent.isDirectory())
		.map((dirent) => dirent.name);

(async () => {
	console.log("🔍 Verifying project structure...\n");

	let hasIssues = false;
	let totalProjects = 0;
	let totalFolders = 0;

	for await (const rootFolder of ROOT_FOLDERS) {
		const folderPath = path.resolve(__dirname, "../", rootFolder);

		const meta = JSON.parse(fs.readFileSync(path.resolve(folderPath, ".meta")));
		const projects = Object.keys(meta.projects);
		const folders = await getDirectories(folderPath);

		totalProjects += projects.length;
		totalFolders += folders.length;

		console.log(`📁 ${rootFolder}: ${projects.length} tracked, ${folders.length} installed`);

		const diffFolders = folders.filter((item) => !projects.includes(item));
		if (diffFolders.length) {
			console.log(`   ⚠️  Untracked folders:`, diffFolders);
			hasIssues = true;
		}

		const diffProjects = projects.filter((item) => !folders.includes(item));
		if (diffProjects.length) {
			console.log(`   ⚠️  Missing projects:`, diffProjects);
			hasIssues = true;
		}
	}

	console.log("");
	if (hasIssues) {
		console.log("❌ Verification completed with issues.");
		process.exit(1);
	} else {
		console.log(`✅ All ${totalProjects} projects verified successfully.`);
	}
})();
