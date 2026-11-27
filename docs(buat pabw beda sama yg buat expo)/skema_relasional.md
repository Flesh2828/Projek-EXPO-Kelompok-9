# Skema Relasional Proyek KopiKita

## Pemetaan Aturan ERD (Aturan 1 sampai 7)
* **Aturan 1 (Entitas Reguler):** `outlet`, `peran`, `satuan`, `pemasok`, `metode_pembayaran`, `produk` dipetakan langsung menjadi tabel induk tanpa FK.
* **Aturan 3 (Relasi Biner 1:N):** FK diletakkan di tabel sisi "banyak" (`pengguna`, `bahan_baku`, `transaksi`, `pembayaran`, `pembelian`, `stok_opname`, `mutasi_stok`, `notifikasi_stok`).
* **Aturan 4 (Relasi Biner M:N dengan Atribut Relasi):** Dipetakan menjadi 4 tabel jembatan/asosiatif dengan PK gabungan (`transaksi_detail`, `resep_bahan`, `pembelian_detail`, `ambang_stok`).

---

## Daftar Skema 18 Tabel
*(Notasi: **tebal** = Primary Key, *miring* = Foreign Key)*

1. `outlet(**id_outlet**, kode_outlet, nama_outlet, alamat, telepon, status_aktif)`
   FK: tidak ada

2. `peran(**id_peran**, nama_peran)`
   FK: tidak ada

3. `satuan(**id_satuan**, nama_satuan, simbol)`
   FK: tidak ada

4. `pemasok(**id_pemasok**, nama_pemasok, telepon, alamat)`
   FK: tidak ada

5. `metode_pembayaran(**id_metode**, nama_metode)`
   FK: tidak ada

6. `produk(**id_produk**, kode_produk, nama_produk, harga_jual, status_aktif)`
   FK: tidak ada

7. `pengguna(**id_pengguna**, username, email, password_hash, nama_lengkap, status_aktif, *id_peran*, *id_outlet*)`
   FK: `id_peran` -> `peran(id_peran)`, `id_outlet` -> `outlet(id_outlet)`

8. `bahan_baku(**id_bahan**, kode_bahan, nama_bahan, *id_satuan*)`
   FK: `id_satuan` -> `satuan(id_satuan)`

9. `resep_bahan(***id_produk***, ***id_bahan***, jumlah_per_porsi)`
   FK: `id_produk` -> `produk(id_produk)`, `id_bahan` -> `bahan_baku(id_bahan)`

10. `ambang_stok(***id_outlet***, ***id_bahan***, stok_minimum)`
    FK: `id_outlet` -> `outlet(id_outlet)`, `id_bahan` -> `bahan_baku(id_bahan)`

11. `notifikasi_stok(**id_notifikasi**, *id_outlet*, *id_bahan*, dibuat_pada, status_dibaca, dibaca_pada)`
    FK: `id_outlet` -> `outlet(id_outlet)`, `id_bahan` -> `bahan_baku(id_bahan)`

12. `stok_opname(**id_opname**, *id_outlet*, *id_bahan*, *id_pengguna*, tanggal_opname, jumlah_fisik)`
    FK: `id_outlet` -> `outlet(id_outlet)`, `id_bahan` -> `bahan_baku(id_bahan)`, `id_pengguna` -> `pengguna(id_pengguna)`

13. `transaksi(**id_transaksi**, no_struk, waktu_transaksi, status_transaksi, *id_outlet*, *id_pengguna*)`
    FK: `id_outlet` -> `outlet(id_outlet)`, `id_pengguna` -> `pengguna(id_pengguna)`

14. `transaksi_detail(***id_transaksi***, ***id_produk***, jumlah, harga_satuan)`
    FK: `id_transaksi` -> `transaksi(id_transaksi)`, `id_produk` -> `produk(id_produk)`

15. `pembayaran(**id_pembayaran**, *id_transaksi*, *id_metode*, jumlah_dibayar, status_pembayaran, referensi_qris, waktu_pembayaran)`
    FK: `id_transaksi` -> `transaksi(id_transaksi)`, `id_metode` -> `metode_pembayaran(id_metode)`

16. `pembelian(**id_pembelian**, no_faktur, tanggal_pembelian, *id_pemasok*, *id_outlet*, *id_pengguna*)`
    FK: `id_pemasok` -> `pemasok(id_pemasok)`, `id_outlet` -> `outlet(id_outlet)`, `id_pengguna` -> `pengguna(id_pengguna)`

17. `pembelian_detail(***id_pembelian***, ***id_bahan***, jumlah, harga_beli_satuan)`
    FK: `id_pembelian` -> `pembelian(id_pembelian)`, `id_bahan` -> `bahan_baku(id_bahan)`

18. `mutasi_stok(**id_mutasi**, *id_outlet*, *id_bahan*, *id_pengguna*, jenis_mutasi, jumlah, waktu_mutasi, *id_transaksi*, *id_pembelian*, keterangan)`
    FK: `id_outlet` -> `outlet(id_outlet)`, `id_bahan` -> `bahan_baku(id_bahan)`, `id_pengguna` -> `pengguna(id_pengguna)`, `id_transaksi` -> `transaksi(id_transaksi)`, `id_pembelian` -> `pembelian(id_pembelian)`