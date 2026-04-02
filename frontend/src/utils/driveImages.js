// Google Drive image URL converter - uses backend proxy to avoid ORB errors
const API_BASE = process.env.REACT_APP_API_URL || 'http://localhost:5000';

export const getDriveImageUrl = (fileId) => {
  // Returns URL through backend proxy endpoint (/images/drive/...)
  return `${API_BASE}/images/drive/${fileId}`;
};

// Store your Google Drive file IDs here
// Get file ID from: https://drive.google.com/file/d/[FILE_ID]/view
export const DRIVE_IMAGES = {
  hero: '1LD1VDYTfffx2TQzyZgidvYy8ZpPP3WOJ', // Your hero image
  project1: 'YOUR_PROJECT1_FILE_ID',
  project2: 'YOUR_PROJECT2_FILE_ID',
  // Add more as needed
};
