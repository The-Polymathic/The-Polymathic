# The Polymathic — production-ready starter

This package turns the visual prototype into a Next.js/PWA starter designed for a real public launch.

## What is included
- Responsive site matching the green/purple/yellow visual direction
- Paper-wing butterfly logo
- Home, Explore, Top Essays, article/discussion, writer application, and review UI
- Search and likes/comments in the demo
- PWA manifest so the website can be installed as an app on supported devices
- SEO metadata
- Sitemap and robots support
- Supabase production database schema for accounts, writers, essays, likes, comments, and applications
- RLS starter policies

## What must still be connected
A real public service needs:
1. A Supabase project and its URL/publishable key.
2. The SQL in `supabase/schema.sql`.
3. Real authentication and server-side admin/editor authorization.
4. A deployment host such as Vercel.
5. A domain, such as `thepolymathic.org`.
6. A privacy policy, terms/community guidelines, reporting/moderation workflow, and age-appropriate safety/privacy design because the platform serves ages 14–17.
7. App-store packaging/signing and store review if you want a native Google Play app.

## Deploying
Install Node.js, then:

npm install
npm run dev

For production:

npm run build
npm start

For Vercel, import this project from GitHub and set:
NEXT_PUBLIC_SUPABASE_URL
NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY
NEXT_PUBLIC_SITE_URL

The Vercel/Next.js deployment path is documented by Vercel. The Supabase docs cover Auth and Row Level Security.

## Google
A public domain can be indexed by Google after it is deployed and crawlable. The included sitemap/robots files are intended to help search engines discover it. Search visibility is not guaranteed or immediate.

## App
The PWA manifest allows supported browsers to offer an "Install app" option. A Google Play listing is a separate publishing step: it requires a Play Console developer account, store listing, testing/release process, and Google's review/policy requirements.

## Security warning
Never put a Supabase service-role/secret key in browser code. The frontend should use the publishable key with strict RLS; privileged review operations belong on a secure server/Edge Function.
