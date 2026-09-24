-- The Polymathic production database
-- Run this in Supabase SQL Editor, then verify the RLS policies before launch.

create extension if not exists pgcrypto;

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  display_name text not null,
  age int check (age between 14 and 21),
  role text not null default 'reader' check (role in ('reader','writer','editor','admin')),
  created_at timestamptz not null default now()
);

create table if not exists public.essays (
  id uuid primary key default gen_random_uuid(),
  author_id uuid not null references public.profiles(id) on delete cascade,
  title text not null,
  topic text not null,
  body text not null,
  status text not null default 'draft' check (status in ('draft','pending','published','rejected')),
  created_at timestamptz not null default now(),
  published_at timestamptz
);

create table if not exists public.likes (
  essay_id uuid not null references public.essays(id) on delete cascade,
  user_id uuid not null references public.profiles(id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (essay_id,user_id)
);

create table if not exists public.comments (
  id uuid primary key default gen_random_uuid(),
  essay_id uuid not null references public.essays(id) on delete cascade,
  author_id uuid not null references public.profiles(id) on delete cascade,
  body text not null check (char_length(body) between 1 and 3000),
  status text not null default 'visible' check (status in ('visible','hidden','reported')),
  created_at timestamptz not null default now()
);

create table if not exists public.writer_applications (
  id uuid primary key default gen_random_uuid(),
  applicant_id uuid references public.profiles(id) on delete set null,
  legal_name text not null,
  age int not null check (age between 14 and 21),
  display_name text not null,
  topic text not null,
  reason text not null,
  writing_submission text not null,
  status text not null default 'pending' check (status in ('pending','approved','needs_review','not_accepted')),
  reviewer_note text,
  created_at timestamptz not null default now(),
  reviewed_at timestamptz
);

create index if not exists essays_status_idx on public.essays(status);
create index if not exists essays_topic_idx on public.essays(topic);
create index if not exists comments_essay_idx on public.comments(essay_id);

alter table public.profiles enable row level security;
alter table public.essays enable row level security;
alter table public.likes enable row level security;
alter table public.comments enable row level security;
alter table public.writer_applications enable row level security;

-- Public readers may only see published essays.
create policy "published essays are public"
on public.essays for select to anon, authenticated
using (status='published');

-- Writers can create drafts/pending submissions belonging to themselves.
create policy "writers create own essays"
on public.essays for insert to authenticated
with check (author_id=auth.uid());

create policy "writers update own essays"
on public.essays for update to authenticated
using (author_id=auth.uid())
with check (author_id=auth.uid());

-- Public comments only on published essays; authenticated users create their own.
create policy "visible comments are public"
on public.comments for select to anon, authenticated
using (status='visible');

create policy "users create own comments"
on public.comments for insert to authenticated
with check (author_id=auth.uid());

-- Likes are owned by the signed-in user.
create policy "users view likes"
on public.likes for select to anon, authenticated using (true);
create policy "users create own likes"
on public.likes for insert to authenticated
with check (user_id=auth.uid());
create policy "users delete own likes"
on public.likes for delete to authenticated
using (user_id=auth.uid());

-- Applicants can create their own application. Do NOT make legal names publicly readable.
create policy "users submit applications"
on public.writer_applications for insert to authenticated
with check (applicant_id=auth.uid());

create policy "users view own applications"
on public.writer_applications for select to authenticated
using (applicant_id=auth.uid());

-- IMPORTANT: editor/admin review policies should be added using a server-side role
-- or a carefully designed custom-claims/RLS policy. Never expose service_role
-- credentials in the browser.
