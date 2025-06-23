// pages/NewsDetail.js (or app/NewsDetail/page.js for App Router)
import Head from 'next/head';
import { useRouter } from 'next/router';
import { useState, useEffect } from 'react';

export default function NewsDetail({ newsData }) {
  const router = useRouter();
  const { id } = router.query;
  const [newsItem, setNewsItem] = useState(newsData);

  // Ensure we have the news data
  useEffect(() => {
    if (!newsItem && id) {
      // Fetch news data if not provided via props
      fetchNewsData(id);
    }
  }, [id, newsItem]);

  const fetchNewsData = async (newsId) => {
    try {
      // Replace with your Supabase fetch logic
      const response = await fetch(`/api/news/${newsId}`);
      const data = await response.json();
      setNewsItem(data);
    } catch (error) {
      console.error('Error fetching news:', error);
    }
  };

  if (!newsItem) {
    return <div>Loading...</div>;
  }

  const newsUrl = `${process.env.NEXT_PUBLIC_BASE_URL}/NewsDetail?id=${newsItem.id}`;
  const imageUrl = newsItem.image_url || `${process.env.NEXT_PUBLIC_BASE_URL}/default-news-image.jpg`;
  
  return (
    <>
      <Head>
        {/* Essential Meta Tags */}
        <title>{newsItem.title} - Palakkad Online News</title>
        <meta name="description" content={newsItem.description || newsItem.title} />
        
        {/* Open Graph Meta Tags for Social Sharing */}
        <meta property="og:type" content="article" />
        <meta property="og:title" content={newsItem.title} />
        <meta property="og:description" content={newsItem.description || newsItem.title} />
        <meta property="og:image" content={imageUrl} />
        <meta property="og:image:width" content="1200" />
        <meta property="og:image:height" content="630" />
        <meta property="og:image:alt" content={newsItem.title} />
        <meta property="og:url" content={newsUrl} />
        <meta property="og:site_name" content="Palakkad Online News" />
        
        {/* Twitter Card Meta Tags */}
        <meta name="twitter:card" content="summary_large_image" />
        <meta name="twitter:title" content={newsItem.title} />
        <meta name="twitter:description" content={newsItem.description || newsItem.title} />
        <meta name="twitter:image" content={imageUrl} />
        
        {/* WhatsApp specific meta tags */}
        <meta property="og:image:type" content="image/jpeg" />
        <meta property="article:published_time" content={newsItem.created_at} />
        <meta property="article:author" content="Palakkad Online News" />
        
        {/* Canonical URL */}
        <link rel="canonical" href={newsUrl} />
      </Head>

      <div className="news-detail-container">
        <article>
          <h1>{newsItem.title}</h1>
          {newsItem.image_url && (
            <img 
              src={newsItem.image_url} 
              alt={newsItem.title}
              style={{ width: '100%', maxWidth: '800px', height: 'auto' }}
            />
          )}
          <p>{newsItem.description}</p>
          <div>{newsItem.content}</div>
          
          <div className="share-buttons">
            <button onClick={handleCopyLink}>Copy Link</button>
            <button onClick={handleShareToWhatsApp}>Share to WhatsApp</button>
          </div>
        </article>
      </div>
    </>
  );

  function handleCopyLink() {
    const shareText = `📰 ${newsItem.title}

${newsItem.description || ''}

🔗 Read more: ${newsUrl}

📰 തുടർന്ന് വായിക്കാം. ക്ലിക്ക് ചെയ്യൂ.👆

Join Our WhatsApp Group 🪀 Palakkad Online News
https://chat.whatsapp.com/G6Zj0ajnIcQ8gm1GyCDgmG

Palakkad Online News Android App download link:
www.palakkadonlinenews.com

#News #Breaking`;

    navigator.clipboard.writeText(shareText).then(() => {
      alert('Complete news data copied to clipboard!');
    }).catch(() => {
      alert('Error copying data');
    });
  }

  function handleShareToWhatsApp() {
    const shareText = `📰 ${newsItem.title}

${newsItem.description || ''}

🔗 Read more: ${newsUrl}`;

    const whatsappUrl = `https://wa.me/?text=${encodeURIComponent(shareText)}`;
    window.open(whatsappUrl, '_blank');
  }
}

// API Route: pages/api/news/[id].js
export async function getServerSideProps(context) {
  const { id } = context.query;
  
  try {
    // Fetch from Supabase
    const { createClient } = require('@supabase/supabase-js');
    const supabase = createClient(
      process.env.NEXT_PUBLIC_SUPABASE_URL,
      process.env.SUPABASE_SERVICE_ROLE_KEY
    );

    const { data: newsData, error } = await supabase
      .from('news')
      .select('*')
      .eq('id', id)
      .single();

    if (error || !newsData) {
      return {
        notFound: true,
      };
    }

    return {
      props: {
        newsData,
      },
    };
  } catch (error) {
    console.error('Error fetching news:', error);
    return {
      notFound: true,
    };
  }
}