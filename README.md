# Mebel Mustika — Website Toko (GitHub Pages + Supabase)

Website toko **Mebel Mustika**, Jl. Gatot Subroto, RT.1/RW.6, Bukir, Kec. Gadingrejo, Kota Pasuruan, Jawa Timur 67138.
Tampilan toko online hijau-putih ala WooCommerce (top bar hijau, header pencarian, Browse Categories, hero sidebar + banner, Kategori Produk asimetris, Produk Pilihan tab Terbaru/Diskon/Terpopuler, spotlight lime, Desain Custom 4 tahap, Blog, footer 4 kolom) — layout terinspirasi toko furniture Jepara online, konten & teks asli Mebel Mustika.
Jual kursi, almari, meja, sofa, tempat tidur, dan bufet.

- 🌐 **Live:** https://obbyakun2-hue.github.io/mustika-mebel/
- 📦 **Repo:** https://github.com/obbyakun2-hue/mustika-mebel

Tampilan di-hosting statis di GitHub Pages (`index.html`, vanilla JS), data disimpan di **Supabase** (project yang sama dengan website Tentang Kami / PAP Berdua): tabel `mustika_products`, `mustika_inquiries`, `mustika_settings`.

## 1. Aktifkan data live (WAJIB, sekali saja — hanya pemilik yang bisa)

Selama langkah ini belum dilakukan, website tampil dalam **Mode Contoh**: 12 produk contoh bawaan frontend + banner peringatan, dan pesanan tidak tersimpan ke database.

1. Buka https://supabase.com dan login, pilih project yang sama seperti Tentang Kami / PAP Berdua.
2. Menu **SQL Editor → New query**.
3. Tempel **seluruh isi** file [`mustika-mebel.sql`](mustika-mebel.sql) → klik **Run**.
4. Muat ulang website — banner Mode Contoh hilang dan katalog membaca data dari database (termasuk seed 12 produk contoh & 1 baris pengaturan toko).

File SQL itu membuat tabel, mengaktifkan RLS, dan menyisipkan seed produk + pengaturan bawaan (hanya bila tabel masih kosong, jadi aman dijalankan ulang).

## 2. Buat akun admin

Menu Admin memakai **Supabase Auth** (email + password), bukan PIN.

1. Di Supabase: **Authentication → Users → Add user** — atau daftar lewat formulir Sign Up bila masih aktif.
2. Setelah **1 akun bersama** jadi, masuk **Authentication → Settings** dan **matikan "Allow new users to sign up"** supaya tidak ada orang lain yang bisa mendaftar.
3. Di website, klik **🔐 Menu Admin** → masuk dengan email + password itu.

Setelah masuk, admin bisa: **Kelola Produk** (tambah/ubah/hapus), **Pesanan Masuk** (lihat, ubah status Baru → Dihubungi → Selesai, hapus), **Pengaturan Toko**.

## 3. Isi nomor WhatsApp Bisnis toko

**Menu Admin → Pengaturan Toko → No. WhatsApp Bisnis** (format `08xx…`) → Simpan.

Setelah itu, setiap pelanggan yang mengirim formulir akan: (1) pesanannya tersimpan di Pesanan Masuk, lalu (2) otomatis diarahkan ke WhatsApp toko dengan isi chat yang sudah terisi otomatis (nama, produk, pesan, kontak). Nomor `08xx` otomatis diubah ke format internasional `62xx`. Kalau nomor masih kosong, pesanan tetap tersimpan tapi pengalihan WhatsApp tidak aktif (tidak ada tautan mati).

## 4. Keamanan — jujur apa adanya

- Keamanan versi GitHub + Supabase ini adalah **Supabase Auth + Row Level Security (RLS)**, ditegakkan di server Supabase — bukan kode di browser.
- Pengunjung tanpa akun (anon) hanya bisa: **membaca** produk & pengaturan, dan **mengirim** pesanan. Mereka **tidak bisa** membaca daftar pesanan (berisi kontak pelanggan), dan **tidak bisa** menambah/mengubah/menghapus produk atau pengaturan — percobaan apa pun ditolak database.
- Hanya akun yang login (`authenticated`) yang bisa mengelola data.
- Key yang tertanam di `index.html` adalah **publishable/anon key** — memang publik by design dan aman disebar karena RLS yang menjaga data. **Jangan pernah** menaruh `service_role` key di repo ini.
- Tidak ada PIN admin di kode. PIN dari dashboard versi lama **tidak** dipakai di sini dan tidak disimpan di mana pun di repo ini.
- Semua teks dari database dirender dengan escape HTML (anti XSS), dan formulir divalidasi di sisi klien sebelum dikirim.

## 5. Struktur file

| File | Isi |
|---|---|
| `index.html` | Seluruh website: tampilan pengunjung + Menu Admin (Supabase Auth) |
| `mustika-mebel.sql` | Skema tabel `mustika_*`, RLS, seed 12 produk + pengaturan toko |
| `README.md` | Dokumen ini |

## 6. Mengubah website

Edit `index.html` di repo ini lalu push ke `main` — GitHub Pages otomatis memperbarui situs dalam 1–2 menit.
