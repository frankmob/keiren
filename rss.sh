#!/bin/bash

# RSS feed header
echo '<?xml version="1.0" encoding="UTF-8" ?>' > rss.xml
echo '<rss version="2.0">' >> rss.xml
echo '  <channel>' >> rss.xml
echo '    <title>keiren.de RSS feed</title>' >> rss.xml
echo '    <link>https://keiren.de</link>' >> rss.xml
echo '    <description>keiren.de RSS feed </description>' >> rss.xml

# Path to the directory containing HTML blog posts
posts_directory="/home/frank/keiren"

# Parsing HTML files in the directory
for filename in "$posts_directory"/*.html; do
    if [ -f "$filename" ]; then
        post_title=$(awk -F'<h1>|</h1>' '/<h1>/ {print $2; exit}' "$filename")
        post_date=$(awk -F'<cite>|</cite>' '/<cite>/ {print $2; exit}' "$filename")
	    post_content=$(sed -n '/<article>/,/<\/article>/p' "$filename" | sed '/^$/d' | tr -s ' ')
	    post_id="$filename"

        # Add the post to the RSS feed
        echo '    <item>' >> rss.xml
        echo "      <title>$post_title</title>" >> rss.xml
	    echo "      <link>https://keiren.de/$post_id</link>" >> rss.xml
	    echo "      <guid>https://keiren.de/$post_id</guid>" >> rss.xml
        echo "      <pubDate>$post_date</pubDate>" >> rss.xml
        echo "      <description><![CDATA[$post_content]]></description>" >> rss.xml
        echo '    </item>' >> rss.xml
    fi
done

# Close the RSS feed
echo '  </channel>' >> rss.xml
echo '</rss>' >> rss.xml

echo 'RSS feed generated successfully.'
