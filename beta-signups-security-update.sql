-- TasteTrip launch page: tighten the existing beta_signups table.
-- This does not delete the table or any waitlist records.

begin;

alter table public.beta_signups enable row level security;
alter table public.beta_signups force row level security;

revoke all on table public.beta_signups from anon, authenticated;
grant insert on table public.beta_signups to anon, authenticated;

alter policy "Anyone can join the beta waitlist"
on public.beta_signups
to anon
with check (
  email ~* '^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$'
);

alter policy "Authenticated visitors can join the beta waitlist"
on public.beta_signups
to authenticated
with check (
  email ~* '^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$'
);

commit;
