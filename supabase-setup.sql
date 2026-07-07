create table if not exists public.beta_signups (
  id uuid primary key default gen_random_uuid(),
  email text not null unique,
  launch_city text not null default 'Las Vegas',
  source text not null default 'TasteTrip beta page',
  created_at timestamptz not null default now()
);

alter table public.beta_signups enable row level security;
alter table public.beta_signups force row level security;

grant usage on schema public to anon, authenticated;
revoke all on table public.beta_signups from anon, authenticated;
grant insert on table public.beta_signups to anon, authenticated;

drop policy if exists "Anyone can join the beta waitlist" on public.beta_signups;
drop policy if exists "Authenticated visitors can join the beta waitlist" on public.beta_signups;

create policy "Anyone can join the beta waitlist"
on public.beta_signups
for insert
to anon
with check (
  email ~* '^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$'
);

create policy "Authenticated visitors can join the beta waitlist"
on public.beta_signups
for insert
to authenticated
with check (
  email ~* '^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$'
);

alter table if exists public.restaurants enable row level security;

create or replace function public.get_tastetrip_launch_counts()
returns table (
  users_signed_up bigint,
  restaurants_onboarded bigint
)
language sql
security definer
set search_path = public
as $$
  select
    (select count(*) from public.beta_signups) as users_signed_up,
    (select count(*) from public.restaurants) as restaurants_onboarded;
$$;

revoke all on function public.get_tastetrip_launch_counts() from public;
grant execute on function public.get_tastetrip_launch_counts() to anon;
grant execute on function public.get_tastetrip_launch_counts() to authenticated;
