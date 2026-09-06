# LinkedIn Human-Approved Publishing Pipeline

## Purpose

CyberFlow AI prepares and publishes verified cybersecurity content to LinkedIn while maintaining a mandatory Human-in-the-Loop approval step.

No LinkedIn post is published automatically without explicit human approval.

## Pipeline

The publishing flow is:

Cybersecurity source
→ Deduplication
→ AI relevance scoring
→ Research
→ Source verification
→ Verification confidence gate
→ LinkedIn Content Agent
→ Source image discovery
→ Draft creation
→ Gmail human approval
→ LinkedIn image upload
→ LinkedIn post publication
→ Publication status persistence

## Human Approval

Generated LinkedIn content is stored in the `linkedin_drafts` PostgreSQL table with:

- status `pending_approval`
- article reference
- headline
- post text
- hashtags
- verified source
- source URL
- image URL

n8n sends an approval request using Gmail.

Approved drafts are changed to:

`status = approved`

Rejected or skipped content follows the non-publishing branch.

Publishing is never attempted before approval.

## LinkedIn Authentication

LinkedIn publishing uses OAuth 2.0 through an n8n Generic OAuth2 credential.

Required LinkedIn scope:

`w_member_social`

Authentication secrets and credential identifiers must never be stored in exported public workflows.

Credentials must be configured locally after workflow import.

## Image Publishing

For approved posts, CyberFlow AI:

1. Downloads the verified article image.
2. Initializes a LinkedIn image upload.
3. Receives an image URN and temporary upload URL.
4. Uploads the binary image.
5. Uses the returned image URN when creating the LinkedIn post.

LinkedIn image initialization endpoint:

`POST /rest/images?action=initializeUpload`

The binary image is uploaded using the temporary LinkedIn upload URL.

## Post Publishing

Posts are created using:

`POST /rest/posts`

Required headers include:

- `Linkedin-Version`
- `X-Restli-Protocol-Version: 2.0.0`

The post contains:

- authenticated member author
- approved commentary
- public visibility
- uploaded LinkedIn image URN
- published lifecycle state

## Publication Verification

The HTTP response is configured to include response headers and HTTP status.

A publication is considered successful only when:

- HTTP status is `201`
- `x-restli-id` is present

The workflow uses:

`LinkedIn Publish Successful`

to enforce both conditions.

## Successful Publication

On success:

`Mark LinkedIn Draft Published`

updates the database:

- `status = published`
- `linkedin_post_id = x-restli-id`
- `published_at = NOW()`
- `updated_at = NOW()`

The LinkedIn post identifier is retained for future analytics and post management.

## Failed Publication

If the LinkedIn API does not return both HTTP 201 and a post identifier:

`Mark LinkedIn Draft Error`

sets:

`status = error`

This prevents failed API requests from being incorrectly recorded as published posts.

## Database Migration

Migration:

`006_add_linkedin_post_id.sql`

adds:

`linkedin_post_id TEXT`

to `linkedin_drafts`.

## Security

Public workflow exports must not contain:

- API keys
- OAuth access or refresh tokens
- client secrets
- n8n credential metadata
- personal email addresses
- n8n owner metadata
- n8n project identifiers

The public workflow uses placeholder values such as:

`approval@example.com`

Credentials must be selected manually after import.

## Verified E2E Milestone

The complete pipeline has been successfully tested against a real LinkedIn personal profile.

Verified working stages:

Source ingestion
→ AI scoring
→ source research
→ source verification
→ LinkedIn content generation
→ article image retrieval
→ PostgreSQL draft
→ Gmail human approval
→ LinkedIn OAuth
→ LinkedIn image upload
→ public LinkedIn post publication

This establishes the first production-capable Human-in-the-Loop LinkedIn publishing path for CyberFlow AI.
