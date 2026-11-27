-- 02_data.sql - Data Contoh Proyek Kelompok KopiKita
-- Jalankan setelah 01_skema.sql pada basis data kopikita_db yang masih kosong

USE kopikita_db;

-- 1. outlet (5 baris; outlet ke-5 sengaja dibuat belum punya transaksi & tanpa telepon NULL)
INSERT INTO outlet (id_outlet, kode_outlet, nama_outlet, alamat, telepon, status_aktif) VALUES
(1, 'OUT-YK01', 'KopiKita Kaliurang', 'Jl. Kaliurang Km 14.5, Sleman', '081210000001', TRUE),
(2, 'OUT-YK02', 'KopiKita Gejayan', 'Jl. Affandi No. 22, Sleman', '081210000002', TRUE),
(3, 'OUT-YK03', 'KopiKita Kotabaru', 'Jl. Suroto No. 5, Yogyakarta', '081210000003', TRUE),
(4, 'OUT-YK04', 'KopiKita Prawirotaman', 'Jl. Prawirotaman No. 18, Yogyakarta', '081210000004', TRUE),
(5, 'OUT-YK05', 'KopiKita Godean (Baru)', 'Jl. Godean Km 7, Sleman', NULL, FALSE);

-- 2. peran (5 baris)
INSERT INTO peran (id_peran, nama_peran) VALUES
(1, 'Owner'),
(2, 'Manajer Outlet'),
(3, 'Kasir'),
(4, 'Barista'),
(5, 'Admin Gudang');

-- 3. satuan (5 baris)
INSERT INTO satuan (id_satuan, nama_satuan, simbol) VALUES
(1, 'Gram', 'gr'),
(2, 'Mililiter', 'ml'),
(3, 'Porsi / Sachet', 'pcs'),
(4, 'Kilogram', 'kg'),
(5, 'Liter', 'L');

-- 4. pemasok (5 baris; pemasok ke-5 sengaja alamat & telepon NULL serta belum ada pembelian)
INSERT INTO pemasok (id_pemasok, nama_pemasok, telepon, alamat) VALUES
(1, 'PT Roastery Nusantara', '0274-511001', 'Jl. Magelang Km 5, Sleman'),
(2, 'CV Susu Segar Merapi', '0274-511002', 'Jl. Pakem-Turi, Sleman'),
(3, 'UD Gula Aren Jogja', '0274-511003', 'Jl. Wates Km 8, Kulon Progo'),
(4, 'PT Kemasan Ramah Lingkungan', '0274-511004', 'Jl. Ringroad Selatan, Bantul'),
(5, 'Supplier Cadangan Sirup', NULL, NULL);

-- 5. metode_pembayaran (5 baris; metode ke-5 belum pernah dipakai transaksi)
INSERT INTO metode_pembayaran (id_metode, nama_metode) VALUES
(1, 'Tunai'),
(2, 'QRIS'),
(3, 'Debit BCA'),
(4, 'Transfer Bank'),
(5, 'E-Wallet OVO');

-- 6. produk (6 baris; produk ke-6 'Matcha Oat Latte' sengaja belum pernah dipesan pelanggan)
INSERT INTO produk (id_produk, kode_produk, nama_produk, harga_jual, status_aktif) VALUES
(1, 'PRD-001', 'Kopi Susu Gula Aren', 20000.00, TRUE),
(2, 'PRD-002', 'Americano Iced', 18000.00, TRUE),
(3, 'PRD-003', 'Caffe Latte', 24000.00, TRUE),
(4, 'PRD-004', 'Caramel Macchiato', 28000.00, TRUE),
(5, 'PRD-005', 'Croissant Butter', 22000.00, TRUE),
(6, 'PRD-006', 'Matcha Oat Latte', 29000.00, TRUE);

-- 7. pengguna (6 baris; Owner memiliki id_outlet = NULL karena membawahi semua outlet)
INSERT INTO pengguna (id_pengguna, username, email, password_hash, nama_lengkap, status_aktif, id_peran, id_outlet) VALUES
(1, 'hafidz_owner', 'hafidz@kopikita.id', '$2y$10$hashowner01', 'Hafidz Taufiqurrahman', TRUE, 1, NULL),
(2, 'hanif_mgr', 'hanif@kopikita.id', '$2y$10$hashmgr02', 'Hanif Pratama', TRUE, 2, 1),
(3, 'umami_kasir1', 'umami@kopikita.id', '$2y$10$hashkasir03', 'Umami Putri', TRUE, 3, 1),
(4, 'awan_kasir2', 'awan@kopikita.id', '$2y$10$hashkasir04', 'Awan Setiawan', TRUE, 3, 2),
(5, 'rina_barista', 'rina@kopikita.id', '$2y$10$hashbarista05', 'Rina Kartika', TRUE, 4, 1),
(6, 'doni_gudang', 'doni@kopikita.id', '$2y$10$hashgudang06', 'Doni Saputra', TRUE, 5, 3);

-- 8. bahan_baku (6 baris)
INSERT INTO bahan_baku (id_bahan, kode_bahan, nama_bahan, id_satuan) VALUES
(1, 'BHN-001', 'Biji Kopi Arabika House Blend', 1),
(2, 'BHN-002', 'Susu UHT Full Cream', 2),
(3, 'BHN-003', 'Gula Aren Cair', 2),
(4, 'BHN-004', 'Sirup Karamel', 2),
(5, 'BHN-005', 'Bubuk Matcha Uji', 1),
(6, 'BHN-006', 'Croissant Frozen', 3);

-- 9. resep_bahan - Tabel Jembatan (8 baris: minimal 8 baris terpenuhi)
INSERT INTO resep_bahan (id_produk, id_bahan, jumlah_per_porsi) VALUES
(1, 1, 18.000),  -- Kopi Susu Gula Aren: 18gr kopi
(1, 2, 120.000), -- Kopi Susu Gula Aren: 120ml susu
(1, 3, 25.000),  -- Kopi Susu Gula Aren: 25ml gula aren
(2, 1, 18.000),  -- Americano: 18gr kopi
(3, 1, 18.000),  -- Caffe Latte: 18gr kopi
(3, 2, 150.000), -- Caffe Latte: 150ml susu
(4, 1, 18.000),  -- Caramel Macchiato: 18gr kopi
(4, 4, 20.000),  -- Caramel Macchiato: 20ml karamel
(5, 6, 1.000),   -- Croissant Butter: 1 pcs
(6, 5, 10.000);  -- Matcha Oat Latte: 10gr matcha

-- 10. ambang_stok - Tabel Jembatan (8 baris)
INSERT INTO ambang_stok (id_outlet, id_bahan, stok_minimum) VALUES
(1, 1, 1000.000),
(1, 2, 5000.000),
(1, 3, 2000.000),
(1, 6, 15.000),
(2, 1, 1000.000),
(2, 2, 4000.000),
(3, 1, 800.000),
(4, 1, 800.000);

-- 11. notifikasi_stok (5 baris; dibaca_pada NULL untuk notifikasi yang belum dibaca)
INSERT INTO notifikasi_stok (id_notifikasi, id_outlet, id_bahan, dibuat_pada, status_dibaca, dibaca_pada) VALUES
(1, 1, 3, '2026-10-20 08:30:00', TRUE, '2026-10-20 09:00:00'),
(2, 1, 6, '2026-10-21 10:15:00', TRUE, '2026-10-21 10:45:00'),
(3, 2, 2, '2026-10-22 14:00:00', FALSE, NULL),
(4, 1, 1, '2026-10-23 16:20:00', FALSE, NULL),
(5, 3, 1, '2026-10-24 09:10:00', FALSE, NULL);

-- 12. stok_opname (5 baris)
INSERT INTO stok_opname (id_opname, id_outlet, id_bahan, id_pengguna, tanggal_opname, jumlah_fisik) VALUES
(1, 1, 1, 2, '2026-10-25', 2450.000),
(2, 1, 2, 2, '2026-10-25', 8500.000),
(3, 1, 3, 5, '2026-10-25', 1800.000),
(4, 2, 1, 4, '2026-10-25', 1900.000),
(5, 3, 1, 6, '2026-10-25', 1200.000);

-- 13. transaksi (6 baris)
INSERT INTO transaksi (id_transaksi, no_struk, waktu_transaksi, status_transaksi, id_outlet, id_pengguna) VALUES
(1, 'STR-20261026-001', '2026-10-26 08:15:00', 'SELESAI', 1, 3),
(2, 'STR-20261026-002', '2026-10-26 08:40:00', 'SELESAI', 1, 3),
(3, 'STR-20261026-003', '2026-10-26 09:10:00', 'SELESAI', 2, 4),
(4, 'STR-20261026-004', '2026-10-26 10:05:00', 'SELESAI', 1, 3),
(5, 'STR-20261026-005', '2026-10-26 11:20:00', 'MENUNGGU_BAYAR', 2, 4),
(6, 'STR-20261026-006', '2026-10-26 12:00:00', 'DIBATALKAN', 3, 6);

-- 14. transaksi_detail - Tabel Jembatan (10 baris: minimal 8 baris terpenuhi; produk 6 sengaja tidak ada)
INSERT INTO transaksi_detail (id_transaksi, id_produk, jumlah, harga_satuan) VALUES
(1, 1, 2, 20000.00),
(1, 5, 1, 22000.00),
(2, 2, 1, 18000.00),
(2, 3, 2, 24000.00),
(3, 1, 3, 20000.00),
(3, 4, 1, 28000.00),
(4, 1, 2, 20000.00),
(4, 2, 2, 18000.00),
(5, 3, 1, 24000.00),
(6, 5, 2, 22000.00);

-- 15. pembayaran (5 baris; referensi_qris NULL untuk pembayaran non-QRIS)
INSERT INTO pembayaran (id_pembayaran, id_transaksi, id_metode, jumlah_dibayar, status_pembayaran, referensi_qris, waktu_pembayaran) VALUES
(1, 1, 2, 62000.00, 'BERHASIL', 'QRIS-99887701', '2026-10-26 08:16:00'),
(2, 2, 1, 66000.00, 'BERHASIL', NULL, '2026-10-26 08:41:00'),
(3, 3, 2, 88000.00, 'BERHASIL', 'QRIS-99887702', '2026-10-26 09:11:00'),
(4, 4, 3, 76000.00, 'BERHASIL', NULL, '2026-10-26 10:06:00'),
(5, 5, 2, 24000.00, 'PENDING', 'QRIS-99887703', '2026-10-26 11:21:00');

-- 16. pembelian (5 baris)
INSERT INTO pembelian (id_pembelian, no_faktur, tanggal_pembelian, id_pemasok, id_outlet, id_pengguna) VALUES
(1, 'INV-RST-001', '2026-10-20', 1, 1, 2),
(2, 'INV-SSU-002', '2026-10-21', 2, 1, 2),
(3, 'INV-ARN-003', '2026-10-22', 3, 1, 6),
(4, 'INV-RST-004', '2026-10-23', 1, 2, 4),
(5, 'INV-KMS-005', '2026-10-24', 4, 3, 6);

-- 17. pembelian_detail - Tabel Jembatan (8 baris: minimal 8 baris terpenuhi)
INSERT INTO pembelian_detail (id_pembelian, id_bahan, jumlah, harga_beli_satuan) VALUES
(1, 1, 3000.000, 180.00),
(1, 5, 500.000, 450.00),
(2, 2, 10000.000, 18.00),
(3, 3, 3000.000, 35.00),
(4, 1, 2500.000, 180.00),
(4, 4, 2000.000, 60.00),
(5, 6, 30.000, 9500.00),
(5, 1, 1500.000, 180.00);

-- 18. mutasi_stok (6 baris; id_transaksi / id_pembelian / keterangan ada yang NULL sesuai jenis mutasi)
INSERT INTO mutasi_stok (id_mutasi, id_outlet, id_bahan, id_pengguna, jenis_mutasi, jumlah, waktu_mutasi, id_transaksi, id_pembelian, keterangan) VALUES
(1, 1, 1, 2, 'PEMBELIAN', 3000.000, '2026-10-20 11:00:00', NULL, 1, 'Restock biji kopi arabika'),
(2, 1, 2, 2, 'PEMBELIAN', 10000.000, '2026-10-21 11:30:00', NULL, 2, 'Restock susu UHT'),
(3, 1, 1, 3, 'PENJUALAN', -36.000, '2026-10-26 08:15:00', 1, NULL, 'Pemakaian transaksi STR-20261026-001'),
(4, 1, 2, 3, 'PENJUALAN', -240.000, '2026-10-26 08:15:00', 1, NULL, 'Pemakaian transaksi STR-20261026-001'),
(5, 1, 1, 5, 'WASTE', -50.000, '2026-10-26 14:00:00', NULL, NULL, 'Kalibrasi mesin espresso pagi'),
(6, 1, 1, 2, 'OPNAME', -14.000, '2026-10-25 18:00:00', NULL, NULL, NULL);
