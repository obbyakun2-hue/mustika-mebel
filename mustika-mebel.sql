-- ============================================================
-- MUSTIKA MEBEL — Skema database (Supabase / PostgreSQL)
-- Cara pakai: login supabase.com -> project yang sama dengan
-- Tentang Kami / PAP Berdua -> SQL Editor -> tempel SEMUA isi
-- file ini -> Run. Aman dijalankan ulang (idempotent-ish).
-- ============================================================

-- ---------- TABEL ----------
create table if not exists public.mustika_products (
  id uuid primary key default gen_random_uuid(),
  nama text not null,
  kategori text not null check (kategori in ('Kursi','Almari','Meja','Sofa','Tempat Tidur','Bufet')),
  bahan text default '',
  harga bigint not null check (harga >= 0),
  stok integer not null default 0 check (stok >= 0),
  deskripsi text default '',
  foto_url text default '',
  created_at timestamptz not null default now()
);

create table if not exists public.mustika_inquiries (
  id uuid primary key default gen_random_uuid(),
  nama text not null,
  kontak text not null,
  produk text default '',
  pesan text default '',
  status text not null default 'Baru' check (status in ('Baru','Dihubungi','Selesai')),
  created_at timestamptz not null default now()
);

create table if not exists public.mustika_settings (
  id uuid primary key default gen_random_uuid(),
  store_name text not null default 'Mustika Mebel',
  tagline text default '',
  whatsapp text default '',
  opening_hours text default '',
  address text default '',
  about text default '',
  updated_at timestamptz not null default now()
);

-- ---------- ROW LEVEL SECURITY ----------
alter table public.mustika_products  enable row level security;
alter table public.mustika_inquiries enable row level security;
alter table public.mustika_settings  enable row level security;

-- Bersihkan policy lama bernama sama (agar bisa Run ulang)
drop policy if exists "mustika_products_baca_publik"   on public.mustika_products;
drop policy if exists "mustika_products_admin_semua"  on public.mustika_products;
drop policy if exists "mustika_inquiries_kirim_publik" on public.mustika_inquiries;
drop policy if exists "mustika_inquiries_admin_semua"  on public.mustika_inquiries;
drop policy if exists "mustika_settings_baca_publik"   on public.mustika_settings;
drop policy if exists "mustika_settings_admin_semua"   on public.mustika_settings;

-- PRODUCTS: publik boleh BACA saja; admin (authenticated) boleh semua
create policy "mustika_products_baca_publik" on public.mustika_products
  for select to anon, authenticated using (true);
create policy "mustika_products_admin_semua" on public.mustika_products
  for all to authenticated using (true) with check (true);

-- INQUIRIES: publik hanya boleh KIRIM (insert), TIDAK boleh membaca;
-- admin (authenticated) boleh semua
create policy "mustika_inquiries_kirim_publik" on public.mustika_inquiries
  for insert to anon, authenticated with check (true);
create policy "mustika_inquiries_admin_semua" on public.mustika_inquiries
  for all to authenticated using (true) with check (true);

-- SETTINGS: publik boleh BACA saja; admin (authenticated) boleh semua
create policy "mustika_settings_baca_publik" on public.mustika_settings
  for select to anon, authenticated using (true);
create policy "mustika_settings_admin_semua" on public.mustika_settings
  for all to authenticated using (true) with check (true);

-- ---------- SEED: 12 PRODUK CONTOH ----------
-- (total stok 57 unit, nilai inventaris Rp186.200.000)
-- Hanya disisipkan bila tabel produk masih kosong.
insert into public.mustika_products (nama, kategori, bahan, harga, stok, deskripsi, foto_url)
select * from (values
  ('Kursi Santai Jati Klasik','Kursi','Kayu Jati',1850000,8,'Kursi santai ukir klasik, rangka jati solid, finishing melamin halus.','https://images.unsplash.com/photo-1586023492125-27b2c045efd7?q=80&w=900&auto=format&fit=crop'),
  ('Kursi Makan Jati Set 4','Kursi','Kayu Jati',2750000,6,'Satu set 4 kursi makan jati, jok busa nyaman untuk ruang makan keluarga.','https://images.unsplash.com/photo-1577140917170-285929fb55b7?q=80&w=900&auto=format&fit=crop'),
  ('Almari Pakaian 3 Pintu Jati','Almari','Kayu Jati',5500000,3,'Almari 3 pintu dengan cermin, gantungan & laci dalam, engsel kuat.','https://images.unsplash.com/photo-1558997519-83ea9252edf8?q=80&w=900&auto=format&fit=crop'),
  ('Almari Pakaian 2 Pintu','Almari','Kayu Mahoni',3900000,4,'Almari 2 pintu mahoni, desain minimalis cocok untuk kamar anak/kost.','https://images.unsplash.com/photo-1595428774223-ef52624120d2?q=80&w=900&auto=format&fit=crop'),
  ('Meja Makan Jati 6 Kursi','Meja','Kayu Jati',6800000,2,'Meja makan jati besar + 6 kursi, kokoh untuk keluarga besar.','https://images.unsplash.com/photo-1615066390971-03e4e1c36ddf?q=80&w=900&auto=format&fit=crop'),
  ('Meja Kerja Minimalis','Meja','Kayu Mahoni',1950000,10,'Meja kerja/belajar minimalis dengan 2 laci, ringan & rapi.','https://images.unsplash.com/photo-1518455027359-f3f8164ba6bd?q=80&w=900&auto=format&fit=crop'),
  ('Meja Rias Jati + Cermin','Meja','Kayu Jati',2400000,6,'Meja rias jati dengan cermin oval dan laci perhiasan.','https://images.unsplash.com/photo-1616046229478-9901c5536a45?q=80&w=900&auto=format&fit=crop'),
  ('Sofa 3 Dudukan Premium','Sofa','Kain Premium + Kayu Jati',7500000,2,'Sofa 3 dudukan busa premium, kain halus mudah dibersihkan.','https://images.unsplash.com/photo-1555041469-a586c61ea9bc?q=80&w=900&auto=format&fit=crop'),
  ('Sofa Bed Multifungsi','Sofa','Busa Premium',3200000,6,'Sofa yang bisa dibuka jadi tempat tidur tamu, praktis & hemat ruang.','https://images.unsplash.com/photo-1540574163026-643ea20ade25?q=80&w=900&auto=format&fit=crop'),
  ('Tempat Tidur Queen Minimalis','Tempat Tidur','Kayu Jati',4600000,5,'Dipan queen 160x200 desain minimalis, rangka jati kuat anti goyang.','https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?q=80&w=900&auto=format&fit=crop'),
  ('Dipan Ukir Jepara King','Tempat Tidur','Kayu Jati Ukir',8900000,1,'Dipan king 180x200 ukiran Jepara asli, karya pengrajin pilihan.','https://images.unsplash.com/photo-1540518614846-7eded433c457?q=80&w=900&auto=format&fit=crop'),
  ('Bufet TV Jati','Bufet','Kayu Jati',2300000,4,'Bufet TV jati dengan laci & rak kaca, cocok untuk ruang keluarga.','https://images.unsplash.com/photo-1593784991095-a205069470b6?q=80&w=900&auto=format&fit=crop')
) as v(nama,kategori,bahan,harga,stok,deskripsi,foto_url)
where not exists (select 1 from public.mustika_products limit 1);

-- ---------- SEED: PENGATURAN TOKO (1 baris) ----------
insert into public.mustika_settings (store_name, tagline, whatsapp, opening_hours, address, about)
select 'Mustika Mebel',
       'Furniture Jati Elegan untuk Rumah Anda',
       '',
       'Setiap hari 08.00 – 20.00 WIB',
       'Jl. Gatot Subroto, RT.1 / RW.6, Bukir, Kec. Gadingrejo, Kota Pasuruan, Jawa Timur 67138',
       'Mustika Mebel adalah toko furniture di Kota Pasuruan, Jawa Timur. Kami menjual kursi, almari, meja, sofa, tempat tidur, dan bufet — mengutamakan kayu jati & mahoni berkualitas dengan harga bersahabat.'
where not exists (select 1 from public.mustika_settings limit 1);
