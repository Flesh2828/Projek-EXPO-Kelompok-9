CREATE DATABASE IF NOT EXISTS pustakauii DEFAULT CHARACTER SET utf8mb4;
USE pustakauii;

-- 1. Tabel penerbit
CREATE TABLE penerbit (
  penerbit_id INT AUTO_INCREMENT NOT NULL,
  nama        VARCHAR(100) NOT NULL,
  kota        VARCHAR(80) NOT NULL,
  PRIMARY KEY (penerbit_id)
) ENGINE=InnoDB;

-- 2. Tabel kategori
CREATE TABLE kategori (
  kategori_id   INT AUTO_INCREMENT NOT NULL,
  nama_kategori VARCHAR(60) NOT NULL,
  PRIMARY KEY (kategori_id)
) ENGINE=InnoDB;

-- 3. Tabel buku
CREATE TABLE buku (
  buku_id          INT AUTO_INCREMENT NOT NULL,
  isbn             VARCHAR(20) NOT NULL,
  judul            VARCHAR(150) NOT NULL,
  tahun_terbit     SMALLINT NOT NULL,
  jumlah_eksemplar INT NOT NULL DEFAULT 0,
  penerbit_id      INT NOT NULL,
  kategori_id      INT NOT NULL,
  PRIMARY KEY (buku_id),
  UNIQUE KEY uq_buku_isbn (isbn),
  CHECK (jumlah_eksemplar >= 0),
  CONSTRAINT fk_buku_penerbit
    FOREIGN KEY (penerbit_id) REFERENCES penerbit(penerbit_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_buku_kategori
    FOREIGN KEY (kategori_id) REFERENCES kategori(kategori_id)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 4. Tabel pengarang
CREATE TABLE pengarang (
  pengarang_id INT AUTO_INCREMENT NOT NULL,
  nama         VARCHAR(100) NOT NULL,
  PRIMARY KEY (pengarang_id)
) ENGINE=InnoDB;

-- 5. Tabel buku_pengarang (jembatan M:N)
CREATE TABLE buku_pengarang (
  buku_id      INT NOT NULL,
  pengarang_id INT NOT NULL,
  PRIMARY KEY (buku_id, pengarang_id),
  CONSTRAINT fk_bp_buku
    FOREIGN KEY (buku_id) REFERENCES buku(buku_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_bp_pengarang
    FOREIGN KEY (pengarang_id) REFERENCES pengarang(pengarang_id)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 6. Tabel anggota
CREATE TABLE anggota (
  anggota_id     INT AUTO_INCREMENT NOT NULL,
  nim            VARCHAR(15) NOT NULL,
  nama           VARCHAR(100) NOT NULL,
  email          VARCHAR(100) NOT NULL,
  tanggal_daftar DATE NOT NULL,
  jalan          VARCHAR(150) NULL,
  kota           VARCHAR(80) NULL,
  PRIMARY KEY (anggota_id),
  UNIQUE KEY uq_anggota_nim (nim),
  UNIQUE KEY uq_anggota_email (email)
) ENGINE=InnoDB;

-- 7. Tabel anggota_telepon (atribut multinilai)
CREATE TABLE anggota_telepon (
  anggota_id INT NOT NULL,
  telepon    VARCHAR(20) NOT NULL,
  PRIMARY KEY (anggota_id, telepon),
  CONSTRAINT fk_telp_anggota
    FOREIGN KEY (anggota_id) REFERENCES anggota(anggota_id)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 8. Tabel kartu (relasi 1:1)
CREATE TABLE kartu (
  kartu_id       INT AUTO_INCREMENT NOT NULL,
  nomor_kartu    VARCHAR(30) NOT NULL,
  tanggal_terbit DATE NOT NULL,
  masa_berlaku   DATE NOT NULL,
  anggota_id     INT NOT NULL,
  PRIMARY KEY (kartu_id),
  UNIQUE KEY uq_kartu_nomor (nomor_kartu),
  UNIQUE KEY uq_kartu_anggota (anggota_id),
  CONSTRAINT fk_kartu_anggota
    FOREIGN KEY (anggota_id) REFERENCES anggota(anggota_id)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 9. Tabel peminjaman
CREATE TABLE peminjaman (
  peminjaman_id       INT AUTO_INCREMENT NOT NULL,
  tanggal_pinjam      DATE NOT NULL,
  tanggal_jatuh_tempo DATE NOT NULL,
  anggota_id          INT NOT NULL,
  PRIMARY KEY (peminjaman_id),
  CHECK (tanggal_jatuh_tempo >= tanggal_pinjam),
  CONSTRAINT fk_peminjaman_anggota
    FOREIGN KEY (anggota_id) REFERENCES anggota(anggota_id)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 10. Tabel detail_peminjaman (jembatan M:N)
CREATE TABLE detail_peminjaman (
  peminjaman_id   INT NOT NULL,
  buku_id         INT NOT NULL,
  tanggal_kembali DATE NULL,
  denda           DECIMAL(10,2) NOT NULL DEFAULT 0,
  PRIMARY KEY (peminjaman_id, buku_id),
  CHECK (denda >= 0),
  CONSTRAINT fk_detail_peminjaman
    FOREIGN KEY (peminjaman_id) REFERENCES peminjaman(peminjaman_id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_detail_buku
    FOREIGN KEY (buku_id) REFERENCES buku(buku_id)
    ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;
