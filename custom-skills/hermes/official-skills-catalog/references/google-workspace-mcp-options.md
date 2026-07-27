# Google Workspace integration options for Hermes

Use this reference when the user asks how to connect Gmail, Google Docs, Drive, Sheets, Calendar, or similar Google Workspace services to Hermes.

## Recommended path: n8n MCP

For broad Google Workspace access, prefer n8n exposed to Hermes through MCP rather than a random Google-specific MCP package.

Why:

- n8n has mature Google integrations and OAuth credential handling.
- One n8n MCP connection can expose many controlled workflows/tools to Hermes.
- Google OAuth tokens stay inside the automation layer rather than being scattered across ad-hoc scripts.
- It is easier to scope tools safely: e.g. read Gmail first, send mail only later, Drive read-only before write access.

High-level setup:

```sh
hermes mcp install n8n
hermes mcp list
hermes mcp test n8n
hermes mcp configure n8n
```

Then configure Google OAuth credentials in n8n and expose only the workflows Hermes should use, such as:

- Search Gmail
- Read email
- Draft/send email
- Search Drive files
- Read a Google Doc
- Create or update a Google Doc
- Read/write selected Sheets

## Alternative: direct Google MCP server

If a trusted Google Workspace MCP server is chosen, connect it as either stdio or HTTP/SSE:

```sh
hermes mcp add google --command npx --args -y <trusted-google-mcp-package>
# or
hermes mcp add google --url https://<endpoint> --auth oauth
hermes mcp test google
hermes mcp configure google
```

Before installing, inspect provenance, requested OAuth scopes, token storage, Android/Termux compatibility, and maintenance status. Do not install a random community Google MCP package without review.

## Alternative: custom Google API scripts + skill

For narrow project workflows, use Python/Node Google API scripts plus a custom Hermes skill. This is best when the task is specific and repeatable, such as “read docs from one Drive folder and create SEO summaries.” It is more controlled than a broad MCP integration but less flexible.

## Scope/safety guidance

Start with least privilege:

- Gmail: read/search first; add send only when explicitly needed; avoid delete/modify initially.
- Drive: prefer read-only or folder/file-scoped access when possible; avoid full Drive scope unless required.
- Docs/Sheets: grant write access only for the documents or workflows that need it.
- Treat payment, deletion, mass-mailing, and broad write tools as explicit-confirmation actions.

## Practical recommendation for this user

For the user's Android/Termux + SEO/GEO + Obsidian workflow, set up in this order:

1. Configure GitHub auth or `gh` CLI so official skill installs do not hit unauthenticated rate limits.
2. Install/test n8n MCP.
3. Configure Google OAuth inside n8n.
4. Expose a small safe Google toolset to Hermes.
5. Create or patch a dedicated class-level skill for the final Google Workspace workflow once it is proven.
