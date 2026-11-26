-- 03_query.sql - Kumpulan Query Aplikasi Web KopiKita
USE kopikita_db;

-- Query 1 (JOIN 4 tabel & Uji Jalur ERD: Transaksi -> Outlet, Pengguna, Pembayaran, Metode)
-- Pertanyaan bisnis: Tampilkan daftar transaksi yang sudah selesai beserta nama outlet, nama kasir, metode pembayaran, dan nominal yang dibayar.
-- Halaman/fitur: Halaman Riwayat Transaksi Kasir & Laporan Penjualan
-- Jumlah baris hasil: 4 baris
SELECT t.no_struk, t.waktu_transaksi, o.nama_outlet, u.nama_lengkap AS kasir, mp.nama_metode, pb.jumlah_dibayar
FROM transaksi t
JOIN outlet o ON t.id_outlet = o.id_outlet
JOIN pengguna u ON t.id_pengguna = u.id_pengguna
JOIN pembayaran pb ON t.id_transaksi = pb.id_transaksi
JOIN metode_pembayaran mp ON pb.id_metode = mp.id_metode
WHERE t.status_transaksi = 'SELESAI'
ORDER BY t.waktu_transaksi ASC;

-- Query 2 (LEFT JOIN dengan IS NULL)
-- Pertanyaan bisnis: Produk menu apa saja yang belum pernah terjual/dipesan sama sekali di seluruh transaksi?
-- Halaman/fitur: Dashboard Manajer - Evaluasi Menu Kurang Laku
-- Jumlah baris hasil: 1 baris (Matcha Oat Latte)
SELECT p.kode_produk, p.nama_produk, p.harga_jual
FROM produk p
LEFT JOIN transaksi_detail td ON p.id_produk = td.id_produk
WHERE td.id_produk IS NULL;

-- Query 3 (JOIN + GROUP BY + HAVING)
-- Pertanyaan bisnis: Produk menu mana saja yang total penjualannya (pada transaksi berstatus SELESAI) sudah terjual lebih dari 2 porsi?
-- Halaman/fitur: Dashboard Admin & Kasir - Daftar Menu Terlaris (Best Seller)
-- Jumlah baris hasil: 3 baris
SELECT p.nama_produk, SUM(td.jumlah) AS total_terjual, SUM(td.jumlah * td.harga_satuan) AS total_omzet
FROM produk p
JOIN transaksi_detail td ON p.id_produk = td.id_produk
JOIN transaksi t ON td.id_transaksi = t.id_transaksi
WHERE t.status_transaksi = 'SELESAI'
GROUP BY p.id_produk, p.nama_produk
HAVING SUM(td.jumlah) > 2
ORDER BY total_terjual DESC;

-- Query 4 (Subquery Skalar dengan Agregat)
-- Pertanyaan bisnis: Produk menu mana saja yang harga jualnya di atas rata-rata harga seluruh produk aktif?
-- Halaman/fitur: Halaman Katalog Menu POS - Filter Menu Premium
-- Jumlah baris hasil: 3 baris
SELECT kode_produk, nama_produk, harga_jual
FROM produk
WHERE status_aktif = TRUE
  AND harga_jual > (SELECT AVG(harga_jual) FROM produk WHERE status_aktif = TRUE)
ORDER BY harga_jual DESC;

-- Query 5 (Uji Jalur Resep & Stok: Produk -> Resep Bahan -> Bahan Baku -> Satuan)
-- Pertanyaan bisnis: Tampilkan komposisi takaran resep bahan baku beserta satuannya untuk produk 'Kopi Susu Gula Aren'.
-- Halaman/fitur: Halaman Manajemen Resep / HPP Produk
-- Jumlah baris hasil: 3 baris
SELECT p.nama_produk, bb.nama_bahan, rb.jumlah_per_porsi, s.simbol AS satuan
FROM produk p
JOIN resep_bahan rb ON p.id_produk = rb.id_produk
JOIN bahan_baku bb ON rb.id_bahan = bb.id_bahan
JOIN satuan s ON bb.id_satuan = s.id_satuan
WHERE p.nama_produk = 'Kopi Susu Gula Aren';

-- Query 6 (Subquery dengan IN)
-- Pertanyaan bisnis: Siapa saja staf pengguna yang pernah melakukan pencatatan pembelian bahan baku ke pemasok?
-- Halaman/fitur: Halaman Audit Gudang & Riwayat Pembelian Supplier
-- Jumlah baris hasil: 3 baris
SELECT u.nama_lengkap, pr.nama_peran, u.email
FROM pengguna u
JOIN peran pr ON u.id_peran = pr.id_peran
WHERE u.id_pengguna IN (SELECT DISTINCT id_pengguna FROM pembelian);
