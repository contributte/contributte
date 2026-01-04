/**
 * Date utilities for calculating time differences
 */

/**
 * Calculate the number of days since a given date
 * @param dateString - ISO date string
 * @returns Number of days since the date
 */
export function daysSince(dateString: string): number {
  const date = new Date(dateString);
  const now = new Date();
  const diffTime = Math.abs(now.getTime() - date.getTime());
  return Math.floor(diffTime / (1000 * 60 * 60 * 24));
}

/**
 * Format a date string to YYYY-MM-DD format
 * @param dateString - ISO date string
 * @returns Formatted date string
 */
export function formatDate(dateString: string): string {
  return dateString.split("T")[0];
}
