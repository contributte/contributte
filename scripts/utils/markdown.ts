/**
 * Markdown table formatting utilities
 */

export interface TableColumn {
  header: string;
  align?: "left" | "right";
}

export interface TableOptions {
  columns: TableColumn[];
  rows: string[][];
}

/**
 * Print a markdown table to console
 * @param options - Table configuration with columns and rows
 */
export function printMarkdownTable(options: TableOptions): void {
  const { columns, rows } = options;

  // Calculate column widths
  const widths = columns.map((col, i) =>
    Math.max(col.header.length, ...rows.map((row) => (row[i] || "").length))
  );

  // Build header row
  const headerCells = columns.map((col, i) =>
    col.align === "right"
      ? col.header.padStart(widths[i])
      : col.header.padEnd(widths[i])
  );
  console.log(`| ${headerCells.join(" | ")} |`);

  // Build separator row
  const separators = widths.map((w) => "-".repeat(w));
  console.log(`| ${separators.join(" | ")} |`);

  // Build data rows
  for (const row of rows) {
    const cells = columns.map((col, i) => {
      const value = row[i] || "";
      return col.align === "right"
        ? value.padStart(widths[i])
        : value.padEnd(widths[i]);
    });
    console.log(`| ${cells.join(" | ")} |`);
  }
}
