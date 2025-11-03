<div align="center">

  <h1>🎀 Master Plan App: Dasar State Management (Part 1) 🌸</h1>

  <p><em>Implementasi Jobsheet 9 — Dasar State Management</em></p>

  <p><strong>💗 Identitas Mahasiswa</strong></p>
  <p>
    <strong>Mata Kuliah:</strong> Pemrograman Mobile<br>
    <strong>Dosen Pengampu:</strong> Ade Ismail, S.Kom., M.TI<br>
    <strong>Nama:</strong> Aqueena Regita Hapsari<br>
    <strong>NIM:</strong> 2341760096<br>
    <strong>Kelas:</strong> SIB 3C<br>
    <strong>No Absen:</strong> 06
  </p>

  <img src="https://img.shields.io/badge/Flutter-💙-blue?style=for-the-badge">
  <img src="https://img.shields.io/badge/Dart-💖-pink?style=for-the-badge">
  <img src="https://img.shields.io/badge/StatefulWidget-✨-ffc0cb?style=for-the-badge">
  <img src="https://img.shields.io/badge/Model--View-📚-ff99cc?style=for-the-badge">
  <img src="https://img.shields.io/badge/State%20Management-🧠-ff69b4?style=for-the-badge">

</div>

---

## 🎯 Tujuan Praktikum

Setelah menyelesaikan codelab ini, mahasiswa mampu:
- Menjelaskan konsep arsitektur **Model–View** pada Flutter.
- Mengelola **data layer** dengan **InheritedWidget** dan **InheritedNotifier** dengan mengelola state secara **immutable**.
- Membangun daftar rencana (tasks) yang bisa **ditambah, diedit, ditandai selesai, dan dihapus**.
- Membuat app state di **multiple** screens.

---

## ⚙️ Ringkasan Implementasi Praktikum 1 : Dasar State dengan Model-View

| Langkah Utama | File / Widget | Deskripsi |
| :---: | :--- | :--- |
| **Model Data** | `models/task.dart`, `models/plan.dart` | Membuat model **immutable**: `Task(description, complete)` dan `Plan(name, tasks)`. |
| **Data Layer Wrap** | `models/data_layer.dart` | Meng-**export** `plan.dart` & `task.dart` agar impor di file lain lebih ringkas. |
| **View (UI)** | `views/plan_screen.dart` | `PlanScreen` sebagai **`StatefulWidget`** yang merender `ListView.builder` dari `plan.tasks`. |
| **State Lokal** | `_PlanScreenState` | Variabel `Plan plan` menjadi **single source of truth**; perubahan memakai **`setState`** + membuat objek baru. |
| **UX Enhancement** | `ScrollController` | Menambah `ScrollController` & pengaturan `keyboardDismissBehavior` agar UX lebih nyaman (khususnya di iOS). |
| **Resource Cleanup** | `dispose()` | Membersihkan `scrollController` saat widget dihancurkan untuk mencegah kebocoran memori. |

---

## 🗂️ Struktur Proyek

```
lib/
 ├─ main.dart
 ├─ models/
 │  ├─ task.dart
 │  ├─ plan.dart
 │  └─ data_layer.dart
 └─ views/
    └─ plan_screen.dart
images/
 └─ praktikum1.gif   ← taruh GIF dokumentasi di sini
```

---

## 🚀 Cara Menjalankan

```bash
flutter pub get
flutter run
```

Interaksi utama:
- Tekan **FAB (+)** untuk menambah baris rencana.
- Ketik deskripsi di `TextFormField`.
- Centang **Checkbox** untuk menandai selesai (teks tercoret).
- Hapus item dengan ikon **✕**.

---

## 🎥 Demo Praktikum 1

**GIF dokumentasi (Langkah 9 hingga tugas praktikum):**  
![Praktikum 1 GIF](\images\praktikum1.gif)

> Rekam urutan: tekan **+**, isi deskripsi, centang selesai (lihat teks tercoret), hapus item, serta perilaku list saat entry bertambah.

---

## 💬 Jawaban Tugas Praktikum 1

### 1) Penjelasan Langkah 4: `data_layer.dart`
**Maksud:** membungkus data layer agar file lain cukup mengimpor **satu berkas** (`data_layer.dart`) untuk mendapatkan akses ke `Task` dan `Plan`.  
**Kenapa:** membuat impor **lebih ringkas dan konsisten**, memudahkan pemeliharaan saat project membesar.

### 2) Kegunaan variabel `plan` (Langkah 6) & alasan dibuat `const`
- `plan` adalah **sumber kebenaran** daftar tugas pada layar tersebut. UI selalu merender berdasarkan nilai `plan`.  
- Inisialisasi `const Plan()` dipakai karena model **immutable**; setiap perubahan dilakukan dengan membuat **objek baru** (lebih aman, mudah dilacak, dan menghindari efek samping dari mutasi data di tempat).

### 3) Dokumentasi hasil Langkah 9 (berikut penjelasan)
Pada **Langkah 9**, setiap item daftar ditampilkan dengan:
- **`Checkbox`** untuk menandai status selesai (UI mencoret teks saat `complete = true`).  
- **`TextFormField`** untuk mengubah `description`.  
- **Tombol hapus (✕)** untuk menghapus item.  
Setiap perubahan membuat **`Task` baru** dan menyusun ulang **`Plan` baru** (immutability). GIF memperlihatkan seluruh alur tersebut.

### 4) Kegunaan `initState()` dan `dispose()` dalam lifecycle
- **`initState()`**: dipanggil sekali ketika `State` dibuat; tempat yang tepat untuk **inisialisasi** seperti `ScrollController`.  
- **`dispose()`**: dipanggil ketika widget akan dihancurkan; tempat yang tepat untuk **membersihkan resource** (mis. `scrollController.dispose()`) agar tidak bocor memori.

---

<div align="center">

**Made with pink & purpose by Aqueena Regita Hapsari 🌷**  
*“Clean state, cute UI, happy commits.”*

</div>
