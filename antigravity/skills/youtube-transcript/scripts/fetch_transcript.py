#!/usr/bin/env python3
"""Fetch plain text transcript from a YouTube video URL or ID."""

import re
import sys
from youtube_transcript_api import YouTubeTranscriptApi

if len(sys.argv) < 2 or sys.argv[1] in ("-h", "--help"):
    print(f"Usage: {sys.argv[0]} <YOUTUBE_URL_OR_ID>")
    sys.exit(0 if len(sys.argv) > 1 and sys.argv[1] in ("-h", "--help") else 1)

match = re.search(r"(?:v=|[/-]|^)([A-Za-z0-9_-]{11})(?:[?&]|$)", sys.argv[1].strip())
if not match:
    sys.exit("Error: Could not extract video ID.")

try:
    transcripts = YouTubeTranscriptApi().list(match.group(1))
    try:
        transcript = transcripts.find_transcript(["en", "en-US", "en-GB"])
    except Exception:
        transcript = next(iter(transcripts))
    print(" ".join(s.text for s in transcript.fetch()))
except StopIteration:
    sys.exit("Error: No transcripts available for this video.")
except Exception as e:
    sys.exit(f"Error: {e}")
