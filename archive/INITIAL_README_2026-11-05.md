# Historical archive — superseded initial README

The content below describes the initial prototype state and is **not** the current deployed-site status. See root README and the cross-site checkpoint for current facts.

# Intentional Noise Remote Band Command Center

Initial front-end rebuild committed November 5, 2026. `index.html` provides visitor-view demonstration of overview, artist media/storage gateway, auditions, packet checklist, engineering/approval gates, storage resources and START/MPCC handoff.

## Deployment

Repository is **private**. A public `intentionalnoise.band` website has **not** been deployed or DNS-configured. Do not add a `CNAME` or claim a public link until domain ownership, hosting eligibility, HTTPS and DNS are verified. A private repository's Pages availability depends on GitHub plan/settings.

## Not implemented

Supabase authentication/RLS and database persistence, secure external-provider OAuth, file uploads, 60-second video duration enforcement, admin approvals, royalty agreement execution, backup/restore, audit logs, and private resources authorization. The current UI is an honest static demonstration only.

## Security requirements

Keep unpublished WAV/MP4 off the public site. Store metadata and pointers under Supabase RLS; enforce actual file access at external provider. Never store credentials or provider tokens in browser-visible code. Verify redirect and allowed origin settings, use signed/short-lived access, protect against SSRF, and test revoked permissions.

## Authority

START and authoritative Music_Project_Command_Center.xlsx remain authoritative. Do not silently overwrite them. Require explicit approval and dated export for handoff. Existing .com, .info, and connect subdomain remain unchanged.

## Resources

Provider descriptions are preliminary. Verify plan prices, limits, retention/inactivity policies, API support, and any affiliate program before presenting claims to artists. Disclose affiliate links.
