# IntentionalNoise.band — public artist website network

**Current checkpoint:** [IN-NET-2026-11-08-SYNC-01](https://github.com/fwjeweler1-droid/connect.intentionalnoise.info/blob/main/NETWORK_SYNC_CHECKPOINT_2026-11-08.md)  
**Machine-readable network placement:** [network-sync.json](network-sync.json)

## Current scope and deployment

This repository contains the deployed public `https://intentionalnoise.band/` website, independent artist showcases, and the `https://intentionalnoise.band/artists.html` published-artist directory. Its latest Pages build at this checkpoint was reported successful. Browser, mobile, signup-to-unpublish and cross-account behavior still require end-to-end acceptance.

A user **signs up once through Connect**, edits their profile there, and receives a private draft for the artist page. Approved/published `artist_pages` are read as public showrooms across four sites: IntentionalNoise.info, Connect, this .band website, and IneedaGig. This is **shared database content**, not four copies or separate logins.

**Site responsibilities:** `.band` is the artist showcase; [IneedaGig](https://ineedagig.net/) is the booking hub; [Connect](https://connect.intentionalnoise.info/) remains the identity/profile/media backend; [.info](https://intentionalnoise.info/) provides community information. Artist publication must remain opt-in. The public directory must never display private drafts or email addresses.

## Security and creative authority

Keep unpublished WAV/MP4 files off public pages. Private member data, storage links and authentication stay protected by Connect/Supabase row-level security. Do not store provider OAuth secrets, service-role keys, or private artist media in public web code. Ensure users consent before publishing; test unpublish and cross-account access.

The Intentional Noise **MPCC/Library** remains authoritative for music releases, approved assets, media lineage and promotional status; the network checkpoint cannot overwrite it.

## Older prototype history

The prior November 5 README stated that this repository was private and not deployed. That is **superseded by the current public GitHub Pages deployment**. The original text has been preserved unchanged in [archive/INITIAL_README_2026-11-05.md](archive/INITIAL_README_2026-11-05.md) for historical reference. Do not use its prototype status as current project evidence.
