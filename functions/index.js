// ✅ Firebase Functions v2 and logger
const { onRequest } = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");

// ✅ Supabase client SDK
const { createClient } = require("@supabase/supabase-js");

// ✅ Replace these with your actual Supabase project URL and anon key
const supabaseUrl = "https://vfwdnzztsvtapbrjvkxi.supabase.co";
const supabaseAnonKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZmd2Ruenp0c3Z0YXBicmp2a3hpIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDkyMzMxMjUsImV4cCI6MjA2NDgwOTEyNX0.CcNyP3_8brVbVRYu8N1G8TG3T0V37H_AVsoCHNw1uvI";

// ✅ Initialize Supabase client outside of function for better performance
const supabase = createClient(supabaseUrl, supabaseAnonKey);

// ✅ Helper function to escape HTML
function escapeHtml(text) {
  if (!text) return '';
  return text.replace(/[&<>"']/g, function(match) {
    const escapeMap = {
      '&': '&amp;',
      '<': '&lt;',
      '>': '&gt;',
      '"': '&quot;',
      "'": '&#39;'
    };
    return escapeMap[match];
  });
}

// ✅ Cloud Function to generate dynamic OG meta tags
exports.ogNews = onRequest({
  timeoutSeconds: 30,
  memory: "2GiB",
  cors: true
}, async (req, res) => {
  try {
    const newsId = req.query.id || req.params.id;
    
    if (!newsId) {
      logger.warn("Missing 'id' query param");
      return res.status(400).send("Missing news ID");
    }

    logger.info("Fetching news data for ID:", newsId);

    // 🔎 Fetch news data from Supabase with timeout
    const { data, error } = await Promise.race([
      supabase
        .from("news")
        .select("id, title, description, image_url")
        .eq("id", newsId)
        .single(),
      new Promise((_, reject) => 
        setTimeout(() => reject(new Error('Database timeout')), 8000)
      )
    ]);

    if (error || !data) {
      logger.error("News not found or error:", error);
      return res.status(404).send(`
        <!DOCTYPE html>
        <html>
        <head>
          <title>News Not Found</title>
          <meta property="og:title" content="News Not Found" />
          <meta property="og:description" content="The requested news article could not be found." />
        </head>
        <body>
          <h1>News Not Found</h1>
          <p>The requested news article could not be found.</p>
        </body>
        </html>
      `);
    }

    // 🖼️ Extract data and process image URL
    const { title, description, image_url } = data;
    
    // Image URL validation and fallback
    let processedImageUrl;
    if (!image_url || image_url.trim() === '') {
      // Use a default fallback image
      processedImageUrl = 'https://palakkadonlinenews.com/assets/default-news-image.jpg';
      logger.warn("No image_url found, using fallback image");
    } else {
      // Ensure image URL is absolute
      if (!image_url.startsWith('http://') && !image_url.startsWith('https://')) {
        processedImageUrl = `https://palakkadonlinenews.com${image_url.startsWith('/') ? '' : '/'}${image_url}`;
      } else {
        processedImageUrl = image_url;
      }
      logger.info("Using image URL:", processedImageUrl);
    }

    const redirectUrl = `https://palakkadonlinenews.com/NewsDetail?id=${newsId}`;
    
    // Escape HTML content
    const safeTitle = escapeHtml(title);
    const safeDescription = escapeHtml(description);
    const safeImageUrl = escapeHtml(processedImageUrl);
    const safeRedirectUrl = escapeHtml(redirectUrl);

    logger.info("✅ Serving OG meta tags for news ID:", newsId);

    // 🧠 Serve dynamic OG meta page
    res.set("Cache-Control", "public, max-age=300, s-maxage=600");
    res.set("Content-Type", "text/html; charset=utf-8");
    
    res.send(`<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>${safeTitle}</title>
  
  <!-- Open Graph -->
  <meta property="og:title" content="${safeTitle}" />
  <meta property="og:description" content="${safeDescription}" />
  <meta property="og:image" content="${safeImageUrl}" />
  <meta property="og:image:secure_url" content="${safeImageUrl}" />
  <meta property="og:image:type" content="image/jpeg" />
  <meta property="og:image:width" content="1200" />
  <meta property="og:image:height" content="630" />
  <meta property="og:image:alt" content="${safeTitle}" />
  <meta property="og:url" content="${safeRedirectUrl}" />
  <meta property="og:type" content="article" />
  <meta property="og:site_name" content="Palakkad Online News" />
  
  <!-- Twitter Card -->
  <meta name="twitter:card" content="summary_large_image" />
  <meta name="twitter:site" content="@palakkadnews" />
  <meta name="twitter:creator" content="@palakkadnews" />
  <meta name="twitter:title" content="${safeTitle}" />
  <meta name="twitter:description" content="${safeDescription}" />
  <meta name="twitter:image" content="${safeImageUrl}" />
  <meta name="twitter:image:alt" content="${safeTitle}" />
  
  <!-- Additional SEO -->
  <meta name="description" content="${safeDescription}" />
  <meta name="robots" content="index, follow" />
  <link rel="canonical" href="${safeRedirectUrl}" />
  
  <!-- Redirect to actual news page -->
  <script>
    setTimeout(function() {
      window.location.href = "${safeRedirectUrl}";
    }, 100);
  </script>
  
  <!-- Fallback redirect -->
  <meta http-equiv="refresh" content="1;url=${safeRedirectUrl}">
</head>
<body>
  <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 50px auto; padding: 20px; text-align: center;">
    <h1>${safeTitle}</h1>
    <p>${safeDescription}</p>
    <p>Redirecting to the full article...</p>
    <a href="${safeRedirectUrl}" style="color: #1976d2; text-decoration: none;">Click here if you're not redirected automatically</a>
  </div>
</body>
</html>`);

  } catch (error) {
    logger.error("Function error:", error);
    res.status(500).send(`
      <!DOCTYPE html>
      <html>
      <head>
        <title>Error Loading News</title>
        <meta property="og:title" content="Error Loading News" />
        <meta property="og:description" content="There was an error loading this news article." />
      </head>
      <body>
        <h1>Error Loading News</h1>
        <p>There was an error loading this news article. Please try again later.</p>
      </body>
      </html>
    `);
  }
});