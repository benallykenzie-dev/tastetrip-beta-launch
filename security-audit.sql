-- Read-only verification for the public beta waitlist table.

select
  grantee,
  privilege_type
from information_schema.role_table_grants
where table_schema = 'public'
  and table_name = 'beta_signups'
  and grantee in ('anon', 'authenticated')
order by grantee, privilege_type;

select
  policyname,
  roles,
  cmd,
  qual,
  with_check
from pg_policies
where schemaname = 'public'
  and tablename = 'beta_signups'
order by policyname;
