<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>3Dreaming AI — Panduan Lengkap</title>
    <style>
        *{margin:0;padding:0;box-sizing:border-box}
        body{font-family:'Segoe UI',sans-serif;line-height:1.7;background:#0f111a;color:#e6e6e6;padding:20px;max-width:900px;margin:0 auto}
        h1,h2,h3{color:#6ee7ff;margin-bottom:.5em}
        h1{border-bottom:2px solid #2563eb;padding-bottom:.5rem}
        pre{background:#1a1d2b;border-left:4px solid #2563eb;padding:1rem;overflow-x:auto;border-radius:4px;margin:1rem 0}
        code{background:#2a2d3f;padding:.15rem .4rem;border-radius:3px;color:#94e9ff}
        ul,ol{margin:1rem 0 1rem 2rem}
        li{margin:.5rem 0}
        .card{background:#1a1d2b;border-radius:8px;padding:1.2rem;margin:1.2rem 0;border:1px solid #2e3447}
        .tag{display:inline-block;background:#2563eb;color:#fff;padding:.2rem .6rem;border-radius:4px;font-size:.85rem;margin:.2rem}
        .success{border-left:4px solid #10b981}
        .info{border-left:4px solid #3b82f6}
        .warning{border-left:4px solid #f59e0b}
        a{color:#6ee7ff;text-decoration:none}
        a:hover{text-decoration:underline}
    </style>
</head>
<body>

<h1>🌐 3Dreaming AI — Panduan Lengkap</h1>

<div class="card info">
  <strong>Versi:</strong> Advanced Complex Model Edition<br>
  <strong>Jenis:</strong> CLI (Bash Script)<br>
  <strong>Platform:</strong> Android/Termux · Linux · macOS · Windows<br>
  <strong>Status:</strong> Tanpa Watermark ✅
</div>

<h2>📖 Tentang 3Dreaming AI</h2>
<p>3Dreaming AI adalah alat pembuat model 3D berbasis antarmuka teks (CLI) yang mengubah deskripsi tulisan menjadi file model 3D secara otomatis. AI ini mendeteksi jenis perangkat dan menggunakan aplikasi yang sesuai:</p>
<ul>
  <li><strong>Android → Nomad Sculpt</strong> (buka di Play Store)</li>
  <li><strong>Linux/macOS/Windows → Blender</strong> (dibuka langsung di latar belakang)</li>
</ul>

<h2>📂 Cara Memasang</h2>
<ol>
  <li>Buat folder baru untuk menyimpan semua hasil model</li>
  <li>Di dalam folder tersebut, buat file bernama <code>install.sh</code></li>
  <li>Salin kode skrip yang diberikan ke dalam file tersebut, lalu simpan</li>
  <li>Buka terminal/CMD, masuk ke folder tersebut, lalu jalankan:
<pre>chmod +x install.sh
./install.sh</pre>
  </li>
</ol>

<h2>🔐 Langkah Masuk (Login)</h2>
<p>Saat pertama kali berjalan, AI akan meminta perintah masuk. Ketik persis:</p>
<pre>3DAI</pre>
<p>Jika benar, muncul tulisan: <code>[✓] Masuk ke 3Dreaming AI ADVANCED berhasil.</code></p>

<h2>✍️ Cara Menulis Perintah</h2>
<p>Di kolom <code>3Dream&gt;</code>, tuliskan deskripsi model yang kamu inginkan. Format umum:</p>
<pre>[jenis benda] + [warna] + [sifat] + [ukuran]</pre>

<h3>📋 Daftar Kata Kunci yang Didukung</h3>

<div class="card">
  <h4>🏷️ Jenis Model</h4>
  <span class="tag">karakter / orang</span>
  <span class="tag">rumah / bangunan</span>
  <span class="tag">mobil / kendaraan</span>
  <span class="tag">pohon / tumbuhan</span>
  <span class="tag">robot / mesin</span>
  <span class="tag">(lainnya = bentuk hiasan)</span>
</div>

<div class="card">
  <h4>🎨 Warna</h4>
  <span class="tag">emas</span> <span class="tag">perak</span> <span class="tag">merah</span> <span class="tag">biru</span>
  <span class="tag">hijau</span> <span class="tag">kuning</span> <span class="tag">ungu</span> <span class="tag">oranye</span>
  <span class="tag">coklat</span> <span class="tag">hitam</span> <span class="tag">putih</span>
</div>

<div class="card">
  <h4>✨ Sifat Permukaan</h4>
  <span class="tag">berkilau</span> <span class="tag">mengkilap</span> <span class="tag">logam</span>
</div>

<div class="card">
  <h4>📏 Ukuran</h4>
  <span class="tag">besar</span> <span class="tag">kecil</span>
</div>

<h3>✅ Contoh Perintah</h3>
<pre>3Dream> robot emas mengkilap besar
3Dream> rumah merah atap coklat
3Dream> mobil biru berkilau
3Dream> karakter perak logam
3Dream> pohon hijau besar
3Dream> bola emas berkilau kecil
</pre>

<h2>📁 Memilih Format File</h2>
<p>Setelah mengetik deskripsi, akan muncul daftar format:</p>
<pre>1) .glb   ✅ Disarankan — ukuran kecil, dipakai di web/game
2) .gltf  — terstruktur, mudah dibaca
3) .obj   — format standar pertukaran
4) .fbx   — kompatibel dengan banyak aplikasi
5) .blend — file asli Blender, bisa diedit ulang
</pre>
<p>Ketik nomor format yang diinginkan → tekan Enter.</p>

<h2>📂 Hasil & Lokasi File</h2>
<ul>
  <li>File tersimpan di <strong>folder tempat kamu menjalankan skrip</strong></li>
  <li>Nama file otomatis: <code>model_tanggal_waktu.format</code> contoh: <code>model_20260911_143022.glb</code></li>
  <li>Di Android: AI akan membuka Nomad Sculpt dan menampilkan deskripsi untuk dibuat secara manual</li>
  <li>Di PC/Laptop: File langsung jadi tanpa membuka jendela aplikasi</li>
</ul>

<h2>❌ Keluar dari Program</h2>
<p>Ketik:</p>
<pre>exit</pre>

<h2>💡 Catatan Penting</h2>
<div class="card warning">
  <ul>
    <li>Selalu <strong>masuk ke folder tujuan</strong> dulu sebelum menjalankan <code>./install.sh</code></li>
    <li>Di Android, pastikan Nomad Sculpt sudah terpasang dari Play Store sebelum menjalankan</li>
    <li>Di Linux, pemasangan Blender mungkin memerlukan sandi admin (<code>sudo</code>)</li>
    <li>Model yang dihasilkan sederhana namun terstruktur — bisa dibuka & diedit ulang di Blender/Nomad Sculpt</li>
    <li>Program ini <strong>tanpa watermark</strong> — bebas dipakai untuk proyek apa saja</li>
  </ul>
</div>

<h2>🔄 Memperbarui Kode</h2>
<p>Jika ada versi baru, cukup ganti isi file <code>install.sh</code> dengan kode terbaru — tidak perlu mengubah cara pakainya.</p>

<hr>
<p style="text-align:center;opacity:.7;padding:1rem 0">3Dreaming AI — 3D Design CLI © 2026</p>

</body>
</html>
