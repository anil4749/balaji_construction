const express = require('express');
const axios = require('axios');
const router = express.Router();

/**
 * Proxy endpoint for Google Drive images
 * GET /api/images/drive/:fileId
 * 
 * This endpoint proxies requests to Google Drive, bypassing ORB (Opaque Response Blocking) errors
 * that occur when loading Drive images directly from the frontend.
 * 
 * Example: GET /api/images/drive/1LD1VDYTfffx2TQzyZgidvYy8ZpPP3WOJ
 */
router.get('/drive/:fileId', async (req, res) => {
  try {
    const { fileId } = req.params;

    // Validate file ID format (Google Drive file IDs are typically 28-30 chars, alphanumeric with dash/underscore)
    if (!fileId || !/^[a-zA-Z0-9_-]{20,}$/.test(fileId)) {
      return res.status(400).json({ error: 'Invalid Google Drive file ID' });
    }

    const driveUrl = `https://drive.google.com/uc?id=${fileId}&export=view`;

    // Fetch image from Google Drive with appropriate headers
    const response = await axios.get(driveUrl, {
      headers: {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36'
      },
      responseType: 'arraybuffer',
      timeout: 10000
    });

    // Set content type based on what Google Drive returns
    const contentType = response.headers['content-type'] || 'image/jpeg';
    
    // Set proper cache headers
    res.set('Content-Type', contentType);
    res.set('Cache-Control', 'public, max-age=86400'); // Cache for 24 hours
    res.set('Access-Control-Allow-Origin', '*');
    
    res.send(response.data);
  } catch (error) {
    console.error('Error fetching Google Drive image:', error.message);
    
    if (error.response?.status === 404) {
      return res.status(404).json({ error: 'Image not found on Google Drive' });
    }
    
    res.status(500).json({ 
      error: 'Failed to fetch image from Google Drive',
      message: process.env.NODE_ENV === 'development' ? error.message : undefined
    });
  }
});

module.exports = router;
