CREATE DATABASE IF NOT EXISTS kopikita_db DEFAULT CHARACTER SET utf8mb4;
USE kopikita_db;

-- 1. outlet
CREATE TABLE outlet (
  id_outlet    INT AUTO_INCREMENT NOT NULL,
  kode_outlet  VARCHAR(20) NOT NULL,
  nama_outlet  VARCHAR(100) NOT NULL,
  alamat       VARCHAR(255) NOT NULL,
  telepon      VARCHAR(20) NULL,
  status_aktif BOOLEAN NOT NULL DEFAULT TRUE,
  PRIMARY KEY (id_outlet),
  UNIQUE KEY uq_outlet_kode (kode_outlet)
) ENGINE=InnoDB;

-- 2. peran
CREATE TABLE peran (
  id_peran   INT AUTO_INCREMENT NOT NULL,
  nama_peran VARCHAR(50) NOT NULL,
  PRIMARY KEY (id_peran),
  UNIQUE KEY uq_peran_nama (nama_peran)
) ENGINE=InnoDB;

-- 3. satuan
CREATE TABLE satuan (
  id_satuan   INT AUTO_INCREMENT NOT NULL,
  nama_satuan VARCHAR(50) NOT NULL,
  simbol      VARCHAR(15) NOT NULL,
  PRIMARY KEY (id_satuan),
  UNIQUE KEY uq_satuan_nama (nama_satuan),
  UNIQUE KEY uq_satuan_simbol (simbol)
) ENGINE=InnoDB;

-- 4. pemasok
CREATE TABLE pemasok (
  id_pemasok   INT AUTO_INCREMENT NOT NULL,
  nama_pemasok VARCHAR(100) NOT NULL,
  telepon      VARCHAR(20) NULL,
  alamat       VARCHAR(255) NULL,
  PRIMARY KEY (id_pemasok)
) ENGINE=InnoDB;

-- 5. metode_pembayaran
CREATE TABLE metode_pembayaran (
  id_metode   INT AUTO_INCREMENT NOT NULL,
  nama_metode VARCHAR(50) NOT NULL,
  PRIMARY KEY (id_metode),
  UNIQUE KEY uq_metode_nama (nama_metode)
) ENGINE=InnoDB;

-- 6. produk
CREATE TABLE produk (
  id_produk    INT AUTO_INCREMENT NOT NULL,
  kode_produk  VARCHAR(30) NOT NULL,
  nama_produk  VARCHAR(100) NOT NULL,
  harga_jual   DECIMAL(12,2) NOT NULL,
  status_aktif BOOLEAN NOT NULL DEFAULT TRUE,
  PRIMARY KEY (id_produk),
  UNIQUE KEY uq_produk_kode (kode_produk),
  CHECK (harga_jual >= 0)
) ENGINE=InnoDB;

-- 7. pengguna
CREATE TABLE pengguna (
  id_pengguna   INT AUTO_INCREMENT NOT NULL,
  username      VARCHAR(50) NOT NULL,
  email         VARCHAR(100) NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  nama_lengkap  VARCHAR(100) NOT NULL,
  status_aktif  BOOLEAN NOT NULL DEFAULT TRUE,
  id_peran      INT NOT NULL,
  id_outlet     INT NULL,
  PRIMARY KEY (id_pengguna),
  UNIQUE KEY uq_pengguna_username (username),
  UNIQUE KEY uq_pengguna_email (email),
  CONSTRAINT fk_pengguna_peran
    FOREIGN KEY (id_peran) REFERENCES peran(id_peran)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_pengguna_outlet
    FOREIGN KEY (id_outlet) REFERENCES outlet(id_outlet)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 8. bahan_baku
CREATE TABLE bahan_baku (
  id_bahan   INT AUTO_INCREMENT NOT NULL,
  kode_bahan VARCHAR(30) NOT NULL,
  nama_bahan VARCHAR(100) NOT NULL,
  id_satuan  INT NOT NULL,
  PRIMARY KEY (id_bahan),
  UNIQUE KEY uq_bahan_kode (kode_bahan),
  CONSTRAINT fk_bahan_satuan
    FOREIGN KEY (id_satuan) REFERENCES satuan(id_satuan)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 9. resep_bahan
CREATE TABLE resep_bahan (
  id_produk        INT NOT NULL,
  id_bahan         INT NOT NULL,
  jumlah_per_porsi DECIMAL(10,3) NOT NULL,
  PRIMARY KEY (id_produk, id_bahan),
  CHECK (jumlah_per_porsi > 0),
  CONSTRAINT fk_resep_produk
    FOREIGN KEY (id_produk) REFERENCES produk(id_produk)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_resep_bahan
    FOREIGN KEY (id_bahan) REFERENCES bahan_baku(id_bahan)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 10. ambang_stok
CREATE TABLE ambang_stok (
  id_outlet    INT NOT NULL,
  id_bahan     INT NOT NULL,
  stok_minimum DECIMAL(12,3) NOT NULL DEFAULT 0,
  PRIMARY KEY (id_outlet, id_bahan),
  CHECK (stok_minimum >= 0),
  CONSTRAINT fk_ambang_outlet
    FOREIGN KEY (id_outlet) REFERENCES outlet(id_outlet)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_ambang_bahan
    FOREIGN KEY (id_bahan) REFERENCES bahan_baku(id_bahan)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 11. notifikasi_stok
CREATE TABLE notifikasi_stok (
  id_notifikasi BIGINT AUTO_INCREMENT NOT NULL,
  id_outlet     INT NOT NULL,
  id_bahan      INT NOT NULL,
  dibuat_pada   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  status_dibaca BOOLEAN NOT NULL DEFAULT FALSE,
  dibaca_pada   DATETIME NULL,
  PRIMARY KEY (id_notifikasi),
  CONSTRAINT fk_notif_outlet
    FOREIGN KEY (id_outlet) REFERENCES outlet(id_outlet)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_notif_bahan
    FOREIGN KEY (id_bahan) REFERENCES bahan_baku(id_bahan)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 12. stok_opname
CREATE TABLE stok_opname (
  id_opname      INT AUTO_INCREMENT NOT NULL,
  id_outlet      INT NOT NULL,
  id_bahan       INT NOT NULL,
  id_pengguna    INT NOT NULL,
  tanggal_opname DATE NOT NULL,
  jumlah_fisik   DECIMAL(12,3) NOT NULL,
  PRIMARY KEY (id_opname),
  CHECK (jumlah_fisik >= 0),
  CONSTRAINT fk_opname_outlet
    FOREIGN KEY (id_outlet) REFERENCES outlet(id_outlet)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_opname_bahan
    FOREIGN KEY (id_bahan) REFERENCES bahan_baku(id_bahan)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_opname_pengguna
    FOREIGN KEY (id_pengguna) REFERENCES pengguna(id_pengguna)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 13. transaksi
CREATE TABLE transaksi (
  id_transaksi     BIGINT AUTO_INCREMENT NOT NULL,
  no_struk         VARCHAR(40) NOT NULL,
  waktu_transaksi  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  status_transaksi ENUM('MENUNGGU_BAYAR', 'SELESAI', 'DIBATALKAN') NOT NULL,
  id_outlet        INT NOT NULL,
  id_pengguna      INT NOT NULL,
  PRIMARY KEY (id_transaksi),
  UNIQUE KEY uq_transaksi_struk (no_struk),
  CONSTRAINT fk_transaksi_outlet
    FOREIGN KEY (id_outlet) REFERENCES outlet(id_outlet)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_transaksi_pengguna
    FOREIGN KEY (id_pengguna) REFERENCES pengguna(id_pengguna)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 14. transaksi_detail
CREATE TABLE transaksi_detail (
  id_transaksi BIGINT NOT NULL,
  id_produk    INT NOT NULL,
  jumlah       INT NOT NULL,
  harga_satuan DECIMAL(12,2) NOT NULL,
  PRIMARY KEY (id_transaksi, id_produk),
  CHECK (jumlah > 0),
  CHECK (harga_satuan >= 0),
  CONSTRAINT fk_td_transaksi
    FOREIGN KEY (id_transaksi) REFERENCES transaksi(id_transaksi)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_td_produk
    FOREIGN KEY (id_produk) REFERENCES produk(id_produk)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 15. pembayaran
CREATE TABLE pembayaran (
  id_pembayaran     BIGINT AUTO_INCREMENT NOT NULL,
  id_transaksi      BIGINT NOT NULL,
  id_metode         INT NOT NULL,
  jumlah_dibayar    DECIMAL(12,2) NOT NULL,
  status_pembayaran ENUM('PENDING', 'BERHASIL', 'GAGAL') NOT NULL,
  referensi_qris    VARCHAR(100) NULL,
  waktu_pembayaran  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id_pembayaran),
  UNIQUE KEY uq_pembayaran_qris (referensi_qris),
  CHECK (jumlah_dibayar > 0),
  CONSTRAINT fk_pembayaran_transaksi
    FOREIGN KEY (id_transaksi) REFERENCES transaksi(id_transaksi)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_pembayaran_metode
    FOREIGN KEY (id_metode) REFERENCES metode_pembayaran(id_metode)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 16. pembelian
CREATE TABLE pembelian (
  id_pembelian      INT AUTO_INCREMENT NOT NULL,
  no_faktur         VARCHAR(50) NOT NULL,
  tanggal_pembelian DATE NOT NULL,
  id_pemasok        INT NOT NULL,
  id_outlet         INT NOT NULL,
  id_pengguna       INT NOT NULL,
  PRIMARY KEY (id_pembelian),
  UNIQUE KEY uq_pembelian_faktur_pemasok (id_pemasok, no_faktur),
  CONSTRAINT fk_pembelian_pemasok
    FOREIGN KEY (id_pemasok) REFERENCES pemasok(id_pemasok)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_pembelian_outlet
    FOREIGN KEY (id_outlet) REFERENCES outlet(id_outlet)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_pembelian_pengguna
    FOREIGN KEY (id_pengguna) REFERENCES pengguna(id_pengguna)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 17. pembelian_detail
CREATE TABLE pembelian_detail (
  id_pembelian      INT NOT NULL,
  id_bahan          INT NOT NULL,
  jumlah            DECIMAL(12,3) NOT NULL,
  harga_beli_satuan DECIMAL(12,2) NOT NULL,
  PRIMARY KEY (id_pembelian, id_bahan),
  CHECK (jumlah > 0),
  CHECK (harga_beli_satuan >= 0),
  CONSTRAINT fk_pd_pembelian
    FOREIGN KEY (id_pembelian) REFERENCES pembelian(id_pembelian)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_pd_bahan
    FOREIGN KEY (id_bahan) REFERENCES bahan_baku(id_bahan)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 18. mutasi_stok
CREATE TABLE mutasi_stok (
  id_mutasi    BIGINT AUTO_INCREMENT NOT NULL,
  id_outlet    INT NOT NULL,
  id_bahan     INT NOT NULL,
  id_pengguna  INT NOT NULL,
  jenis_mutasi ENUM('PEMBELIAN', 'PENJUALAN', 'OPNAME', 'WASTE', 'TRANSFER') NOT NULL,
  jumlah       DECIMAL(12,3) NOT NULL,
  waktu_mutasi DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  id_transaksi BIGINT NULL,
  id_pembelian INT NULL,
  keterangan   VARCHAR(255) NULL,
  PRIMARY KEY (id_mutasi),
  CONSTRAINT fk_mutasi_outlet
    FOREIGN KEY (id_outlet) REFERENCES outlet(id_outlet)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_mutasi_bahan
    FOREIGN KEY (id_bahan) REFERENCES bahan_baku(id_bahan)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_mutasi_pengguna
    FOREIGN KEY (id_pengguna) REFERENCES pengguna(id_pengguna)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_mutasi_transaksi
    FOREIGN KEY (id_transaksi) REFERENCES transaksi(id_transaksi)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_mutasi_pembelian
    FOREIGN KEY (id_pembelian) REFERENCES pembelian(id_pembelian)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;
