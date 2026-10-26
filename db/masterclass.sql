-- Run once in the Supabase SQL editor. Service role credentials stay on the server.
create table public.session_config (id integer primary key check (id=1), settings jsonb not null default '{}'::jsonb);
insert into public.session_config(id) values(1);
create table public.registrations (
 id uuid primary key default gen_random_uuid(),
 name text not null, email text not null unique, mobile text not null,
 role text not null, automation text not null default '',
 token_hash text not null unique,
 utr text unique, status text not null default 'unpaid' check(status in ('unpaid','pending','confirmed','rejected')),
 email_sent boolean not null default false,
 created_at timestamptz not null default now(), confirmed_at timestamptz
);
alter table public.registrations enable row level security;
alter table public.session_config enable row level security;
-- No anonymous or authenticated client policies. Access only via server service role.
revoke all on public.registrations, public.session_config from anon, authenticated;
create or replace function public.approve_registration(registration_id uuid)
returns setof public.registrations language plpgsql security definer set search_path = public as $$
declare seat_capacity integer; current_count integer;
begin
 perform pg_advisory_xact_lock(96702319);
 if not exists(select 1 from registrations where id=registration_id and status='pending' and utr is not null) then
  raise exception 'Only pending submissions with a UTR may be approved';
 end if;
 select (settings->>'capacity')::integer into seat_capacity from session_config where id=1;
 select count(*) into current_count from registrations where status='confirmed';
 if seat_capacity is not null and current_count >= seat_capacity then raise exception 'Session is full'; end if;
 return query update registrations set status='confirmed', confirmed_at=now() where id=registration_id and status='pending' returning *;
end $$;
revoke all on function public.approve_registration(uuid) from public, anon, authenticated;
grant execute on function public.approve_registration(uuid) to service_role;
