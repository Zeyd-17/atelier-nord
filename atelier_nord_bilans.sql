-- Atelier Nord : bilan global et persistant des candidats
-- À exécuter une seule fois dans Supabase > SQL Editor.
-- Les visiteurs peuvent lire et ajouter des bilans, mais le site ne peut pas les modifier ni les supprimer.

create table if not exists public.atelier_nord_bilans (
  client_id uuid primary key,
  candidat text not null check (char_length(trim(candidat)) between 1 and 35),
  score_final integer not null check (score_final between 0 and 300),
  created_at timestamptz not null default now()
);

alter table public.atelier_nord_bilans enable row level security;

-- Accorder uniquement la lecture et l'ajout au rôle public non connecté.
revoke all on table public.atelier_nord_bilans from anon, authenticated;
grant select, insert on table public.atelier_nord_bilans to anon;

-- Retirer les anciennes politiques si ce script est relancé.
drop policy if exists "Atelier Nord - bilans publics visibles" on public.atelier_nord_bilans;
drop policy if exists "Atelier Nord - ajout de bilans" on public.atelier_nord_bilans;

create policy "Atelier Nord - bilans publics visibles"
on public.atelier_nord_bilans
for select
to anon
using (true);

create policy "Atelier Nord - ajout de bilans"
on public.atelier_nord_bilans
for insert
to anon
with check (
  char_length(trim(candidat)) between 1 and 35
  and score_final between 0 and 300
);

-- Aucune permission publique UPDATE ou DELETE n'est accordée.
